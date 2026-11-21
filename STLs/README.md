# Drawer organizer STL profiles (v12)

These printer-ready files are exported from two named OpenSCAD presets:
**MAXIMERA Cutlery (Default)** and **Metal Cabinet Drawer**, with dimensions
defined in `drawer-organizer-v12.json`. Both presets use five physical trays:
one fused full-width tray spanning rows 1–2, three side-by-side trays
spanning rows 3–5, and a full-width tray in row 6. The metal cabinet
preset uses 315 × 460 × 115 mm interior dimensions, straight sides,
and no access cutouts.

- [Metal Cabinet Drawer — with connectors](Metal-Cabinet-Drawer-with-connectors/)
- [Metal Cabinet Drawer — without connectors](Metal-Cabinet-Drawer-without-connectors/)
- [With connectors](MAXIMERA-Cutlery-with-connectors/): unique tray STLs
  with underside sockets, plus a **single** `dogbone-connector.stl`.
- [Without connectors](MAXIMERA-Cutlery-without-connectors/): unique tray
  STLs with no sockets.

## Print quantities and positions

The default layout has **five physical trays**. The entire rear section,
**rows 1–2 across all three logical columns**, is **one fused tray**.
The three middle trays span rows 3–5; row 6 is a separate full-width front tray.

| STL file | Quantity | Location in drawer |
| --- | ---: | --- |
| `tray-row01-col01.stl` | **1** | One fused full-width rear tray, rows 1–2 |
| `tray-row03-col01.stl` | **2** | Middle left (column 1); rotated 180° for middle right (column 3) |
| `tray-row03-col02.stl` | **1** | Middle center (column 2) |
| `tray-row06-col01.stl` | **1** | Full-width front tray, row 6 |

Both connector-enabled and connector-free sets therefore need **four distinct
tray STL files** if the middle side pair is geometrically equivalent under a
180° turn, otherwise five. The with-connectors set adds just **one**
`dogbone-connector.stl` for duplication in the slicer. The file counts
are not the number of pieces to print: **five physical trays** are needed.

If you instead want the rear split into two separate full-width trays, change
`Row_02` from `0` to `1` and regenerate exports; that is **not** this default.

**Use each folder's `manifest.json` to assemble the layout.** It lists
the row/column position, STL file to print, how many copies are required,
and any 180-degree Z rotation needed to reuse a geometrically identical tray.
If an STL is used twice, print two copies. For the
connector-enabled version, duplicate the single connector in your slicer
as needed; no pre-arranged array of connectors is baked into that STL.

To regenerate both folders locally, install OpenSCAD 2021.01+ and the
Python dependencies, then run:

```sh
python -m pip install -r requirements-dev.txt
python -m scripts.export_stls
```

The all-capitals `STL` and lowercase plural `s` in `STLs/` are intentional
and make this directory easy to recognize. Files are in millimetres; tray
bases sit on the print bed (Z=0). This profile is based on **measured drawer
dimensions**, not a guarantee of fit for every IKEA MAXIMERA or Blum
TANDEMBOX model. Verify measurements and test-print fit first.
