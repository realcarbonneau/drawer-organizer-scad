# Modular Drawer Organizer

Parametric, 3D-printable organizer for metal-sided kitchen drawers, including sloped sidewalls, connector sockets, and a grid-based tray layout.

## Current version: v5

- [OpenSCAD source](modular-organizer-v5.scad)
- [OpenSCAD Customizer preset](modular-organizer-v5.json)

Download **both files to the same folder**, then open `modular-organizer-v5.scad` in OpenSCAD 2021.01. The JSON supplies the **Kitchen cutlery drawer** preset.

## Example drawer and layout

- Top opening: **218 mm**; bottom flat width: **190 mm**; bottom corner radius: **10 mm**
- Interior depth: **475 mm**; drawer rim height: **~65 mm**; tray extension: **10 mm**
- Grid rows (rear to front): `1, 0, 3, 0, 0, 1`

This creates five trays: one full-width rear tray, three long central trays, and one full-width front tray. A row value of `0` extends the preceding tray group.

Use **Full layout** to preview the assembly or select an individual grid row and column to export one tray. The Customizer also controls adjoining-edge cutouts, connector placement, bottom chamfers, and optional exterior rim extensions.

## Versioning

Only the **current** `modular-organizer-vN.scad` and `modular-organizer-vN.json` files live in the repository root. Earlier revisions remain available in [Git history](https://github.com/realcarbonneau/drawer-organizer-scad/commits/main); no `versions/` directory is maintained.

## Source and notes

Based on the [Modular Drawer Organizer Remix](https://www.printables.com/model/816729-modular-drawer-organizer-remix/) concept. Check the upstream license and attribution requirements before redistributing derived files.

Check fit with a small test print before manufacturing the full set; measured drawer dimensions and physical fit have not yet been validated.
