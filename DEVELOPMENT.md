# Development Guidelines

## Release management

- Project name **Drawer Organizer**.
- Current functional release: **v8**. Increment one number for each new functional release: v8 → v9 → v10.
- Keep filenames, model header and README links synchronized: `drawer-organizer-vN.scad` and `drawer-organizer-vN.json`.
- Keep only the latest SCAD/JSON pair in the repository root along with README.md, DEVELOPMENT.md, build scripts and tests. **No `versions/` directory and no release ZIPs.**
- Replace the preceding version files with the new pair **in one normal commit**. Git history preserves earlier files and content; **do not rewrite, rebase, squash, or force-update existing history**.
- Use a concise commit title without model or AI attribution trailers.
- Documentation and CI-only fixes may be committed without incrementing the functional model version.

## Geometry and UI conventions

- Describe the grid from a **top view while standing at the front** of an open drawer.
- Row 1 is REAR; rows increase toward the FRONT. Column 1 is LEFT; columns increase toward RIGHT.
- Row 1 must have a positive split count. Later rows can use `0` to extend the preceding tray group.
- Single selected invalid rows/columns give a nonfatal console message and no geometry; invalid global drawer dimensions can produce a clear configuration assertion.
- When exploding the preview, **one constant separation** is added per physically adjacent tray pair, not per logical continuation row. The slider is 0–50 mm in integer steps.
- The facet count defaults to 20 and supports 3–200.
- Bottom INSIDE edges are filleted, bottom OUTSIDE edges chamfered, and top interior horizontal edges remain sharp by default.
- Front/rear metal drawer ends are not outward-drafted as if they were metal sidewalls.
- Shared print overhang angle defaults to 60° from the horizontal.
- Rim ramps start at the metal rim without a spurious intermediate vertical segment; large projections increase total height.
- Each interior divider cutout is controlled by its **row checkbox**, not by a column boundary selector; never cut through the entire tray width.
- Bottom-up dogbones use **two circular lobes and one rectangular web**, constant along Z, no locking features, with matching blind underside sockets and a closed roof. Preserve roof and socket-side stock according to the base/wall thickness; avoid an unwanted entry chamfer inside the pocket.

## Test framework and build contract

- Run the **real OpenSCAD 2021.01 CLI** for STL geometry: Python is orchestration, not a substitute renderer.
- Test suite: `tests/test_config.py` (fast release and preset checks) and `tests/test_openscad.py` (geometry/functional regressions).
- Shared helpers: `scripts/organizer_cli.py`. The test runner merges overrides into a TEMPORARY JSON preset, because OpenSCAD 2021.01 can give preset values precedence over `-D`. Never claim parameter tests passed if overrides were not applied.
- `make test` runs pytest; `make build` exports the default tray parts and loose dogbones plus preview screenshots; `make check` runs both.
- Tests should include all default individual trays, watertightness, z>=0, connector dimensions, rear-end verticality, internal bottom rounds, printed angles (25/35/45/60/75), large rim (>6 mm), row cutouts, and all preview separations (0/1/12/50).
- Screen previews are exported using OpenSCAD with a virtual X server if available. The GitHub Actions artifact holds STLs and screenshots; **do not add generated build outputs to Git history**.
- A local green test suite is not a guarantee of correct physical fit; print a small drawer-edge and connector sample before committing to a full production run.

## Commit checklist

1. Confirm source and preset names/parameters match.
2. Run `make check` against OpenSCAD 2021.01.
3. Inspect exported previews of rear, center, front, and whole layout.
4. Commit to `main` with one parent, without rewriting history.
5. Confirm the root contains only the current model/preset pair, docs and automation code.
6. Check GitHub Actions for a successful CI run and retrieve the build artifact if needed.
