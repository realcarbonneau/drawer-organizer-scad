# MAXIMERA-style cutlery STLs (v12)

These printer-ready files are exported from the named OpenSCAD preset
**MAXIMERA Cutlery (Default)** using the drawer measurements in
`drawer-organizer-v12.json`. The default layout is six physical trays:
separate full-width rows 1 and 2, three side-by-side trays spanning rows 3–5,
and a full-width tray in row 6.

- [With connectors](MAXIMERA-Cutlery-with-connectors/): unique tray STLs
  with underside sockets, plus a **single** `dogbone-connector.stl`.
- [Without connectors](MAXIMERA-Cutlery-without-connectors/): unique tray
  STLs with no sockets.

## Print quantities and positions

The default layout is **six separate physical trays**, but some occupy the same geometric shape. To split the original two-row rear tray into two pieces, `Row_02=1`. To keep the original single joined rear tray, use `Row_02=0` and regenerate the exports; do not use the six-tray set.

### Without connectors (3 tray STL files; print 6 physical trays)

| STL file | Quantity | Locations |
| --- | ---: | --- |
| `tray-row01-col01.stl` | **3** | Rear row 1, rear row 2, and front row 6 |
| `tray-row03-col01.stl` | **2** | Middle row 3 column 1; reuse rotated 180° for column 3 |
| `tray-row03-col02.stl` | **1** | Middle row 3 column 2 |

### With connectors (5 tray STL files and one connector STL)

| STL file | Quantity | Locations |
| --- | ---: | --- |
| `tray-row01-col01.stl` | **1** | Rear row 1 |
| `tray-row02-col01.stl` | **1** | Rear row 2 |
| `tray-row03-col01.stl` | **2** | Middle row 3 columns 1 and 3; rotate second 180° |
| `tray-row03-col02.stl` | **1** | Middle row 3 column 2 |
| `tray-row06-col01.stl` | **1** | Front row 6 |
| `dogbone-connector.stl` | As needed | Print multiple copies in the slicer |

The row/column numbers identify *placements*, not six different shapes.
In particular, the file for row 3 column 1 is not missing: column 3
reuses that same file after a 180° rotation.

**Use each folder's `manifest.json` to assemble the layout.** It lists
the row/column position, STL file to print, how many copies are required,
and any 180-degree Z rotation needed to reuse a geometrically identical tray.
If an STL is shared across three positions, print three copies. For the
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
