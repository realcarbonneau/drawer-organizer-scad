// MODULAR DRAWER ORGANIZER — v3: drawer-level geometry vs tray-level geometry
// Based on fotrik's remix: https://www.printables.com/model/816729-modular-drawer-organizer-remix/
// OpenSCAD 2021.01 compatible; no libraries required.
//
// USAGE
// A. Set the DRAWER dimensions and the layout (front + N middle columns + rear).
// B. Set TRAY construction (chamfer, walls, height, etc.). These apply to every tray.
// C. Output -> "One selected tray" for export, or "Full current layout" for inspection.
// D. Part type picks the tray's POSITION; no duplicate preset per position.
// E. The only included preset is "Kitchen cutlery drawer" (218 / 190 / R10 / 475).
//
// COORDINATES: X left-to-right, Y front-to-rear, Z upwards.
// Connector sockets are on JOINING edges only in Automatic mode.
// End rows are full width, taper on BOTH outer X sides, ONE joining row each.
// Exterior 45-degree chamfer retained. Interior fillet derived from base thickness.
// Parts are shown touching in Full layout view; split/export each part separately.

/* [01 - Drawer] */
// Width at metal drawer's upper rim (inside), mm.
drawer_top_inner_width_mm = 218; // [100:1:1200]
// Flat floor width between the two inside corner-radius tangencies, mm.
drawer_bottom_flat_width_mm = 190; // [100:1:1200]
// Metal drawer floor-to-wall fillet radius, mm (NOT tray fillet).
drawer_bottom_inside_radius_mm = 10; // [1:0.5:30]
// Usable internal front-to-back depth, mm.
drawer_inside_length_mm = 475; // [100:1:1200]
// Drawer floor to metal upper rim, mm.
drawer_rim_height_mm = 65; // [20:1:100]
// Total assembly width AND depth clearance, mm (1 = 0.5/side).
assembly_total_clearance_mm = 1; // [0:0.2:6]
// Count of long, parallel middle trays between two full-width end trays.
middle_tray_columns = 4; // [2:1:8]
// Front and rear full-width end-tray depths, mm.
front_tray_depth_mm = 59; // [25:1:150]
rear_tray_depth_mm = 59; // [25:1:150]
// How to calculate the outer tray sidewall draft.
drawer_draft_fit_mode = 0; // [0:From top and bottom widths, 1:Use manually entered top offsets]
// Manual top offset of drawer LEFT sidewall, mm (only used in Manual draft mode).
left_top_offset_mm = 4; // [0:0.1:30]
// Manual top offset of drawer RIGHT sidewall, mm (only used in Manual draft mode).
right_top_offset_mm = 4; // [0:0.1:30]
// Front / rear drawer endwall offsets, mm. Typically 0 (straight).
front_top_offset_mm = 0; // [0:0.5:25]
rear_top_offset_mm = 0; // [0:0.5:25]

/* [02 - Tray] */
// Single-tray STL or preview of the ENTIRE CURRENT drawer configuration.
output_mode = 0; // [0:One selected tray, 1:Full current drawer layout]
// Position of the tray to print when Output = One selected tray.
part_type = 103; // [103:Front - full width, 109:Rear - full width, 102:Middle - left outer, 101:Middle - interior, 108:Middle - right outer, 104:Front-left corner (alternative layout), 107:Front-right corner (alternative layout), 105:Rear-left corner (alternative layout), 106:Rear-right corner (alternative layout), 1:Loose straight joiners only, 51:Loose half-section joiners only]
// Optional older split-part geometry. Prints ONE HALF only, not two halves.
print_half = false;
// Normally selected tray size is derived from the overall drawer / layout.
tray_sizing_mode = 0; // [0:From drawer and layout, 1:Manual grid size - advanced]
// Tray rim height above drawer's metal top edge, mm.
tray_extension_above_rim_mm = 10; // [0:0.5:30]
// Tray vertical wall thickness, mm.
wall_thickness_mm = 1.8; // [0.6:0.1:5]
// Tray floor/base thickness, mm. Sets minimum material under auto interior fillet.
base_thickness_mm = 1.8; // [0.6:0.1:5]
// Lower exterior corner is ALWAYS a 45-degree chamfer.
chamfer_fit_mode = 0; // [0:Chamfer leg = drawer floor radius, 1:Manual 45-degree chamfer leg]
// Manual 45-degree exterior chamfer leg, mm (when Manual is selected above).
bottom_chamfer_leg_mm = 10; // [0:0.5:25]
// Projection of the TOP FRONT lip in millimetres (zero disables).
front_rim_extension_mm = 0; // [0:0.5:12]
// For non-standard bins, override which X side receives the drawer taper.
sidewall_profile = 0; // [0:Auto by tray position, 1:No sidewall draft, 2:Left only, 3:Right only, 4:Both]
// For non-standard bins, override which Y end receives draft.
endwall_profile = 0; // [0:Auto by tray position, 1:No endwall draft, 2:Front only, 3:Rear only, 4:Both]

/* [03 - Connectors] */
// Automatic puts sockets only on INSIDE joining edges.
connector_mode = 0; // [0:Auto - joining edges only, 1:None, 2:All four - override]
// Socket positions along the sides of a tray.
joiner_distribution = 2; // [0:Grid stations, 1:Fixed station pitch, 2:Exact station count]
// Number of sockets per MIDDLE COLUMN on FRONT/REAR rows, in measured mode.
// A 4-column drawer, 1/socket/column gives 4 aligned sockets on each end row.
sockets_per_middle_column = 1; // [1:1:3]
// Socket count per LEFT/RIGHT joining edge of a long middle tray.
joiner_count_left_right = 6; // [1:1:20]
// Socket count on the short side of the alternate corner trays.
joiner_count_short_corner_side = 1; // [1:1:6]
// Number of sockets per front/rear edge in MANUAL tray-sizing mode.
joiner_count_front_rear = 4; // [1:1:20]
// Station pitch in Fixed pitch mode, mm.
joiner_socket_pitch_mm = 59; // [20:1:150]
// Minimum edge clearance to first/last socket center in Fixed pitch mode, mm.
joiner_min_end_inset_mm = 12; // [9:0.5:50]
// Clearance for separately printed joining tabs, mm.
connector_fit_clearance_mm = 0.1; // [0.05:0.05:0.5]
// ONLY quantity of LOOSE JOINERS printed (not number of sockets).
connector_quantity = 6; // [1:1:40]

/* [04 - Individual tray options] */
// In manual sizing mode, choose the X/Y size using these grid dimensions.
grid_pitch_x_mm = 59; // [25:0.5:150]
grid_pitch_y_mm = 59; // [25:0.5:150]
tray_width_grid_units = 1; // [0.5:0.05:10]
tray_depth_grid_units = 4; // [1:0.1:10]
tray_height_mm = 75; // [20:1:100]
// Y positions of optional access notches on left and right walls, grid units (0=off).
left_wall_cutout_y_units = 0; // [0:0.1:10]
right_wall_cutout_y_units = 0; // [0:0.1:10]
rear_knife_riser = false;
front_knife_riser = false;

/* [05 - Display quality] */
curve_facets = 64; // [16:8:160]

/* [Hidden] */
$fn = curve_facets;
connector_span_mm = 14;
connector_tab_width_mm = 3;
connector_tab_height_mm = 3;
connector_wall_reinforcement_mm = 2;
epsilon_mm = 0.01;

// ---- Shared derived geometry, applies to every position in the drawer ----
measured_mode_active = tray_sizing_mode==0 || output_mode==1;
effective_chamfer_mm = measured_mode_active && chamfer_fit_mode==0
                     ? drawer_bottom_inside_radius_mm : bottom_chamfer_leg_mm;
effective_tray_height_mm = measured_mode_active
                         ? drawer_rim_height_mm+tray_extension_above_rim_mm : tray_height_mm;
active_rim_height_mm = min(drawer_rim_height_mm,effective_tray_height_mm);
measured_at_chamfer_width_mm = drawer_bottom_flat_width_mm+2*effective_chamfer_mm-assembly_total_clearance_mm;
measured_at_rim_width_mm = drawer_top_inner_width_mm-assembly_total_clearance_mm;
measured_draft_per_side_mm = (measured_at_rim_width_mm-measured_at_chamfer_width_mm)/2;
measured_usable_depth_mm = drawer_inside_length_mm-assembly_total_clearance_mm;
measured_middle_depth_mm = measured_usable_depth_mm-front_tray_depth_mm-rear_tray_depth_mm;
measured_middle_column_width_mm = measured_at_chamfer_width_mm/middle_tray_columns;
// Interior fillet tangent to outer 45-degree chamfer, at minimum normal thickness = base thickness.
inside_fillet_radius_mm = (effective_chamfer_mm+(sqrt(2)-1)*base_thickness_mm-wall_thickness_mm)/(2-sqrt(2));

// Engine default values also work for the loose-joiner and direct rendering paths.
effective_front_rear_joiner_count = measured_mode_active ? sockets_per_middle_column : joiner_count_front_rear;
effective_left_right_joiner_count = joiner_count_left_right;

assert(drawer_top_inner_width_mm>drawer_bottom_flat_width_mm,"Drawer upper width must exceed flat bottom width.");
assert(measured_draft_per_side_mm>=0 || !measured_mode_active, "Drawer upper width is too narrow for chosen chamfer. Check measurements.");
assert(measured_middle_depth_mm>20 || !measured_mode_active,"Front+rear depth exceeds the available drawer depth.");
assert(!measured_mode_active || effective_chamfer_mm<=drawer_bottom_inside_radius_mm+0.0001,"Measured drawer fit: chamfer leg cannot exceed metal corner radius.");
assert(effective_chamfer_mm>=0 && effective_chamfer_mm<effective_tray_height_mm,"Chamfer leg must fit tray height.");
assert(active_rim_height_mm>effective_chamfer_mm,"Rim height must exceed chamfer.");
assert(inside_fillet_radius_mm>0.1,"Interior fillet cannot be constructed: change chamfer or material thickness.");
assert(wall_thickness_mm>=0.45 && base_thickness_mm>=0.4,"Material thickness too small.");
assert(joiner_min_end_inset_mm>=connector_span_mm/2+connector_wall_reinforcement_mm,"Socket end inset too small.");
assert(connector_fit_clearance_mm>=0.01 && connector_fit_clearance_mm<=0.5,"Connector clearance out of range.");
assert(!measured_mode_active || (measured_middle_column_width_mm>2*(inside_fillet_radius_mm+wall_thickness_mm)),"Middle tray is too narrow for automatic inside fillet.");

// OpenSCAD text-console summary (same geometry for all parts in the current drawer).
echo("DRAWER: top width / flat floor / radius / depth / metal height (mm)",drawer_top_inner_width_mm,drawer_bottom_flat_width_mm,drawer_bottom_inside_radius_mm,drawer_inside_length_mm,drawer_rim_height_mm);
echo("LAYOUT: front / middle / rear depths (mm)",front_tray_depth_mm,measured_middle_depth_mm,rear_tray_depth_mm);
echo("LAYOUT: middle tray columns / nominal at-chamfer width (mm)",middle_tray_columns,measured_middle_column_width_mm);
echo("PROFILE: at-chamfer width / near-rim width (mm)",measured_at_chamfer_width_mm,measured_at_rim_width_mm);
echo("PROFILE: automatically derived outward offset per side (mm)",measured_draft_per_side_mm);
echo("TRAY: chamfer leg / calculated inner fillet radius / wall / base (mm)",effective_chamfer_mm,inside_fillet_radius_mm,wall_thickness_mm,base_thickness_mm);
echo("JOINERS: sockets per middle column",sockets_per_middle_column,"total row sockets",middle_tray_columns*sockets_per_middle_column);

// ----------------------------------------------
// GEOMETRY ENGINE (descriptive parameter names)
// ----------------------------------------------

// Extrude an X-Z 2D cross-section between two Y planes.
module xz_prism(profile, y_min, y_max) {
    translate([0,y_max,0]) rotate([90,0,0])
        linear_extrude(height=y_max-y_min, convexity=10) polygon(points=profile);
}
// Extrude a Y-Z 2D cross-section between two X planes.
module yz_prism(profile, x_min, x_max) {
    translate([x_min,0,0]) rotate([0,0,90]) rotate([90,0,0])
        linear_extrude(height=x_max-x_min, convexity=10) polygon(points=profile);
}

// Socket stations on a single edge: the locations below drive BOTH the
// mounting blocks and their recesses, so the quantities always agree.
// Fixed pitch has exact center-to-center spacing, centered about the edge.
// Exact count has equal edge-to-edge station spacing, at cell midpoints.
function joiner_stations(edge_length_mm,grid_pitch_mm,grid_units,count_override) =
    joiner_distribution==0
      ? [for(i=[0:1:grid_units-1]) (i+0.5)*grid_pitch_mm]
      : joiner_distribution==1
        ? let(n=max(1,1+floor((edge_length_mm-2*joiner_min_end_inset_mm)/joiner_socket_pitch_mm)))
          [for(i=[0:1:n-1]) edge_length_mm/2+(i-(n-1)/2)*joiner_socket_pitch_mm]
        : [for(i=[0:1:count_override-1]) (i+0.5)*edge_length_mm/count_override];

module connector() {
// creates connector between sections

    module cubeyshift(x,y,z) {
        translate([0,-y,0]) cube([x,y,z]);
    }

    difference() {
        cube([2*connector_tab_height_mm-connector_fit_clearance_mm,connector_tab_width_mm,connector_span_mm]);
        translate([2*connector_tab_height_mm+10*connector_fit_clearance_mm,connector_tab_width_mm,-epsilon_mm]) rotate([0,0,-atan(connector_tab_height_mm/connector_tab_width_mm)])
         cubeyshift(2*connector_tab_height_mm,2*connector_tab_width_mm,connector_span_mm+2*epsilon_mm);
    }
    cube([connector_tab_height_mm-2*connector_fit_clearance_mm,4*connector_tab_width_mm,connector_span_mm]);
    difference() {
        translate([0,3*connector_tab_width_mm,0]) cube([2*connector_tab_height_mm-connector_fit_clearance_mm,connector_tab_width_mm,connector_span_mm]);
        translate([2*connector_tab_height_mm+10*connector_fit_clearance_mm,3*connector_tab_width_mm,-epsilon_mm]) rotate([0,0,atan(connector_tab_height_mm/connector_tab_width_mm)])
         cube([2*connector_tab_width_mm,2*connector_tab_height_mm,connector_span_mm+2*epsilon_mm]);
     }
}

module connector_half() {
// creates connector between two halves of a section
    extra_space =0.4; // shortens the connector pins to allow extra spacing
    // it may be needed when bridgings drops down a little.
    cube([2*connector_tab_height_mm-2*connector_fit_clearance_mm-extra_space,connector_tab_width_mm,connector_tab_width_mm]);
    cube([connector_tab_height_mm-2*connector_fit_clearance_mm,4*connector_tab_width_mm,connector_tab_width_mm]);
    translate([0,3*connector_tab_width_mm,0]) cube([2*connector_tab_height_mm-2*connector_fit_clearance_mm-extra_space,connector_tab_width_mm,connector_tab_width_mm]);
}

module step(width_grid_units,depth_grid_units,grid_pitch_x_mm,grid_pitch_y_mm) {
// creates 1 module long insertable step for sharp knives with wide handles
// width_grid_units = X module multiplication
// depth_grid_units = Y module multiplication
    difference() {
       union() {
            translate([inside_fillet_radius_mm+wall_thickness_mm,inside_fillet_radius_mm+wall_thickness_mm,inside_fillet_radius_mm+wall_thickness_mm]) {
                minkowski() {
                    cube([width_grid_units*grid_pitch_x_mm-2*inside_fillet_radius_mm-2*wall_thickness_mm,depth_grid_units*grid_pitch_y_mm-2*inside_fillet_radius_mm-2*wall_thickness_mm,0.01]);
                    sphere(inside_fillet_radius_mm);
                }
                minkowski() {
                    cube([width_grid_units*grid_pitch_x_mm-2*inside_fillet_radius_mm-2*wall_thickness_mm,depth_grid_units*grid_pitch_y_mm-2*inside_fillet_radius_mm-2*wall_thickness_mm,0.01]);
                    cylinder(effective_tray_height_mm-inside_fillet_radius_mm-wall_thickness_mm,inside_fillet_radius_mm,inside_fillet_radius_mm);
                }
            }
        }
        translate([-0.1,-0.1,10+wall_thickness_mm]) cube([width_grid_units*grid_pitch_x_mm,depth_grid_units*grid_pitch_y_mm,effective_tray_height_mm]);
        translate([-0.1,-0.1,wall_thickness_mm]) cube([width_grid_units*grid_pitch_x_mm,(depth_grid_units-1.1)*grid_pitch_y_mm,effective_tray_height_mm]);
    }
 }

module section(width_grid_units,depth_grid_units,left_wall_cutout_y_units,right_wall_cutout_y_units,front_connector,right_connector,rear_connector,left_connector,rear_knife_riser,front_knife_riser,left_draft_mm,right_draft_mm, front_rim_extension_mm, front_draft_mm=0, rear_draft_mm=0, x_socket_count=effective_front_rear_joiner_count, y_socket_count=effective_left_right_joiner_count) {
// creates the 1 section of the modular system based on the following parameters:
// width_grid_units = X module multiplication
// depth_grid_units = Y module multiplication
// left_wall_cutout_y_units = Y module multiplication where it cuts hole in the left wall_thickness_mm (0=off)
// right_wall_cutout_y_units = Y module multiplication where it cuts hole in the right wall_thickness_mm (0=off)
// front_connector = boolean, adds connection blocks at the front side
// right_connector = boolean, adds connection blocks at the right side
// rear_connector = boolean, adds connection blocks at the back side
// left_connector = boolean, adds connection blocks at the left side
// rear_knife_riser = boolean, adds support at back (blade) side for knives with wider handle
//        this helps to keep knives horizontally and avoid them stuck inside drawer
// front_knife_riser = boolean, same as rear_knife_riser but support added at the front side
// left_draft_mm = extend left wall_thickness_mm by left_draft_mm mm for angled drawer or gap fill
// right_draft_mm = extend right wall_thickness_mm by right_draft_mm mm for angled drawer or gap fill
// front_rim_extension_mm = a kind of front_rim_extension_mm on the top of the front side. This may be useful for the first line of boxed in the drawer, where handle screw heads may take few mimimeters. The front_rim_extension_mm will hide the demo_spacing_mm for those heads. Set in mm or 0 to disable.

outer_width_mm=width_grid_units*grid_pitch_x_mm;  // outer x size of the box
outer_depth_mm=depth_grid_units*grid_pitch_y_mm;  // outer y size of the box
// Same socket coordinates for front+rear, and likewise left+right.
x_joiner_stations_mm = joiner_stations(outer_width_mm,grid_pitch_x_mm,width_grid_units,x_socket_count);
y_joiner_stations_mm = joiner_stations(outer_depth_mm,grid_pitch_y_mm,depth_grid_units,y_socket_count);
// Ensure socket blocks do not overlap and remain inside the adjoining edge.
assert((!(front_connector||rear_connector) || len(x_joiner_stations_mm)>0) &&
       (!(left_connector||right_connector) || len(y_joiner_stations_mm)>0),"Every enabled edge must have at least one joiner station.");
assert(!(front_connector||rear_connector) ||
      (x_joiner_stations_mm[0]>=connector_span_mm/2+connector_wall_reinforcement_mm &&
       x_joiner_stations_mm[len(x_joiner_stations_mm)-1]<=outer_width_mm-connector_span_mm/2-connector_wall_reinforcement_mm),
       "FRONT/REAR sockets too close to corners: reduce socket count or increase edge width.");
assert(!(left_connector||right_connector) ||
      (y_joiner_stations_mm[0]>=connector_span_mm/2+connector_wall_reinforcement_mm &&
       y_joiner_stations_mm[len(y_joiner_stations_mm)-1]<=outer_depth_mm-connector_span_mm/2-connector_wall_reinforcement_mm),
       "LEFT/RIGHT sockets too close to corners: reduce socket count or increase edge depth.");
assert((!(front_connector||rear_connector) || len(x_joiner_stations_mm)<2 || x_joiner_stations_mm[1]-x_joiner_stations_mm[0]>=connector_span_mm+2*connector_wall_reinforcement_mm) &&
       (!(left_connector||right_connector) || len(y_joiner_stations_mm)<2 || y_joiner_stations_mm[1]-y_joiner_stations_mm[0]>=connector_span_mm+2*connector_wall_reinforcement_mm),
       "Socket centers too close; choose fewer sockets or larger pitch.");

    module conbody(rot) {
        y= 2*connector_tab_width_mm+connector_wall_reinforcement_mm<effective_chamfer_mm ? effective_chamfer_mm : 2*connector_tab_width_mm+connector_wall_reinforcement_mm;
        z= 2*connector_tab_height_mm+connector_wall_reinforcement_mm<effective_chamfer_mm ? effective_chamfer_mm : 2*connector_tab_height_mm+connector_wall_reinforcement_mm;
        rotate([0,0,rot]) translate([-connector_span_mm/2-connector_wall_reinforcement_mm,0,0]) cube([connector_span_mm+2*connector_wall_reinforcement_mm,y,z]);
    }
    module conhole(rot) {
        rotate([0,0,rot]) translate([-connector_span_mm/2-connector_wall_reinforcement_mm,0,0-epsilon_mm]) {
            translate([connector_wall_reinforcement_mm-connector_fit_clearance_mm,-connector_fit_clearance_mm,0])
             cube([connector_span_mm+2*connector_fit_clearance_mm,2*connector_tab_width_mm+2*connector_fit_clearance_mm,connector_tab_height_mm+2*connector_fit_clearance_mm+epsilon_mm]);
             difference() {
                translate([connector_wall_reinforcement_mm-connector_fit_clearance_mm,connector_tab_width_mm-connector_fit_clearance_mm,0])
                 cube([connector_span_mm+2*connector_fit_clearance_mm,connector_tab_width_mm+2*connector_fit_clearance_mm,2*connector_tab_height_mm+2*connector_fit_clearance_mm]);
                translate([connector_wall_reinforcement_mm-connector_fit_clearance_mm,connector_tab_width_mm+2*connector_fit_clearance_mm,2*connector_tab_height_mm+12*connector_fit_clearance_mm]) rotate([-atan(connector_tab_height_mm/connector_tab_width_mm),0,0])
                 cube([connector_span_mm+2*connector_fit_clearance_mm,2*connector_tab_height_mm+2*connector_fit_clearance_mm,2*connector_tab_width_mm+connector_fit_clearance_mm]);
             }
        }
    }

    
    // Four independently adjustable outer walls, with 45-degree CHAMFERS on all
    // four bottom edges. At/above the rim, draft is held rather than extrapolated.
    // The XZ and YZ prisms are intersected, so exterior corners get both profiles.
    module rawbody(outer_width_mm,outer_depth_mm,left_draft_mm,right_draft_mm,front_rim_extension_mm,front_draft_mm,rear_draft_mm) {
        intersection() {
            xz_prism([
                [effective_chamfer_mm,0], [outer_width_mm-effective_chamfer_mm,0],
                [outer_width_mm,effective_chamfer_mm],
                [outer_width_mm+right_draft_mm,active_rim_height_mm],
                [outer_width_mm+right_draft_mm,effective_tray_height_mm],
                [-left_draft_mm,effective_tray_height_mm],
                [-left_draft_mm,active_rim_height_mm],
                [0,effective_chamfer_mm]
            ], -front_draft_mm-front_rim_extension_mm-2,outer_depth_mm+rear_draft_mm+2);
            yz_prism([
                [effective_chamfer_mm,0], [outer_depth_mm-effective_chamfer_mm,0],
                [outer_depth_mm,effective_chamfer_mm],
                [outer_depth_mm+rear_draft_mm,active_rim_height_mm],
                [outer_depth_mm+rear_draft_mm,effective_tray_height_mm],
                [-front_draft_mm-front_rim_extension_mm,effective_tray_height_mm],
                [-front_draft_mm,active_rim_height_mm],
                [0,effective_chamfer_mm]
            ],-left_draft_mm-2,outer_width_mm+right_draft_mm+2);
        }
    }

    difference() {
        // the outer body
        union() {
            rawbody(outer_width_mm, outer_depth_mm, left_draft_mm, right_draft_mm, front_rim_extension_mm, front_draft_mm, rear_draft_mm);

            // extend bottom part on the openings:
            if(right_wall_cutout_y_units) {
                translate([outer_width_mm-effective_chamfer_mm-wall_thickness_mm,right_wall_cutout_y_units*grid_pitch_y_mm-grid_pitch_y_mm/2+connector_span_mm/2,0])
                 cube([effective_chamfer_mm+wall_thickness_mm,grid_pitch_y_mm-connector_span_mm,effective_chamfer_mm+wall_thickness_mm]);
            }
            if(left_wall_cutout_y_units) {
                translate([0,left_wall_cutout_y_units*grid_pitch_y_mm-grid_pitch_y_mm/2+connector_span_mm/2,0])
                 cube([effective_chamfer_mm+wall_thickness_mm,grid_pitch_y_mm-connector_span_mm,effective_chamfer_mm+wall_thickness_mm]);
            }
            // connection to next module
            if(front_connector) {
                for(x_mm=x_joiner_stations_mm) {
                    translate([x_mm,0,0]) conbody(0);
                }
            }
            if(right_connector) {
                for(y_mm=y_joiner_stations_mm) {
                    translate([outer_width_mm,y_mm,0]) conbody(90);
                }
            }
            if(rear_connector) {
                for(x_mm=x_joiner_stations_mm) {
                    translate([x_mm,outer_depth_mm,0]) conbody(180);
                }
            }
            if(left_connector) {
                for(y_mm=y_joiner_stations_mm) {
                    translate([0,y_mm,0]) conbody(270);
                }
            }
        } // union
        union() {
            // Interior void: Minkowski rounding about a convex drafted inner core.
            // Vertical offset = base_thickness_mm, lateral offsets = wall_thickness_mm.
            // Derived r keeps the 45-degree outer chamfer to interior fillet
            // NORMAL distance equal to base_thickness_mm at the nearest point.
            translate([inside_fillet_radius_mm+wall_thickness_mm,
                       inside_fillet_radius_mm+wall_thickness_mm,
                       inside_fillet_radius_mm+base_thickness_mm]) {
                minkowski() {
                    intersection() {
                        xz_prism([
                            [0,0],
                            [outer_width_mm-2*(inside_fillet_radius_mm+wall_thickness_mm),0],
                            [outer_width_mm-2*(inside_fillet_radius_mm+wall_thickness_mm)+right_draft_mm,effective_tray_height_mm-inside_fillet_radius_mm],
                            [-left_draft_mm,effective_tray_height_mm-inside_fillet_radius_mm]
                        ], -1,outer_depth_mm+1);
                        yz_prism([
                            [0,0],
                            [outer_depth_mm-2*(inside_fillet_radius_mm+wall_thickness_mm),0],
                            [outer_depth_mm-2*(inside_fillet_radius_mm+wall_thickness_mm)+rear_draft_mm,effective_tray_height_mm-inside_fillet_radius_mm],
                            [-front_draft_mm-front_rim_extension_mm,effective_tray_height_mm-inside_fillet_radius_mm]
                        ], -1,outer_width_mm+1);
                    }
                    sphere(r=inside_fillet_radius_mm);
                }
            }
            // optional cut in right wall_thickness_mm
            if(right_wall_cutout_y_units && depth_grid_units>2) {
                difference() {
                    union() {
                        translate([outer_width_mm/2,right_wall_cutout_y_units*grid_pitch_y_mm-12,wall_thickness_mm]) cube([width_grid_units*grid_pitch_x_mm,24,effective_tray_height_mm]);
                        translate([outer_width_mm/2,right_wall_cutout_y_units*grid_pitch_y_mm-12,wall_thickness_mm]) rotate([-25,0]) cube([outer_width_mm,24,2*effective_tray_height_mm]);
                        translate([outer_width_mm/2,right_wall_cutout_y_units*grid_pitch_y_mm+12,wall_thickness_mm]) mirror([0,1,0]) rotate([-25,0,0]) cube([outer_width_mm,24,2*effective_tray_height_mm]);
                    }
                    translate([outer_width_mm/2,0,-20]) cube([outer_width_mm,outer_depth_mm,20+wall_thickness_mm]);
                }
            }
            // optional cut in left wall_thickness_mm
            if(left_wall_cutout_y_units && depth_grid_units>2) {
                difference() {
                    union() {
                        translate([-outer_width_mm/2,left_wall_cutout_y_units*grid_pitch_y_mm-12,wall_thickness_mm]) cube([outer_width_mm,24,effective_tray_height_mm]);
                        translate([-outer_width_mm/2,left_wall_cutout_y_units*grid_pitch_y_mm-12,wall_thickness_mm]) rotate([-25,0]) cube([outer_width_mm,24,2*effective_tray_height_mm]);
                        translate([-outer_width_mm/2,left_wall_cutout_y_units*grid_pitch_y_mm+12,wall_thickness_mm]) mirror([0,1,0]) rotate([-25,0,0]) cube([outer_width_mm,24,2*effective_tray_height_mm]);
                    }
                    translate([-outer_width_mm/2,0,-20]) cube([outer_width_mm,outer_depth_mm,20+wall_thickness_mm]);
                }
            }
            // connection to next module
            if(front_connector) {
                for(x_mm=x_joiner_stations_mm) {
                    translate([x_mm,0,0]) conhole(0);
                }
            }
            if(right_connector) {
                for(y_mm=y_joiner_stations_mm) {
                    if(right_wall_cutout_y_units==0 || abs(y_mm-right_wall_cutout_y_units*grid_pitch_y_mm)>grid_pitch_y_mm/4) {
                        translate([outer_width_mm,y_mm,0]) conhole(90);
                    }
                }
            }
            if(rear_connector) {
                for(x_mm=x_joiner_stations_mm) {
                    translate([x_mm,outer_depth_mm,0]) conhole(180);
                }
            }
            if(left_connector) {
                for(y_mm=y_joiner_stations_mm) {
                    if(left_wall_cutout_y_units==0 || abs(y_mm-left_wall_cutout_y_units*grid_pitch_y_mm)>grid_pitch_y_mm/4) {
                        translate([0,y_mm,0]) conhole(270);
                    }
                }
            }
        } // union
    } // difference
    // add optional support step
    if(rear_knife_riser) { step(width_grid_units,depth_grid_units,grid_pitch_x_mm,grid_pitch_y_mm); }
    if(front_knife_riser) { translate([outer_width_mm,outer_depth_mm,0]) rotate([0,0,180]) step(width_grid_units,depth_grid_units,grid_pitch_x_mm,grid_pitch_y_mm); }
} // module

module section_half(width_grid_units,depth_grid_units,left_wall_cutout_y_units,right_wall_cutout_y_units,front_connector,right_connector,rear_connector,left_connector,rear_knife_riser,front_knife_riser,left_draft_mm,right_draft_mm, front_rim_extension_mm,front_draft_mm=0,rear_draft_mm=0, x_socket_count=effective_front_rear_joiner_count, y_socket_count=effective_left_right_joiner_count) {

    // if (width_grid_units>depth_grid_units) Wide box, cut out the right part (instead of back part)
    wide_model=(width_grid_units>depth_grid_units);
    // for wide model, the section is called normally, then the model ir rotated left and the rest continues with swapped x and y sizes
    
    outer_width_mm=(wide_model)?depth_grid_units*grid_pitch_y_mm: width_grid_units*grid_pitch_x_mm;  // outer x size of the (rotated) box
    outer_depth_mm=(wide_model)?width_grid_units*grid_pitch_x_mm: depth_grid_units*grid_pitch_y_mm;  // outer y size of the (rotated) box
    section_rotation=[0,0,(wide_model)?90:0];
    section_translation=[(wide_model)?outer_width_mm:0, 0,0];
    
    difference() {
        union() {
            translate (section_translation) rotate(section_rotation)
                section(width_grid_units,depth_grid_units,left_wall_cutout_y_units,right_wall_cutout_y_units,front_connector,right_connector,rear_connector,left_connector,rear_knife_riser,front_knife_riser,left_draft_mm,right_draft_mm, front_rim_extension_mm,front_draft_mm,rear_draft_mm,x_socket_count,y_socket_count);
            //Base for half-connectors: add a material for carving connector holes
            translate([0,outer_depth_mm/2-connector_span_mm/2-wall_thickness_mm,effective_chamfer_mm]) rotate([-90,0,0])
                linear_extrude(connector_span_mm/2+wall_thickness_mm) polygon([[0,effective_chamfer_mm],[effective_chamfer_mm,effective_chamfer_mm],[0,0]]);
            translate([outer_width_mm-effective_chamfer_mm,outer_depth_mm/2-connector_span_mm/2-wall_thickness_mm,effective_chamfer_mm]) rotate([-90,0,0])
                linear_extrude(connector_span_mm/2+wall_thickness_mm) polygon([[effective_chamfer_mm,effective_chamfer_mm],[effective_chamfer_mm,0],[0,effective_chamfer_mm]]);
        }
        translate([-left_draft_mm-epsilon_mm,outer_depth_mm/2,-epsilon_mm]) cube([outer_width_mm+left_draft_mm+right_draft_mm+front_rim_extension_mm+0.1,outer_depth_mm+0.1,effective_tray_height_mm+0.1]);
        
        translate([wall_thickness_mm-connector_fit_clearance_mm,outer_depth_mm/2-2*connector_tab_width_mm-connector_fit_clearance_mm,-epsilon_mm])
            cube([connector_tab_width_mm+2*connector_fit_clearance_mm,2*connector_tab_width_mm+2*connector_fit_clearance_mm,connector_tab_height_mm+2*connector_fit_clearance_mm+epsilon_mm]);
        
        translate([wall_thickness_mm-connector_fit_clearance_mm,outer_depth_mm/2-2*connector_tab_width_mm-connector_fit_clearance_mm,0])
            cube([connector_tab_width_mm+2*connector_fit_clearance_mm,connector_tab_width_mm+2*connector_fit_clearance_mm,2*connector_tab_height_mm+2*connector_fit_clearance_mm]);
        
        translate([outer_width_mm-wall_thickness_mm-connector_tab_width_mm-connector_fit_clearance_mm,outer_depth_mm/2-2*connector_tab_width_mm-connector_fit_clearance_mm,-epsilon_mm])
            cube([connector_tab_width_mm+2*connector_fit_clearance_mm,2*connector_tab_width_mm+2*connector_fit_clearance_mm,connector_tab_height_mm+2*connector_fit_clearance_mm+epsilon_mm]);
            
        translate([outer_width_mm-wall_thickness_mm-connector_tab_width_mm-connector_fit_clearance_mm,outer_depth_mm/2-2*connector_tab_width_mm-connector_fit_clearance_mm,0])
            cube([connector_tab_width_mm+2*connector_fit_clearance_mm,connector_tab_width_mm+2*connector_fit_clearance_mm,2*connector_tab_height_mm+2*connector_fit_clearance_mm]);
    }
}



// -------------------------------------------------------
// ONE geometric part builder: reusable by either the selected tray
// or the full CURRENT layout preview. No per-part presets needed.
// -------------------------------------------------------
module draw_tray_by_position(code, for_layout=false, half=false) {
    is_front = code==103;
    is_rear = code==109;
    is_front_corner = code==104 || code==107;
    is_rear_corner = code==105 || code==106;
    is_full_end = is_front || is_rear;
    on_left = code==102 || code==104 || code==105 || is_full_end;
    on_right = code==108 || code==106 || code==107 || is_full_end;
    at_front = is_front || is_front_corner;
    at_rear = is_rear || is_rear_corner;

    // A full-width end has BOTH outside X edges tapered and one inward Y row.
    default_front_join = !at_front;
    default_rear_join = !at_rear;
    default_left_join = !on_left;
    default_right_join = !on_right;
    jfront = connector_mode==2 ? true : connector_mode==1 ? false : default_front_join;
    jrear = connector_mode==2 ? true : connector_mode==1 ? false : default_rear_join;
    jleft = connector_mode==2 ? true : connector_mode==1 ? false : default_left_join;
    jright = connector_mode==2 ? true : connector_mode==1 ? false : default_right_join;

    use_drawer_dimensions = for_layout || tray_sizing_mode==0;
    part_width_mm = use_drawer_dimensions
        ? (is_full_end ? measured_at_chamfer_width_mm : measured_middle_column_width_mm)
        : tray_width_grid_units*grid_pitch_x_mm;
    part_depth_mm = use_drawer_dimensions
        ? (is_front || is_front_corner ? front_tray_depth_mm
           : is_rear || is_rear_corner ? rear_tray_depth_mm
           : measured_middle_depth_mm)
        : tray_depth_grid_units*grid_pitch_y_mm;
    width_grid = part_width_mm/grid_pitch_x_mm;
    depth_grid = part_depth_mm/grid_pitch_y_mm;

    use_left = sidewall_profile==2 || sidewall_profile==4 || (sidewall_profile==0 && on_left);
    use_right = sidewall_profile==3 || sidewall_profile==4 || (sidewall_profile==0 && on_right);
    use_front = endwall_profile==2 || endwall_profile==4 || (endwall_profile==0 && at_front);
    use_rear = endwall_profile==3 || endwall_profile==4 || (endwall_profile==0 && at_rear);
    left_draft = use_left ? (use_drawer_dimensions && drawer_draft_fit_mode==0 ? measured_draft_per_side_mm : left_top_offset_mm) : 0;
    right_draft = use_right ? (use_drawer_dimensions && drawer_draft_fit_mode==0 ? measured_draft_per_side_mm : right_top_offset_mm) : 0;
    front_draft = use_front ? front_top_offset_mm : 0;
    rear_draft = use_rear ? rear_top_offset_mm : 0;

    // End-row socket centers coincide with the centers in each middle column.
    // The full end row has N * sockets_per_middle_column.
    sockets_x = use_drawer_dimensions
        ? (is_full_end ? middle_tray_columns*sockets_per_middle_column : sockets_per_middle_column)
        : joiner_count_front_rear;
    sockets_y = use_drawer_dimensions && (is_front_corner || is_rear_corner)
        ? joiner_count_short_corner_side : joiner_count_left_right;

    assert(part_width_mm>2*(inside_fillet_radius_mm+wall_thickness_mm) && part_depth_mm>2*(inside_fillet_radius_mm+wall_thickness_mm),
           "Individual tray too narrow or shallow for derived inside fillet.");
    echo("SELECTED TRAY",code,"width x depth",part_width_mm,part_depth_mm,
         "outward left/right",left_draft,right_draft,
         "connector edges [F,R,L,R]",jfront,jrear,jleft,jright,
         "socket counts X/Y",sockets_x,sockets_y);
    if (half)
        section_half(width_grid_units=width_grid,depth_grid_units=depth_grid,
            left_wall_cutout_y_units=left_wall_cutout_y_units,
            right_wall_cutout_y_units=right_wall_cutout_y_units,
            front_connector=jfront,right_connector=jright,
            rear_connector=jrear,left_connector=jleft,
            rear_knife_riser=rear_knife_riser,front_knife_riser=front_knife_riser,
            left_draft_mm=left_draft,right_draft_mm=right_draft,
            front_rim_extension_mm=front_rim_extension_mm,
            front_draft_mm=front_draft,rear_draft_mm=rear_draft,
            x_socket_count=sockets_x,y_socket_count=sockets_y);
    else
        section(width_grid_units=width_grid,depth_grid_units=depth_grid,
            left_wall_cutout_y_units=left_wall_cutout_y_units,
            right_wall_cutout_y_units=right_wall_cutout_y_units,
            front_connector=jfront,right_connector=jright,
            rear_connector=jrear,left_connector=jleft,
            rear_knife_riser=rear_knife_riser,front_knife_riser=front_knife_riser,
            left_draft_mm=left_draft,right_draft_mm=right_draft,
            front_rim_extension_mm=front_rim_extension_mm,
            front_draft_mm=front_draft,rear_draft_mm=rear_draft,
            x_socket_count=sockets_x,y_socket_count=sockets_y);
}

// The six-piece example: full-width FRONT, four parallel MIDDLE columns,
// full-width REAR. Changing the column count adapts the middle layout.
module draw_full_current_layout() {
    draw_tray_by_position(103,for_layout=true);
    for (column=[0:middle_tray_columns-1]) {
        part = column==0 ? 102 : column==middle_tray_columns-1 ? 108 : 101;
        translate([column*measured_middle_column_width_mm,front_tray_depth_mm,0])
            draw_tray_by_position(part,for_layout=true);
    }
    translate([0,front_tray_depth_mm+measured_middle_depth_mm,0])
        draw_tray_by_position(109,for_layout=true);
}

if (output_mode==1) {
    draw_full_current_layout();
} else if (part_type==1) {
    for(i=[0:connector_quantity-1]) translate([i*10,-20,0]) connector();
} else if (part_type==51) {
    for(i=[0:connector_quantity-1]) translate([i*10,-40,0]) connector_half();
} else {
    draw_tray_by_position(part_type,for_layout=false,half=print_half);
}