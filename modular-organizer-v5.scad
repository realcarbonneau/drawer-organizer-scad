// MODULAR DRAWER ORGANIZER v5 — GRID-ROW LAYOUT ENGINE
// Remix foundation: https://www.printables.com/model/816729-modular-drawer-organizer-remix/
// OpenSCAD 2021.01; no third-party libraries.
//
// CONCEPT:
// 1) Enter the drawer measurements and define the logical GRID.
// 2) Each GRID ROW specifies a number of widthwise compartments.
//    0 = continue the preceding row's compartments, extending them in depth.
//    Row 1 is at the BACK, highest row is at the FRONT.
// 3) Select FULL LAYOUT or one tray by row + column. The selected row can
//    be a 0 continuation: it automatically resolves to its group start.
// 4) Outer walls are drafted automatically; connectors exist ONLY at joins.
//    The connector stations along cross-band edges are co-located even if
//    adjacent bands have DIFFERENT numbers of widthwise compartments.
// 5) One named JSON preset only: Kitchen cutlery drawer. No per-part presets.
// 6) Per-row cutouts are defined on the boundary AFTER a column, mirrored on both trays.
//
// Default row splits [1,0,3,0,0,1]:
// REAR  rows 1-2: 1 full-width tray; rows 3-5: 3 long trays;
// FRONT row 6: 1 full-width tray. Total = 5 trays.

/* [01 - Drawer dimensions] */
// Inside opening measured at top of metal sides, mm.
drawer_top_inner_width_mm = 218; // [100:1:1200]
// Flat floor between the metal corner radii, mm.
drawer_bottom_flat_width_mm = 190; // [100:1:1200]
// Metal floor-to-sidewall inside radius, mm.
drawer_bottom_inside_radius_mm = 10; // [0:0.5:30]
// Clear front-to-back interior length, mm.
drawer_inside_length_mm = 475; // [100:1:1200]
// Drawer floor to upper metal rim, mm.
drawer_rim_height_mm = 65; // [20:1:100]
// Clearance across BOTH opposing sides, mm.
assembly_total_clearance_mm = 1; // [0:0.1:5]
// Automatic computes the sidewall draft from the measured widths.
drawer_draft_fit_mode = 0; // [0:Automatic from measurements, 1:Manual offsets]
// Per-side X offsets from the end of the bottom chamfer to drawer rim, mm.
left_top_offset_mm = 4; // [0:0.1:30]
right_top_offset_mm = 4; // [0:0.1:30]
// Only for drawer fronts/backs that are also drafted.
front_top_offset_mm = 0; // [0:0.2:20]
rear_top_offset_mm = 0; // [0:0.2:20]

/* [02 - Drawer edges and rim overhang] */
// One angle shared by lower chamfers and optional upper rim flare.
// Measured from the print bed: 45 degrees gives equal rise and run.
chamfer_angle_deg = 45; // [25:1:70]
// The exterior lower chamfer matches the metal corner by default.
chamfer_fit_mode = 0; // [0:Use drawer bottom radius, 1:Manual rise]
// Outer bottom chamfer vertical rise, mm (manual mode).
bottom_chamfer_height_mm = 10; // [0:0.5:25]
// A smaller chamfer on INTERNAL joining edges to mitigate elephant foot.
join_edge_chamfer_height_mm = 1; // [0:0.25:4]
// Whether the upper rim flares over each EXTERIOR metal wall (not every tray).
rim_on_left = true;
rim_on_right = true;
rim_on_front = false;
rim_on_rear = false;
// Outward horizontal projection of lip, mm; print ramp uses chamfer_angle_deg.
rim_overhang_mm = 3; // [0:0.5:10]

/* [03 - Drawer logical grid] */
// Maximum widthwise subdivision count used in any row.
grid_columns = 3; // [1:1:10]
// Equal-depth logical rows, from BACK (row 1) to FRONT.
grid_rows = 6; // [1:1:10]
// Row split count; 0 continues preceding row's compartments.
row_01_splits = 1; // [1:1:10]
row_02_splits = 0; // [0:1:10]
row_03_splits = 3; // [0:1:10]
row_04_splits = 0; // [0:1:10]
row_05_splits = 0; // [0:1:10]
row_06_splits = 1; // [0:1:10]
row_07_splits = 0; // [0:1:10]
row_08_splits = 0; // [0:1:10]
row_09_splits = 0; // [0:1:10]
row_10_splits = 0; // [0:1:10]

/* [04 - Joining-wall access cutouts] */
// For each grid row, 0 = none; 1 = notch BETWEEN columns 1 and 2,
// 2 = between columns 2 and 3, etc. Both neighboring tray walls are cut.
// Only applicable when this row's continued tray group has enough columns.
// The cutout is at the CENTER of the logical row, high above the sockets.
cutout_after_column_row_01 = 0; // [0:1:9]
cutout_after_column_row_02 = 0; // [0:1:9]
cutout_after_column_row_03 = 0; // [0:1:9]
cutout_after_column_row_04 = 0; // [0:1:9]
cutout_after_column_row_05 = 0; // [0:1:9]
cutout_after_column_row_06 = 0; // [0:1:9]
cutout_after_column_row_07 = 0; // [0:1:9]
cutout_after_column_row_08 = 0; // [0:1:9]
cutout_after_column_row_09 = 0; // [0:1:9]
cutout_after_column_row_10 = 0; // [0:1:9]
// Width of a cutout along the joining wall, mm.
join_cutout_width_mm = 30; // [10:1:60]
// How far down from the top of a tray the notch goes, mm.
join_cutout_depth_mm = 22; // [8:1:50]

/* [05 - Shared tray construction] */
// Extra vertical tray wall above the metal drawer rim, mm.
tray_extension_above_rim_mm = 10; // [0:0.5:30]
wall_thickness_mm = 1.8; // [0.6:0.1:5]
// Floor thickness is also used for the automatically calculated inside fillet.
base_thickness_mm = 1.8; // [0.6:0.1:5]

/* [06 - Connector design] */
// Outside drawer edges are never joined in Auto mode.
connector_mode = 0; // [0:Auto on internal joins, 1:None, 2:All edges - override]
// Socket stations placed in each overlap of adjacent row groups.
sockets_per_boundary_overlap = 1; // [1:1:3]
joiner_distribution = 0; // [0:One per grid row, 1:Fixed pitch, 2:Exact count]
joiner_socket_pitch_mm = 59; // [20:1:150]
joiner_min_end_inset_mm = 12; // [9:0.5:50]
joiner_count_left_right = 3; // [1:1:20]
connector_fit_clearance_mm = 0.1; // [0.05:0.05:0.5]
// Only controls loose connectors, never tray socket stations.
connector_quantity = 6; // [1:1:40]

/* [07 - Render quality] */
curve_facets = 40; // [16:8:160]

/* [08 - Part selection and preview] */
// A full preview is NOT intended for printing as one STL.
output_mode = 0; // [0:Full drawer layout, 1:One tray by row and column, 2:Loose joiners, 3:Loose half joiners]
// Grid row 1 = BACK; row with split 0 selects its merged tray group.
selected_grid_row = 1; // [1:1:10]
// Column 1 = LEFT; choose a column valid for that row's group.
selected_grid_column = 1; // [1:1:10]
preview_explode_gap_mm = 0; // [0:0.2:3]

/* [Hidden] */
$fn=curve_facets;
connector_span_mm=14;
connector_tab_width_mm=3;
connector_tab_height_mm=3;
connector_wall_reinforcement_mm=2;
epsilon_mm=0.01;
grid_pitch_x_mm=59;
grid_pitch_y_mm=59;
effective_front_rear_joiner_count=1;
effective_left_right_joiner_count=1;
effective_tray_height_mm=drawer_rim_height_mm+tray_extension_above_rim_mm;
active_rim_height_mm=drawer_rim_height_mm;
effective_chamfer_mm=chamfer_fit_mode==0 ? drawer_bottom_inside_radius_mm : bottom_chamfer_height_mm;
outer_chamfer_run_mm=effective_chamfer_mm/tan(chamfer_angle_deg);
join_chamfer_run_mm=join_edge_chamfer_height_mm/tan(chamfer_angle_deg);
rim_lip_rise_mm=rim_overhang_mm*tan(chamfer_angle_deg);
measured_at_chamfer_width_mm=drawer_bottom_flat_width_mm+2*outer_chamfer_run_mm-assembly_total_clearance_mm;
measured_at_rim_width_mm=drawer_top_inner_width_mm-assembly_total_clearance_mm;
measured_draft_per_side_mm=(measured_at_rim_width_mm-measured_at_chamfer_width_mm)/2;
measured_usable_depth_mm=drawer_inside_length_mm-assembly_total_clearance_mm;
logical_row_depth_mm=measured_usable_depth_mm/grid_rows;
// Circle-to-line tangency for the exterior chamfer: leave a minimum normal
// thickness equal to base_thickness_mm between outside slope and inside fillet.
chamfer_slope_inverse=1/tan(chamfer_angle_deg);
chamfer_normal_length=sqrt(1+chamfer_slope_inverse*chamfer_slope_inverse);
inside_fillet_radius_mm=(outer_chamfer_run_mm-wall_thickness_mm+
    (chamfer_normal_length-chamfer_slope_inverse)*base_thickness_mm)/
    (1+chamfer_slope_inverse-chamfer_normal_length);

// Return the split count (0 = continue the previous group) for row 1..10.
function cutout_boundary_for_row(row) =
    row==1 ? cutout_after_column_row_01 : row==2 ? cutout_after_column_row_02 :
    row==3 ? cutout_after_column_row_03 : row==4 ? cutout_after_column_row_04 :
    row==5 ? cutout_after_column_row_05 : row==6 ? cutout_after_column_row_06 :
    row==7 ? cutout_after_column_row_07 : row==8 ? cutout_after_column_row_08 :
    row==9 ? cutout_after_column_row_09 : row==10 ? cutout_after_column_row_10 : 0;

function row_splits(row) =
    row==1 ? row_01_splits : row==2 ? row_02_splits :
    row==3 ? row_03_splits : row==4 ? row_04_splits :
    row==5 ? row_05_splits : row==6 ? row_06_splits :
    row==7 ? row_07_splits : row==8 ? row_08_splits :
    row==9 ? row_09_splits : row==10 ? row_10_splits : 0;
function group_start_for_row(row) = max([for(k=[1:row]) if(row_splits(k)>0) k]);
function group_end_from_start(start) = min(concat([for(k=[1:grid_rows]) if(k>start && row_splits(k)>0) k],[grid_rows+1]))-1;
function group_cols_for_row(row) = row_splits(group_start_for_row(row));
function group_start_y_mm(start) = (grid_rows-group_end_from_start(start))*logical_row_depth_mm;
function group_depth_mm(start) = (group_end_from_start(start)-start+1)*logical_row_depth_mm;
function tray_width_mm(cols) = measured_at_chamfer_width_mm/cols;
// Both adjacent pieces compute this exact same global socket center for their
// shared boundary, even when their respective subdivision counts differ.
// Minimum overlap: corner clearance + socket reinforcement each side.
function cross_band_socket_x_positions(cols, col, neighbor_cols) =
    [for(other=[1:neighbor_cols])
      let(left=max((col-1)/cols,(other-1)/neighbor_cols),
          right=min(col/cols,other/neighbor_cols),
          span=(right-left)*measured_at_chamfer_width_mm)
      if(span>=connector_span_mm+2*connector_wall_reinforcement_mm+1)
        for(k=[1:sockets_per_boundary_overlap])
          (left+(right-left)*(k-0.5)/sockets_per_boundary_overlap)*measured_at_chamfer_width_mm
              -(col-1)*measured_at_chamfer_width_mm/cols
    ];

assert(row_01_splits>0,"Row 1 (back) must start a tray group, not be zero.");
assert(grid_rows>=1 && grid_rows<=10 && grid_columns>=1 && grid_columns<=10,"Grid limits 1..10.");
assert(min([for (r=[1:grid_rows]) row_splits(r)])>=0,"Split count cannot be negative.");
assert(max([for (r=[1:grid_rows]) row_splits(r)])<=grid_columns,"A row cannot have more subdivisions than grid_columns.");
assert(drawer_draft_fit_mode==1 || measured_draft_per_side_mm>=0,"Drawer profile incompatible with chamfer; check widths and corner radius.");
assert(drawer_top_inner_width_mm>drawer_bottom_flat_width_mm,"Top width must be larger than bottom flat width.");
assert(effective_chamfer_mm>=0 && effective_chamfer_mm<drawer_rim_height_mm,"Chamfer must fit metal wall height.");
assert(join_edge_chamfer_height_mm>=0 && join_edge_chamfer_height_mm<=effective_chamfer_mm,"Internal chamfer must be no larger than external chamfer.");
assert(rim_lip_rise_mm<=tray_extension_above_rim_mm+0.0001 || rim_overhang_mm==0,"Rim lip ramp is taller than the tray extension above the rim.");
assert(min([for(r=[1:grid_rows]) cutout_boundary_for_row(r)])>=0 &&
       max([for(r=[1:grid_rows]) cutout_boundary_for_row(r)])<grid_columns, "Cutout boundary must be below grid_columns.");
assert(min([for(r=[1:grid_rows]) (cutout_boundary_for_row(r)==0 || cutout_boundary_for_row(r)<group_cols_for_row(r)) ? 1 : 0]) == 1,"Cutout boundary must be between compartments in its row group.");
assert(join_cutout_width_mm+4 < logical_row_depth_mm,"Cutout wider than a logical row depth.");
assert(chamfer_fit_mode!=1 || effective_chamfer_mm<=drawer_bottom_inside_radius_mm+0.0001,"Tray chamfer cannot exceed metal corner radius in measured mode.");
assert(inside_fillet_radius_mm>0.1,"Impossible interior radius for chosen wall/base/chamfer.");
assert(base_thickness_mm>=0.5 && wall_thickness_mm>=0.5,"Wall/base thickness too small.");
assert(logical_row_depth_mm>2*(inside_fillet_radius_mm+wall_thickness_mm),"Grid rows too shallow for curved base.");
assert(tray_width_mm(grid_columns)>2*(inside_fillet_radius_mm+wall_thickness_mm),"Grid columns too narrow for curved base.");
assert(joiner_min_end_inset_mm>=connector_span_mm/2+connector_wall_reinforcement_mm,"Connector end inset too small.");

// Console report helps review the current split/merge logic.
echo("DRAWER (top / bottom flat / floor corner R / depth / rim)",drawer_top_inner_width_mm,drawer_bottom_flat_width_mm,drawer_bottom_inside_radius_mm,drawer_inside_length_mm,drawer_rim_height_mm);
echo("GRID (columns / rows / row pitch)",grid_columns,grid_rows,logical_row_depth_mm);
echo("ROW SPLITS (0 extends previous group)",[for(r=[1:grid_rows]) row_splits(r)]);
echo("TRAY PROFILE (at chamfer width / at rim width / per-side draft)",measured_at_chamfer_width_mm,measured_at_rim_width_mm,measured_draft_per_side_mm);
echo("BOTTOM (outside chamfer rise / join chamfer rise / shared slope / inside fillet)",effective_chamfer_mm,join_edge_chamfer_height_mm,chamfer_angle_deg,inside_fillet_radius_mm);
echo("RIM (L/R/F/B, overhang)",rim_on_left,rim_on_right,rim_on_front,rim_on_rear,rim_overhang_mm);
echo("CUTOUT BOUNDARIES PER ROW",[for(r=[1:grid_rows]) cutout_boundary_for_row(r)]);

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

module section(width_grid_units,depth_grid_units,front_connector,right_connector,rear_connector,left_connector,left_draft_mm,right_draft_mm, front_draft_mm=0, rear_draft_mm=0, x_socket_count=effective_front_rear_joiner_count, y_socket_count=effective_left_right_joiner_count, front_socket_positions_mm=undef, rear_socket_positions_mm=undef, side_socket_positions_mm=undef, left_is_outer=false,right_is_outer=false,front_is_outer=false,rear_is_outer=false,left_cutout_centers_mm=[],right_cutout_centers_mm=[]) {
// A tray in local X/Y. Physical boundary treatments derive from the grid.
// Cutouts are mirrored on both adjoining tray walls.

outer_width_mm=width_grid_units*grid_pitch_x_mm;  // outer x size of the box
outer_depth_mm=depth_grid_units*grid_pitch_y_mm;  // outer y size of the box
// Same socket coordinates for front+rear, and likewise left+right.
x_joiner_stations_mm = joiner_stations(outer_width_mm,grid_pitch_x_mm,width_grid_units,x_socket_count);
front_joiner_stations_mm = is_undef(front_socket_positions_mm) ? x_joiner_stations_mm : front_socket_positions_mm;
rear_joiner_stations_mm = is_undef(rear_socket_positions_mm) ? x_joiner_stations_mm : rear_socket_positions_mm;
y_joiner_stations_mm = is_undef(side_socket_positions_mm)
    ? joiner_stations(outer_depth_mm,grid_pitch_y_mm,depth_grid_units,y_socket_count)
    : side_socket_positions_mm;
// Socket centers are shared between the two neighboring tray edges.
assert(!front_connector || len(front_joiner_stations_mm)>0, "Front joining edge needs sockets.");
assert(!rear_connector  || len(rear_joiner_stations_mm)>0,  "Rear joining edge needs sockets.");
assert(!(left_connector||right_connector) || len(y_joiner_stations_mm)>0, "Side joining edge needs sockets.");
assert(!front_connector || (min(front_joiner_stations_mm)>=connector_span_mm/2+connector_wall_reinforcement_mm &&
       max(front_joiner_stations_mm)<=outer_width_mm-connector_span_mm/2-connector_wall_reinforcement_mm),
       "Front socket too close to corner; reduce density or change grid.");
assert(!rear_connector || (min(rear_joiner_stations_mm)>=connector_span_mm/2+connector_wall_reinforcement_mm &&
       max(rear_joiner_stations_mm)<=outer_width_mm-connector_span_mm/2-connector_wall_reinforcement_mm),
       "Rear socket too close to corner; reduce density or change grid.");
assert(!(left_connector||right_connector) || (min(y_joiner_stations_mm)>=connector_span_mm/2+connector_wall_reinforcement_mm &&
       max(y_joiner_stations_mm)<=outer_depth_mm-connector_span_mm/2-connector_wall_reinforcement_mm),
       "Side socket too close to corner; reduce density or change grid.");
assert(!front_connector || len(front_joiner_stations_mm)<2 ||
       min([for (i=[1:len(front_joiner_stations_mm)-1]) front_joiner_stations_mm[i]-front_joiner_stations_mm[i-1]]) >= connector_span_mm+2*connector_wall_reinforcement_mm,
       "Front sockets overlap: fewer sockets needed.");
assert(!rear_connector || len(rear_joiner_stations_mm)<2 ||
       min([for (i=[1:len(rear_joiner_stations_mm)-1]) rear_joiner_stations_mm[i]-rear_joiner_stations_mm[i-1]]) >= connector_span_mm+2*connector_wall_reinforcement_mm,
       "Rear sockets overlap: fewer sockets needed.");
assert(!(left_connector||right_connector) || len(y_joiner_stations_mm)<2 ||
       min([for (i=[1:len(y_joiner_stations_mm)-1]) y_joiner_stations_mm[i]-y_joiner_stations_mm[i-1]]) >= connector_span_mm+2*connector_wall_reinforcement_mm,
       "Side sockets overlap: fewer sockets needed.");

    module conbody(rot) {
        y= 2*connector_tab_width_mm+connector_wall_reinforcement_mm<join_edge_chamfer_height_mm ? join_edge_chamfer_height_mm : 2*connector_tab_width_mm+connector_wall_reinforcement_mm;
        z= 2*connector_tab_height_mm+connector_wall_reinforcement_mm<join_edge_chamfer_height_mm ? join_edge_chamfer_height_mm : 2*connector_tab_height_mm+connector_wall_reinforcement_mm;
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

    
    // Outer joining edges: small elephant-foot chamfer only. Physical drawer
    // perimeter: deep clearance chamfer plus optional outward upper lip.
    // All ramps use one angle, relative to the horizontal print bed.
    module rawbody(outer_width_mm,outer_depth_mm,left_draft_mm,right_draft_mm,front_draft_mm,rear_draft_mm) {
        lx=left_is_outer?outer_chamfer_run_mm:join_chamfer_run_mm;
        rx=right_is_outer?outer_chamfer_run_mm:join_chamfer_run_mm;
        fy=front_is_outer?outer_chamfer_run_mm:join_chamfer_run_mm;
        by=rear_is_outer?outer_chamfer_run_mm:join_chamfer_run_mm;
        lz=left_is_outer?effective_chamfer_mm:join_edge_chamfer_height_mm;
        rz=right_is_outer?effective_chamfer_mm:join_edge_chamfer_height_mm;
        fz=front_is_outer?effective_chamfer_mm:join_edge_chamfer_height_mm;
        bz=rear_is_outer?effective_chamfer_mm:join_edge_chamfer_height_mm;
        lip_l=(left_is_outer&&rim_on_left)?rim_overhang_mm:0;
        lip_r=(right_is_outer&&rim_on_right)?rim_overhang_mm:0;
        lip_f=(front_is_outer&&rim_on_front)?rim_overhang_mm:0;
        lip_b=(rear_is_outer&&rim_on_rear)?rim_overhang_mm:0;
        intersection() {
            xz_prism([
                [lx,0], [outer_width_mm-rx,0],
                [outer_width_mm,rz],
                [outer_width_mm+right_draft_mm,active_rim_height_mm],
                [outer_width_mm+right_draft_mm,effective_tray_height_mm-rim_lip_rise_mm],
                [outer_width_mm+right_draft_mm+lip_r,effective_tray_height_mm],
                [-left_draft_mm-lip_l,effective_tray_height_mm],
                [-left_draft_mm,effective_tray_height_mm-rim_lip_rise_mm],
                [-left_draft_mm,active_rim_height_mm],
                [0,lz]
            ],-front_draft_mm-rim_overhang_mm-2,
               outer_depth_mm+rear_draft_mm+rim_overhang_mm+2);
            yz_prism([
                [fy,0], [outer_depth_mm-by,0],
                [outer_depth_mm,bz],
                [outer_depth_mm+rear_draft_mm,active_rim_height_mm],
                [outer_depth_mm+rear_draft_mm,effective_tray_height_mm-rim_lip_rise_mm],
                [outer_depth_mm+rear_draft_mm+lip_b,effective_tray_height_mm],
                [-front_draft_mm-lip_f,effective_tray_height_mm],
                [-front_draft_mm,effective_tray_height_mm-rim_lip_rise_mm],
                [-front_draft_mm,active_rim_height_mm],
                [0,fz]
            ],-left_draft_mm-rim_overhang_mm-2,
               outer_width_mm+right_draft_mm+rim_overhang_mm+2);
        }
    }

    // Cutouts are at logical grid-row centers and only on joining side walls.
    // Remove just the upper wall; keep the lower socket and base untouched.
    module upper_join_cutout(ycenter,xstart,xend) {
        w=join_cutout_width_mm;
        zlow=effective_tray_height_mm-join_cutout_depth_mm;
        yz_prism([
            [ycenter-w/2,zlow+5],
            [ycenter-w/2+5,zlow],
            [ycenter+w/2-5,zlow],
            [ycenter+w/2,zlow+5],
            [ycenter+w/2,effective_tray_height_mm+2],
            [ycenter-w/2,effective_tray_height_mm+2]
        ],xstart,xend);
    }

    difference() {
        // the outer body
        union() {
            rawbody(outer_width_mm, outer_depth_mm, left_draft_mm, right_draft_mm, front_draft_mm, rear_draft_mm);

            // connection to next module
            if(front_connector) {
                for(x_mm=front_joiner_stations_mm) {
                    translate([x_mm,0,0]) conbody(0);
                }
            }
            if(right_connector) {
                for(y_mm=y_joiner_stations_mm) {
                    translate([outer_width_mm,y_mm,0]) conbody(90);
                }
            }
            if(rear_connector) {
                for(x_mm=rear_joiner_stations_mm) {
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
                            [-front_draft_mm,effective_tray_height_mm-inside_fillet_radius_mm]
                        ], -1,outer_width_mm+1);
                    }
                    sphere(r=inside_fillet_radius_mm);
                }
            }
            // Symmetric cutout on BOTH walls bordering a chosen grid boundary.
            for(cy=left_cutout_centers_mm)
                upper_join_cutout(cy,-2,wall_thickness_mm+2);
            for(cy=right_cutout_centers_mm)
                upper_join_cutout(cy,outer_width_mm-wall_thickness_mm-2,outer_width_mm+2);
            // connection to next module
            if(front_connector) {
                for(x_mm=front_joiner_stations_mm) {
                    translate([x_mm,0,0]) conhole(0);
                }
            }
            if(right_connector) {
                for(y_mm=y_joiner_stations_mm) {
                    translate([outer_width_mm,y_mm,0]) conhole(90);
                }
            }
            if(rear_connector) {
                for(x_mm=rear_joiner_stations_mm) {
                    translate([x_mm,outer_depth_mm,0]) conhole(180);
                }
            }
            if(left_connector) {
                for(y_mm=y_joiner_stations_mm) {
                    translate([0,y_mm,0]) conhole(270);
                }
            }
        } // union
    } // difference
} // module

// --------------------------------------------
// LAYOUT ENGINE: 0 means CONTINUE previous row
// --------------------------------------------
module draw_grid_tray(start_row, column, for_layout=false, half=false) {
    last_row=group_end_from_start(start_row);
    cols=row_splits(start_row);
    part_w=tray_width_mm(cols);
    part_d=group_depth_mm(start_row);
    first_col=column==1;
    last_col=column==cols;
    at_rear=start_row==1;
    at_front=last_row==grid_rows;
    jfront=connector_mode==2 || (connector_mode==0 && !at_front);
    jrear=connector_mode==2 || (connector_mode==0 && !at_rear);
    jleft=connector_mode==2 || (connector_mode==0 && !first_col);
    jright=connector_mode==2 || (connector_mode==0 && !last_col);
    // Wall draft is only applied to OUTER X sides. Each full-width end tray
    // receives BOTH left and right drafts. Front/rear metal ends remain straight
    // by default; their offsets can be enabled independently.
    l_draft=first_col ? (drawer_draft_fit_mode==0 ? measured_draft_per_side_mm : left_top_offset_mm) : 0;
    r_draft=last_col ? (drawer_draft_fit_mode==0 ? measured_draft_per_side_mm : right_top_offset_mm) : 0;
    f_draft=at_front ? front_top_offset_mm : 0;
    b_draft=at_rear ? rear_top_offset_mm : 0;
    // Back row 1 -> following rows increasing towards front. At the 'front'
    // of this group, the neighbor is the NEXT row (larger index).
    front_stations=last_row<grid_rows ? cross_band_socket_x_positions(cols,column,group_cols_for_row(last_row+1)) : (connector_mode==2 ? [part_w/2] : []);
    rear_stations=start_row>1 ? cross_band_socket_x_positions(cols,column,group_cols_for_row(start_row-1)) : (connector_mode==2 ? [part_w/2] : []);
    // Exactly one socket per logical depth-row by default, centered in each.
    // Unlike the original designer's fixed 59 mm pitch, this adapts to any
    // measured drawer depth and any logical grid row count.
    side_stations=joiner_distribution==0
        ? [for(i=[0:last_row-start_row]) (i+0.5)*logical_row_depth_mm]
        : joiner_stations(part_d,logical_row_depth_mm,1,joiner_count_left_right);
    // Row-level cutout boundary selectors are mirrored to adjacent tray walls.
    // center is measured from the FRONT of the current merged group.
    left_notches=[for(r=[start_row:last_row])
        if(cutout_boundary_for_row(r)==column-1 && column>1)
            (last_row-r+0.5)*logical_row_depth_mm];
    right_notches=[for(r=[start_row:last_row])
        if(cutout_boundary_for_row(r)==column && column<cols)
            (last_row-r+0.5)*logical_row_depth_mm];
    assert(!jfront || len(front_stations)>0 || connector_mode==2,"No valid front joiner overlap; try fewer grid columns.");
    assert(!jrear  || len(rear_stations)>0 || connector_mode==2,"No valid rear joiner overlap; try fewer grid columns.");
    if(!for_layout) echo("PART (start row / end row / column / total columns)",start_row,last_row,column,cols);
    if(!for_layout) echo("PART SIZE X/Y (mm)",part_w,part_d,"JOINING EDGES (F,R,Left,Right)",jfront,jrear,jleft,jright);
    if(!for_layout) echo("PART SOCKETS (front/rear/side)",front_stations,rear_stations,side_stations);
    section(width_grid_units=part_w/grid_pitch_x_mm,
        depth_grid_units=part_d/grid_pitch_y_mm,
        front_connector=jfront,right_connector=jright,rear_connector=jrear,left_connector=jleft,
        left_draft_mm=l_draft,right_draft_mm=r_draft,
        front_draft_mm=f_draft,rear_draft_mm=b_draft,
        x_socket_count=1,y_socket_count=joiner_count_left_right,
        front_socket_positions_mm=front_stations,
        rear_socket_positions_mm=rear_stations,
        side_socket_positions_mm=side_stations,
        left_is_outer=first_col,right_is_outer=last_col,
        front_is_outer=at_front,rear_is_outer=at_rear,
        left_cutout_centers_mm=left_notches,right_cutout_centers_mm=right_notches);
}

module full_layout() {
    for(row=[1:grid_rows]) if(row_splits(row)>0) {
        cols=row_splits(row);
        for(column=[1:cols]) {
            x0=(column-1)*tray_width_mm(cols);
            y0=group_start_y_mm(row);
            translate([x0+(column-(cols+1)/2)*preview_explode_gap_mm,
                       y0+(grid_rows-row)*preview_explode_gap_mm,0])
                color([(column%3==0)?0.68:0.85,(row%3==0)?0.78:0.87,((column+row)%3==0)?0.7:0.94])
                    draw_grid_tray(row,column,for_layout=true);
        }
    }
}

if(output_mode==0) {
    full_layout();
} else if(output_mode==2) {
    for(i=[0:connector_quantity-1]) translate([i*10,-20,0]) connector();
} else if(output_mode==3) {
    for(i=[0:connector_quantity-1]) translate([i*10,-40,0]) connector_half();
} else {
    assert(selected_grid_row<=grid_rows,"Selected row exceeds grid_rows.");
    part_start=group_start_for_row(selected_grid_row);
    assert(selected_grid_column<=row_splits(part_start),"Selected column exceeds columns in selected row group.");
    draw_grid_tray(part_start,selected_grid_column);
}