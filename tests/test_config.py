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
    assert [int(params[f"row_{i:02d}_splits"]) for i in range(1,7)]==[1,0,3,0,0,1]


def test_invalid_grid_first_row_rejected():
    with pytest.raises(ValueError,match="row 1"):
        default_parts({"grid_rows":"1","grid_columns":"1","row_01_splits":"0"})


def test_one_by_one_grid_is_valid():
    assert default_parts({"grid_rows":"1","grid_columns":"1","row_01_splits":"1"})==[(1,1)]


def test_customizer_controls_and_defaults():
    source,preset=release_paths()
    scad=source.read_text()
    params=preset_parameters(preset)
    assert "preview_separation_mm = 0; // [0:1:50]" in scad
    assert "render_facets = 20; // [3:1:200]" in scad
    assert int(params["render_facets"])==20
    assert int(params["print_overhang_angle_deg"])==60
    assert params["connector_diameter_protrusion_mm"] == "1"
    assert params["connector_center_thickness_mm"] == "4"
    assert "connector_diameter_addition_mm" not in params
    assert params["base_thickness_mm"] == "2"
    assert params["wall_thickness_mm"] == "2"
    assert params["soft_edge_radius_mm"] == "0.6"
    assert params["cutout_row_04"] == "true"
    assert "connector_center_thickness_mm" in params
    assert "connector_height_mm" in params
    assert "cutout_round_diameter_mm" in params
    assert "cutout_riser_angle_deg" in params
    for key in ("connector_entry_bevel_mm","connector_head_diameter_mm",
                "connector_lobe_inset_mm","cutout_after_column_row_03"):
        assert key not in params
    for i in range(1,11):
        assert params[f"cutout_row_{i:02d}"] in ("true","false")

def test_connector_clearance_semantics_and_independent_controls():
    source,preset=release_paths()
    scad=source.read_text()
    p=preset_parameters(preset)
    assert p["connector_side_clearance_total_mm"]=="0.2"
    assert p["connector_top_clearance_mm"]=="1"
    assert "connector_clearance_mm" not in p
    assert "connector_clearance_mm" not in scad
    assert "SOCKET_SIDE_CLEARANCE=connector_side_clearance_total_mm/2;" in scad
    assert "socket_roof_safe_cap_at(y)-SOCKET_TOP_CLEARANCE" in scad
    assert "PAD_HEIGHT=CONNECTOR_HEIGHT+SOCKET_TOP_CLEARANCE+SOCKET_STOCK+0.4" in scad
