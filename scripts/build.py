#!/usr/bin/env python3
"""Build each tray, loose connectors, and preview screenshots."""

from __future__ import annotations

import argparse
from pathlib import Path

from scripts.organizer_cli import (
    default_parts, openscad_render, preset_parameters,
    release_paths, require_render_ok,
)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=Path("build"))
    args = parser.parse_args()
    source, preset = release_paths()
    params = preset_parameters(preset)
    parts = default_parts(params)
    for row, col in parts:
        destination = args.output / f"tray-row{row:02d}-col{col:02d}.stl"
        result = openscad_render(destination, {
            "Output_mode": 1, "Selected_row": row, "Selected_column": col
        })
        require_render_ok(result, destination)
        print(f"built {destination}")
    if params.get("Connectors_enabled", "true") != "false":
        destination = args.output / "dogbone-connectors.stl"
        result = openscad_render(destination, {"Output_mode": 2})
        require_render_ok(result, destination)
        print(f"built {destination}")
    # Screenshot images are CI artifacts, not files retained in Git history.
    # Each camera is fitted to the *actual model*, without cropping the PNG.
    # The middle-tray camera faces the access cutout for an unobstructed view.
    screenshots = {
        "full-layout": ((58, 0, 35), {"Output_mode": 0, "Preview_separation_mm": 12}),
        "rear-tray": ((62, 0, 35), {"Output_mode": 1, "Selected_row": 1, "Selected_column": 1}),
        "middle-tray": ((70, 0, 67), {"Output_mode": 1, "Selected_row": 3, "Selected_column": 2}),
        "front-tray": ((62, 0, 35), {"Output_mode": 1, "Selected_row": 6, "Selected_column": 1}),
        "dogbone": ((58, 0, 35), {"Output_mode": 2, "Loose_connector_quantity": 1}),
    }
    for name, (camera, selection) in screenshots.items():
        destination = args.output / "previews" / f"{name}.png"
        # More facets for screenshots alone; printable STL defaults are unchanged.
        result = openscad_render(destination, {**selection, "Render_facets": 64},
                                image_camera=camera)
        require_render_ok(result, destination)
        print(f"high-resolution preview {destination}")
    print(f"Built {len(parts)} trays and preview images from {source.name}")


if __name__ == "__main__":
    main()
