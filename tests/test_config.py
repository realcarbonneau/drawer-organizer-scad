"""Fast release, OpenSCAD Customizer and grid-schema tests."""
from __future__ import annotations

import json
import re
from pathlib import Path

import pytest

from scripts.organizer_cli import default_parts,preset_parameters,release_paths


def test_only_one_current_release_pair():
    source,preset=release_paths()
    assert source.stem==preset.stem
    assert source.name=="drawer-organizer-v12.scad"
    assert json.loads(preset.read_text())["fileFormatVersion"]=="1"


def test_preset_keys_exist_as_model_controls():
    source,preset=release_paths()
    scad=source.read_text()
    for key in preset_parameters(preset):
        assert re.search(rf"(?m)^\s*{re.escape(key)}\s*=",scad),key


def test_default_grid_and_row_continuations():
    _,preset=release_paths()
    params=preset_parameters(preset)
    assert default_parts(params)==[(1,1),(3,1),(3,2),(3,3),(6,1)]
    assert [int(params[f"Row_{i:02d}"]) for i in range(1,7)]==[1,0,3,0,0,1]


def test_invalid_grid_first_row_rejected():
    with pytest.raises(ValueError,match="row 1"):
        default_parts({"Grid_rows":"1","Grid_columns":"1","Row_01":"0"})


def test_one_by_one_grid_is_valid():
    assert default_parts({"Grid_rows":"1","Grid_columns":"1","Row_01":"1"})==[(1,1)]


@pytest.mark.parametrize("compartments", [4,5,6])
def test_row_split_requires_sufficient_grid_columns(compartments):
    _,preset=release_paths()
    params=preset_parameters(preset)
    params["Row_03"]=str(compartments)
    with pytest.raises(ValueError,match="row 3"):
        default_parts(params)
    params["Grid_columns"]=str(compartments)
    assert [c for r,c in default_parts(params) if r==3] == list(range(1,compartments+1))


def test_customizer_controls_and_defaults():
    source,preset=release_paths()
    scad=source.read_text()
    params=preset_parameters(preset)
    assert "Preview_separation_mm = 0; // [0:1:50]" in scad
    assert "Preview_loose_connector_gap_mm = 12; // [0:0.5:60]" in scad
    assert "Preview_loose_connector_offset_mm = 12; // [0:0.5:100]" in scad
    assert params["Preview_loose_connector_gap_mm"] == "12"
    assert params["Preview_loose_connector_offset_mm"] == "12"
    assert scad.index("Preview_loose_connector_gap_mm =") < scad.index("Render_facets =")
    assert scad.index("Preview_loose_connector_offset_mm =") < scad.index("Render_facets =")
    assert "Render_facets = 40; // [3:1:200]" in scad
    assert int(params["Render_facets"])==40
    assert int(params["Print_overhang_angle_deg"])==60
    assert params["Connector_diameter_protrusion_mm"] == "1.25"
    assert params["Connector_center_thickness_mm"] == "5.5"
    assert "connector_diameter_addition_mm" not in params
    assert params["Base_thickness_mm"] == "2"
    assert params["Wall_thickness_mm"] == "2"
    assert params["Soft_edge_radius_mm"] == "0.6"
    assert params["Inner_bottom_radius_mm"] == "30"
    assert "Inner_bottom_radius_mm = 30; // [0:0.5:100]" in scad
    assert "preview_loose_connectors();" in scad
    assert "color([0.18,0.49,0.51])" in scad
    assert scad.count("color([0.90,0.62,0.25])") >= 2
    assert "color([0.78+0.03*((r+c)%3),0.84,0.91-0.04*(c%3)])" not in scad
    assert "module inner_corner_fillet_keepouts(" in scad
    assert "offset(r=INNER_BOTTOM_R) offset(delta=-INNER_BOTTOM_R)" not in scad
    assert "INNER_BOTTOM_R_MIN=max(B,CHAMFER_Z+B);" in scad
    assert "connector_offset_circle_z(x,B)" in scad
    assert "connector_offset_circle_z(x,B+SOCKET_TOP_CLEARANCE)" in scad
    assert "inner_fillet_center_x(outer,is_x)" in scad
    assert "connector_fillet_center_x()=inner_fillet_center_x(false,false)" in scad
    assert "function inner_fillet_center_z() = B+INNER_BOTTOM_R;" in scad
    assert "CONNECTOR_LOBE_REDUCTION" not in scad
    assert "INNER_BOTTOM_R=max(INNER_BOTTOM_R_MIN,Inner_bottom_radius_mm);" in scad
    assert params["Drawer_floor_corner_radius_mm"] == "10"
    assert "Outer_bottom_chamfer_max_rise_mm" not in params
    assert "Outer_bottom_chamfer_max_rise_mm" not in scad
    assert "DRAWER_CORNER_CHAMFER_Z=max(0,Drawer_floor_corner_radius_mm);" in scad
    assert "ELEPHANT_FOOT_Z=max(0,Elephant_foot_mm);" in scad
    assert "CHAMFER_Z=max(DRAWER_CORNER_CHAMFER_Z,ELEPHANT_FOOT_Z);" in scad
    assert "JOIN_Z=ELEPHANT_FOOT_Z;" in scad
    assert "CHAMFER_X=CHAMFER_Z/tan(ALPHA);" in scad
    assert "CHAMFER_FIT_ERROR" in scad
    assert "function cutout_floor_z()" in scad
    assert params["Cutout_row_04"] == "true"
    assert "Connector_center_thickness_mm" in params
    assert params["Connector_height_mm"] == "9"
    assert "Connector_height_mm" in params
    assert "Cutout_round_diameter_mm" in params
    assert params["Cutout_riser_angle_deg"] == "75"
    assert "Cutout_riser_angle_deg = 75;" in scad
    assert "Cutout_base_width_mm = 25;" in scad
    assert "Cutout_base_width_mm = 25; // [" not in scad
    assert "Cutout_riser_angle_deg = 75; // [" not in scad
    assert "Grid_columns = 3; // [1:1:10]" in scad
    assert params["Grid_columns"] == "3"
    for key in ("connector_entry_bevel_mm","connector_head_diameter_mm",
                "connector_lobe_inset_mm","cutout_after_column_row_03"):
        assert key not in params
    for i in range(1,11):
        assert params[f"Cutout_row_{i:02d}"] in ("true","false")

def test_cutout_soft_touch_roundover_tracks_the_same_radius():
    source,_=release_paths()
    scad=source.read_text()
    assert "if(SOFT_R>0 && Cutout_base_width_mm>=1" in scad
    assert "function cutout_touch_clearance(u,r)" in scad
    assert "soft_cutout_face_3d(1,+1)" in scad
    assert "soft_cutout_face_3d(1+T,-1)" in scad
    assert "polyhedron(points=vertices,faces=faces,convexity=8);" in scad
    assert "minkowski()" not in scad


def test_reference_drawer_images_are_local_and_full_width():
    root=release_paths()[0].parent
    readme=(root/"README.md").read_text()
    assert readme.endswith("</small>\n")
    assert "## Reference drawers" in readme
    assert readme.index("## Reference drawers") > readme.index("## Version history")
    for filename in ("maximera-ikea.jpg", "maximera-installed.jpg",
                     "tandembox-blum.jpg"):
        path=f"docs/images/reference-drawers/{filename}"
        assert (root/path).is_file(), path
        assert f'<img src="{path}"' in readme
        assert f'<a href="{path}">' in readme
    # Standalone photographs, not two-column CAD tables.
    assert readme.count('width="780"')==3


def test_readme_visuals_are_camera_fitted_and_never_cropped():
    root=release_paths()[0].parent
    cli=(root/"scripts/organizer_cli.py").read_text()
    gallery=(root/"scripts/readme_gallery.py").read_text()
    build=(root/"scripts/build.py").read_text()
    assert '"--imgsize", "3200,2200"' in cli
    assert '"--autocenter", "--viewall"' in cli
    assert 'image_focus=focus' in build
    assert '"cutout-closeup"' in build
    assert '"full-layout": ((107,250,37,58,0,35,1500)' in build
    assert '"front-tray": ((94.5,39.5,35,62,0,35,750)' in build
    assert 'verify_preview_framing(destination' in build
    assert "'cutout-closeup.png'" in gallery
    assert '"Render_facets": 64' in build
    assert "def image_contain(" in gallery
    assert "def image_crop(" not in gallery
    assert ".crop(" not in gallery
    assert "min(size[0]/im.width,size[1]/im.height,1.0)" in gallery
    assert "SCALE=2" in gallery


def test_underside_preview_uses_f6_not_opencsg():
    # F5 OpenCSG showed white holes through the rear blind connector roofs.
    from scripts.tray_gallery import TRAY_VIEWS
    source = (release_paths()[0].parent / "scripts/tray_gallery.py").read_text()
    assert 'image_render=view.name.endswith("-underside")' in source
    assert {v.name for v in TRAY_VIEWS if v.name.endswith("-underside")} == {
        "tray-rear-underside", "tray-front-underside"
    }


def test_every_physical_tray_has_two_distinct_real_cad_gallery_views():
    from scripts.tray_gallery import TRAY_VIEWS

    _, preset = release_paths()
    physical_parts = set(default_parts(preset_parameters(preset)))
    assert len(TRAY_VIEWS) == 10
    assert { (v.row, v.col) for v in TRAY_VIEWS } == physical_parts
    assert len({v.name for v in TRAY_VIEWS}) == 10
    for row, col in physical_parts:
        views = [v for v in TRAY_VIEWS if (v.row, v.col) == (row, col)]
        assert len(views) == 2
        assert len({v.camera for v in views}) == 2
    assert sum(v.closeup for v in TRAY_VIEWS) == 3
    readme = (release_paths()[0].parent / "README.md").read_text()
    for v in TRAY_VIEWS:
        assert f'docs/images/cad/{v.name}.png' in readme


def test_preview_frame_validator_catches_tiny_and_clipped_models(tmp_path):
    from PIL import Image, ImageDraw
    from scripts.build import verify_preview_framing

    image=Image.new("RGB",(1000,700),(247,247,247))
    d=ImageDraw.Draw(image)
    p=tmp_path/"framing.png"

    d.rectangle((495,345,505,355),fill=(45,66,91))
    image.save(p)
    with pytest.raises(RuntimeError,match="too small"):
        verify_preview_framing(p)

    d.rectangle((275,200,725,525),fill=(45,66,91))
    image.save(p)
    verify_preview_framing(p)

    d.rectangle((0,200,725,525),fill=(45,66,91))
    image.save(p)
    with pytest.raises(RuntimeError,match="clipped"):
        verify_preview_framing(p)


def test_connector_clearance_semantics_and_independent_controls():
    source,preset=release_paths()
    scad=source.read_text()
    p=preset_parameters(preset)
    assert p["Connector_side_clearance_total_mm"]=="0.2"
    assert p["Connector_top_clearance_mm"]=="1"
    assert p["Elephant_foot_mm"]=="1"
    assert "Elephant_foot_mm = 1; // [0:0.1:2]" in scad
    assert "Join_edge_elephant_foot_mm" not in p
    assert "Connector_elephant_foot_mm" not in p
    assert "Join_edge_elephant_foot_mm" not in scad
    assert "Connector_elephant_foot_mm" not in scad
    assert "connector_clearance_mm" not in p
    assert "connector_clearance_mm" not in scad
    assert "SOCKET_SIDE_CLEARANCE=Connector_side_clearance_total_mm/2;" in scad
    assert "JOIN_Z=ELEPHANT_FOOT_Z;" in scad
    assert "CONNECTOR_FOOT_REQUEST=max(0,Elephant_foot_mm);" in scad
    assert "outside ? concat([[JOIN_X,0],[0,JOIN_Z],[0,H]]" in scad
    assert "function connector_offset_circle_z(x,extra_radius)" in scad
    assert "connector_offset_circle_z(x,B)" in scad
    assert "connector_offset_circle_z(x,B+SOCKET_TOP_CLEARANCE)" in scad
    assert "PAD_HEIGHT=CONNECTOR_HEIGHT+SOCKET_TOP_CLEARANCE+SOCKET_STOCK+0.4" in scad


def test_print_angle_and_height_are_only_rim_dimension_controls():
    source,preset=release_paths()
    params=preset_parameters(preset)
    scad=source.read_text()
    assert params["Tray_height_above_rim_mm"]=="10"
    assert params["Print_overhang_angle_deg"]=="60"
    assert "rim_projection_mm" not in params
    assert "rim_projection_mm" not in scad
    assert "Continue previous" in scad
    assert "zero continues" not in scad.lower()
