"""Generate v12 build-plate-interface reference screenshots from the real SCAD geometry.

These are isolated CAD coupons, not photographs and not full-size trays.
The model's dogbone, socket, and chamfer modules are used unchanged.
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
// Only surrounding tray stock is shortened into inspection coupons.
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
module inspection_outer_wall() {
    rotate([90,0,0]) linear_extrude(height=19,center=true)
      polygon([[0,0],[9,0],[9,16],[-8,16],[-8,CHAMFER_Z],[-CHAMFER_X,CHAMFER_Z]]);
}
Inspection_view="male";
if(Inspection_view=="male") color([0.9,0.62,0.25]) loose_dogbone();
else if(Inspection_view=="male_head")
    translate([0,-HEAD_IN,0]) color([0.9,0.62,0.25]) loose_dogbone();
else if(Inspection_view=="male_web") color([0.9,0.62,0.25]) loose_dogbone();
else if(Inspection_view=="socket_bottom")
    rotate([180,0,0]) color([0.30,0.68,0.83]) inspection_socket_coupon();
else if(Inspection_view=="socket_lobe")
    rotate([180,0,0]) translate([0,-HEAD_IN,0])
        color([0.30,0.68,0.83]) inspection_socket_coupon();
else if(Inspection_view=="socket_section")
    rotate([180,0,0]) color([0.30,0.68,0.83]) inspection_socket_section();
else if(Inspection_view=="join_edge") color([0.30,0.68,0.83]) inspection_join_edge();
else if(Inspection_view=="outer_wall") color([0.30,0.68,0.83]) inspection_outer_wall();
"""

# n, OpenSCAD inspection selector, technical title, description, camera X/Y/Z/distance
VIEWS = [
    ("01","male","Loose connector: complete foot","Circular lobes and straight web",(65,0,35,90)),
    ("02","male_head","Loose connector: round head","Chamfer follows the circular lobe",(40,0,45,90)),
    ("03","male_web","Loose connector: center web","Chamfer on both narrow straight sides",(20,0,50,90)),
    ("04","socket_bottom","Socket: underside entrance","Bevel begins at the build-plate face",(30,0,30,90)),
    ("05","socket_lobe","Socket: lobe and mouth lips","Relief around the curved end and short edges",(12,0,0,90)),
    ("06","socket_section","Socket: wall section","Entry chamfer below unchanged fitting walls",(25,0,35,90)),
    ("07","join_edge","Tray: joining edge","Continuous relief across connector mouths",(65,0,35,90)),
    ("08","outer_wall","Tray: outside lower wall","Drawer floor radius clearance, not elephant foot",(65,0,35,90)),
]


def font(size:int,bold:bool=False):
    family="DejaVuSans-Bold.ttf" if bold else "DejaVuSans.ttf"
    return ImageFont.truetype("/usr/share/fonts/truetype/dejavu/"+family,size)


def run_preview(source:Path,name:str,camera:tuple[int,int,int,int],output:Path):
    cmd=["openscad","--hardwarnings","--imgsize=1280,850",
         "--colorscheme=Tomorrow",
         "--camera=0,0,0,"+",".join(map(str,camera)),
         "--autocenter","--viewall","-D",'Inspection_view="'+name+'"',
         "-o",str(output),str(source)]
    if shutil.which("xvfb-run"):
        cmd=["xvfb-run","-a",*cmd]
    proc=subprocess.run(cmd,text=True,capture_output=True,timeout=150)
    if proc.returncode or not output.exists() or output.stat().st_size<2000:
        raise RuntimeError(f"OpenSCAD inspection {name} failed:\n{proc.stdout}\n{proc.stderr}")


def crop_model(source:Path):
    img=Image.open(source).convert("RGB")
    a=np.asarray(img,dtype=np.int16)
    mask=(a.max(2)-a.min(2)>24)&(a.min(2)<215)
    yy,xx=np.nonzero(mask)
    if len(xx)<150:
        raise RuntimeError(f"Missing CAD geometry: {source.name}")
    x0,x1=int(xx.min()),int(xx.max())
    y0,y1=int(yy.min()),int(yy.max())
    mx=max(15,int((x1-x0)*.05))
    my=max(15,int((y1-y0)*.05))
    return img.crop((max(0,x0-mx),max(0,y0-my),
                     min(img.width,x1+mx+1),min(img.height,y1+my+1)))


def inspection_card(number:str,title:str,description:str,render:Path,metric:str):
    width,height=1400,975
    bg=Image.new("RGB",(width,height),(248,250,252))
    draw=ImageDraw.Draw(bg)
    navy=(23,38,58)
    draw.rectangle((0,0,width,135),fill=navy)
    draw.rounded_rectangle((27,27,104,104),radius=13,fill=(253,181,68))
    draw.text((45,49),number,font=font(25),fill=navy)
    draw.text((126,18),title,font=font(36,True),fill="white")
    draw.text((126,82),description,font=font(24),fill=(186,218,228))
    draw.rectangle((30,151,width-30,846),fill=(247,247,247),outline=(205,218,227),width=2)
    im=crop_model(render)
    scale=min(1290/im.width,675/im.height)
    im=im.resize((round(im.width*scale),round(im.height*scale)),Image.Resampling.LANCZOS)
    bg.paste(im,((width-im.width)//2,159+(680-im.height)//2))
    draw.rectangle((0,865,width,height),fill=(236,243,247))
    draw.text((35,886),metric,font=font(24),fill=(0,104,117))
    draw.text((35,934),"OpenSCAD v12  |  dimensions in mm  |  CAD coupon, not a printed sample",
              font=font(21),fill=(64,78,86))
    return bg


def schematic(output:Path):
    im=Image.new("RGB",(1400,740),(247,250,252))
    d=ImageDraw.Draw(im)
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
            d.polygon([(o+80,y),(o+195,y),(o+195,235),(o,235),(o,y-185)],fill=(68,160,177))
            a=(o+80,y)
        d.line((a,(o,y-185)),fill=(253,181,68),width=11)
        d.text((x+22,610),f"Rise {rise:.1f} mm",font=font(23),fill=(23,38,58))
        d.text((x+22,655),f"Run {rise/math.tan(math.radians(60)):.2f} mm at 60 degrees",
               font=font(22),fill=(23,38,58))
    im.save(output,optimize=True)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output",type=Path,default=Path("docs/images"))
    args=parser.parse_args()
    source,_=release_paths()
    model=source.read_text()
    if MARKER not in model:
        raise RuntimeError("Cannot locate the release's OpenSCAD output marker")
    args.output.mkdir(parents=True,exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="drawer-inspection-") as temp:
        fixture=Path(temp)/"inspection.scad"
        fixture.write_text(model.split(MARKER,1)[0]+"\n"+APPEND)
        pictures=[]
        for num,view,title,description,camera in VIEWS:
            raw=Path(temp)/(view+".png")
            run_preview(fixture,view,camera,raw)
            metric=("1.0 mm join-edge relief" if view=="join_edge"
                    else "10.0 mm outer wall clearance rise" if view=="outer_wall"
                    else "0.4 mm socket/connector foot rise")
            dst=args.output/("inspection-"+num+".png")
            inspection_card(num,title,description,raw,metric).save(dst,optimize=True)
            pictures.append(dst)
            print("Saved",dst)
        sheet=Image.new("RGB",(1420,2040),(233,240,245))
        d=ImageDraw.Draw(sheet)
        d.rectangle((0,0,1420,73),fill=(23,38,58))
        d.text((22,18),"v12: build-plate interfaces (8 CAD views)",font=font(33,True),fill="white")
        for i,path in enumerate(pictures):
            im=Image.open(path).convert("RGB").resize((700,488),Image.Resampling.LANCZOS)
            sheet.paste(im,(10+(i%2)*705,76+(i//2)*490))
        sheet.save(args.output/"inspection-contact-sheet.png",optimize=True)
        schematic(args.output/"inspection-section-dimensions.png")


if __name__=="__main__":
    main()
