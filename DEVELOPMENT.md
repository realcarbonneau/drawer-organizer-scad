# Development Guidelines

## Naming and versioning

- Name the project **Drawer Organizer**.
- Use matching, lowercase, hyphenated file names: `drawer-organizer-vN.scad` and `drawer-organizer-vN.json` (for example, `drawer-organizer-v5.scad` and `drawer-organizer-v5.json`).
- Increment the version number for **each new functional release**: v5 → v6 → v7, and so on. Update both filenames and the version text inside the SCAD header.
- **Current version is v5.** Keep it at v5 while it is being tested; make v6 when the next requested changes are implemented and ready for review.
- A documentation or naming correction to the current release does not, by itself, require a version increment.
- Keep the SCAD and matching JSON preset beside one another in the repository root and in download packages. Update the README links when a new version is released.

## Repository layout

The root should contain the **current version only**, alongside project documentation:

```text
README.md
DEVELOPMENT.md
drawer-organizer-vN.scad
drawer-organizer-vN.json
```

- Do **not** create a `versions/` folder.
- When promoting vN+1, remove the old vN files from the **current Git tree** in the same commit as adding vN+1. Git history preserves old content and names.
- Do not leave duplicate dated or numbered copies of earlier releases in the current tree.

## Change and commit policy

1. Start from the current release and implement the requested changes.
2. Keep the Customizer layout, preset parameters, and README instructions synchronized.
3. Compile and render the relevant parts in **OpenSCAD 2021.01**; verify geometry, connector placement, and STLs when practical. Report any remaining untested physical fit.
4. Commit normally to the existing branch, preserving the parent history. **Do not squash, force-push, rewrite, or discard prior commits.**
5. Use a short, descriptive, plain commit message (for example, `Update drawer organizer to v6`). Do not add attribution trailers such as `Co-authored-by`.
6. Confirm the repository root contains only the current SCAD/JSON pair and documentation.

## Sources and fit

The project draws on the [Modular Drawer Organizer Remix](https://www.printables.com/model/816729-modular-drawer-organizer-remix/) concept; comply with any applicable source license and attribution requirements. Test physical drawer fit before a complete print.
