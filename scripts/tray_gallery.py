"""Render ten additional real OpenSCAD views: two for each physical tray.

Uses the shipped kitchen-drawer preset. Each image comes from the selected
physical tray (Output_mode=1), not a mockup or a reassembled depiction.
Five alternate angles and five detail/underside images supplement the gallery.
Uses actual OpenSCAD F5 geometry previews; model colors match the other trays.
"""
from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path

from PIL import Image

from scripts.chamfer_docs import FRAME_SIZE, uniform_frame
from scripts.organizer_cli import (
    default_parts, openscad_render, preset_parameters,
    release_paths, require_render_ok,
)


@dataclass(frozen=True)
class TrayView:
    name: str
    row: int
    col: int
    camera: tuple[float, float, float, float, float, float, float]
    closeup: bool = False


# Camera target X/Y/Z; Euler X/Y/Z; viewing distance (mm).
# Rear: rows 1-2; middle: rows 3-5, columns 1-3; front: row 6.
# For the middle, the access openings are in logical row 4, Y=118.5.
TRAY_VIEWS = (
    TrayView("tray-rear-angle", 1, 1, (94.5,79,35,42,0,145,880)),
    TrayView("tray-rear-underside", 1, 1, (94.5,79,18,145,0,35,950)),
    TrayView("tray-middle-left-angle", 3, 1, (31.5,118.5,35,55,0,145,970)),
    TrayView("tray-middle-left-cutout", 3, 1, (58,118.5,44,70,0,38,485), True),
    TrayView("tray-middle-center-angle", 3, 2, (31.5,118.5,35,47,0,20,970)),
    TrayView("tray-middle-center-cutout", 3, 2, (58,118.5,44,73,0,42,485), True),
    TrayView("tray-middle-right-angle", 3, 3, (31.5,118.5,35,53,0,-32,970)),
    TrayView("tray-middle-right-cutout", 3, 3, (5,118.5,44,72,0,142,485), True),
    TrayView("tray-front-angle", 6, 1, (94.5,39.5,35,44,0,140,800)),
    TrayView("tray-front-underside", 6, 1, (94.5,39.5,18,145,0,35,900)),
)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=Path("docs/images"))
    parser.add_argument("--input", type=Path, default=Path("build/previews"))
    args = parser.parse_args()
    _, preset = release_paths()
    selected = {(v.row, v.col) for v in TRAY_VIEWS}
    expected = set(default_parts(preset_parameters(preset)))
    if selected != expected or len(TRAY_VIEWS) != 2 * len(expected):
        raise RuntimeError("Extra gallery must show two views of each physical tray")
    destdir = args.output / "cad"
    destdir.mkdir(parents=True, exist_ok=True)
    args.input.mkdir(parents=True, exist_ok=True)
    for view in TRAY_VIEWS:
        raw = args.input / f"{view.name}.png"
        params = {
            "Output_mode": 1,
            "Selected_row": view.row,
            "Selected_column": view.col,
            "Render_facets": 64,
        }
        proc = openscad_render(
            raw, params,
            image_focus=view.camera,
            image_render=False,  # F5 actual geometry preview; teal color is set in the model.
            timeout=120,
        )
        require_render_ok(proc, raw)
        dest = destdir / f"{view.name}.png"
        uniform_frame(raw, name=view.name, allow_clipping=view.closeup).save(dest, optimize=True)
        with Image.open(dest) as im:
            if im.size != FRAME_SIZE:
                raise RuntimeError(f"Unexpected image dimensions: {view.name}")
        print("Wrote actual OpenSCAD tray screenshot", dest)
    print(f"Validated {len(TRAY_VIEWS)} supplementary real-CAD gallery images")


if __name__ == "__main__":
    main()
