"""Regression tests using OpenSCAD 2021.01 as the geometry engine.

F5-like CSG exports validate selection/preview; F6 STL renders validate solids.
"""
from __future__ import annotations

import math
import re

import numpy as np
import pytest
import trimesh

from scripts.organizer_cli import openscad_render, require_render_ok, release_paths, preset_parameters


def render_stl(tmp_path, name, overrides):
    path = tmp_path / f"{name}.stl"
    proc = openscad_render(path, overrides)
    require_render_ok(proc, path)
    mesh = trimesh.load(path, force="mesh", process=True)
    assert not mesh.is_empty, name
    assert mesh.is_watertight, f"Non-watertight STL: {name}"
    assert mesh.volume > 0, name
    assert abs(mesh.bounds[0, 2]) < 0.03, f"STL protrudes below base plane: {name}"
    return mesh, proc.stdout + proc.stderr


def render_csg(tmp_path, name, overrides):
    path = tmp_path / f"{name}.csg"
    proc = openscad_render(path, overrides)
    require_render_ok(proc, path)
    return proc.stdout + proc.stderr, path


def preview_positions(messages):
    p = r'ECHO: "PREVIEW ORIGIN \(row, column, x, y, w, depth\)", (\d+), (\d+), ([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+)'
    return {(int(r), int(c)): tuple(float(v) for v in (x,y,w,d))
            for r,c,x,y,w,d in re.findall(p, messages)}


def preview_connector_positions(messages):
    p = r'ECHO: "PREVIEW LOOSE CONNECTOR \(index, x, y\)", (\d+), ([\d.e+-]+), ([\d.e+-]+)'
    return [(int(i),float(x),float(y)) for i,x,y in re.findall(p,messages)]


@pytest.mark.parametrize("gap", [0, 1, 12, 50])
def test_preview_separation_is_one_constant_gap_between_tray_edges(tmp_path, gap):
    output, _ = render_csg(tmp_path, f"preview_{gap}", {
        "Output_mode": 0, "Preview_separation_mm": gap
    })
    parts = preview_positions(output)
    assert set(parts) == {(1,1), (3,1), (3,2), (3,3), (6,1)}
    m1, m2, m3 = (parts[(3,c)] for c in [1,2,3])
    rear, front = parts[(1,1)], parts[(6,1)]
    assert m2[0] - (m1[0] + m1[2]) == pytest.approx(gap, abs=0.01)
    assert m3[0] - (m2[0] + m2[2]) == pytest.approx(gap, abs=0.01)
    assert rear[1] - (m1[1] + m1[3]) == pytest.approx(gap, abs=0.01)
    assert m1[1] - (front[1] + front[3]) == pytest.approx(gap, abs=0.01)


@pytest.mark.parametrize("quantity,gap", [(1,0),(8,0),(8,12),(60,50)])
def test_full_preview_shows_loose_dogbones_in_right_hand_y_column(tmp_path,quantity,gap):
    out,path=render_csg(tmp_path,f"preview_connectors_{quantity}_{gap}",{
        "Output_mode":0,"Loose_connector_quantity":quantity,
        "Preview_separation_mm":gap
    })
    connectors=preview_connector_positions(out)
    assert len(connectors)==quantity
    assert [i for i,_,_ in connectors]==list(range(1,quantity+1))
    xs=[x for _,x,_ in connectors]
    ys=[y for _,_,y in connectors]
    assert max(xs)-min(xs)<0.001, "Connectors must occupy one Y-aligned column"
    # The rightmost tray side expands 14 mm at the rim plus an outer lip run.
    # The three-column group has one full preview gap on its right.
    rim_right=189+14+10/math.tan(math.radians(60))+gap
    head_radius=3.0
    assert min(xs)-head_radius>=rim_right+5.9
    assert (ys[0]+ys[-1])/2==pytest.approx((474+2*gap)/2,abs=0.01)
    if quantity>1:
        head_in=2+math.sqrt(3**2-2**2)
        pitch=2*(head_in+head_radius)+4
        assert np.allclose(np.diff(ys),-pitch,atol=0.002)
    assert path.stat().st_size>1000


@pytest.mark.parametrize("mode",[1,2])
def test_loose_connector_preview_column_is_exclusive_to_full_layout(tmp_path,mode):
    out,_=render_csg(tmp_path,f"no_preview_connectors_mode_{mode}",{
        "Output_mode":mode,"Loose_connector_quantity":8
    })
    assert "PREVIEW LOOSE CONNECTOR" not in out


@pytest.mark.parametrize("row,col", [(1,1),(3,1),(3,2),(3,3),(6,1)])
def test_default_kitchen_parts_are_single_watertight_solids(tmp_path,row,col):
    m, out = render_stl(tmp_path,f"tray_r{row}c{col}",{
        "Output_mode": 1,"Selected_row":row,"Selected_column":col
    })
    assert m.body_count == 1
    assert "TRAY rows" in out
    assert m.bounds[1,2] == pytest.approx(75,abs=0.05)


@pytest.mark.parametrize("row,col,expected",[
    (7,1,"Row 7 does not exist"),
    (1,2,"Column 2 does not exist"),
    (3,4,"Column 4 does not exist")
])
def test_invalid_selection_warns_without_creating_geometry(tmp_path,row,col,expected):
    out, csg = render_csg(tmp_path,f"invalid_r{row}_c{col}",{
        "Output_mode":1,"Selected_row":row,"Selected_column":col
    })
    assert "SELECTION INVALID" in out
    assert expected in out
    assert csg.stat().st_size < 400


def test_continuation_row_selects_full_multiroot_tray(tmp_path):
    out, _ = render_csg(tmp_path,"continued",{
        "Output_mode":1,"Selected_row":5,"Selected_column":2
    })
    assert "TRAY rows 3-5 column 2" in out


@pytest.mark.parametrize("angle", [25,35,45,60,75])
def test_print_angles_create_valid_solids(tmp_path,angle):
    m, out = render_stl(tmp_path,f"angle_{angle}",{
        "Output_mode":1,"Selected_row":1,"Selected_column":1,
        "Print_overhang_angle_deg":angle,
        "Drawer_floor_corner_radius_mm":4 if angle<45 else 10
    })
    assert m.extents[2] >= 65
    assert f"{angle}," in out


@pytest.mark.parametrize("angle,height",[(25,10),(60,18),(75,18)])
def test_large_rim_runs_use_fixed_height_without_crashing(tmp_path,angle,height):
    m, output = render_stl(tmp_path,f"rim_{angle}_{height}",{
        "Output_mode":1,"Selected_row":1,"Selected_column":1,
        "Print_overhang_angle_deg":angle,"Tray_height_above_rim_mm":height,
        "Drawer_floor_corner_radius_mm":4 if angle<45 else 10
    })
    assert m.bounds[1,2] == pytest.approx(65+height,abs=0.12)
    assert 'RIM (angle FROM PRINT BED / fixed height / derived projection)' in output


def test_sidewalls_are_outward_drafted_and_rear_wall_is_vertical(tmp_path):
    m,_ = render_stl(tmp_path,"rear_profile",{
        "Output_mode":1,"Selected_row":1,"Selected_column":1
    })
    # The REAR exterior lies on y=d for the complete metal wall height;
    # no unwanted inward draft or oversized bottom chamfer at this end.
    rear = m.vertices[np.abs(m.vertices[:,1]-158)<0.03]
    assert rear.size > 0
    assert rear[:,2].min() == pytest.approx(0, abs=0.03)
    assert np.any((rear[:,2]>=64.5)&(rear[:,2]<=65.5))
    assert m.bounds[0,0] < -10, "Outer left wall must slope outward to top"
    assert m.bounds[1,0] > 189, "Outer right wall must slope outward to top"


def test_bottom_internal_corners_are_rounded(tmp_path):
    m,_ = render_stl(tmp_path,"middle_fillet",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2
    })
    section=m.section(plane_origin=[0,118,0],plane_normal=[0,1,0])
    assert section is not None
    vertices=np.vstack(section.discrete)
    # Section through a plain part of the left interior corner: intermediate
    # X and Z coordinates prove it is a round, not a single sharp vertex.
    curved=vertices[(vertices[:,0]>2) & (vertices[:,0]<9)
                    & (vertices[:,2]>1.9) & (vertices[:,2]<6.5)]
    assert len(np.unique(np.round(curved[:,2],2))) >= 3


@pytest.mark.parametrize("radius,angle",[(0,60),(4,25),(10,60),(10,75)])
def test_drawer_corner_radius_drives_exterior_chamfer(tmp_path,radius,angle):
    m,out=render_stl(tmp_path,f"exterior_chamfer_r{radius}_a{angle}",{
        "Output_mode":1,"Selected_row":1,"Selected_column":1,
        "Drawer_floor_corner_radius_mm":radius,"Print_overhang_angle_deg":angle
    })
    assert m.is_watertight
    match=re.search(r'"ANGLE / AUTO OUTER CHAMFER run, rise \(from drawer floor radius\)", ([\d.]+), ([\d.]+), ([\d.]+)',out)
    assert match
    _,run,rise=map(float,match.groups())
    assert rise==pytest.approx(radius,abs=0.001)
    assert run==pytest.approx(radius/math.tan(math.radians(angle)),abs=0.002)


@pytest.mark.parametrize("radius,angle",[(10,25),(35,60),(20,75)])
def test_unfittable_drawer_chamfer_reports_no_geometry(tmp_path,radius,angle):
    out,path=render_csg(tmp_path,f"bad_chamfer_r{radius}_a{angle}",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Drawer_floor_corner_radius_mm":radius,"Print_overhang_angle_deg":angle
    })
    assert "DRAWER CHAMFER DOES NOT FIT:" in out
    assert "Nothing rendered" in out
    assert "ERROR:" not in out
    assert "WARNING:" not in out
    assert path.stat().st_size<400


@pytest.mark.parametrize("inner",[0,1,12,18,20,24,30,35,62])
def test_inner_bottom_radius_enforces_chamfer_protected_minimum(tmp_path,inner):
    out,path=render_csg(tmp_path,f"inner_bottom_radius_{inner}",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Inner_bottom_radius_mm":inner
    })
    spec=re.search(
        r'"INNER BOTTOM ROUNDING \(requested / chamfer-protected minimum / effective\)", '
        r'([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+)',out)
    assert spec,out[-3000:]
    req,minimum,effective=map(float,spec.groups())
    assert req==pytest.approx(inner)
    assert minimum==pytest.approx(12)
    assert effective==pytest.approx(max(minimum,inner))
    if inner and inner<minimum:
        assert "INNER BOTTOM ROUNDING WARNING" in out
        assert "Enforcing the minimum" in out
    else:
        assert "INNER BOTTOM ROUNDING WARNING" not in out
    if inner>=62:
        assert "INNER FLOOR FILLET DOES NOT FIT" in out
        assert "Nothing rendered" in out
        assert path.stat().st_size<400
    else:
        assert "Nothing rendered" not in out
        assert path.stat().st_size>1000
        assert "CONNECTOR_LOBE_REDUCTION" not in out


@pytest.mark.parametrize("radius",[20,30])
def test_inner_bottom_arcs_remain_circular_without_square_ledges(tmp_path,radius):
    # A fixed 16-mm transition once clipped the R20 curve with a square
    # horizontal shelf; an R30 opening used to be rejected or filled solid.
    mesh,out=render_stl(tmp_path,f"continuous_bottom_radius_{radius}",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Inner_bottom_radius_mm":radius
    })
    assert mesh.body_count==1
    assert mesh.is_watertight
    section=mesh.section(plane_origin=[0,60,0],plane_normal=[0,1,0])
    assert section is not None
    points=np.vstack(section.discrete)
    # The left divider has an exact 2 mm offset and vertical inner wall.
    # Its fillet circle has center (B+R, B+R), radius R.
    c=2+radius
    arc=points[(points[:,0]>2.15)&(points[:,0]<radius+1)&
               (points[:,2]>2.1)&(points[:,2]<radius+1.9)]
    assert len(arc)>=15
    radial=np.sqrt((arc[:,0]-c)**2+(arc[:,2]-c)**2)
    assert np.max(np.abs(radial-radius))<0.045, (
        f"The inner fillet must remain a true circular arc for R{radius}"
    )
    # At the narrowest 63-mm tray, R30 consumes the 59-mm clear floor,
    # but must retain a cavity down to approximately the 2-mm base.
    if radius==30:
        center=points[(np.abs(points[:,0]-31.5)<1)&(points[:,2]>1)]
        assert len(center)>0
        assert np.min(center[:,2])<2.15
        assert mesh.volume<300_000, "Do not fill the cavity with solid material"
        assert "INNER BOTTOM FILLET NOTE" in out


def test_radius_below_structural_minimum_cannot_change_the_stl(tmp_path):
    automatic,_=render_stl(tmp_path,"inner_radius_auto_identical",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Inner_bottom_radius_mm":0
    })
    clamped,out=render_stl(tmp_path,"inner_radius_clamped_identical",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Inner_bottom_radius_mm":1
    })
    assert "INNER BOTTOM ROUNDING WARNING" in out
    assert len(automatic.faces)==len(clamped.faces)
    assert clamped.volume==pytest.approx(automatic.volume,abs=0.001)
    assert np.allclose(clamped.bounds,automatic.bounds,atol=0.00001)


def test_connector_male_mesh_volume_grows_with_larger_floor_fillet(tmp_path):
    volumes=[]
    for radius in (0,18,24):
        m,_=render_stl(tmp_path,f"male_volume_radius_{radius}",{
            "Output_mode":2,"Loose_connector_quantity":1,
            "Inner_bottom_radius_mm":radius
        })
        volumes.append(m.volume)
    assert 0<volumes[0]<volumes[1]<volumes[2]


def test_larger_inner_rounding_expands_male_and_female_connector_lobes(tmp_path):
    values=[]
    for inner in [0,18,24]:
        out,_=render_csg(tmp_path,f"socket_trim_radius_{inner}",{
            "Output_mode":1,"Selected_row":3,"Selected_column":2,
            "Inner_bottom_radius_mm":inner
        })
        match=re.search(
            r'"CONNECTOR ROOF CAPS \(at lobe T\+2 / T\+4, female / male\)", '
            r'([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+)',out)
        assert match,out[-3000:]
        female_near,male_near,female_far,male_far=map(float,match.groups())
        assert female_near>=male_near>=0
        assert female_far>=male_far>=0
        values.append((female_near,male_near,female_far,male_far))
    for index in range(4):
        assert values[0][index]<=values[1][index]<=values[2][index]
    assert values[0][0]<values[1][0]<=values[2][0]
    assert values[0][2]<values[1][2]<=values[2][2]
    for female_near,male_near,female_far,male_far in values:
        assert male_near<=6 and male_far<=6
        assert female_near<=7 and female_far<=7
        if male_near>0: assert female_near-male_near>=0.999
        if male_far>0: assert female_far-male_far>=0.999


@pytest.mark.parametrize("outer_radius,expected",[(0,2),(4,6),(10,12)])
def test_chamfer_alone_determines_minimum_radius(tmp_path,outer_radius,expected):
    output,_=render_csg(tmp_path,f"chamfer_min_{outer_radius}",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Drawer_floor_corner_radius_mm":outer_radius,
    })
    match=re.search(
        r'"INNER BOTTOM ROUNDING \(requested / chamfer-protected minimum / effective\)", '
        r'([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+)',output)
    assert match,output
    assert float(match.group(2))==pytest.approx(expected)


@pytest.mark.parametrize("radius",[12,18,20,24,30])
def test_socket_roof_and_male_follow_two_exact_fillet_offsets(tmp_path,radius):
    out,_=render_csg(tmp_path,f"fillet_offsets_{radius}",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Inner_bottom_radius_mm":radius,
    })
    match=re.search(
        r'"CONNECTOR ROOF CAPS \(at lobe T\+2 / T\+4, female / male\)", '
        r'([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+)',out)
    assert match
    values=list(map(float,match.groups()))
    for u,female,male in ((2,values[0],values[1]),(4,values[2],values[3])):
        # Exact normal offsets of the inner concave quarter circle; the
        # female roof has B stock, the male has B+top-clearance stock.
        def cap(stock,max_height):
            return min(max_height,max(0,2+radius-
                math.sqrt((radius+stock)**2-(radius-u)**2)))
        assert female==pytest.approx(cap(2,7),abs=0.012)
        assert male==pytest.approx(cap(3,6),abs=0.012)
        if male>0:
            assert female-male>=0.999


def test_socket_profile_uses_actual_base_offset_not_wall_thickness(tmp_path):
    # The cavity is eroded by B. T controls the nominal connector geometry,
    # but must not move the fillet profile inwards when T differs from B.
    out,_=render_csg(tmp_path,"unequal_base_and_wall",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Base_thickness_mm":2,"Wall_thickness_mm":4,
        "Inner_bottom_radius_mm":20,
    })
    match=re.search(
        r'"CONNECTOR ROOF CAPS \(at lobe T\+2 / T\+4, female / male\)", '
        r'([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+)',out)
    assert match,out[-2500:]
    female,male=map(float,match.groups()[:2])
    # Echo samples T+2=6 mm. Actual inner wall starts at B=2 mm,
    # so the circular profile is sampled 4 mm into the fillet, not 2.
    R=20
    u=4
    expected_female=22-math.sqrt((R+2)**2-(R-u)**2)
    expected_male=22-math.sqrt((R+3)**2-(R-u)**2)
    assert female==pytest.approx(expected_female,abs=0.01)
    assert male==pytest.approx(expected_male,abs=0.01)
    assert female-male>=1


@pytest.mark.parametrize("radius",[0,18,20,24,30])
def test_larger_bottom_radius_keeps_tray_and_dogbone_watertight(tmp_path,radius):
    m,out=render_stl(tmp_path,f"larger_inner_round_{radius}",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Inner_bottom_radius_mm":radius
    })
    assert m.body_count==1
    radius_match=re.search(r'"CUTOUT floor Z / protected inner bottom fillet top Z", ([\d.e+-]+), ([\d.e+-]+)',out)
    assert radius_match
    floor,protected_top=map(float,radius_match.groups())
    assert floor-protected_top>0.6
    male,_=render_stl(tmp_path,f"male_inner_round_{radius}",{
        "Output_mode":2,"Loose_connector_quantity":1,
        "Inner_bottom_radius_mm":radius
    })
    assert male.body_count==1
    assert male.volume>0


@pytest.mark.parametrize("relief",[0,1,1.8])
def test_joining_edge_elephant_foot_settings(tmp_path,relief):
    render_stl(tmp_path,f"foot_{relief}",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Join_edge_elephant_foot_mm":relief
    })


def test_cutout_is_only_in_internal_dividers(tmp_path):
    base,_ = render_stl(tmp_path,"uncut",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Cutout_row_04":False
    })
    notch,_ = render_stl(tmp_path,"cut",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Cutout_row_04":True
    })
    removed = base.volume-notch.volume
    assert 200 < removed < base.volume*0.22, (
        "Expected a pair of wall notches, not a cut crossing entire tray width",removed
    )


def test_exposed_cutout_edges_are_soft_not_knife_sharp(tmp_path):
    # The 20 mm rounds shape the notch in YZ; these samples verify the
    # separate 0.6 mm touch-softening across the 2 mm divider thickness.
    m,out=render_stl(tmp_path,"soft_touch_access_notch",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Cutout_row_04":True,"Soft_edge_radius_mm":0.6
    })
    assert m.body_count==1
    assert m.is_watertight
    mval=re.search(r'"CUTOUT floor Z / protected inner bottom fillet top Z", ([\d.]+), ([\d.]+)',out)
    assert mval
    base_z,fillet_top=map(float,mval.groups())
    assert base_z-0.6>fillet_top
    yc=1.5*(474/6)
    levels=[]
    for x in (0.05,1.0):
        section=m.section(plane_origin=[x,0,0],plane_normal=[1,0,0])
        assert section is not None
        vertices=np.vstack(section.discrete)
        floor=vertices[(np.abs(vertices[:,1]-yc)<8)&
                       (vertices[:,2]>fillet_top-0.6)&(vertices[:,2]<base_z+0.6)]
        assert floor.size>0, f"Missing cutout floor section at x={x}"
        levels.append(np.min(floor[:,2]))
    assert levels[0]+0.3 < levels[1], (
        "Exposed divider face should have a curved, lower rounded notch edge",levels
    )


def test_cutout_fillet_curves_the_correct_way(tmp_path):
    # The former Minkowski cutter used the opposite quarter circle:
    # it stayed almost 0.6 mm below the floor near the face, then turned
    # sharply at the inner transition. A convex touch fillet must instead
    # meet the ORIGINAL notch floor tangentially.
    radius=0.6
    m,out=render_stl(tmp_path,"correct_cutout_quarter_circle",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Cutout_row_04":True,"Soft_edge_radius_mm":radius
    })
    assert m.is_watertight
    assert m.body_count==1
    match=re.search(r'"CUTOUT floor Z / protected inner bottom fillet top Z", ([\d.]+), ([\d.]+)',out)
    assert match,out[-2000:]
    base_z,fillet_top=map(float,match.groups())
    assert base_z-radius > fillet_top, "Touch fillet must not gouge the bottom fillet"
    yc=1.5*(474/6)
    for x,depth in ((0.2,0.2),(0.4,0.4),(1.6,0.4),(1.8,0.2)):
        section=m.section(plane_origin=[x,0,0],plane_normal=[1,0,0])
        assert section is not None
        # Interpolate the cutout floor where the section crosses its
        # centreline. STL triangulation is free to omit a vertex at y=yc.
        elevations=[]
        for polyline in section.discrete:
            for p,q in zip(polyline[:-1],polyline[1:]):
                if (p[1]-yc)*(q[1]-yc)<=0:
                    t=0 if abs(q[1]-p[1])<1e-8 else (yc-p[1])/(q[1]-p[1])
                    z=p[2]+t*(q[2]-p[2])
                    if fillet_top-1<z<base_z+1:
                        elevations.append(z)
        assert elevations, f"Missing cutout floor at x={x}"
        actual=min(elevations)
        expected=base_z-(radius-math.sqrt(2*radius*depth-depth*depth))
        assert actual==pytest.approx(expected,abs=0.04), (
            f"Incorrect cutout edge curvature at x={x}: {actual} vs {expected}")


@pytest.mark.parametrize("gap,angle", [(0.05,75),(0.5,75),(25,1),(25,2)])
def test_extreme_cutout_inputs_render_without_cgal_errors(tmp_path,gap,angle):
    # No minimum on the user controls. The touch fillet is omitted where
    # its 3D construction would self-intersect; the notch still renders.
    m,_=render_stl(tmp_path,f"extreme_gap_{gap}_angle_{angle}",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Cutout_row_04":True,"Cutout_base_width_mm":gap,
        "Cutout_riser_angle_deg":angle
    })
    assert m.is_watertight
    assert m.body_count==1


@pytest.mark.parametrize("diameter", [0,20])
def test_cutout_touches_remain_watertight_without_profile_rounding(tmp_path,diameter):
    m,_=render_stl(tmp_path,f"cutout_diameter_{diameter}",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Cutout_row_04":True,"Cutout_round_diameter_mm":diameter
    })
    assert m.is_watertight
    assert m.body_count==1


def test_cutout_on_single_column_row_is_noop(tmp_path):
    m,_ = render_stl(tmp_path,"cut_singlecol",{
        "Output_mode":1,"Selected_row":1,"Selected_column":1,
        "Cutout_row_01":True
    })
    assert m.is_watertight


@pytest.mark.parametrize("angle", [45,60,75,90])
def test_cutout_base_width_and_profile_options(tmp_path, angle):
    # The 25 mm setting is the unrounded intersection of the two risers
    # with the floor. Lower arc tangent points move inward after rounding.
    base_width = 25.0
    radius = 10.0
    y_center = 1.5 * (474 / 6)
    flat_half = base_width/2 - radius*math.tan(math.radians(angle)/2)
    m, out=render_stl(tmp_path,f"cutout_angle_{angle}",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Cutout_row_04":True,"Cutout_riser_angle_deg":angle,
        "Cutout_round_diameter_mm":20,
        "Cutout_base_width_mm":base_width
    })
    match=re.search(r'"CUTOUT floor Z / protected inner bottom fillet top Z", ([\d.]+), ([\d.]+)',out)
    assert match
    z_base=float(match.group(1))
    section=m.section(plane_origin=[1,0,0],plane_normal=[1,0,0])
    assert section is not None
    points=np.vstack(section.discrete)
    for y in (y_center-flat_half,y_center+flat_half):
        assert np.any((np.abs(points[:,1]-y)<0.07) &
                      (np.abs(points[:,2]-z_base)<0.07)), (
            f"At {angle} degrees the rounded floor must start inside the pre-rounding gap"
        )
    # Tangent-to-riser coordinates extrapolate to exactly half of entered gap.
    lower_y = flat_half+radius*math.sin(math.radians(angle))
    lower_z = radius*(1-math.cos(math.radians(angle)))
    assert lower_y-lower_z/math.tan(math.radians(angle)) == pytest.approx(base_width/2)
    assert 'CUTOUT widths (pre-rounding base / flat floor / lower risers / top opening, mm)' in out


@pytest.mark.parametrize("gap,angle", [(0,0),(0,75),(25,0),(25,1)])
def test_cutout_accepts_zero_gap_and_unrestricted_low_angle(tmp_path,gap,angle):
    m,_=render_stl(tmp_path,f"notch_gap_{gap}_angle_{angle}",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Cutout_row_04":True,
        "Cutout_base_width_mm":gap,"Cutout_riser_angle_deg":angle
    })
    assert m.is_watertight


@pytest.mark.parametrize("compartments", [4,5,6])
@pytest.mark.parametrize("mode", [0,1,2])
def test_grid_limit_mismatch_is_nonfatal_and_empty(tmp_path,compartments,mode):
    out,csg=render_csg(tmp_path,f"grid_mismatch_{compartments}_{mode}",{
        "Output_mode":mode,"Row_03":compartments
    })
    assert f"Row 3 requests {compartments}" in out
    assert "Increase Grid_columns to at least" in out
    assert "Nothing rendered" in out
    assert "ERROR:" not in out
    assert "WARNING:" not in out
    assert "PREVIEW ORIGIN" not in out
    assert csg.stat().st_size < 400


@pytest.mark.parametrize("compartments", [4,5,6])
def test_larger_grid_splits_render_when_grid_increased(tmp_path,compartments):
    out,_=render_csg(tmp_path,f"grid_supported_{compartments}",{
        "Output_mode":0,"Grid_columns":compartments,"Row_03":compartments
    })
    positions=preview_positions(out)
    assert len([k for k in positions if k[0]==3])==compartments
    assert (3,compartments) in positions


def test_six_compartment_tray_renders_watertight(tmp_path):
    m,_=render_stl(tmp_path,"six_compartment_middle",{
        "Grid_columns":6,"Row_03":6,"Output_mode":1,
        "Selected_row":3,"Selected_column":6
    })
    assert m.is_watertight
    assert m.body_count==1


def test_shared_wall_and_floor_thickness_defaults(tmp_path):
    m,out=render_stl(tmp_path,"uniform_2mm",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2
    })
    assert 'BOTTOM INNER R' in out
    assert 'BASE MIN THICKNESS' in out
    assert ' 2,' in out or ', 2,' in out


def test_soft_edge_radius_limited_to_half_wall(tmp_path):
    m,_=render_stl(tmp_path,"soft_edge_clamp",{
        "Output_mode":1,"Selected_row":1,"Selected_column":1,
        "Soft_edge_radius_mm":1.5
    })
    assert m.is_watertight


def test_standalone_1x1_drawer(tmp_path):
    m,_ = render_stl(tmp_path,"one_by_one",{
        "Grid_rows":1,"Grid_columns":1,"Row_01":1,
        "Output_mode":1,"Selected_row":1,"Selected_column":1
    })
    assert m.extents[0]>180


def test_simple_cylinder_rectangle_dogbones_are_separate_and_flush(tmp_path):
    m,_ = render_stl(tmp_path,"loose_joiners",{
        "Output_mode":2,"Loose_connector_quantity":3
    })
    assert m.body_count==3
    assert m.bounds[1,2]==pytest.approx(6.0,abs=0.1)
    # A truncated top profile clears the lower inner rounding; the XY
    # silhouette remains two circles joined by a rectangle.
    components=m.split(only_watertight=True)
    assert len(components)==3
    for c in components:
        assert c.extents[0]==pytest.approx(6.0,abs=0.15)
        assert c.extents[1]==pytest.approx(14.47,abs=0.15)


@pytest.mark.parametrize("facets", [3,20,200])
def test_facet_range_compiles_without_warnings(tmp_path,facets):
    output,_=render_csg(tmp_path,f"facets_{facets}",{
        "Output_mode":2,"Loose_connector_quantity":1,"Render_facets":facets
    })
    assert "WARNING:" not in output


def test_f5_preview_uses_original_geometry_without_forced_render(tmp_path):
    """F5 must display all trays without forcing CGAL render or overflowing OpenCSG."""
    path=tmp_path/"full-preview.png"
    proc=openscad_render(path,{"Output_mode":0,"Preview_separation_mm":12})
    require_render_ok(proc,path)
    text=proc.stdout+proc.stderr
    assert "CSG normalization resulted in an empty tree" not in text
    match=re.search(r"Normalized (?:CSG )?tree has (\d+) elements",text)
    assert match and 10 < int(match.group(1)) < 10000, text[-1000:]
    assert path.stat().st_size>5000


def test_f5_preview_is_unforced_for_selected_part(tmp_path):
    path=tmp_path/"single-preview.png"
    proc=openscad_render(path,{"Output_mode":1,"Selected_row":3,"Selected_column":2})
    require_render_ok(proc,path)
    text=proc.stdout+proc.stderr
    assert "CSG normalization resulted in an empty tree" not in text
    match=re.search(r"Normalized (?:CSG )?tree has (\d+) elements",text)
    assert match and 10 < int(match.group(1)) < 10000, text[-1000:]
    assert path.stat().st_size>5000


def test_rounded_top_corners_wrap_in_xy_plane(tmp_path):
    mesh, _ = render_stl(tmp_path, "top_xy_round", {
        "Output_mode": 1, "Selected_row": 1, "Selected_column": 1
    })
    # The rear-left corner is x≈-17, y≈158 and z≈75. Rounding in XZ
    # alone leaves a sharp plan-view XY corner; the new 3D mask must
    # create intermediate points in BOTH x and y near that corner.
    section = mesh.section(plane_origin=[0, 0, 74.6], plane_normal=[0, 0, 1])
    assert section is not None
    vertices = np.vstack(section.discrete)
    outer = vertices[(vertices[:, 0] < -16.4) & (vertices[:, 1] > 157.5)]
    assert len(np.unique(np.round(outer[:, 0], 3))) >= 4
    assert len(np.unique(np.round(outer[:, 1], 3))) >= 4

def test_inner_lip_transition_is_delayed_and_continuous(tmp_path):
    mesh, _ = render_stl(tmp_path, "rim_section", {
        "Output_mode": 1, "Selected_row": 1, "Selected_column": 1
    })
    section = mesh.section(plane_origin=[0,75,0], plane_normal=[0,1,0])
    assert section is not None
    pts = np.vstack(section.discrete)
    def left_bound(z):
        xs=[]
        for a,b in zip(pts,pts[1:]):
            if a[2]!=b[2] and (a[2]-z)*(b[2]-z)<=0 and a[0]<0 and b[0]<0:
                xs.append(float(a[0]+(b[0]-a[0])*(z-a[2])/(b[2]-a[2])))
        assert len(xs)>=2
        return sorted(set(xs))
    # Inner wall continues along ordinary drawer draft for 2 mm above H=65.
    x64=left_bound(64)[-1];x65=left_bound(65)[-1];x66=left_bound(66)[-1]
    assert x66-x65 == pytest.approx(x65-x64,abs=0.06)
    # After H+B=67 it follows the lip's outer print ramp angle.
    x67_5=left_bound(67.5)[-1];x68_5=left_bound(68.5)[-1]
    assert x68_5-x67_5 == pytest.approx(-1/math.tan(math.radians(60)),abs=0.05)
    assert min(left_bound(68.5)[-1]-left_bound(68.5)[0],
               left_bound(65)[-1]-left_bound(65)[0]) >= 2.0

def test_cutout_has_two_tangent_rounds_at_requested_riser_angle(tmp_path):
    mesh,_ = render_stl(tmp_path,"tangent_cutout", {
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Cutout_row_04":True,"Cutout_round_diameter_mm":20,
        "Cutout_riser_angle_deg":60
    })
    section=mesh.section(plane_origin=[1,0,0],plane_normal=[1,0,0])
    assert section is not None
    pts=np.vstack(section.discrete)
    # Inner divider notch side profile contains a protected flat bottom,
    # an angled riser, and several non-collinear facets at BOTH ends.
    lower=pts[(pts[:,2]>14)&(pts[:,2]<22)&(pts[:,1]>90)&(pts[:,1]<150)]
    upper=pts[(pts[:,2]>69)&(pts[:,2]<75.1)&(pts[:,1]>50)&(pts[:,1]<190)]
    assert len(np.unique(np.round(lower[:,2],2))) >= 4
    assert len(np.unique(np.round(upper[:,2],2))) >= 4

@pytest.mark.parametrize("side,top", [(0,0),(0.2,1.0),(0.6,1.5)])
def test_independent_connector_clearances_keep_blind_sockets_watertight(tmp_path, side, top):
    mesh,output=render_stl(tmp_path,f"socket_side{side}_top{top}",{
        "Output_mode":1,"Selected_row":1,"Selected_column":1,
        "Connector_side_clearance_total_mm":side,
        "Connector_top_clearance_mm":top
    })
    assert mesh.body_count==1
    assert "CONNECTOR CLEARANCES (total side / each side / top)" in output
    assert mesh.bounds[1,2]==pytest.approx(75,abs=0.05)

def test_connector_uses_full_6mm_height_under_7mm_blind_pocket(tmp_path):
    male,output=render_stl(tmp_path,"male_nominal_top_clearance",{
        "Output_mode":2,"Loose_connector_quantity":1
    })
    assert male.bounds[1,2]==pytest.approx(6.0,abs=0.05)
    import re
    m=re.search(r'"CONNECTOR ROOF CAPS \(at seam\)", ([\d.]+), ([\d.]+)',output)
    assert m,output[-2000:]
    male_cap,female_cap=map(float,m.groups())
    assert male_cap==pytest.approx(6.0)
    assert female_cap-male_cap==pytest.approx(1.0)


def test_single_geometry_path_and_openscad_controls_f5_f6():
    source,_=release_paths()
    scad=source.read_text()
    assert "if($preview)" not in scad
    assert "render(convexity" not in scad
    assert "fast_preview_tray" not in scad
    assert "module socket_opening_3d()" in scad
    assert "polyhedron(points=pts,faces=faces" in scad


@pytest.mark.parametrize("angle", [25,35,45,60,75])
def test_rim_uses_exact_selected_overhang_angle(tmp_path,angle):
    height=10
    mesh,output=render_stl(tmp_path,f"rim_exact_angle_{angle}",{
        "Output_mode":1,"Selected_row":1,"Selected_column":1,
        "Print_overhang_angle_deg":angle,"Tray_height_above_rim_mm":height,
        "Drawer_floor_corner_radius_mm":4 if angle<45 else 10
    })
    assert mesh.bounds[1,2] == pytest.approx(65+height,abs=0.06)
    assert 'RIM (angle FROM PRINT BED / fixed height / derived projection)' in output
    path=mesh.section(plane_origin=[0,79,0],plane_normal=[0,1,0])
    assert path is not None
    points=path.discrete[0]
    def outer_x(z):
        xs=[]
        for a,b in zip(points,points[1:]):
            if (a[2]-z)*(b[2]-z)<=0 and abs(a[2]-b[2])>1e-8 and a[0]<0 and b[0]<0:
                xs.append(float(a[0]+(b[0]-a[0])*(z-a[2])/(b[2]-a[2])))
        assert xs
        return min(xs)
    first=outer_x(65+0.1*height)
    second=outer_x(65+0.3*height)
    measured_angle=math.degrees(math.atan2(0.2*height,first-second))
    assert measured_angle==pytest.approx(angle,abs=0.4)

def test_rim_without_flare_retains_height(tmp_path):
    mesh,_=render_stl(tmp_path,"no_flare_height",{
        "Output_mode":1,"Selected_row":1,"Selected_column":1,
        "Rim_left":False,"Rim_right":False,"Rim_front":False,"Rim_rear":False,
        "Tray_height_above_rim_mm":13
    })
    assert mesh.bounds[1,2] == pytest.approx(78,abs=0.05)

def test_rim_parameter_is_derived_not_exposed():
    source, preset = release_paths()
    params = preset_parameters(preset)
    scad = source.read_text()
    assert "rim_projection_mm" not in scad
    assert "rim_projection_mm" not in params
    assert "RIM_PROJECTION=HAS_RIM ? LIP_Z/tan(ALPHA) : 0;" in scad
    assert "0:Continue previous" in scad
    assert "zero continues" not in scad.lower()

def test_customizer_sentence_case_controls_without_redundant_row_descriptions():
    source,preset=release_paths()
    scad=source.read_text()
    params=preset_parameters(preset)
    top=scad.split('/* [Hidden] */')[0]
    titles=re.findall(r'(?m)^([A-Za-z][A-Za-z0-9_]*)\s*=\s*[^;]+;',top)
    assert len(titles)>=55
    assert all(x[0].isupper() for x in titles)
    assert all(x[0].isupper() for x in params)
    assert 'Row_03' not in scad.lower()
    assert 'rim_projection_mm' not in scad.lower()


@pytest.mark.parametrize("radius",[12,20,30])
def test_socket_roof_is_actual_concentric_circle_in_exported_mesh(tmp_path,radius):
    """The rendered cutter, not merely the echo, must share the tray-filleting center."""
    model,preset=release_paths()
    marker="// ----------- Output and non-fatal invalid selection handling -----------"
    source=model.read_text()
    assert marker in source
    # Exercise exactly the socket module used inside actual trays, without
    # requiring a separate multi-minute full-tray Boolean for every radius.
    fixture=tmp_path/"actual_socket_fixture.scad"
    fixture.write_text(source.split(marker,1)[0]+"\nsocket_opening_3d();\n")
    path=tmp_path/f"actual_socket_r{radius}.stl"
    proc=openscad_render(path,{"Inner_bottom_radius_mm":radius},source=fixture,preset=preset)
    require_render_ok(proc,path)
    mesh=trimesh.load(path,force="mesh",process=True)
    assert mesh.is_watertight
    # Cutter native local Y is the perpendicular distance into the tray.
    cross=mesh.section(plane_origin=[0,0,0],plane_normal=[1,0,0])
    assert cross is not None
    points=np.vstack(cross.discrete)
    xs=np.round(points[:,1],5)
    roof=np.array([(x,points[xs==x,2].max()) for x in np.unique(xs)])
    R=radius
    cx=2+R
    cz=2+R
    # The opening is flat at Z=7 wherever the roof would otherwise exceed
    # the configured maximum. Only the visible curved portion is fitted.
    curved=roof[(roof[:,1]>0.15)&(roof[:,1]<6.98)&(roof[:,0]>0.1)&(roof[:,0]<7.3)]
    if radius==30:
        assert len(curved)==0, "R30 must retain its full 7 mm socket roof"
        assert roof[:,1].max()==pytest.approx(7,abs=0.01)
    else:
        assert len(curved)>=10
        fitted=np.hypot(curved[:,0]-cx,curved[:,1]-cz)
        assert np.max(np.abs(fitted-(R+2)))<0.06


@pytest.mark.parametrize("radius",[12,20,30])
def test_full_tray_and_socket_share_exact_circle_center(tmp_path,radius):
    out,_=render_csg(tmp_path,f"circle_center_r{radius}",{
        "Output_mode":1,"Selected_row":3,"Selected_column":2,
        "Inner_bottom_radius_mm":radius})
    match=re.search(
        r'"CONCENTRIC FILLET CENTER \(X, Z\) / RADII \(inner, socket, male\)", '
        r'([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+)',out)
    assert match,out[-2500:]
    cx,cz,inner,socket,male=map(float,match.groups())
    assert cx==pytest.approx(radius+2)
    assert cz==pytest.approx(radius+2)
    assert inner==pytest.approx(radius)
    assert socket-inner==pytest.approx(2)
    assert male-socket==pytest.approx(1)
