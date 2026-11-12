"""CLI helpers shared by the build command and tests.

OpenSCAD is always the geometry engine; Python merely selects configurations,
executes OpenSCAD, and inspects its results.
"""

from __future__ import annotations

import json
import re
import shutil
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PRESET_NAME = "Kitchen cutlery drawer"


def release_paths(root: Path = ROOT) -> tuple[Path, Path]:
    """Find exactly one matched, versioned SCAD/JSON pair in the repo root."""
    files = sorted(root.glob("drawer-organizer-v*.scad"))
    if len(files) != 1:
        raise ValueError(f"Expected one versioned .scad in {root}, found {len(files)}")
    source = files[0]
    if not re.fullmatch(r"drawer-organizer-v[1-9][0-9]*\.scad", source.name):
        raise ValueError(f"Unrecognized release name: {source.name}")
    preset = source.with_suffix(".json")
    if not preset.is_file():
        raise ValueError(f"Missing matching Customizer JSON: {preset.name}")
    if sorted(root.glob("drawer-organizer-v*.json")) != [preset]:
        raise ValueError("Only one matching versioned JSON file may be present")
    return source, preset


def preset_parameters(json_file: Path, name: str = PRESET_NAME) -> dict[str, str]:
    data = json.loads(json_file.read_text(encoding="utf-8"))
    if data.get("fileFormatVersion") != "1":
        raise ValueError("OpenSCAD Customizer format must be version 1")
    parameters = data.get("parameterSets", {}).get(name)
    if not isinstance(parameters, dict):
        raise ValueError(f"Missing preset {name!r}")
    return parameters


def default_parts(parameters: dict[str, str]) -> list[tuple[int, int]]:
    """Return (starting row, column) for each tray in rear-to-front order."""
    rows = int(parameters["grid_rows"])
    columns = int(parameters["grid_columns"])
    if not 1 <= rows <= 10 or not 1 <= columns <= 10:
        raise ValueError("Grid dimensions must be 1..10")
    parts = []
    for row in range(1, rows + 1):
        n = int(parameters[f"row_{row:02d}_splits"])
        if not 0 <= n <= columns or (row == 1 and n == 0):
            raise ValueError(f"Invalid grid row {row}: {n}")
        if n:
            parts.extend((row, col) for col in range(1, n + 1))
    return parts


def openscad_render(
    output: Path,
    overrides: dict[str, int | float | bool | str] | None = None,
    *,
    source: Path | None = None,
    preset: Path | None = None,
    timeout: int = 180,
) -> subprocess.CompletedProcess[str]:
    model, config = release_paths() if source is None or preset is None else (source, preset)
    executable = shutil.which("openscad")
    if not executable:
        raise RuntimeError("OpenSCAD CLI was not found; install OpenSCAD 2021.01")
    output.parent.mkdir(parents=True, exist_ok=True)
    args = [executable, "--hardwarnings", "-o", str(output)]
    if output.suffix.lower() == ".stl":
        args.extend(["--export-format", "binstl"])
    elif output.suffix.lower() == ".png":
        args.extend(["--viewall", "--imgsize", "1200,900",
                     "--camera", "0,0,0,45,0,35,900"])
    # OpenSCAD 2021.01's JSON Customizer preset wins over -D. Merge overrides
    # into a temporary preset; otherwise tests silently render default values.
    merged = json.loads(config.read_text(encoding="utf-8"))
    settings = merged["parameterSets"][PRESET_NAME]
    for key, value in (overrides or {}).items():
        settings[key] = str(value).lower() if isinstance(value, bool) else str(value)
    with tempfile.TemporaryDirectory(prefix="organizer-preset-") as folder:
        generated = Path(folder) / "test-preset.json"
        generated.write_text(json.dumps(merged), encoding="utf-8")
        command = [*args, "-p", str(generated), "-P", PRESET_NAME, str(model)]
        if output.suffix.lower() == ".png":
            # Some headless environments expose a stale DISPLAY=:0.
            xvfb = shutil.which("xvfb-run")
            if xvfb:
                command = [xvfb, "-a", *command]
        return subprocess.run(command, capture_output=True, text=True,
                              timeout=timeout, check=False)


def require_render_ok(result: subprocess.CompletedProcess[str], output: Path) -> None:
    combined = (result.stdout or "") + "\n" + (result.stderr or "")
    if result.returncode or "ERROR:" in combined or "WARNING:" in combined:
        raise RuntimeError(f"OpenSCAD render failed ({result.returncode}):\n{combined[-3500:]}")
    if not output.is_file() or output.stat().st_size == 0:
        raise RuntimeError(f"OpenSCAD produced no output: {output}\n{combined[-3500:]}")
