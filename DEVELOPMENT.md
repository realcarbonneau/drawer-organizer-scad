# Drawer Organizer development guidelines

## Version and Git policies

- Use `drawer-organizer-vN.scad` and `drawer-organizer-vN.json` together. Increase **N** once for each new functional release; **remain on v9 throughout the current screenshot-led review iterations**. Documentation/checkpoint commits do not increment the functional version.
- Maintain only the latest SCAD/JSON pair at the branch root; older work belongs to Git history, **not a `versions/` directory**. Do not generate release ZIPs; use GitHub's repository download.
- Keep unfinished geometry on WIP branches. Promote reviewed releases to the default `main` branch. Release a WIP branch as a **single squash-equivalent commit** on the existing `main` parent when requested, without rewriting previous `main` history or adding `Co-authored-by` trailers.
- **Push a checkpoint frequently**, not just when a release is ready: after meaningful implementation milestones, before major refactors, and before expensive renders/testing. A WIP checkpoint may contain an incomplete design, but describe its status plainly. After any sync interruption, inspect the branch and resume from the newest surviving checkpoint.
- Update the README, preset, tests, and gallery with each significant geometry change, and verify Markdown uses unescaped backticks and fenced code blocks.

## Geometry and UI invariants

- Top-down drawer orientation: row 1 = REAR/farthest; column 1 = LEFT. A **Continue previous** row dropdown value extends the preceding group. Invalid selected parts print a message and generate no geometry.
- Use **2 mm walls and base**, 0.6 mm soft exposed-edge radius by default, capped below half the thickness. Maintain the uniform bottom inside fillet, no top internal horizontal ledges, and bottom exterior clearance chamfers.
- Outer left/right side tapers must fit the metal-sided drawer. Front/rear ends have no metal-side taper. Exterior lip ramp starts at drawer rim; inner ramp starts one base thickness higher and stays sloped through the top.
- The rounded access cutout has a specified BASE width, two smooth tangent R10 transitions by default, a configurable 45°–90° riser, and is controlled by an on/off checkbox for each row on interior dividers only.
- The dogbone uses two round heads plus a rectangular center and presses upward from underneath. No socket mouth chamfer or locking feature. Keep a blind roof, floor clearance, and adequate wall stock.
- Preserve ONE identical geometry path for both OpenSCAD F5 preview and F6 render. Do not call `render()` automatically, and do not implement a simplified `$preview` model. Avoid multiplying intersections in repeatable features (e.g. each female socket is a single manifold polyhedron), and test F5 CSG normalization without claiming this measures interactive orbit performance.

## Quality and review checks

1. Run `make check` on OpenSCAD 2021.01, and verify the current SCAD and JSON agree.
2. Confirm five individual tray STL bodies are watertight, no solid extends below z=0, and all default cutouts stay in inner divider walls.
3. Inspect **actual mesh screenshots** for full layout, both end trays, a middle tray, upper outer/inner corners, bottom fillet, cutout lower/upper transitions, rim cross-section, dogbone, and blind seats.
4. Test rim angles 25°/35°/45°/60°/75° and independent tray heights 10/18 mm; verify that projection is derived from height / tan(angle). Test the cutout at 45°/60°/90°, preview gaps 0/1/12/50 mm, invalid selections, and 1×1 grid.
5. Push WIP commits during implementation, including screenshots or CI preview artifacts, before further modifications. Use `main` for completed releases and WIP branches for later experimental iterations.
6. A watertight STL alone does **not** prove clearance, print quality, wall minimum everywhere, or the physical snap-fit; verify with physical test prints.
### v9 connector checkpoint

Use `Connector_center_thickness_mm = 4`, `Connector_diameter_protrusion_mm = 1` (radius increase on **each** side, yielding a 6 mm lobe), and `Connector_height_mm = 6`. The free straight section is 2× the 2 mm tray wall, so each tray receives 2 mm of the center bar. Render real STLs and verify pocket clearance before promoting v9.

## v9 connector tolerance controls

- `Connector_side_clearance_total_mm = 0.2`: female cavity is **0.1 mm larger on each side**, not 0.2 mm per side. Male dimensions remain unchanged.
- `Connector_top_clearance_mm = 1`: female roof is **1 mm higher** than the matching truncated male top wherever the connector has solid height; still a blind underside pocket.
- Test the socket roof for minimum floor stock when changing top clearance; verify clearances at the lobes and test-print.

## Rim parameter and Customizer invariant

- Expose **Tray_height_above_rim_mm** and **Print_overhang_angle_deg**, never a redundant projection control. Compute horizontal lip run from the two inputs, preserving exact height and slope.
- Use capitalized public Customizer identifiers (and matching JSON/test selectors). Keep section names and help text concise; no obsolete numeric-continuation explanations.
- Confirm CI passes on WIP before promoting a new functional change to `main`.
