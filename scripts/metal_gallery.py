"""Render four genuine OpenSCAD views of the Metal Cabinet Drawer preset.

The four images show one 5-piece assembly from 3D, top, side, and front.
All sides of this preset stay vertical above the print-bed foot relief.
No Photoshop/AI reconstruction or external reference photo is involved.
"""
from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path

from PIL import Image

from scripts.chamfer_docs import FRAME_SIZE, uniform_frame
from scripts.organizer_cli import (
    openscad_render, preset_parameters, release_paths, require_render_ok,
)

PRESET = "Metal Cabinet Drawer"


@dataclass(frozen=True)
class View:
    name: str
    camera: tuple[float, float, float, float, float, float, float]


# Center: effective width=314 mm, length=459 mm, printed height=125 mm.
# OpenSCAD camera rotations: plan (0,0,0); front (90,0,0);
# side (90,0,90). Orthographic projection keeps vertical edges parallel.
VIEWS = (
    View("metal-drawer-3d", (157, 229.5, 62, 58, 0, 35, 1600)),
    View("metal-drawer-top", (157, 229.5, 62, 0, 0, 0, 1550)),
    View("metal-drawer-side", (157, 229.5, 62, 90, 0, 90, 1550)),
    View("metal-drawer-front", (157, 229.5, 62, 90, 0, 0, 1250)),
)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=Path("docs/images/cad"))
    args = parser.parse_args()
    _, preset = release_paths()
    parameters = preset_parameters(preset, PRESET)
    expected = {
        "Straight_edges": "true",
        "Rim_left": "false",
        "Rim_right": "false",
        "Drawer_top_inside_width_mm": "315",
        "Drawer_inside_length_mm": "460",
        "Drawer_inside_height_mm": "115",
        "Row_02": "0",
    }
    for key, value in expected.items():
        if parameters.get(key) != value:
            raise ValueError(f"Metal preset changed: {key}={parameters.get(key)}")
    if any(parameters[f"Cutout_row_{row:02d}"] != "false"
           for row in range(1, 7)):
        raise ValueError("Metal preset gallery expects divider cutouts disabled")

    args.output.mkdir(parents=True, exist_ok=True)
    for view in VIEWS:
        raw = args.output / (view.name + "-raw.png")
        final = args.output / (view.name + ".png")
        settings = {
            "Output_mode": 0,
            "Preview_separation_mm": 7,
            "Connectors_enabled": False,
            "Render_facets": 48,
        }
        try:
            result = openscad_render(
                raw,
                settings,
                image_focus=view.camera,
                image_ortho=True,
                image_render=False,
                preset_name=PRESET,
                timeout=240,
            )
            require_render_ok(result, raw)
            framed = uniform_frame(raw, name=view.name)
            framed.save(final, optimize=True)
            with Image.open(final) as image:
                if image.size != FRAME_SIZE:
                    raise RuntimeError(f"Bad CAD image dimensions: {view.name}")
        finally:
            raw.unlink(missing_ok=True)
        print("Rendered real metal cabinet drawer CAD view:", final)


if __name__ == "__main__":
    main()
