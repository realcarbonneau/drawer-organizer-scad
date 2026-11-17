# Drawer Organizer — OpenSCAD v12

Parametric tray geometry for a measured, metal-sided drawer. Separate printed trays connect through removable dogbone pieces inserted into blind sockets from underneath. All dimensions below are millimetres unless stated otherwise. This README is a reference for the supplied Customizer preset, geometry rules, exporting, and verification.

**Files:** [Model](drawer-organizer-v12.scad) · [Matching Customizer preset](drawer-organizer-v12.json) · [Development and regression requirements](DEVELOPMENT.md)

## OpenSCAD gallery — actual model and print interfaces

These are **OpenSCAD previews from v12 geometry**, not photos or slicer results. The top rows show the actual supplied preset; the magnified connector/socket views use isolated CAD inspection crops and shortened surrounding stock while reusing the real connector and socket geometry. All gallery images use the same 4:3 frame and are paired with the relevant technical setting. Tap a thumbnail to open its full-resolution PNG. **Color convention:** teal = printed trays, orange = loose male connectors, blue = socket inspection sections.

<!-- Intentionally fixed 256 × 192 display thumbnails for balanced two-column GitHub mobile tables. Full-resolution PNG links are kept in each cell. -->

### Assembly and individual trays

| Complete five-tray layout | Full-width rear tray |
| --- | --- |
| <a href="docs/images/cad/full-layout.png"><img src="docs/images/cad/full-layout.png" alt="Complete five-tray layout" width="256" height="192"></a> | <a href="docs/images/cad/rear-tray.png"><img src="docs/images/cad/rear-tray.png" alt="Full-width rear tray" width="256" height="192"></a> |
| `Output_mode=0`; 3 × 6 logical grid, five separate physical trays | `Output_mode=1`, row 1: full-width rear section |

| Middle tray with dividers | Full-width front tray |
| --- | --- |
| <a href="docs/images/cad/middle-tray.png"><img src="docs/images/cad/middle-tray.png" alt="Middle tray with dividers" width="256" height="192"></a> | <a href="docs/images/cad/front-tray.png"><img src="docs/images/cad/front-tray.png" alt="Full-width front tray" width="256" height="192"></a> |
| Selected middle section from row 3; 30 mm inner bottom radius | Selected front section from row 6, printed independently |

| Interior divider access cutout | Loose connector output |
| --- | --- |
| <a href="docs/images/cad/cutout-closeup.png"><img src="docs/images/cad/cutout-closeup.png" alt="Interior divider access cutout" width="256" height="192"></a> | <a href="docs/images/cad/dogbone.png"><img src="docs/images/cad/dogbone.png" alt="Loose connector output" width="256" height="192"></a> |
| Row-4 access cutout, rounded 20 mm transition diameter | `Output_mode=2`; one dogbone shown for inspection |

### Each physical tray — alternate angle and details

These ten additional **OpenSCAD CAD previews** cover every physical tray in the five-piece preset. The alternate angles show the complete selected tray; the closer views show its underside connection interfaces or row-4 divider access cutouts. Underside screenshots are fully rendered (F6): the sockets open at the bottom but have closed roofs, not through-holes. Images remain 1200 × 900 pixels and open at full resolution when tapped.

| Rear tray — opposite corner | Rear tray — underside |
| --- | --- |
| <a href="docs/images/cad/tray-rear-angle.png"><img src="docs/images/cad/tray-rear-angle.png" alt="Rear tray from opposite corner" width="256" height="192"></a> | <a href="docs/images/cad/tray-rear-underside.png"><img src="docs/images/cad/tray-rear-underside.png" alt="Rear tray underside and joining sockets" width="256" height="192"></a> |
| Rows 1–2, column 1; alternate raised camera angle | Blind underside sockets; closed roofs above the openings |

| Middle left — alternate angle | Middle left — access cutout |
| --- | --- |
| <a href="docs/images/cad/tray-middle-left-angle.png"><img src="docs/images/cad/tray-middle-left-angle.png" alt="Middle left tray alternate angle" width="256" height="192"></a> | <a href="docs/images/cad/tray-middle-left-cutout.png"><img src="docs/images/cad/tray-middle-left-cutout.png" alt="Middle left tray row 4 divider cutout" width="256" height="192"></a> |
| Rows 3–5, column 1; full individual tray | Row-4 access opening in the right-hand divider |

| Middle center — alternate angle | Middle center — access cutout |
| --- | --- |
| <a href="docs/images/cad/tray-middle-center-angle.png"><img src="docs/images/cad/tray-middle-center-angle.png" alt="Middle center tray alternate angle" width="256" height="192"></a> | <a href="docs/images/cad/tray-middle-center-cutout.png"><img src="docs/images/cad/tray-middle-center-cutout.png" alt="Middle center tray row 4 divider cutout" width="256" height="192"></a> |
| Rows 3–5, column 2; full individual tray | Row-4 rounded access opening in the divider |

| Middle right — alternate angle | Middle right — access cutout |
| --- | --- |
| <a href="docs/images/cad/tray-middle-right-angle.png"><img src="docs/images/cad/tray-middle-right-angle.png" alt="Middle right tray alternate angle" width="256" height="192"></a> | <a href="docs/images/cad/tray-middle-right-cutout.png"><img src="docs/images/cad/tray-middle-right-cutout.png" alt="Middle right tray row 4 divider cutout" width="256" height="192"></a> |
| Rows 3–5, column 3; full individual tray | Row-4 access opening in the left-hand divider |

| Front tray — opposite corner | Front tray — underside |
| --- | --- |
| <a href="docs/images/cad/tray-front-angle.png"><img src="docs/images/cad/tray-front-angle.png" alt="Front tray from opposite corner" width="256" height="192"></a> | <a href="docs/images/cad/tray-front-underside.png"><img src="docs/images/cad/tray-front-underside.png" alt="Front tray underside and joining sockets" width="256" height="192"></a> |
| Row 6, column 1; alternate raised camera angle | Blind underside sockets; closed roofs above the openings |

### Loose dogbone — footprint and first layers

| Complete connector — angled foot | Top-down connector footprint |
| --- | --- |
| <a href="docs/images/cad/connector-foot.png"><img src="docs/images/cad/connector-foot.png" alt="Complete connector — angled foot" width="256" height="192"></a> | <a href="docs/images/cad/connector-plan.png"><img src="docs/images/cad/connector-plan.png" alt="Top-down connector footprint" width="256" height="192"></a> |
| Both 10 mm lobes joined by a straight 7 mm web | 10 mm nominal lobe diameter; no locking undercuts |

| Circular lobe — sectioned detail | Straight web — isolated section |
| --- | --- |
| <a href="docs/images/cad/connector-lobe.png"><img src="docs/images/cad/connector-lobe.png" alt="Circular lobe — lower perimeter" width="256" height="192"></a> | <a href="docs/images/cad/connector-web.png"><img src="docs/images/cad/connector-web.png" alt="Straight web — first-layer edge" width="256" height="192"></a> |
| Rounded head locally sectioned to expose its 1 mm foot relief | Center web locally sectioned to expose both straight foot edges |

| Connector underside | Connector side profile |
| --- | --- |
| <a href="docs/images/cad/connector-underside.png"><img src="docs/images/cad/connector-underside.png" alt="Connector underside" width="256" height="192"></a> | <a href="docs/images/cad/connector-profile.png"><img src="docs/images/cad/connector-profile.png" alt="Connector side profile" width="256" height="192"></a> |
| Bottom-facing view of the reduced first-layer footprint | Full fitting profile resumes above the 1 mm relief |

### Blind underside socket — mouth and section

| Underside socket entrance | Entrance viewed straight on |
| --- | --- |
| <a href="docs/images/cad/socket-underside.png"><img src="docs/images/cad/socket-underside.png" alt="Underside socket entrance" width="256" height="192"></a> | <a href="docs/images/cad/socket-mouth-plan.png"><img src="docs/images/cad/socket-mouth-plan.png" alt="Entrance viewed straight on" width="256" height="192"></a> |
| Female pocket opens at `Z=0` underneath the tray | Lobe and web entry are part of one blind socket |

| Lobe and joining-edge lips | Solid section through socket wall |
| --- | --- |
| <a href="docs/images/cad/socket-lips.png"><img src="docs/images/cad/socket-lips.png" alt="Lobe and joining-edge lips" width="256" height="192"></a> | <a href="docs/images/cad/socket-section.png"><img src="docs/images/cad/socket-section.png" alt="Solid section through socket wall" width="256" height="192"></a> |
| Single 1 mm elephant-foot relief at socket mouth and joining edge | The roof remains blind; upper fitting walls are not tapered |

### Tray joining edge — first-layer relief

| Joining-edge foot profile | Edge relief at a socket mouth |
| --- | --- |
| <a href="docs/images/cad/joining-edge.png"><img src="docs/images/cad/joining-edge.png" alt="Joining-edge foot profile" width="256" height="192"></a> | <a href="docs/images/cad/joining-socket.png"><img src="docs/images/cad/joining-socket.png" alt="Edge relief at a socket mouth" width="256" height="192"></a> |
| Universal elephant-foot rise: 1.0 mm; ~0.58 mm run at 60° | Same relief covers the lips beside the socket mouth |

The 10 mm exterior drawer-side slope is the larger drawer-floor-radius clearance required by the metal drawer. The same **Elephant_foot_mm** minimum applies to that edge; it takes over if the drawer's required corner chamfer is smaller. [Foot-relief dimensions (schematic, not to scale)](docs/images/inspection-section-dimensions.png).

## Print and export

1. Keep `drawer-organizer-v12.scad` and `drawer-organizer-v12.json` together. Open the SCAD file in OpenSCAD 2021.01 or later.
2. Select the **Kitchen cutlery drawer** preset and change the drawer/grid dimensions to match the actual drawer.
3. Set **Output mode** to **Selected tray** (`1`). Select row and column, press **F6**, and export its STL. A continued row belongs to the group started above it; selecting that row exports the complete grouped tray.
4. Repeat for each physical tray. Set **Output mode** to **Loose dogbone connectors** (`2`) to export the connectors. **Full layout** (`0`) is an inspection view, not a single print job.
5. Print the trays and connectors with their bottoms on the build plate. Insert dogbones upward into neighboring underside sockets after printing. The connectors are removable; no locking undercuts are modeled.

One **Elephant_foot_mm = 1** setting now controls all printed first-layer edges: tray joins, exterior front/rear ends, connector entries and loose connectors. Drawer-floor corner sides use the larger of the corner-radius rise and this setting. The relief is included in exported STL geometry. To evaluate the intended geometry, start with slicer elephant-foot compensation **off** and test-fit a single connector/socket pair. Physical printer variation is not measured by the model.

## Default configuration

| Parameter | v12 preset | Interpretation |
| --- | ---: | --- |
| Drawer top width / nominal floor width | 218 / 190 | Measured drawer dimensions; 1 mm total clearance is subtracted |
| Drawer inside length / rim height | 475 / 65 | Drawer length and height to rim |
| Grid | 3 columns × 6 rows | Row 1 is rear; column 1 is left as viewed from the drawer front |
| Row starts | 1, continued, 3, continued, continued, 1 | Five trays: rear full width, three middle, front full width |
| Floor / wall thickness | 2 / 2 | Nominal base and divider stock |
| **Inner bottom radius** | **30 mm** | Requested shared concave floor-to-wall fillet; changed from automatic in v11 |
| Inner bottom radius = 0 | automatic | Structural minimum, **12 mm** for this preset (10 mm exterior chamfer rise + 2 mm stock) |
| Soft exposed-edge radius | 0.6 | Top wall and accessible cutout edge treatment |
| Print overhang angle | 60° above build plate | Shared for exterior slopes, joining-edge relief and connector bevel |
| Drawer floor corner radius | 10 | Exterior lower sidewall clearance slope: 10 mm rise, ~5.77 mm horizontal run |
| **Elephant foot** | **1 mm** | One first-layer relief on all tray/connector perimeters and socket entries; ~0.58 mm horizontal run at 60°; outer drawer-side corner relief is at least this large |
| Connector web width / lobe diameter | 7 / 10 | Two circular lobes joined by a straight web |
| Max male connector height | 10 | Actual head height can be shortened by the inner bottom fillet |
| Connector side clearance | 0.2 total | Female pocket 0.1 mm larger on each side |
| Connector top clearance | 1.0 | Female blind pocket roof clearance over the male |
| Default interior divider cutout | Row 4 enabled | Pre-rounding base width 25; rounding diameter 20; riser angle 75° |
| Loose connector count in preview/export | 8 | Full-layout inspection and connector-only output |

At the default preset, nominal floor width after clearance is 189 mm, and usable drawer length before tray-edge wall/fillet losses is 474 mm. Logical cell pitch is 63 × 79 mm. Actual clear floor area is reduced by the walls and circular bottom fillets.

## Geometry and fit rules

- **Plan and grouping.** Row 1 is farthest from the user (rear). A `Continue previous` row enlarges the tray immediately behind it rather than adding another seam. Column 1 is left when facing the open drawer.
- **Exterior walls.** Left/right outer walls widen with drawer height and can flare above the rim. Front/rear ends remain vertical above their 1 mm elephant-foot rise and below any optional rim flare. The floor-to-side chamfer rises by the larger of the metal drawer's required lower corner radius and Elephant_foot_mm. An impossible exterior fit is rejected with an echo rather than clipped.
- **Inside fillet.** v12 requests a 30 mm concave inside floor-to-wall radius by default. The effective fillet is the larger of the entered value and its structural minimum. Enter **0** for automatic minimum. Adjacent rounds may meet in a shallow valley rather than leaving a horizontal flat area.
- **Connector outline.** Each loose dogbone has two circular 10 mm-diameter heads and a 7 mm web. Nominal straight span between lobe intersections is 4 mm at 2 mm tray wall thickness. Male connector upper height follows the same calculated interior fillet as the protected female socket roof, at a different constant radial offset.
- **Socket position.** All true joining edges receive sockets when connectors are enabled. Their stations are computed from available seam length and connector spacing. The pockets are blind and open on the underside only.
- **Clearances.** Side and top tolerances change the female pocket, not the male's upper fitting dimensions. The same generalized elephant-foot chamfer changes only the socket entrance and the loose piece's build-plate edge; it does not add a locking taper.
- **Cutout geometry.** Optional cutouts affect internal divider walls only. The 25 mm setting is the *unrounded* gap at the theoretical floor/riser intersection; tangent 10 mm-radius transitions are added. The cutout floor stays above the protected inner fillet and blind socket roofs.

## Reproduce and verify

Run from the repository root after installing OpenSCAD, Python 3, and the packages in `requirements-dev.txt`:

```sh
python -m pip install -r requirements-dev.txt
make check
python -m scripts.readme_gallery --input build/previews --output docs/images
python -m scripts.chamfer_docs --output docs/images
```

`make check` runs the pytest geometry tests and exports the tray STLs plus standard previews. The inspection generator publishes **18 equally sized, unnumbered CAD images** in `docs/images/cad/` (six actual-preset overview/detail views and twelve connector/socket/joining-edge views), plus the linked section schematic. GitHub Actions regenerates and publishes the gallery from the same v12 geometry.

Tests cover OpenSCAD F5/F6 output, watertight individual tray/connector meshes, multiple inner radii, connector clearance envelopes, tray selections, cutout geometry and parameter bounds. Passing these tests does **not** establish actual first-layer printer behavior or connector fit; those need printed samples.

## Version history

- **v12:** configurable inner bottom radius (currently 30 mm by default; 0 remains automatic), unified first-layer relief, and geometry-matched underside connector sockets; technical reference screenshots and documentation.
- **v11:** prior release, retrievable from Git history. Only the current v12 SCAD/JSON pair is retained in the repository root.

## Reference drawers

Square-sided drawers with vertical walls and a sharp floor-to-wall junction do not need the special lower-side clearance. Their profile can be rectangular (90°), with equal top/floor widths and a zero drawer-floor corner radius. Metal-sided systems such as **Blum TANDEMBOX** and **IKEA MAXIMERA** can have tapered sides and a shaped junction at the floor; an organizer placed against those sides needs clearance.

In this model, `Drawer_floor_width_mm` and `Drawer_top_width_mm` describe side taper; `Drawer_floor_corner_radius_mm` sets the **outside** lower-side clearance; and `Print_overhang_angle_deg` determines the clearance chamfer's slope and any rim projection. `Inner_bottom_radius_mm` is the separate **inside radius of the printed tray**. Measure the individual drawer; these photos illustrate drawer construction, not nominal dimensions or interchangeable profiles.

**IKEA MAXIMERA — high drawer**

<a href="docs/images/reference-drawers/maximera-ikea.jpg"><img src="docs/images/reference-drawers/maximera-ikea.jpg" alt="IKEA MAXIMERA high drawer with metal-sided rails" width="780"></a>

<small>Image: [IKEA](https://www.ikea.com/ca/en/images/products/maximera-drawer-high-white__0625584_pe692375_s5.jpg?f=s); local, resized copy.</small>

**IKEA MAXIMERA — installed, without front**

<a href="docs/images/reference-drawers/maximera-installed.jpg"><img src="docs/images/reference-drawers/maximera-installed.jpg" alt="Installed IKEA MAXIMERA drawer with its floor and tapered metal sides visible" width="780"></a>

<small>Photo: [Stilfehler, Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Maximera_drawer_without_front.jpg), [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/); resized, otherwise unmodified.</small>

**Blum TANDEMBOX — drawer-side profile components**

<a href="docs/images/reference-drawers/tandembox-blum.jpg"><img src="docs/images/reference-drawers/tandembox-blum.jpg" alt="Blum TANDEMBOX antaro metal drawer-side profile and runners" width="780"></a>

<small>Image: [Lee Valley](https://www.leevalley.com/); local, resized copy of the supplied TANDEMBOX antaro product photograph.</small>
