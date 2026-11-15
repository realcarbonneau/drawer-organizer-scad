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
    difference() {
        translate([-10,0,0]) cube([20,19,10]);
        socket_with_entry_chamfer_3d();
        inspection_join_cut();
    }
}
module inspection_socket_section() {
    difference() {
        inspection_socket_coupon();
        translate([-20,-10,-1]) cube([20,40,30]);
    }
}
module inspection_join_edge() {
    difference() {
        translate([-12,0,0]) cube([24,9,7]);
        inspection_join_cut();
    }
}
// Color comes from OpenSCAD's Tomorrow preview scheme. Its contrasting
// gold cut surfaces identify the removed pocket/foot material.
Inspection_view="connector-foot";
if(Inspection_view=="connector-foot") loose_dogbone();
else if(Inspection_view=="connector-lobe")
    translate([0,-HEAD_IN,0]) loose_dogbone();
else if(Inspection_view=="connector-web") loose_dogbone();
else if(Inspection_view=="socket-underside")
    rotate([180,0,0]) inspection_socket_coupon();
else if(Inspection_view=="socket-lips")
    rotate([180,0,0]) translate([0,-HEAD_IN,0]) inspection_socket_coupon();
else if(Inspection_view=="socket-section")
    rotate([180,0,0]) inspection_socket_section();
else if(Inspection_view=="joining-edge") inspection_join_edge();
"""

# Stable semantic filenames, not serial numbers. Focal points in CAD mm.
# For the female pockets the inspection coupon is flipped to expose the
# underside, hence the negative focal Y/Z coordinates.
VIEWS = [
    ("connector-foot",    (0,  0,  3, 58,  0, 32, 35)),
    ("connector-lobe",    (0,  0,  1, 47,  0, 20, 19)),
    ("connector-web",     (0,  0,  2, 82,  0,  0, 24)),
    ("socket-underside",  (0, -9, -3, 25,  0, 25, 43)),
    ("socket-lips",       (0, -5, -1,  7,  0,  0, 32)),
    ("socket-section",    (0, -9, -4, 48,  0, 55, 40)),
    ("joining-edge",     (0,  4,  2, 62,  0, 42, 40)),
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


def trim_preview(path: Path, *, closeup: bool = False) -> Image.Image:
    image = Image.open(path).convert("RGB")
    rgb = np.asarray(image,dtype=np.int16)
    # Preserve the actual OpenSCAD preview colors and shaded cut surfaces.
    # This mask selects colored geometry, not pale-gray background pixels.
    visible = ((rgb.max(axis=2)-rgb.min(axis=2))>20) & (rgb.min(axis=2)<225)
    yy,xx=np.nonzero(visible)
    if len(xx)<5000:
        raise RuntimeError(f"No usable CAD geometry in screenshot {path.name}")
    x0,x1=int(xx.min()),int(xx.max())
    y0,y1=int(yy.min()),int(yy.max())
    width,height=image.size
    if not closeup and (x0<8 or x1>width-9 or y0<8 or y1>height-9):
        raise RuntimeError(f"Camera cuts off geometry in {path.name}: {(x0,y0,x1,y1)}")
    if x1-x0<width*0.24 or y1-y0<height*0.20:
        raise RuntimeError(f"Camera too distant in {path.name}: {(x0,y0,x1,y1)}")
    margin=max(30,int(max(x1-x0,y1-y0)*.04))
    rect=(max(0,x0-margin),max(0,y0-margin),
          min(width,x1+margin+1),min(height,y1+margin+1))
    return image.crop(rect)


def font(size:int,bold:bool=False):
    name="DejaVuSans-Bold.ttf" if bold else "DejaVuSans.ttf"
    return ImageFont.truetype("/usr/share/fonts/truetype/dejavu/"+name,size)


def schematic(output: Path) -> None:
    image=Image.new("RGB",(1400,740),(247,250,252))
    d=ImageDraw.Draw(image)
    d.rectangle((0,0,1400,110),fill=(23,38,58))
    d.text((30,30),"Foot relief sections (schematic, not to scale)",font=font(36,True),fill="white")
    specs=[("Male dogbone",.4,True),("Female socket",.4,False),("Joining edge",1.0,False)]
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
            trim_preview(raw,closeup=name in {'connector-lobe','connector-web','socket-lips'}).save(destination,optimize=True)
            print("Wrote raw OpenSCAD CAD view",destination)
    # Old numbered, upscaled image cards misrepresented the zoom level and
    # exterior wall. They are intentionally removed rather than retained.
    for old in args.output.glob("inspection-??.png"):
        old.unlink()
    (args.output/"inspection-contact-sheet.png").unlink(missing_ok=True)
    schematic(args.output/"inspection-section-dimensions.png")


if __name__=="__main__":
    main()
