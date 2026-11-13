# Drawer Organizer development guidelines

## Version and Git policies

- Use `drawer-organizer-vN.scad` and `drawer-organizer-vN.json` together. Increase **N** once for each new functional release; **remain on v9 throughout the current screenshot-led review iterations**. Documentation/checkpoint commits do not increment the functional version.
- Maintain only the latest SCAD/JSON pair at the branch root; older work belongs to Git history, **not a `versions/` directory**. Do not generate release ZIPs; use GitHub's repository download.
- Keep unfinished code on `wip/v9-recovery`, without modifying `main` until the screenshot review is accepted. Commits must be normal, additive commits; no force-push, history rewriting, squash, or `Co-authored-by` attribution trailers.
- **Push a checkpoint frequently**, not just when a release is ready: after meaningful implementation milestones, before major refactors, and before expensive renders/testing. A WIP checkpoint may contain an incomplete design, but describe its status plainly. After any sync interruption, inspect the branch and resume from the newest surviving checkpoint.
- Update the README, preset, tests, and gallery with each significant geometry change, and verify Markdown uses unescaped backticks and fenced code blocks.

## Geometry and UI invariants

- Top-down drawer orientation: row 1 = REAR/farthest; column 1 = LEFT. A zero split continues the preceding row group. Invalid selected parts print a message and generate no geometry.
- Use **2 mm walls and base**, 0.6 mm soft exposed-edge radius by default, capped below half the thickness. Maintain the uniform bottom inside fillet, no top internal horizontal ledges, and bottom exterior clearance chamfers.
- Outer left/right side tapers must fit the metal-sided drawer. Front/rear ends have no metal-side taper. Exterior lip ramp starts at drawer rim; inner ramp starts one base thickness higher and stays sloped through the top.
- The rounded access cutout has a specified BASE width, two smooth tangent R10 transitions by default, a configurable 45°–90° riser, and is controlled by an on/off checkbox for each row on interior dividers only.
- The dogbone uses two round heads plus a rectangular center and presses upward from underneath. No socket mouth chamfer or locking feature. Keep a blind roof, floor clearance, and adequate wall stock.
- Avoid repeated high-complexity CSG preview nodes; cache a completed solid per tray in `$preview` and maintain a fast F6 render. Test F5 preview node/solid counts separately from camera orbit performance, which needs manual UI inspection.

## Quality and review checks

1. Run `make check` on OpenSCAD 2021.01, and verify the current SCAD and JSON agree.
2. Confirm five individual tray STL bodies are watertight, no solid extends below z=0, and all default cutouts stay in inner divider walls.
3. Inspect **actual mesh screenshots** for full layout, both end trays, a middle tray, upper outer/inner corners, bottom fillet, cutout lower/upper transitions, rim cross-section, dogbone, and blind seats.
4. Test the rim at 60° and 75° with 18 mm projection, the cutout at 45°/60°/90°, gap spacing 0/1/12/50 mm, invalid selections, 1×1 grid, and output angle options.
5. Push WIP commits during implementation, including screenshots or CI preview artifacts, before further modifications. Keep `main` untouched pending review.
6. A watertight STL alone does **not** prove clearance, print quality, wall minimum everywhere, or the physical snap-fit; verify with physical test prints.
### v9 connector checkpoint

Use `connector_center_thickness_mm = 4`, `connector_diameter_protrusion_mm = 1` (radius increase on **each** side, yielding a 6 mm lobe), and `connector_height_mm = 6`. The free straight section is 2× the 2 mm tray wall, so each tray receives 2 mm of the center bar. Render real STLs and verify pocket clearance before promoting v9.
