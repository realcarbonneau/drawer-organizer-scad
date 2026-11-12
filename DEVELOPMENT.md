# Development Guidelines

## Release naming and Git history

- Project name: **Drawer Organizer**.
- Current functional release: **v7**.
- New functional releases increment one step: **v7 → v8 → v9**. Name source and matching preset `drawer-organizer-vN.scad` and `drawer-organizer-vN.json`.
- Keep the same version in the source header, filenames, and README links.
- A documentation-only correction need not increment the functional release.
- **Do not create ZIP release files**. The complete repository can be downloaded directly through GitHub.
- The `main` branch contains only the current `.scad` and `.json` files plus `README.md` and `DEVELOPMENT.md`. **No `versions/` directory or old release copies.**
- Earlier releases are preserved in **Git commit history**. Replace the current files in an ordinary commit; **do not squash, rebase, or force-push history**.
- Use concise, ordinary commit messages, without `Co-authored-by` trailers.

## Design conventions

- **Top view**: as a person standing at the front of an open drawer looking down. **Row 1 at rear**, increasing rows toward front; **column 1 at left**, increasing columns toward right.
- Grids support up to 10 rows and 10 columns. `row_01_splits` cannot be 0. Other row values of 0 extend the previous group's trays.
- Each separately printable tray is determined by the drawer geometry and grid; selecting a continuation row selects the entire merged tray group.
- Invalid selected row/column shows a console warning with no tray, not a hard assertion.
- A **1×1 grid** is the supported configuration for an arbitrary one-off tray; manual joins, if desired, belong in the **Manual standalone tray** section.
- Render controls stay with **Part selection and preview**.
- Keep the matching OpenSCAD JSON preset in sync with source controls.

## Manufacturing constraints

- Shared print-overhang angle defaults to **60° from horizontal**.
- Bottom outside edges have chamfers; inside bottom corners have fillets. The top interior horizontal corners remain sharp unless explicitly configured otherwise.
- The lower joining-edge elephant-foot relief is continuous even across connector socket pads.
- Rim ramps start at the drawer rim. Large projections increase overall height rather than fail because of an arbitrary above-rim limit.
- Connectors have a **rounded I/dogbone plan view**, and are inserted **vertically from the underside** of an inverted tray. Their bottoms are flush with the drawer floor when upright. They must **not** insert through the top or horizontally through a sidewall.
- Socket openings are **bottom facing and blind at the top**, with closed, print-friendly tapered roofs. Socket walls and roofs must preserve at least the base thickness; side reinforcement also respects any thicker wall setting.
- One adjustable center-to-center pitch determines connector count and location. Use a centered single connector when appropriate and symmetric end spacing for longer edges.
- When changing connectors, test both mating halves and the male joiner, including clearance, tapered top profile, and socket roof thickness.

## Verification before each commit

1. Compile and render with **OpenSCAD 2021.01**.
2. Test all example trays and loose connectors; check watertight STLs.
3. Test small and large print angles, rim projections greater than 6 mm, 1×1 layouts, row continuations, and invalid row/column selections.
4. Check that the bottom-inserted dogbones and closed socket roofs fit and do not protrude below z=0.
5. Reconcile the matching JSON preset, README, source header, and version numbers.
6. Commit with one normal parent and verify the four expected root files.

**Physical fit is untested** until a test print is made against the measured drawer.
