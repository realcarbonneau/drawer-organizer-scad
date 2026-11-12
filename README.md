# Drawer Organizer

Parametric 3D-printable trays for metal-sided kitchen drawers, implemented in OpenSCAD 2021.01. The entire arrangement is defined by drawer measurements, a logical grid, and shared tray / connector settings.

## Current release: v8

- [OpenSCAD model](drawer-organizer-v8.scad)
- [Kitchen cutlery drawer Customizer preset](drawer-organizer-v8.json)
- [Development and testing guidelines](DEVELOPMENT.md)

Download the matching SCAD and JSON files into the **same directory**, open the SCAD in OpenSCAD, and choose **Kitchen cutlery drawer** in the Customizer.

### Drawer orientation and example

**Top view, standing at the FRONT of the open drawer:** Row 1 is at the REAR (farthest away); larger row numbers move toward the FRONT. Column 1 is LEFT; larger column numbers move RIGHT.

Example measured drawer: top opening **218 mm**, flat floor width **190 mm**, bottom corner radius **10 mm**, interior depth **475 mm**, rim height approximately **65 mm**, and tray extension **10 mm**. These dimensions remain approximate until physically verified.

The default 6-row grid, \`1, 0, 3, 0, 0, 1\`, creates five parts: one full-width rear tray (rows 1–2), three long middle trays (rows 3–5), and one full-width front tray (row 6). **0 means continue the previous row's compartments.** Grid rows and columns are selectable with labeled dropdowns. Invalid selected parts print an explanatory message and generate no geometry.

### What v8 changes

- **Preview separation:** 0–50 mm in **whole millimetres**, with a constant gap between adjacent tray parts in both axes. The spacing is counted per actual tray-group boundary, not per logical grid row. Preview separation does not change an individual exported tray.
- **Render facets:** default **20** for faster previews; permitted range **3–200**.
- **Round dogbone joiners:** two circles connected by a rectangle in XY, straight-extruded in Z; **no locking taper or retention edges**. They press **from underneath** into blind, closed-roof sockets in the inverted trays. Connector web width, circular diameter addition, and fit clearance are adjustable; height and socket reinforcement are derived.
- **Joining-edge elephant-foot relief:** a small bevel along joining edges; the female socket mouths are protected from the bevel. There are no internal socket chamfers.
- **Sidewalls and rim:** side profiles widen outward to the drawer rim; the rear and front exterior ends are vertical unless a separately enabled rim flare is requested. Default rim extensions are LEFT and RIGHT only. Default printable ramp/chamfer angle is **60° from horizontal**.
- **Interior bottom fillets** are retained and related to the base-thickness requirement. The top interior horizontal edges remain square; exterior bottom edges receive chamfers.
- **Divider access cutouts:** one checkbox per row, affecting **all interior dividers** in that row, not external walls. The notch has rounded shoulders and a controlled printable slope; the width control measures the opening at its base.

### Preview and export

1. Choose **Full layout preview**, **Selected tray**, or **Loose dogbone connectors** in the Part selection and preview section.
2. For **Selected tray**, choose row and column. A continuation row resolves to its full multirow part.
3. Press F5 to preview, F6 to render, then export the STL.
4. For visual inspection, increase preview separation. Use 0 mm for the dimensional assembly arrangement.

**Physical fit and press-fit tolerance must be confirmed by a small test print.** Watertight STL tests do not guarantee mechanical fit or printability on every machine.

## Automated tests and builds

Uses **Python 3 + pytest + trimesh**, with **OpenSCAD 2021.01** as the actual geometry engine. The suite covers valid and invalid grid selections, all default trays, exact preview gaps at 0/1/12/50 mm, bottom fillets, rear-wall profile, dogbones, row cutouts, print angles, large rim projections, and watertight meshes.

Install Python requirements from [requirements-dev.txt](requirements-dev.txt), install OpenSCAD, then run:

\`\`\`sh
python -m pip install -r requirements-dev.txt
make test      # Test source, presets, parameter combinations and STL geometry
make build     # Render all sample tray STLs, joiners, and screenshots
make check     # Both steps; the CI build command
\`\`\`

On Linux, PNG snapshots require \`xvfb-run\` and a working OpenSCAD installation.

[GitHub Actions](.github/workflows/ci.yml) runs \`make check\` on pushes and pull requests. The workflow publishes **STLs and PNG preview screenshots as a downloadable build artifact**; generated parts/images are not committed to the repository.

## Development and versions

See [DEVELOPMENT.md](DEVELOPMENT.md). Each functional release increments the number, and only the current \`drawer-organizer-vN.scad\` and matching \`.json\` stay at repository root. Earlier releases remain in ordinary [Git history](https://github.com/realcarbonneau/drawer-organizer-scad/commits/main). No release ZIPs or \`versions/\` folder are maintained.
