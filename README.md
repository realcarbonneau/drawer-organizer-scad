# Drawer Organizer

Parametric, 3D-printable organizer for metal-sided kitchen drawers, including sloped sidewalls, connector sockets, and a grid-based tray layout.

## Current version: v5

- [OpenSCAD source](drawer-organizer-v5.scad)
- [OpenSCAD Customizer preset](drawer-organizer-v5.json)

Download **both files to the same folder**, then open `drawer-organizer-v5.scad` in **OpenSCAD 2021.01**. Its matching JSON file contains the **Kitchen cutlery drawer** preset.

## Example drawer and layout

- Top opening: **218 mm**; bottom flat width: **190 mm**; bottom corner radius: **10 mm**
- Interior depth: **475 mm**; drawer rim height: **~65 mm**; tray extension: **10 mm**
- Grid rows (rear to front): `1, 0, 3, 0, 0, 1`

This creates five trays: one full-width rear tray, three long central trays, and one full-width front tray. A row value of `0` extends the preceding tray group.

Use **Full layout** to preview the assembly, or select an individual grid row and column to export one tray. The Customizer also controls adjoining-edge cutouts, connector placement, bottom chamfers, and optional exterior rim extensions.

## Source and notes

Based on the [Modular Drawer Organizer Remix](https://www.printables.com/model/816729-modular-drawer-organizer-remix/) concept. Check the upstream license and attribution requirements before redistributing derived files.

Check fit with a small test print before manufacturing the full set; measured drawer dimensions and physical fit have not yet been validated.

## Development guidelines

See [DEVELOPMENT.md](DEVELOPMENT.md) for naming, version increments, Git-history policy, and release steps. **Keep only the current version at the repository root; use Git history for earlier versions.**
