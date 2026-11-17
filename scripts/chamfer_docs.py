"""Render magnified OpenSCAD geometry close-ups for the v12 README.

Images contain geometry only; Markdown tables supply titles and parameters.
CAD coupons shorten surrounding stock but reuse production connector/socket cutters.
"""
from __future__ import annotations

import argparse
import math
import shutil
import subprocess
import tempfile
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFont

from scripts.organizer_cli import release_paths

MARKER = "// ----------- Output and non-fatal invalid selection handling -----------"
APPEND = r"""
// Trim stock only. Real socket, dogbone and joining-edge relief modules are reused.
module inspection_join_cut() {
    rotate([0,0,90]) rotate([90,0,0])
      linear_extrude(height=40,center=true)
        polygon([[-20,-E],[JOIN_X+E,-E],[JOIN_X,0],[0,JOIN_Z],[-20,JOIN_Z+20]]);
}
module inspection_socket_coupon() {
    // F6 evaluation removes OpenCSG stripe artifacts at the blind pocket
    // roof and mouth; all actual production subtractors are retained.
    render(convexity=10)
    difference() {
        // Leave stock ABOVE the blind pocket's 13 mm roof in the technical coupon.
        // Otherwise a harmless inspection crop would misleadingly show the sky.
        color([0.30,0.68,0.83]) translate([-11,0,0])
            cube([22,21,max(17,CONNECTOR_HEIGHT+SOCKET_TOP_CLEARANCE+SOCKET_STOCK+1)]);
        color([0.96,0.72,0.12]) socket_with_entry_chamfer_3d();
        color([0.96,0.72,0.12]) inspection_join_cut();
    }
}
module inspection_socket_section() {
    // An actual solid section, evaluated before display, prevents OpenCSG
    // z-fighting and the striped/corrupted walls in the previous screenshot.
    render(convexity=10)
        intersection() {
            inspection_socket_coupon();
            translate([-0.2,-2,-0.5]) cube([14,23,16]);
        }
}
module inspection_join_edge() {
    difference() {
        color([0.30,0.68,0.83]) translate([-12,0,0]) cube([24,9,3]);
        color([0.96,0.72,0.12]) inspection_join_cut();
    }
}
// Preview palette: teal for stock / loose connector and gold for volumes
// removed by the socket or joining-edge chamfer. STL color is unaffected.
Inspection_view="connector-foot";
if(Inspection_view=="connector-foot") color([0.90,0.62,0.25]) render(convexity=10) loose_dogbone();
else if(Inspection_view=="connector-lobe")
    // Crop at a real lobe: this inspection section makes the round head
    // large enough to distinguish from the complete dogbone overview.
    translate([0,-HEAD_IN,0]) color([0.90,0.62,0.25])
        render(convexity=10) intersection() {
            loose_dogbone();
            translate([-5,HEAD_IN-3.2,-0.2])
                cube([10,8,CONNECTOR_HEIGHT+2]);
        }
else if(Inspection_view=="connector-web")
    // Crop away the heads to expose the actual straight center relief.
    color([0.90,0.62,0.25])
        render(convexity=10) intersection() {
            loose_dogbone();
            translate([-WEB_R-0.4,-HEAD_IN+2,-0.2])
                cube([2*(WEB_R+0.4),2*(HEAD_IN-2),CONNECTOR_HEIGHT+2]);
        }
else if(Inspection_view=="socket-underside")
    rotate([180,0,0]) inspection_socket_coupon();
else if(Inspection_view=="socket-lips")
    rotate([180,0,0]) translate([0,-HEAD_IN,0]) inspection_socket_coupon();
else if(Inspection_view=="socket-section")
    rotate([180,0,0]) inspection_socket_section();
else if(Inspection_view=="joining-edge") inspection_join_edge();
else if(Inspection_view=="connector-plan")
    color([0.90,0.62,0.25]) render(convexity=10) loose_dogbone();
else if(Inspection_view=="connector-underside")
    rotate([180,0,0]) color([0.90,0.62,0.25]) render(convexity=10) loose_dogbone();
else if(Inspection_view=="connector-profile")
    // Evaluate the real CSG intersection before previewing the side profile.
    // OpenCSG's coplanar faces otherwise draw a false notch at the lobe top.
    color([0.90,0.62,0.25]) render(convexity=10) loose_dogbone();
else if(Inspection_view=="socket-mouth-plan")
    rotate([180,0,0]) inspection_socket_coupon();
else if(Inspection_view=="joining-socket")
    rotate([180,0,0]) inspection_socket_coupon();
"""

# Stable semantic filenames. Camera: target X/Y/Z, rotation X/Y/Z, distance.
# Image dimensions are uniform; close-ups differ by view angle, not PNG size.
VIEWS = [
    ("connector-foot",      (0,  0,  3.0, 78, 0, 34, 85)),
    ("connector-plan",      (0,  0,  5.0,  0, 0,  0, 78)),
    ("connector-lobe",      (0,  0,  2.5, 75, 0, 28, 68)),
    ("connector-web",       (0,  0,  2.5, 80, 0, 52, 70)),
    ("connector-underside", (0,  0, -2.8, 38, 0, 20, 97)),
    ("connector-profile",   (0,  0,  4.0, 90, 0,  0, 86)),
    ("socket-underside",    (0, -8,  0.0, 52, 0,190, 118)),
    ("socket-mouth-plan",   (0, -9,  0.0,  0, 0,180, 108)),
    ("socket-lips",         (0, -7,  0.0, 60, 0,180, 118)),
    ("socket-section",      (0, -6,  0.0, 60, 0,220, 122)),
    ("joining-edge",        (0,  4,  1.0, 80, 0, 32, 71)),
    ("joining-socket",      (0, -6,  0.0, 80, 0,190, 115)),
]

# Raw F5 views of the actual preset, without any card art or marketing copy.
CONTEXT_VIEWS = [
    "full-layout",
    "rear-tray",
    "middle-tray",
    "front-tray",
    "cutout-closeup",
    "dogbone",
]


def run_preview(source: Path, name: str, camera: tuple[int, ...], destination: Path) -> None:
    command = [
        "openscad", "--hardwarnings", "--imgsize=2200,1500",
        "--colorscheme=Tomorrow", "--camera="+",".join(map(str,camera)),
        "-D", "Render_facets=128", "-D", 'Inspection_view="'+name+'"',
        "-o", str(destination), str(source),
    ]
    if shutil.which("xvfb-run"):
        command = ["xvfb-run", "-a", *command]
    result = subprocess.run(command,capture_output=True,text=True,timeout=150)
    if result.returncode or "ERROR:" in result.stderr or not destination.is_file():
        raise RuntimeError(f"OpenSCAD screenshot {name} failed: {result.stdout}\n{result.stderr}")


FRAME_SIZE = (1200, 900)
BACKGROUND = (248, 248, 248)


def uniform_frame(path: Path, *, name: str, allow_clipping: bool = False) -> Image.Image:
    """Place uncropped CAD geometry on equal 4:3 canvases at a consistent scale.

    A high-resolution camera render is fitted to a constant 1200x900 frame.
    Detail crops may receive at most 1.5x resizing, never the former huge upscale.
    """
    source = Image.open(path).convert("RGB")
    rgb = np.asarray(source, dtype=np.int16)
    mask = ((rgb.max(axis=2)-rgb.min(axis=2)) > 19) & (rgb.min(axis=2) < 227)
    ys, xs = np.nonzero(mask)
    if len(xs) < 2500:
        raise RuntimeError(f"No usable CAD pixels in {name}")
    x0, x1 = int(xs.min()), int(xs.max()) + 1
    y0, y1 = int(ys.min()), int(ys.max()) + 1
    w, h = source.size
    # The interior-divider detail is intentionally a camera crop of a tray,
    # unlike the complete fitting interfaces, which must not be clipped.
    if not (allow_clipping or name == "cutout-closeup") and (x0 <= 1 or y0 <= 1 or x1 >= w-1 or y1 >= h-1):
        raise RuntimeError(f"CAD model clipped by the source camera: {name}")
    box_w, box_h = x1-x0, y1-y0
    margin = max(24, round(max(box_w, box_h) * .05))
    crop = source.crop((max(0,x0-margin), max(0,y0-margin),
                        min(w,x1+margin), min(h,y1+margin)))
    max_w, max_h = int(FRAME_SIZE[0]*.84), int(FRAME_SIZE[1]*.84)
    factor = min(max_w/crop.width, max_h/crop.height, 1.5)
    size = (max(1,round(crop.width*factor)), max(1,round(crop.height*factor)))
    resized = crop.resize(size,Image.Resampling.LANCZOS)
    canvas = Image.new("RGB",FRAME_SIZE,BACKGROUND)
    canvas.paste(resized,((FRAME_SIZE[0]-size[0])//2,(FRAME_SIZE[1]-size[1])//2))
    if size[0] < FRAME_SIZE[0]*.24 or size[1] < FRAME_SIZE[1]*.24:
        raise RuntimeError(f"CAD view too small in normalized frame: {name}")
    return canvas


def assert_gallery(output: Path) -> None:
    expected = [f"{name}.png" for name, _ in VIEWS] + [
        f"{name}.png" for name in CONTEXT_VIEWS
    ]
    if len(expected) != len(set(expected)):
        raise RuntimeError("Duplicate gallery output filenames")
    for filename in expected:
        path = output / filename
        with Image.open(path) as im:
            if im.size != FRAME_SIZE:
                raise RuntimeError(f"Unequal gallery dimensions: {filename}")
    print(f"Validated {len(expected)} equally sized real-CAD gallery images")

def font(size:int,bold:bool=False):
    name="DejaVuSans-Bold.ttf" if bold else "DejaVuSans.ttf"
    return ImageFont.truetype("/usr/share/fonts/truetype/dejavu/"+name,size)


def schematic(output: Path) -> None:
    image=Image.new("RGB",(1400,740),(247,250,252))
    d=ImageDraw.Draw(image)
    d.rectangle((0,0,1400,110),fill=(23,38,58))
    d.text((30,30),"Foot relief sections (schematic, not to scale)",font=font(36,True),fill="white")
    specs=[("Male dogbone",1.0,True),("Female socket",1.0,False),("Joining edge",1.0,False)]
    for i,(title,rise,male) in enumerate(specs):
        x=20+i*464
        d.rounded_rectangle((x,145,x+445,715),radius=12,
                            fill=(236,243,247),outline=(195,210,221),width=2)
        d.text((x+18,169),title,font=font(25),fill=(23,38,58))
        o=x+200;y=570
        d.line((x+38,y,x+420,y),fill=(181,102,88),width=5)
        if male:
            d.polygon([(o-140,y),(o-80,y),(o,y-185),(o,235),(o-140,235)],fill=(68,160,177))
            a=(o-80,y)
        else:
            d.polygon([(o+80,y),(o+195,y),(o+195,235),(o,y-185)],fill=(68,160,177))
            a=(o+80,y)
        d.line((a,(o,y-185)),fill=(253,181,68),width=11)
        d.text((x+22,610),f"Rise {rise:.1f} mm",font=font(23),fill=(23,38,58))
        d.text((x+22,655),f"Run {rise/math.tan(math.radians(60)):.2f} mm at 60 degrees",
               font=font(22),fill=(23,38,58))
    image.save(output,optimize=True)


def main() -> None:
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output",type=Path,default=Path("docs/images"))
    parser.add_argument("--input",type=Path,default=Path("build/previews"))
    args=parser.parse_args()
    source,_=release_paths()
    model=source.read_text()
    if MARKER not in model:
        raise RuntimeError("OpenSCAD output marker not present")
    out=args.output/"cad"
    out.mkdir(parents=True,exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="drawer-cad-inspect-") as temp:
        fixture=Path(temp)/"inspection.scad"
        fixture.write_text(model.split(MARKER,1)[0]+"\n"+APPEND)
        for name,camera in VIEWS:
            raw=Path(temp)/(name+".png")
            run_preview(fixture,name,camera,raw)
            destination=out/(name+".png")
            uniform_frame(raw,name=name).save(destination,optimize=True)
            print("Wrote normalized OpenSCAD CAD view",destination)
    for name in CONTEXT_VIEWS:
        original = args.input/(name+".png")
        if not original.is_file():
            raise FileNotFoundError(f"Missing actual OpenSCAD preset preview: {original}")
        uniform_frame(original,name=name).save(out/(name+".png"),optimize=True)
    assert_gallery(out)
    # Old numbered, upscaled image cards misrepresented the zoom level and
    # exterior wall. They are intentionally removed rather than retained.
    for old in args.output.glob("inspection-??.png"):
        old.unlink()
    (args.output/"inspection-contact-sheet.png").unlink(missing_ok=True)
    schematic(args.output/"inspection-section-dimensions.png")


if __name__=="__main__":
    main()
