# Drawer Organizer

Parametric 3D-printable organizer for metal-sided kitchen drawers, written independently in OpenSCAD 2021.01. Designs are defined by the actual **drawer**, an adjustable **logical grid**, and a shared set of **tray/connector** parameters.

## Current source: v7

- [OpenSCAD model](drawer-organizer-v7.scad)
- [Kitchen cutlery drawer preset](drawer-organizer-v7.json)
- [Development guidelines](DEVELOPMENT.md)

Download the matching `.scad` and `.json` **into the same directory**. Open the SCAD file in OpenSCAD 2021.01; in Customizer, choose **Kitchen cutlery drawer** if required.

## Drawer dimensions and top-view conventions

Looking **straight down into the open drawer while standing at its FRONT**:

- Row **1** is at the **REAR** (farthest from the viewer); subsequent rows approach the **FRONT**.
- Column **1** is at the **LEFT**; increasing columns move **RIGHT**.
- A row split of **0** continues the tray group started in the previous row. Row 1 cannot be zero.
- The default **six logical rows** read rear-to-front as `1, 0, 3, 0, 0, 1`. This makes **one wide rear tray, three long middle trays, and one wide front tray**.
- The Customizer offers labeled row-split and selected row/column dropdowns (up to 10). Choosing a non-existent row or column prints `SELECTION INVALID` to the console and draws no tray.

Measured example: top inner width **218 mm**, flat-floor inner width **190 mm**, bottom corner radius **10 mm**, depth **475 mm**, metal rim height **about 65 mm**, and tray extension **10 mm**. Actual corner radii and drawer fit remain approximate and should be verified by test-printing.

## Geometry and printing

- The default **printing slope angle is 60° from the horizontal print bed**. It is used for bottom chamfers, optional rim ramps, joining-edge relief, and dogbone roof transitions.
- **Exterior** bottom edges receive a large, automatically fitted chamfer. **Joining** edges receive independent, small, full-length elephant-foot relief, normally **1 mm**, including across socket blocks.
- Upper **interior horizontal** edges are sharp by default; the **bottom interior** corners are filleted using the base-thickness constraint. Outer bottom corners remain chamfered.
- Rim flares can be enabled independently for left, right, front, and rear; the default has **left and right on**. The ramp starts immediately at the metal rim without an intermediate vertical section. Larger horizontal projections can increase the tray height automatically to maintain the chosen slope.
- A raised socket pad is provided where needed for structural reinforcement. The bottom-facing socket has a blind roof, with roof stock of at least the specified base thickness. Socket-side material is at least the greater of the base and wall thickness.

## Dogbone connectors — underside vertical insertion

The connector is a **rounded I/dogbone in XY (top view)** with two circular lobes and a narrower central bar. The profile extends **upward in Z**.

**Assembly:** Turn two trays **upside down**, align their joining edges, and **press the dogbone upward into the open underside sockets** (in the final upright coordinate system). Put the assembled trays right side up. The dogbone's **bottom is flush with the underside**, in contact with the drawer floor. The mating sockets have a **closed upper roof**; they are **not** open through the tray floor and do **not** receive the connectors horizontally through a sidewall.

The lower section of the dogbone has vertical walls. The upper section narrows inward with a taper based on the selected printing slope; the blind pocket has the corresponding shape plus clearance. Socket pads maintain material around the pocket and above its roof.

Connector placement is based on **center-to-center spacing** (default **59 mm**) with symmetric end margins. If only one can fit, it is centered. Connectors are placed only along adjoining edges by default; a standalone 1×1 tray can optionally enable individual edges.

## Selecting and exporting

- **Full layout preview:** shows assembled tray locations. This is not a printable monolithic STL.
- **Selected tray:** choose a **row** and **column**, then press **F6** and export that individual tray as STL.
- **Loose dogbone connectors:** prints an array of separate bottom-inserted connectors.

The **Part selection and preview** section also contains rendering-quality controls. The OpenSCAD console reports selected tray geometry and connector stations.

## Development

See [DEVELOPMENT.md](DEVELOPMENT.md). Each functional release increments the version, and the root contains **only the current** SCAD/JSON pair alongside documentation. Older versions remain in [Git history](https://github.com/realcarbonneau/drawer-organizer-scad/commits/main).
