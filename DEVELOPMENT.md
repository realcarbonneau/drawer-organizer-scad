# Development Guidelines

## Naming and versioning

- Name the project **Drawer Organizer**. Use lowercase hyphenated filenames: `drawer-organizer-vN.scad` and `drawer-organizer-vN.json`.
- Increment `N` for each **new functional release**: `v5 → v6 → v7`. Update **both filenames**, the SCAD title/header, the README links, and any version references in documentation.
- **Current version: v6.** Keep the latest version at repository root while it is being tested. A documentation-only correction to the existing release does not necessarily require an increment.
- Keep the matching SCAD and JSON files next to each other, both in the repository and when downloaded. The JSON provides the OpenSCAD Customizer named preset.

## Repository structure

The main branch root should include only the current release plus project documentation:

```text
README.md
DEVELOPMENT.md
drawer-organizer-vN.scad
drawer-organizer-vN.json
```

- Never use a `versions/` folder or keep old numbered copies in the current tree.
- On release of vN+1, replace vN source and preset with vN+1 **in the same ordinary commit**.
- Prior versions remain accessible from ordinary [Git history](https://github.com/realcarbonneau/drawer-organizer-scad/commits/main).

## Grid and part-selection conventions

- All rows and columns are described **in top view, as a human looking straight down into the drawer from the front**.
- **Row 1 = REAR (farthest); highest row = FRONT (nearest).**
- **Column 1 = LEFT; highest column = RIGHT**.
- A row split value of `0` continues the preceding row's tray group.
- Dropdowns are a fixed list of 1–10; OpenSCAD 2021.01 cannot dynamically constrain them based on another parameter. Out-of-range selected **row** or **column** must **not** trigger a hard assertion. Print a clear `SELECTION INVALID` message and generate no geometry for invalid part selections.
- Invalid global configurations that cannot produce a feasible drawer or tray are allowed to fail with a clear explanatory assertion; do not emit misleading geometry silently.

## Rendering and quality expectations

1. Begin from the currently published `.scad` and `.json` pair and implement requested changes.
2. Preserve shared drawer geometry, per-tray geometry, connector positioning, and sample preset consistency.
3. Test with **OpenSCAD 2021.01**: full preview, each sample individual tray, selected row continuations, invalid row and column selections, join-edge chamfer variants, and the full selectable chamfer-angle range.
4. Render each exported tray individually, checking that it is a watertight solid when practical. Distinguish the assembled display (multiple separate solids) from a single-print STL.
5. Verify that the relief chamfer on **joining edges** remains continuous across connector socket blocks and is subtracted from the tray without modifying the loose joiner models.
6. Describe any unverified physical fit; the 218/190 mm profile and R10 corner are measurement approximations.

## Commit policy

- Commit normally to `main` with an existing parent, preserving all history. **No squashing, rebasing, forced ref updates, or other history rewrites.**
- Use a concise descriptive commit message such as `Update drawer organizer to v7`. Do not add `Co-authored-by` or other model-attribution trailers.
- After committing, verify the root lists only the current `.scad`, `.json`, `README.md`, and `DEVELOPMENT.md`.

## Upstream source

Based on the [Modular Drawer Organizer Remix](https://www.printables.com/model/816729-modular-drawer-organizer-remix/) concept. Review and respect any applicable license and attribution requirements before distributing derivatives.
