# Drawer Organizer

Parametric 3D-printable kitchen-drawer tray system for metal-sided drawers. The design supports drafted exterior walls, independently printable compartments, connector sockets, optional join-wall cutouts, and a drawer-defined row/column grid.

## Current release: v6

- [OpenSCAD source](drawer-organizer-v6.scad)
- [OpenSCAD Customizer preset](drawer-organizer-v6.json)

Download **both files to the same directory**, then open `drawer-organizer-v6.scad` with **OpenSCAD 2021.01**. Select the **Kitchen cutlery drawer** preset in the Customizer (if needed).

### Top-down grid orientation

The grid is described **as a person looking straight down into an open drawer from the front**, with the drawer pulled toward them:

- **Row 1 is at the REAR**, farthest from the viewer; increasing row numbers move **toward the FRONT**, nearest to the viewer.
- **Column 1 is at the LEFT**; increasing column numbers move **toward the RIGHT**.
- For example, in a 6-row, 3-column grid, *row 6* is the closest row and *column 3* is the rightmost column.
- A row split value of `0` continues the **previous row's compartments**. Selecting any row within a continued group selects that whole multirow tray.

### Example dimensions and layout

- Measured top opening **218 mm**; bottom flat width **190 mm**; bottom corner radius **10 mm**.
- Interior depth **475 mm**; rim height approximately **65 mm**; tray extension **10 mm**.
- `grid_rows = 6`, `grid_columns = 3`.
- Row splits from REAR to FRONT: `1, 0, 3, 0, 0, 1`.

Result: five trays—one full-width rear, three long center trays, one full-width front.

### Rendering and selecting a tray

1. In **Part selection and preview**, select **Full drawer layout** to examine the assembled layout, or **One tray by row and column** to generate an individual part.
2. Choose from the labeled dropdowns **Selected row 1–10** and **Selected column 1–10**. The choices are fixed because OpenSCAD 2021.01's Customizer does not dynamically rebuild dropdown choices from other parameters.
3. Press **F5** for preview and **F6** for a final render before exporting the selected tray as STL.
4. If a row number is greater than `grid_rows`, or its column exceeds the number of compartments in that row's group, **no tray geometry** is generated. The **Console** (View → Console) prints `SELECTION INVALID: ...` and lists the available range. Select a valid row/column to continue. The full-layout option ignores individual part selection.

### Chamfers, connectors, and cutouts

- **Exterior edges** use a large bottom chamfer to clear the metal drawer's curved floor transitions. **Internal joining edges** use an independent small chamfer, normally **1 mm**, as continuous elephant-foot relief along the *entire* joining side, including connector mounting blocks.
- The join-edge relief is subtracted from the **tray**, not the loose joining connectors. Setting `join_edge_chamfer_height_mm=0` disables it.
- `chamfer_angle_deg` controls the common chamfer angle **from the horizontal print bed**. For shallow angles, **automatic** chamfer fitting reduces the exterior chamfer **height** to preserve the specified angle and keep the tray within the measured drawer profile. **Manual** sizing will report a configuration error if an incompatible height/angle combination is requested.
- The full-layout preview displays adjoining tray parts; it is **not** one ready-to-print combined STL. Use the one-part output mode for independent printing.
- Row cutouts use the `cutout_after_column_row_XX` controls, where `0` means no cutout and `1` means the boundary between columns 1 and 2 in that row. Cutouts are mirrored on both adjacent walls, above the lower connector sockets.

## Development guidelines

See [DEVELOPMENT.md](DEVELOPMENT.md) for version increments, repository naming, testing, and Git-history rules. **Only the current `drawer-organizer-vN.scad` and matching `.json` are kept at repository root; earlier releases remain in Git history.**

## Source and physical fit

Based on the [Modular Drawer Organizer Remix](https://www.printables.com/model/816729-modular-drawer-organizer-remix/) concept; check the upstream license and attribution requirements before republishing derivatives. Verify dimensions by making a short test print before printing the complete drawer. STL geometry tests do not establish physical fit.
