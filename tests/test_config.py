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
    assert source.name=="drawer-organizer-v9.scad"
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
    assert "Render_facets = 20; // [3:1:200]" in scad
    assert int(params["Render_facets"])==20
    assert int(params["Print_overhang_angle_deg"])==60
    assert params["Connector_diameter_protrusion_mm"] == "1"
    assert params["Connector_center_thickness_mm"] == "4"
    assert "connector_diameter_addition_mm" not in params
    assert params["Base_thickness_mm"] == "2"
    assert params["Wall_thickness_mm"] == "2"
    assert params["Soft_edge_radius_mm"] == "0.6"
    assert params["Cutout_row_04"] == "true"
    assert "Connector_center_thickness_mm" in params
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
    assert "if(SOFT_R>0 && Cutout_base_width_mm>0" in scad
    assert "for(face=[1,1+T])" in scad
    assert "sphere(r=SOFT_R" in scad
    assert "minkowski()" in scad


def test_readme_visuals_are_camera_fitted_and_never_cropped():
    root=release_paths()[0].parent
    cli=(root/"scripts/organizer_cli.py").read_text()
    gallery=(root/"scripts/readme_gallery.py").read_text()
    build=(root/"scripts/build.py").read_text()
    assert '"--imgsize", "3200,2200"' in cli
    assert '"--autocenter", "--viewall"' in cli
    assert 'image_camera=camera, image_focus=focus' in build
    assert '"cutout-closeup"' in build
    assert 'focus = (31.5, 118.5, 35, 70, 0, 67, 280)' in build
    assert "'cutout-closeup.png'" in gallery
    assert '"Render_facets": 64' in build
    assert "def image_contain(" in gallery
    assert "def image_crop(" not in gallery
    assert ".crop(" not in gallery
    assert "min(size[0]/im.width,size[1]/im.height,1.0)" in gallery
    assert "SCALE=2" in gallery


def test_connector_clearance_semantics_and_independent_controls():
    source,preset=release_paths()
    scad=source.read_text()
    p=preset_parameters(preset)
    assert p["Connector_side_clearance_total_mm"]=="0.2"
    assert p["Connector_top_clearance_mm"]=="1"
    assert "connector_clearance_mm" not in p
    assert "connector_clearance_mm" not in scad
    assert "SOCKET_SIDE_CLEARANCE=Connector_side_clearance_total_mm/2;" in scad
    assert "socket_roof_safe_cap_at(y)-SOCKET_TOP_CLEARANCE" in scad
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
