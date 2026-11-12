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
            "output_mode": 1, "selected_row": row, "selected_column": col
        })
        require_render_ok(result, destination)
        print(f"built {destination}")
    if params.get("connectors_enabled", "true") != "false":
        destination = args.output / "dogbone-connectors.stl"
        result = openscad_render(destination, {"output_mode": 2})
        require_render_ok(result, destination)
        print(f"built {destination}")
    # Screenshot images are CI artifacts, not files retained in Git history.
    screenshots = {
        "full-layout": {"output_mode": 0, "preview_separation_mm": 12},
        "rear-tray": {"output_mode": 1, "selected_row": 1, "selected_column": 1},
        "middle-tray": {"output_mode": 1, "selected_row": 3, "selected_column": 2},
        "front-tray": {"output_mode": 1, "selected_row": 6, "selected_column": 1},
        "dogbone": {"output_mode": 2, "loose_connector_quantity": 1},
    }
    for name, selection in screenshots.items():
        destination = args.output / "previews" / f"{name}.png"
        result = openscad_render(destination, selection)
        require_render_ok(result, destination)
        print(f"preview {destination}")
    print(f"Built {len(parts)} trays and preview images from {source.name}")


if __name__ == "__main__":
    main()
