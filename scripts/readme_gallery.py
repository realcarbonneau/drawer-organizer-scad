"""Build polished README visuals from real OpenSCAD preview PNGs.

This changes presentation only. It does not modify or invent CAD geometry.
Run after make build; requires Pillow and DejaVuSans.
"""
from __future__ import annotations
import argparse
from pathlib import Path
from PIL import Image, ImageChops, ImageDraw, ImageFont

DARK='#142338'; MID='#263b53'; INK='#223349'
MUTED='#597085'; PALE='#f3f7fa'; WHITE='#ffffff'
ACCENT='#4bc6b4'; BORDER='#dfe7ee'
FONT_DIR=Path('/usr/share/fonts/truetype/dejavu')

def font(size, bold=False):
    name='DejaVuSans-Bold.ttf' if bold else 'DejaVuSans.ttf'
    return ImageFont.truetype(str(FONT_DIR/name),size)

def label(draw,xy,s,size=27,color=INK,bold=False):
    draw.text(xy,s,font=font(size,bold),fill=color)

def rounded(draw,rect,fill,radius=22,outline=None):
    draw.rounded_rectangle(rect,radius=radius,fill=fill,outline=outline,width=2)

def image_crop(path,size):
    im=Image.open(path).convert('RGB')
    background=im.getpixel((0,0))
    diff=ImageChops.difference(im,Image.new('RGB',im.size,background))
    bounds=diff.convert('L').point(lambda v:255 if v>28 else 0).getbbox()
    if bounds:
        x0,y0,x1,y1=bounds
        im=im.crop((max(0,x0-24),max(0,y0-24),min(im.width,x1+24),min(im.height,y1+24)))
    scale=min(size[0]/im.width,size[1]/im.height)
    return im.resize((max(1,round(im.width*scale)),max(1,round(im.height*scale))),Image.Resampling.LANCZOS)

def insert(canvas,source,rect):
    x0,y0,x1,y1=rect
    im=image_crop(source,(x1-x0-24,y1-y0-24))
    backdrop=Image.new('RGB',(x1-x0,y1-y0),'#fffef4')
    backdrop.paste(im,((backdrop.width-im.width)//2,(backdrop.height-im.height)//2))
    canvas.paste(backdrop,(x0,y0))

def hero(source,dest):
    im=Image.new('RGB',(1800,820),DARK);d=ImageDraw.Draw(im)
    d.ellipse((1190,-300,1980,490),fill='#1e344c')
    d.ellipse((1380,370,1980,970),fill='#1a2f44')
    label(d,(92,66),'OPENSCAD  /  PARAMETRIC CAD',23,ACCENT,True)
    label(d,(86,132),'Drawer',87,WHITE,True)
    label(d,(86,233),'Organizer',87,WHITE,True)
    label(d,(91,363),'Print the trays you need. Connect them',27,'#d3e0ea')
    label(d,(91,408),'underneath. Keep the layout flexible.',27,'#d3e0ea')
    rounded(d,(90,544,360,615),MID,18)
    label(d,(110,562),'5 TRAYS  /  v9',28,WHITE,True)
    rounded(d,(375,544,642,615),MID,18)
    label(d,(402,562),'2 mm WALLS',26,WHITE,True)
    rounded(d,(85,689,1705,750),'#1c354c',15)
    label(d,(112,704),'Customizable grid  /  Soft edges  /  Underside connectors',24,'#cee0ec')
    rounded(d,(792,97,1710,651),WHITE,26)
    insert(im,source/'full-layout.png',(810,115,1692,633))
    im.save(dest,optimize=True)

def sheet(dest,source,title,subtitle,left,right):
    im=Image.new('RGB',(1800,900),PALE);d=ImageDraw.Draw(im)
    label(d,(78,49),title,48,DARK,True)
    label(d,(80,119),subtitle,23,MUTED)
    for rect,view in zip([(64,202,892,790),(908,202,1736,790)],[left,right]):
        name,title,caption=view
        x0,y0,x1,y1=rect
        rounded(d,rect,WHITE,19,BORDER)
        insert(im,source/name,(x0+17,y0+12,x1-17,y1-85))
        label(d,(x0+23,y1-72),title,25,INK,True)
        label(d,(x0+23,y1-37),caption,18,MUTED)
    label(d,(85,833),'Actual OpenSCAD v9 model previews  /  Test print before use',19,MUTED)
    im.save(dest,optimize=True)

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input',type=Path,default=Path('build/previews'))
    parser.add_argument('--output',type=Path,default=Path('docs/images'))
    args=parser.parse_args()
    args.output.mkdir(parents=True,exist_ok=True)
    for name in ('full-layout','rear-tray','middle-tray','front-tray','dogbone'):
        if not (args.input/(name+'.png')).is_file():
            raise FileNotFoundError('Missing OpenSCAD screenshot: '+name+'.png')
    hero(args.input,args.output/'hero.png')
    sheet(args.output/'layout.png',args.input,
          'Five trays. One configurable grid.',
          'The kitchen example: one rear, three middle, one front tray.',
          ('full-layout.png','Default five-tray layout','Rear to front: 1 / 3 / 1'),
          ('rear-tray.png','Full-width rear tray','Tapered walls and smooth bottom'))
    sheet(args.output/'details.png',args.input,
          'Rounded access. Modular storage.',
          'A row-4 access opening with smooth tangent risers.',
          ('middle-tray.png','Middle tray and cutout','20 mm transition diameter'),
          ('front-tray.png','Full-width front tray','A separately printed section'))
    sheet(args.output/'connector.png',args.input,
          'The connector beneath the trays.',
          'Loose dogbones have independent side and roof clearances.',
          ('dogbone.png','Male dogbone','4 mm core / 6 mm lobes / 6 mm tall'),
          ('middle-tray.png','Individual tray','Blind pockets face down'))
    for f in sorted(args.output.glob('*.png')):print('Generated',f)

if __name__=='__main__':main()
