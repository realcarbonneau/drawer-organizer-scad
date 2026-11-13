# Drawer Organizer — v9 geometry review

Parametric 3D-printable drawer trays for metal-sided kitchen drawers, authored in OpenSCAD 2021.01. **v9 is the current release on `main`.**

## Review files

- [OpenSCAD model](drawer-organizer-v9.scad)
- [Matching Customizer preset](drawer-organizer-v9.json)
- [Development and test guidelines](DEVELOPMENT.md)
- Actual mesh review screenshots are attached to the current review conversation. CI also generates a downloadable preview build artifact.

To open the named kitchen preset, download the `.scad` and matching `.json` into the same directory. In OpenSCAD, open the SCAD and select **Kitchen cutlery drawer**.

## Drawer and grid

In top view while standing at the FRONT, **row 1 is REAR** and column 1 is LEFT. Row subdivision `0` continues the previous row's group. The kitchen example uses a six-row, three-column grid: `1, 0, 3, 0, 0, 1`. This makes five trays: a rear full-width tray, three long middle trays, and a front full-width tray.

Measured working profile: 218 mm top inside width, 190 mm flat floor width, R10 mm floor corners, 475 mm inside length, ~65 mm rim height. Treat these as measured approximations. A 2 mm base and 2 mm walls are the defaults, with 0.6 mm soft exposed-edge rounding.

## v9 geometry and review checkpoints

- A uniform calculated **bottom inside fillet** protects the minimum floor stock. Outer bottom edges are chamfered for the metal drawer corner profile.
- The top rim has **continuous 0.6 mm exposed-edge softening** in XZ, YZ and around the XY corner intersections, including a small tapered fill at the inside corners. The soft radius is capped below half the minimum wall/base thickness.
- Exterior side walls follow the metal drawer taper. **Front and rear ends are vertical** apart from any separately enabled rim flare.
- A rim flare uses the same print slope on its outer and inner faces. The outside ramp starts at the metal rim; the **inside ramp starts 2 mm higher** and continues to the top without a vertical return.
- One checkbox per logical row controls an access cutout on all INNER left/right dividers in that row; row 4 is ON by default. **At the lowest point** the opening measures `cutout_base_width_mm` (25 mm by default). Two tangent circular arcs with a shared 20 mm diameter blend to a straight 60° riser and back to the top surface. The opening may expand into neighboring logical-row space when the rise/angle/rounding require it.
- Rounded dogbones press **upward into blind underside pockets**, without locking ledges or socket entry chamfers. The connector has a **4 mm straight center thickness**, **1 mm radial protrusion per side (6 mm lobe diameter)** and a **4 mm exposed straight span (2 mm per tray)**. The connector is **6 mm high at its flat center**, with a trimmed top profile at both lobes to clear the bottom fillet.
- F5 preview calls `render()` once per tray to normalize the CSG to one cached solid per part. This reduces preview-scene complexity; it does **not** guarantee smooth camera navigation on every computer. F6 produces the final mesh.
- The console prints nominal logical grid pitch, approximate clear pitch, and the selected tray's dimensions.

## Actual model review screenshots

The review gallery includes the complete layout, front/rear trays, outer and inner top corners, uniform bottom fillet, rounded cutout and profile, lip cross-section, blind sockets, and dogbone top/side views. Request the latest review images in the conversation or download generated PNGs from GitHub Actions build artifacts.

The close-up mesh sections show the actual OpenSCAD STL contours. **No physical fit or F5 mouse-orbit performance has been verified on your printer/computer.**

## Build and tests

Requirements: Python 3, pytest, numpy, trimesh, OpenSCAD 2021.01; `xvfb-run` for headless PNG previews.

```sh
python -m pip install -r requirements-dev.txt
make test
make build
make check
```

The suite exercises the five default trays, connectors, invalid selections, rim and chamfer parameters, row-4 cutouts, both tangent radii, top XY corner rounding, inner rim start height, and F5 cached preview. Generated STL/PNG files are build artifacts, not a substitute for physical inspection.
## Independent connector fit clearances

The **male** dogbone keeps its nominal shape: 4 mm center thickness, 6 mm lobe diameter, 4 mm straight span and 6 mm maximum height. The **female socket** adds **0.2 mm total side clearance** (0.1 mm each opposing side) and **1 mm vertical top clearance** beneath its blind roof. The socket's cut-out follows the rounded-base-derived safe roof cap with the extra top clearance while preserving the modeled minimum material thickness. Test print a connector and socket before relying on press fit.

