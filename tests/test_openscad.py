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
    assert csg.stat().st_size < 200


def test_continuation_row_selects_full_multiroot_tray(tmp_path):
    out, _ = render_csg(tmp_path,"continued",{
        "Output_mode":1,"Selected_row":5,"Selected_column":2
    })
    assert "TRAY rows 3-5 column 2" in out


@pytest.mark.parametrize("angle", [25,35,45,60,75])
def test_print_angles_create_valid_solids(tmp_path,angle):
    m, out = render_stl(tmp_path,f"angle_{angle}",{
        "Output_mode":1,"Selected_row":1,"Selected_column":1,
        "Print_overhang_angle_deg":angle
    })
    assert m.extents[2] >= 65
    assert f"{angle}," in out


@pytest.mark.parametrize("angle,height",[(25,10),(60,18),(75,18)])
def test_large_rim_runs_use_fixed_height_without_crashing(tmp_path,angle,height):
    m, output = render_stl(tmp_path,f"rim_{angle}_{height}",{
        "Output_mode":1,"Selected_row":1,"Selected_column":1,
        "Print_overhang_angle_deg":angle,"Tray_height_above_rim_mm":height
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


def test_cutout_on_single_column_row_is_noop(tmp_path):
    m,_ = render_stl(tmp_path,"cut_singlecol",{
        "Output_mode":1,"Selected_row":1,"Selected_column":1,
        "Cutout_row_01":True
    })
    assert m.is_watertight


def test_cutout_base_width_and_profile_options(tmp_path):
    for angle in (45,60,90):
        m,_=render_stl(tmp_path,f"cutout_angle_{angle}",{
            "Output_mode":1,"Selected_row":3,"Selected_column":2,
            "Cutout_row_04":True,"Cutout_riser_angle_deg":angle,
            "Cutout_round_diameter_mm":20
        })
        assert m.is_watertight


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
    # Inner divider notch side profile contains a flat bottom at z≈9.4,
    # an angled riser, and several non-collinear facets at BOTH ends.
    lower=pts[(pts[:,2]>9.4)&(pts[:,2]<16)&(pts[:,1]>90)&(pts[:,1]<150)]
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
        "Print_overhang_angle_deg":angle,"Tray_height_above_rim_mm":height
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
