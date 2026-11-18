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
