"""Geometry regression tests against the real OpenSCAD 2021.01 renderer."""
from __future__ import annotations

import math
import re
import numpy as np
import pytest
import trimesh
from scripts.organizer_cli import openscad_render, require_render_ok


def render_stl(tmp_path, name, overrides):
    path = tmp_path / f"{name}.stl"
    result = openscad_render(path, overrides)
    require_render_ok(result, path)
    mesh = trimesh.load(path, force="mesh", process=True)
    assert not mesh.is_empty
    assert mesh.is_watertight, f"Non-watertight STL: {name}"
    assert mesh.volume > 0
    assert abs(mesh.bounds[0, 2]) < 0.03, "Tray or joiner extends below drawer floor"
    return mesh, result.stdout + result.stderr


def render_csg(tmp_path, name, overrides):
    path = tmp_path / f"{name}.csg"
    result = openscad_render(path, overrides)
    require_render_ok(result, path)
    return result.stdout + result.stderr, path


def preview_positions(messages):
    expr = r'ECHO: "PREVIEW ORIGIN \(row, column, x, y, w, depth\)", (\d+), (\d+), ([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+), ([\d.e+-]+)'
    return {(int(r), int(c)): tuple(float(v) for v in (x, y, w, d))
            for r, c, x, y, w, d in re.findall(expr, messages)}


@pytest.mark.parametrize("gap", [0, 1, 12, 50])
def test_preview_separation_is_exact_between_tray_edges(tmp_path, gap):
    text, _ = render_csg(tmp_path, f"gap_{gap}", {
        "output_mode": 0, "preview_separation_mm": gap
    })
    parts = preview_positions(text)
    assert set(parts) == {(1, 1), (3, 1), (3, 2), (3, 3), (6, 1)}
    m1, m2, m3 = [parts[(3, c)] for c in (1, 2, 3)]
    rear, front = parts[(1, 1)], parts[(6, 1)]
    assert m2[0] - (m1[0] + m1[2]) == pytest.approx(gap, abs=0.01)
    assert m3[0] - (m2[0] + m2[2]) == pytest.approx(gap, abs=0.01)
    assert rear[1] - (m1[1] + m1[3]) == pytest.approx(gap, abs=0.01)
    assert m1[1] - (front[1] + front[3]) == pytest.approx(gap, abs=0.01)


@pytest.mark.parametrize("row,col", [(1, 1), (3, 1), (3, 2), (3, 3), (6, 1)])
def test_each_default_tray_is_single_watertight_solid(tmp_path, row, col):
    mesh, out = render_stl(tmp_path, f"r{row}c{col}", {
        "output_mode": 1, "selected_row": row, "selected_column": col
    })
    assert mesh.body_count == 1
    assert "TRAY rows" in out
    assert mesh.bounds[1, 2] >= 74.9


@pytest.mark.parametrize("row,col,expected", [
    (7, 1, "Row 7 does not exist"),
    (1, 2, "Column 2 does not exist"),
    (3, 4, "Column 4 does not exist"),
])
def test_invalid_selection_is_empty_not_fatal(tmp_path, row, col, expected):
    out, path = render_csg(tmp_path, f"invalid_{row}_{col}", {
        "output_mode": 1, "selected_row": row, "selected_column": col
    })
    assert "SELECTION INVALID" in out
    assert expected in out
    assert path.stat().st_size < 200


def test_continued_row_selects_whole_tray_group(tmp_path):
    out, _ = render_csg(tmp_path, "continued", {
        "output_mode": 1, "selected_row": 5, "selected_column": 2
    })
    assert "TRAY rows 3-5 column 2" in out


@pytest.mark.parametrize("angle", [25, 35, 45, 60, 75])
def test_print_angles_render(tmp_path, angle):
    mesh, out = render_stl(tmp_path, f"angle_{angle}", {
        "output_mode": 1, "selected_row": 1, "selected_column": 1,
        "print_overhang_angle_deg": angle
    })
    assert mesh.extents[2] >= 65
    assert f"{angle}," in out


@pytest.mark.parametrize("angle,projection", [(60, 18), (75, 18)])
def test_large_rim_projection_remains_printable(tmp_path, angle, projection):
    mesh, _ = render_stl(tmp_path, f"rim_{angle}", {
        "output_mode": 1, "selected_row": 1, "selected_column": 1,
        "print_overhang_angle_deg": angle, "rim_projection_mm": projection
    })
    height = 65 + max(10, projection * math.tan(math.radians(angle)))
    assert mesh.bounds[1, 2] == pytest.approx(height, abs=0.12)


def test_rear_end_vertical_and_sides_outward(tmp_path):
    mesh, _ = render_stl(tmp_path, "rear", {
        "output_mode": 1, "selected_row": 1, "selected_column": 1
    })
    rear = mesh.vertices[np.abs(mesh.vertices[:, 1] - 158) < 0.03]
    assert rear.size > 0
    assert rear[:, 2].min() == pytest.approx(0, abs=0.03)
    assert np.any((rear[:, 2] >= 64.5) & (rear[:, 2] <= 65.5))
    assert mesh.bounds[0, 0] < -10
    assert mesh.bounds[1, 0] > 189


def test_bottom_interior_corners_are_rounded(tmp_path):
    mesh, _ = render_stl(tmp_path, "fillet", {
        "output_mode": 1, "selected_row": 3, "selected_column": 2
    })
    section = mesh.section(plane_origin=[0, 118, 0], plane_normal=[0, 1, 0])
    assert section is not None
    vertices = np.vstack(section.discrete)
    curved = vertices[(vertices[:, 0] > 2) & (vertices[:, 0] < 9)
                      & (vertices[:, 2] > 1.9) & (vertices[:, 2] < 6.5)]
    assert len(np.unique(np.round(curved[:, 2], 2))) >= 3


@pytest.mark.parametrize("relief", [0, 1, 1.8])
def test_joining_edge_elephant_foot_variations(tmp_path, relief):
    render_stl(tmp_path, f"foot_{relief}", {
        "output_mode": 1, "selected_row": 3, "selected_column": 2,
        "join_edge_elephant_foot_mm": relief
    })


def test_row_cutout_only_removes_divider_wall_material(tmp_path):
    mesh0, _ = render_stl(tmp_path, "uncut", {
        "output_mode": 1, "selected_row": 3, "selected_column": 2
    })
    mesh1, _ = render_stl(tmp_path, "cut", {
        "output_mode": 1, "selected_row": 3, "selected_column": 2,
        "cutout_row_04": True
    })
    removed = mesh0.volume - mesh1.volume
    assert 200 < removed < mesh0.volume * 0.12, removed


def test_cutout_of_one_column_group_is_noop(tmp_path):
    mesh, _ = render_stl(tmp_path, "one_column_cutout", {
        "output_mode": 1, "selected_row": 1, "selected_column": 1,
        "cutout_row_01": True
    })
    assert mesh.is_watertight


def test_single_tray_grid_mode(tmp_path):
    mesh, _ = render_stl(tmp_path, "one_by_one", {
        "grid_rows": 1, "grid_columns": 1, "row_01_splits": 1,
        "output_mode": 1, "selected_row": 1, "selected_column": 1
    })
    assert mesh.extents[0] > 180


def test_two_circles_and_rectangle_make_simple_loose_connectors(tmp_path):
    mesh, _ = render_stl(tmp_path, "joiners", {
        "output_mode": 2, "loose_connector_quantity": 3
    })
    assert mesh.body_count == 3
    assert mesh.bounds[1, 2] == pytest.approx(3.8, abs=0.1)
    parts = mesh.split(only_watertight=True)
    assert len(parts) == 3
    for part in parts:
        assert part.extents[0] == pytest.approx(5.2, abs=0.12)
        assert part.extents[1] == pytest.approx(16.0, abs=0.12)


@pytest.mark.parametrize("facets", [3, 20, 200])
def test_facet_range_accepted_by_openscad(tmp_path, facets):
    text, _ = render_csg(tmp_path, f"fn_{facets}", {
        "output_mode": 2, "loose_connector_quantity": 1, "render_facets": facets
    })
    assert "WARNING:" not in text
