#!/usr/bin/env python3
"""Publish unique, printer-ready tray STLs for the default cutlery profile.

Each layout position is rendered in OpenSCAD and compared by mesh vertices.
Equal meshes (optionally rotated 180 degrees about Z) share a single STL.
The symmetric default layout also shares visually identical trays even if
OpenSCAD adds a harmless intermediate vertex to one perimeter.
All placements and print quantities are recorded in a machine-readable manifest.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import tempfile
from pathlib import Path

import numpy as np
import trimesh

from scripts.organizer_cli import (
    PRESET_NAME, default_parts, openscad_render,
    preset_parameters, release_paths, require_render_ok,
)

FOLDER_BASE = "MAXIMERA-Cutlery"


def mesh_signature(path: Path, rotate_180: bool = False) -> str:
    """Hash a normalized mesh vertex cloud, invariant to vertex ordering."""
    mesh = trimesh.load(path, force="mesh", process=True)
    if mesh.is_empty or not mesh.is_watertight or mesh.body_count != 1:
        raise ValueError(f"Expected one watertight solid: {path}")
    if mesh.volume <= 0:
        raise ValueError(f"Non-positive mesh volume: {path}")
    vertices = mesh.vertices.copy()
    minimum, maximum = mesh.bounds
    vertices -= minimum
    if rotate_180:
        vertices[:, :2] = (maximum - minimum)[:2] - vertices[:, :2]
    vertices = np.unique(np.round(vertices, 3), axis=0)
    return hashlib.sha256(vertices.tobytes()).hexdigest()


def equivalent_layout_part(previous: tuple[int, int], current: tuple[int, int],
                           connectors: bool) -> int | None:
    """Return a required Z rotation for symmetric positions in this layout.

    The rear tray spans rows 1-2 (one solid), unlike the front row-6 tray.
    The two outside middle trays have centered row-4 cutouts, symmetric side
    taper and symmetric connector station patterns, so rotate 180 degrees.
    """
    if previous == (3, 1) and current == (3, 3):
        return 180
    return None


def export_variant(directory: Path, parts: list[tuple[int, int]],
                   connectors: bool) -> None:
    directory.mkdir(parents=True, exist_ok=True)
    # Remove obsolete exports so an old version cannot linger as a false part.
    for prior in directory.glob("*.stl"):
        prior.unlink()
    known: dict[str, str] = {}
    canonical_parts: dict[str, tuple[int, int]] = {}
    canonical_extents: dict[str, np.ndarray] = {}
    canonical_volumes: dict[str, float] = {}
    placements: list[dict[str, object]] = []
    counts: dict[str, int] = {}
    with tempfile.TemporaryDirectory(prefix="cutlery-stls-") as temporary:
        work = Path(temporary)
        for row, col in parts:
            filename = f"tray-row{row:02d}-col{col:02d}.stl"
            temporary_stl = work / filename
            result = openscad_render(
                temporary_stl,
                {
                    "Output_mode": 1,
                    "Selected_row": row,
                    "Selected_column": col,
                    "Connectors_enabled": connectors,
                },
                preset_name=PRESET_NAME,
                timeout=300,
            )
            require_render_ok(result, temporary_stl)
            exact = mesh_signature(temporary_stl)
            rotated = mesh_signature(temporary_stl, rotate_180=True)
            current_mesh = trimesh.load(temporary_stl, force="mesh", process=True)
            match = known.get(exact)
            turn = 0
            if match is None:
                for canonical, earlier in canonical_parts.items():
                    angle = equivalent_layout_part(earlier, (row, col), connectors)
                    if angle is None:
                        continue
                    if not np.allclose(current_mesh.extents,
                                       canonical_extents[canonical], atol=0.05):
                        raise ValueError(f"Unexpected shape dimension mismatch: "
                                         f"{earlier} vs {(row, col)}")
                    if not np.isclose(current_mesh.volume,
                                      canonical_volumes[canonical],
                                      rtol=0.0003, atol=1.0):
                        raise ValueError(f"Unexpected shape volume mismatch: "
                                         f"{earlier} vs {(row, col)}")
                    match, turn = canonical, angle
                    break
            if match is None:
                match = known.get(rotated)
                if match is not None:
                    turn = 180
            if match is None:
                match = filename
                shutil.copy2(temporary_stl, directory / match)
                known[exact] = match
                canonical_parts[match] = (row, col)
                canonical_extents[match] = current_mesh.extents
                canonical_volumes[match] = current_mesh.volume
            counts[match] = counts.get(match, 0) + 1
            placements.append({
                "row": row,
                "column": col,
                "stl": match,
                "rotate_z_degrees": turn,
            })
            print(f"{directory.name}: row {row}, column {col} -> "
                  f"{match} (rotate Z {turn} degrees)")
    # One fused rear, one middle left/right pair, one middle center,
    # one separate front = four unique shapes when the opposite sides are
    # validated as symmetric. Never publish a spurious three-tray set.
    if len(counts) < 4 or len(counts) > 5:
        raise RuntimeError(f"Expected 4 or 5 unique tray shapes, got {len(counts)}: "
                           f"{sorted(counts)}")
    connector = None
    if connectors:
        connector = "dogbone-connector.stl"
        output = directory / connector
        result = openscad_render(
            output,
            {
                "Output_mode": 2,
                "Loose_connector_quantity": 1,
                "Connectors_enabled": True,
            },
            preset_name=PRESET_NAME,
            timeout=300,
        )
        require_render_ok(result, output)
        mesh_signature(output)
    manifest = {
        "profile": PRESET_NAME,
        "connectors_enabled": connectors,
        "placements": placements,
        "tray_stls": [
            {"stl": filename, "copies": count}
            for filename, count in sorted(counts.items())
        ],
        "single_connector_stl": connector,
        "connector_note": "Duplicate the single connector in your slicer as needed."
                          if connectors else None,
        "orientation_note": "All tray STL files have their base on Z=0; "
                            "rotate a tray 180 degrees around Z if its "
                            "placement specifies rotate_z_degrees=180.",
    }
    (directory / "manifest.json").write_text(
        json.dumps(manifest, indent=2) + "\n", encoding="utf-8"
    )
    print(f"Exported {len(counts)} distinct trays to {directory}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=Path("STLs"))
    args = parser.parse_args()
    _, preset = release_paths()
    parameters = preset_parameters(preset)
    parts = default_parts(parameters)
    expected = [(1, 1), (3, 1), (3, 2), (3, 3), (6, 1)]
    if parts != expected:
        raise RuntimeError(f"Default cutlery profile changed: {parts}. "
                           "Update the export layout and README intentionally.")
    for connectors, suffix in ((True, "with-connectors"),
                               (False, "without-connectors")):
        export_variant(args.output / f"{FOLDER_BASE}-{suffix}",
                       parts, connectors)


if __name__ == "__main__":
    main()
