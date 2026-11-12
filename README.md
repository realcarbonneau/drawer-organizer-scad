# Modular Drawer Organizer (OpenSCAD)

Parametric 3D-printable tray organizer for metal-sided kitchen drawers, with sloped sidewalls, modular connectors, and a logical row/column grid.

## Latest version

- [v5 source](versions/modular-organizer-v5.scad)
- [v5 kitchen drawer preset](versions/modular-organizer-v5.json)
- [v5 instructions and revision details](versions/modular-organizer-v5-README.md)

Open the `.scad` and keep the same-version `.json` alongside it for OpenSCAD Customizer presets.

## Version history

All releases are retained separately under `versions/`, using file names `modular-organizer-v1.scad` through `modular-organizer-v5.scad`. Commits are preserved in ordinary Git history.

## Current example

Interior metal drawer width: 218 mm at the top, 190 mm flat bottom, R10 mm bottom corners. Depth: 475 mm, metal wall height: approximately 65 mm, tray extension: 10 mm above the rim. Six logical rows split as `1, 0, 3, 0, 0, 1`, creating a full-width rear tray, three long middle trays, and a full-width front tray.

## Attribution

Adapted from the [Modular Drawer Organizer Remix](https://www.printables.com/model/816729-modular-drawer-organizer-remix/) concept. Check that model's license and other dependencies before redistributing or publishing derived printable designs.

## Notes

- OpenSCAD 2021.01.
- Use the individual-part output to export each tray. The full layout is a preview.
- Validate with a small test print. Physical drawer fit has not yet been verified.
