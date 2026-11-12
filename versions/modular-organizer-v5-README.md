# Modular Drawer Organizer v5

A parametric OpenSCAD organizer generated from drawer dimensions and logical grid rows. Compatible with OpenSCAD 2021.01. Based on the [Modular Drawer Organizer Remix](https://www.printables.com/model/816729-modular-drawer-organizer-remix/) concept; refer to the source page for the original author's terms.

## Files

- `modular-organizer-v5.scad` — OpenSCAD source, with built-in Customizer groups.
- `modular-organizer-v5.json` — single named preset **Kitchen cutlery drawer**.

Keep the `.scad` and `.json` together so OpenSCAD sees the preset.

## Drawer and grid

Default measured profile: **218 mm top opening, 190 mm flat floor, R10 bottom metal corners, 475 mm depth, 65 mm rim height**. Tray rises **10 mm above the rim**. These dimensions are measured estimates, not certified Blum/IKEA specifications.

Row 1 = drawer **rear**, final row = **front**. One number per row gives the number of equal-width compartments; `0` continues the preceding nonzero row across the next unit of depth.

Default: `grid_columns = 3`, `grid_rows = 6`, row splits `1, 0, 3, 0, 0, 1`. Produces five trays: two full-width end trays and three long center trays. Every tray touching the left/right metal wall automatically receives the wall draft. Each full-width end tray has connector sockets **only along its single inward edge**.

## Selecting one printable part

In the final **08 - Part selection and preview** Customizer section, set `output_mode = 1`, then choose `selected_grid_row` and `selected_grid_column`. Selecting any zero continuation row resolves to the entire merged tray. Row 3, column 2 selects the middle long tray.

`output_mode = 0` shows the full layout; modes 2 and 3 generate loose connectors. The full layout is for inspection, not a single assembled STL.

## Upper rim overhang and bottom chamfers

**02 - Drawer edges and rim overhang** includes four independently switchable flags: `rim_on_left`, `rim_on_right`, `rim_on_front`, `rim_on_rear`. Default is **left/right enabled**, front/rear disabled. `rim_overhang_mm = 3` defines the maximum horizontal flare at the tray top. This is a **printed flare**, not a mechanical clip/snap under the drawer rim.

Exterior lower edges have the larger 45° (default) chamfer needed around the metal bottom radius. Internal *joining* lower edges use a smaller `join_edge_chamfer_height_mm = 1` for elephant-foot mitigation. `chamfer_angle_deg` (angle from print bed) is shared by both lower chamfers and the top rim flare. The inside fillet radius is calculated from the chamfer slope, wall thickness, and minimum base thickness. For other chamfer angles, check that the measured drawer profile remains physically feasible; OpenSCAD assertions will reject certain incompatible profiles.

## Access cutouts on joining walls

In **04 - Joining-wall access cutouts**, each logical grid row has `cutout_after_column_row_01` through `_10`:

- `0`: no cutout in that row.
- `1`: cutout at the joining boundary between tray columns 1 and 2.
- `2`: between columns 2 and 3; and so on.

Both adjacent joining walls get identical **upper notches** at the center of the requested logical grid row, even when rows are merged into one longer tray. Their lower connector sockets remain present. The setting does nothing in a row group that has only one tray across (an invalid boundary is rejected by an assertion). Example: `cutout_after_column_row_03 = 1` cuts the right wall of middle column 1 and the left wall of middle column 2, in the portion of the long trays corresponding to logical row 3. `join_cutout_width_mm` and `join_cutout_depth_mm` size the notch.

This initial version allows **one joining boundary per logical grid row**. For more cutouts on the same row, additional slots would be needed in a future revision.

## Connectors

With `connector_mode=0`, sockets are generated *only where trays adjoin*, and positions on both sides of a common boundary agree. The small chamfer is independent of the connector socket geometry. `connector_quantity` only determines how many **loose** connectors are exported, never the socket count.

## Validation

Tested in OpenSCAD 2021.01: compiled default layout, selected tray modes, loose joiners and two matching cutout examples. Rendered STL meshes for all five individual default trays, matching cutout pairs, alternative front rim, and 55° chamfer; all rendered as watertight meshes. **Physical fit, manufacturing tolerances and printer behavior are untested.** Print a small profile sample before committing to the full set.