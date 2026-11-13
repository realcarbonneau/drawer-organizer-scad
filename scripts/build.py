#!/usr/bin/env python3
"""Build each tray, loose connectors, and preview screenshots."""

from __future__ import annotations

import argparse
from pathlib import Path
from PIL import Image

from scripts.organizer_cli import (
    default_parts, openscad_render, preset_parameters,
    release_paths, require_render_ok,
)


def verify_preview_framing(path: Path, *, closeup: bool = False, small_object: bool = False) -> None:
    """Reject tiny or accidentally clipped model screenshots before publishing."""
    with Image.open(path) as image:
        # Tomorrow's OpenSCAD preview background is nearly white. Use the
        # occupied dark CAD pixels, not the CSG construction bounding box.
        mask=image.convert("L").point(lambda pixel: 255 if pixel < 210 else 0)
        bounds=mask.getbbox()
        if bounds is None:
            raise RuntimeError(f"Preview has no visible geometry: {path}")
        x0,y0,x1,y1=bounds
        width_fraction=(x1-x0)/image.width
        height_fraction=(y1-y0)/image.height
        min_width=0.16 if small_object else 0.25
        min_height=0.16 if small_object else 0.22
        if width_fraction < min_width or height_fraction < min_height:
            raise RuntimeError(
                f"CAD preview too small: {path.name}; occupied "
                f"{width_fraction:.0%} width, {height_fraction:.0%} height"
            )
        if not closeup and (
            x0 < image.width*0.018 or x1 > image.width*0.982 or
            y0 < image.height*0.018 or y1 > image.height*0.982
        ):
            raise RuntimeError(f"CAD preview accidentally clipped: {path.name}")
        print(f"Checked framing {path.name}: "
              f"{width_fraction:.0%} width, {height_fraction:.0%} height")


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
    # These camera targets are measured for the shipped kitchen-drawer preset.
    # --autocenter/--viewall fit an oversized CSG *construction* box rather
    # than the printed trays, shrinking a model to just a few pixels.
    # Explicit 3D camera targets make each model fill the PNG without cropping.
    screenshots = {
        "full-layout": ((107,250,37,58,0,35,1500),
                        {"Output_mode": 0, "Preview_separation_mm": 12}),
        "rear-tray": ((94.5,79,35,62,0,35,850),
                      {"Output_mode": 1, "Selected_row": 1, "Selected_column": 1}),
        "middle-tray": ((31.5,118.5,35,70,0,67,1000),
                        {"Output_mode": 1, "Selected_row": 3, "Selected_column": 2}),
        "front-tray": ((94.5,39.5,35,62,0,35,750),
                       {"Output_mode": 1, "Selected_row": 6, "Selected_column": 1}),
        "dogbone": ((7,-21,3,58,0,35,85),
                    {"Output_mode": 2, "Loose_connector_quantity": 1}),
        "cutout-closeup": ((31.5,118.5,35,70,0,67,280),
                           {"Output_mode": 1, "Selected_row": 3, "Selected_column": 2}),
    }
    for name, (focus, selection) in screenshots.items():
        destination = args.output / "previews" / f"{name}.png"
        # Raise facets for published screenshots; printed STL defaults do not change.
        result = openscad_render(destination, {**selection, "Render_facets": 64},
                                image_focus=focus)
        require_render_ok(result, destination)
        verify_preview_framing(destination,closeup=name=="cutout-closeup",
                               small_object=name=="dogbone")
        print(f"high-resolution, properly framed preview {destination}")
    print(f"Built {len(parts)} trays and preview images from {source.name}")


if __name__ == "__main__":
    main()
