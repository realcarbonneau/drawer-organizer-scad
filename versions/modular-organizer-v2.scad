// MODULAR DRAWER ORGANIZER — v2 — corrected location joinery + calculated interior radius (2026-11-12)
// Original design by fotrik: https://www.printables.com/model/816729-modular-drawer-organizer-remix/
// Original remix permitted with attribution. Geometry based on original section()/section_half().
// OpenSCAD 2021.01 compatible; no external libraries required.
//
// QUICK START
// 1. Select Part type. Front and rear full-width parts each have ONE connector row.
//    Select a numbered DRAWER preset to use the complete 218 x 190 x 475 measured profile.
// 2. Drawer-fit mode calculates the left/right sidewall draft from floor width,
//    top width, bottom radius and chamfer; disable it for manual geometry.
// 3. In manual mode, change left/right outward top offsets; F5/F6.
// 4. Interior fillet radius is calculated to preserve the base thickness over the exterior chamfer.
// 5. "Front rim extension" projects over the front top edge; it is NOT front wall draft.
// 6. Only Example parts use hard-coded grid dimensions; custom parts use your dimensions.
// 7. Automatic joinery: front-full = rear edge ONLY; rear-full = front edge ONLY.
// 8. Outer corners = only two joining edges. Connector override bypasses this.
// 9. For no joining tabs, select "None" in the joinery dropdown.
// 10. Joiner sockets are distributed along enabled edges in the [01b] section.
//     In drawer-fit Exact count mode: the end tray count is divided equally
//     among the middle columns (4 at the end / 4 columns = one per column).
//     In GRID mode, adjoining modules must share a matching global grid.
//     In EXACT COUNT mode, adjoining edges must have matching centers.
// 11. Loose joiners and tray socket count are independent settings.
//
// AXES: X = left/right across drawer, Y = front/rear, Z = height.
// SIDEWALL DRAFT: top offset in X from lower wall at z=bottom chamfer leg.
// Positive offsets lean outward: left towards -X, right towards +X.
// Draft offsets are reached at drawer rim height and remain constant above the rim.

/* [01 - Part selection] */
// Part type (editable trays or the author's sample examples)
part_type = 103; // [101:Interior - full, 102:Left outside - full, 108:Right outside - full, 103:FRONT full width - full, 109:REAR full width - full, 104:Front-left corner - full, 105:Rear-left corner - full, 106:Rear-right corner - full, 107:Front-right corner - full, 201:Interior - print half, 202:Left outside - print half, 208:Right outside - print half, 203:FRONT full width - print half, 209:REAR full width - print half, 204:Front-left corner - print half, 205:Rear-left corner - print half, 206:Rear-right corner - print half, 207:Front-right corner - print half, 1:Standard joining tabs only, 51:Half tray joining tabs only, 9001:Sample 1 - teaspoons, 9002:Sample 2 - knives, 9003:Sample 3 - forks, 9004:Sample 4 - spoons, 9005:Sample 5 - chef knives, 9006:Sample 6 - steak knives, 9007:Sample 7 - utility compartment, 9999:Full original demo layout]
// Interlocking tabs (applies to editable tray parts, not fixed examples)
connector_mode = 0; // [0:Automatic - inward edges only, 1:None - plain tray, 2:All four edges - override]
/* [01b - Joiner socket geometry] */
// Socket positioning on each ENABLED connecting edge.
joiner_distribution = 2; // [0:Original grid stations, 1:Fixed center-to-center pitch, 2:Exact socket count]
// Center-to-center pitch for Fixed pitch mode (mm); stations centered on each edge.
joiner_socket_pitch_mm = 59; // [20:1:150]
// Exact count on each enabled FRONT or REAR edge (X direction).
joiner_count_front_rear = 4; // [1:1:20]
// Exact count on each enabled LEFT or RIGHT edge (Y direction).
joiner_count_left_right = 6; // [1:1:20]
// LEFT/RIGHT joining edge socket count for SHORT end-corner pieces in measured drawer mode.
joiner_count_short_corner_side = 1; // [1:1:6]
// Minimum end clearance to the center of the first/last socket in Fixed pitch mode (mm).
joiner_min_end_inset_mm = 12; // [9:0.5:50]
// Fit clearance around separate printed joiners, mm.
connector_fit_clearance_mm = 0.1; // [0.05:0.05:0.5]
// Number of LOOSE joiners printed (only for "joining tabs only" part types).
connector_quantity = 6; // [1:1:40]

/* [02 - Measured metal drawer fit] */
// Automatically dimension editable front / rear / middle / corner parts to this drawer.
// With this ON for editable trays, grid dimensions are replaced by measured dimensions.
use_measured_drawer_fit = true;
// Width across the inside of the metal drawer, at its open top rim.
drawer_top_inner_width_mm = 218; // [100:1:1200]
// Width of FLAT floor between the two bottom corner-radius tangency points.
drawer_bottom_flat_width_mm = 190; // [100:1:1200]
// Radius of the METAL DRAWER's bottom inside corner (NOT the tray fillet radius).
drawer_bottom_inside_radius_mm = 10; // [1:0.5:30]
// Front-to-rear internal usable length of metal drawer.
drawer_inside_length_mm = 475; // [100:1:1200]
// Height from drawer floor to upper inside metal rim.
drawer_rim_height_mm = 65; // [20:1:100]
// Tray height above the metal drawer rim.
tray_extension_above_rim_mm = 10; // [0:0.5:30]
// Total allowance across drawer width (0.5 mm per side if 1 mm) AND depth.
assembly_total_clearance_mm = 1; // [0:0.2:6]
// Number of parallel middle trays between front and rear trays.
middle_tray_columns = 4; // [2:1:8]
// Front and rear tray Y depths (middle row gets all remaining length).
front_tray_depth_mm = 59; // [25:1:150]
rear_tray_depth_mm = 59; // [25:1:150]
// With AUTO, bottom chamfer leg is tied to the metal drawer bottom corner radius.
chamfer_fit_mode = 0; // [0:Use drawer bottom radius, 1:Manual chamfer leg]
// With AUTO, side draft is computed to meet measured width at drawer rim.
drawer_draft_fit_mode = 0; // [0:Auto from top/bottom drawer widths, 1:Manual offsets]

/* [02 - Sidewall draft] */
// Where sidewall draft is applied to editable trays
sidewall_profile = 0; // [0:Automatic - only selected outer edge, 1:Vertical - no draft, 2:Left side only, 3:Right side only, 4:Both left and right sides]
// Left sidewall OUTWARD top offset, for MANUAL draft mode (0 = vertical)
left_top_offset_mm = 4; // [0:0.1:30]
// Right sidewall OUTWARD top offset, for MANUAL draft mode (0 = vertical)
right_top_offset_mm = 4; // [0:0.1:30]

// Front/rear OUTWARD top offset at the drawer rim (mm). Usually zero unless verified by measurement.
front_top_offset_mm = 0; // [0:0.5:25]
rear_top_offset_mm = 0; // [0:0.5:25]
// Which front/rear exterior walls should receive a draft
endwall_profile = 0; // [0:Automatic - only selected exterior end, 1:Vertical - no draft, 2:Front only, 3:Rear only, 4:Both front and rear]

/* [03 - Tray geometry] */
// X-direction pitch of layout grid in MANUAL mode, mm
grid_pitch_x_mm = 59; // [25:0.5:150]
// Y-direction pitch of layout grid in MANUAL mode, mm
grid_pitch_y_mm = 59; // [25:0.5:150]
// Outer tray width in X-grid units (fractions are supported for precise fitting)
tray_width_grid_units = 1; // [0.5:0.05:10]
// Outer tray depth in Y-grid units (decimals are supported)
tray_depth_grid_units = 4; // [1:0.1:10]
// Exterior height of tray in MANUAL mode (measured fit sets rim height + extension)
tray_height_mm = 75; // [20:1:100]
// Nominal vertical wall thickness, mm (may differ from floor thickness)
wall_thickness_mm = 1.8; // [0.6:0.1:5]
// Floor thickness, mm. Determines REQUIRED minimum thickness over the exterior chamfer.
base_thickness_mm = 1.8; // [0.6:0.1:5]
// Height of drawer rim above floor, mm. Draft reaches its specified offset here.
// The interior fillet is AUTO-CALCULATED, not an independent setting.
// External lower edge 45-degree chamfer leg in MANUAL chamfer mode (original edgec)
bottom_chamfer_leg_mm = 10; // [0:0.5:25]
// Forward projection of the TOP FRONT RIM, mm (original collar)
front_rim_extension_mm = 0; // [0:0.5:12]

/* [04 - Cutouts and accessories] */
// Left-wall access notch center position along Y, in grid units; 0=disabled (requires depth >2 units)
left_wall_cutout_y_units = 0; // [0:0.1:10]
// Right-wall access notch center position along Y, in grid units; 0=disabled (requires depth >2 units)
right_wall_cutout_y_units = 0; // [0:0.1:10]
// Raised knife riser at the rear of an editable tray
rear_knife_riser = false;
// Raised knife riser at the front of an editable tray
front_knife_riser = false;

/* [05 - Display quality] */
// Facets for curves (64 previews faster; increase for final production)
curve_facets = 64; // [16:8:160]
// Separation between sample parts in the seven-piece demo, mm
demo_spacing_mm = 10; // [0:1:30]

/* [Hidden] */
$fn = curve_facets;
// Geometry-engine constants from the original implementation (mm)
connector_span_mm = 14;
connector_tab_width_mm = 3;
connector_tab_height_mm = 3;
connector_wall_reinforcement_mm = 2;
epsilon_mm = 0.01;

// Editable part placement: outer edges only are tapered in Auto mode.
custom_part_selected = (part_type>=101 && part_type<=109) || (part_type>=201 && part_type<=209);
measured_mode_active = use_measured_drawer_fit && custom_part_selected;
left_outer_location = (part_type==102 || part_type==104 || part_type==105 || part_type==103 || part_type==109 || part_type==202 || part_type==204 || part_type==205 || part_type==203 || part_type==209);
right_outer_location = (part_type==108 || part_type==106 || part_type==107 || part_type==103 || part_type==109 || part_type==208 || part_type==206 || part_type==207 || part_type==203 || part_type==209);
apply_left_draft = sidewall_profile==2 || sidewall_profile==4 || (sidewall_profile==0 && left_outer_location);
apply_right_draft = sidewall_profile==3 || sidewall_profile==4 || (sidewall_profile==0 && right_outer_location);
effective_left_offset_mm = apply_left_draft ? left_top_offset_mm : 0;
effective_right_offset_mm = apply_right_draft ? right_top_offset_mm : 0;
front_outer_location = (part_type==103 || part_type==104 || part_type==107 || part_type==203 || part_type==204 || part_type==207);
rear_outer_location = (part_type==109 || part_type==105 || part_type==106 || part_type==209 || part_type==205 || part_type==206);
apply_front_draft = endwall_profile==2 || endwall_profile==4 || (endwall_profile==0 && front_outer_location);
apply_rear_draft = endwall_profile==3 || endwall_profile==4 || (endwall_profile==0 && rear_outer_location);
effective_front_offset_mm = apply_front_draft ? front_top_offset_mm : 0;
effective_rear_offset_mm = apply_rear_draft ? rear_top_offset_mm : 0;
// Drawer fit: at z=0 outer floor width is bottom flat width minus clearance.
// Matching the exterior 45-degree chamfer leg to the drawer radius gives a
// conservative diagonal inside the rounded metal corner. Above this leg,
// the sloped outside walls widen to the desired upper rim width.
effective_chamfer_mm = measured_mode_active && chamfer_fit_mode==0 ? drawer_bottom_inside_radius_mm : bottom_chamfer_leg_mm;
effective_tray_height_mm = measured_mode_active ? drawer_rim_height_mm + tray_extension_above_rim_mm : tray_height_mm;
measured_at_chamfer_width_mm = drawer_bottom_flat_width_mm + 2*effective_chamfer_mm - assembly_total_clearance_mm;
measured_at_rim_width_mm = drawer_top_inner_width_mm - assembly_total_clearance_mm;
measured_draft_per_side_mm = (measured_at_rim_width_mm-measured_at_chamfer_width_mm)/2;
measured_usable_depth_mm = drawer_inside_length_mm - assembly_total_clearance_mm;
measured_middle_depth_mm = measured_usable_depth_mm - front_tray_depth_mm - rear_tray_depth_mm;
measured_middle_column_width_mm = measured_at_chamfer_width_mm / middle_tray_columns;
front_full_width_location = (part_type==103 || part_type==109 || part_type==203 || part_type==209);
front_corner_location = (part_type==104 || part_type==107 || part_type==204 || part_type==207);
rear_corner_location = (part_type==105 || part_type==106 || part_type==205 || part_type==206);
measured_part_width_mm = front_full_width_location ? measured_at_chamfer_width_mm : measured_middle_column_width_mm;
measured_part_depth_mm = front_full_width_location ? (part_type==103 || part_type==203 ? front_tray_depth_mm : rear_tray_depth_mm)
                       : front_corner_location ? front_tray_depth_mm
                       : rear_corner_location ? rear_tray_depth_mm : measured_middle_depth_mm;
effective_width_grid_units = measured_mode_active ? measured_part_width_mm/grid_pitch_x_mm : tray_width_grid_units;
effective_depth_grid_units = measured_mode_active ? measured_part_depth_mm/grid_pitch_y_mm : tray_depth_grid_units;
custom_draft_left_mm = apply_left_draft ? (measured_mode_active && drawer_draft_fit_mode==0 ? measured_draft_per_side_mm : left_top_offset_mm) : 0;
custom_draft_right_mm = apply_right_draft ? (measured_mode_active && drawer_draft_fit_mode==0 ? measured_draft_per_side_mm : right_top_offset_mm) : 0;
// Every one-column middle tray must line up with one or more end-row sockets.
// The end-row count is distributed evenly among the middle column count.
effective_front_rear_joiner_count = measured_mode_active && !front_full_width_location && joiner_distribution==2
                                 ? joiner_count_front_rear/middle_tray_columns : joiner_count_front_rear;
effective_left_right_joiner_count = measured_mode_active && (front_corner_location || rear_corner_location) && joiner_distribution==2
                                 ? joiner_count_short_corner_side : joiner_count_left_right;
// Editable parts must share the SAME two X station sequences when assembled.
// Tangency of the round interior and the exterior x+z=c chamfer.
// At closest 45-degree approach: (wall+base+(2-sqrt(2))*r-c)/sqrt(2)=base.
// Solve for r, so the minimum normal material thickness is exactly BASE thickness.
inside_fillet_radius_mm = (effective_chamfer_mm + (sqrt(2)-1)*base_thickness_mm - wall_thickness_mm)/(2-sqrt(2));
active_rim_height_mm = min(drawer_rim_height_mm,effective_tray_height_mm);


assert(!measured_mode_active || drawer_top_inner_width_mm>drawer_bottom_flat_width_mm, "Top width must exceed flat bottom width.");
assert(!measured_mode_active || measured_draft_per_side_mm>=0, "Chamfer is too large for measured widths; reduce radius or chamfer size.");
assert(!measured_mode_active || measured_middle_depth_mm>20, "Front and rear rows consume all available drawer depth.");
assert(!measured_mode_active || joiner_distribution!=2 || joiner_count_front_rear % middle_tray_columns==0, "Exact end-row socket count must be a multiple of middle-column count (e.g. 4 sockets / 4 columns).");
assert(!measured_mode_active || effective_chamfer_mm<=drawer_bottom_inside_radius_mm+0.0001, "For a rounded drawer floor, chamfer leg must not exceed drawer radius in measured fit mode.");
assert(effective_width_grid_units>=0.5 && effective_depth_grid_units>=0.5, "Tray grid unit counts must be at least 0.5.");
assert(effective_tray_height_mm>0 && wall_thickness_mm>=0.45, "Tray height and wall thickness must be positive.");
assert(effective_chamfer_mm>=0 && effective_chamfer_mm<effective_tray_height_mm, "Chamfer leg must be less than tray height.");
assert(inside_fillet_radius_mm>0.1, "Chamfer leg / thickness yields non-positive calculated interior fillet radius.");
assert(2*(inside_fillet_radius_mm+wall_thickness_mm)<effective_width_grid_units*grid_pitch_x_mm && 2*(inside_fillet_radius_mm+wall_thickness_mm)<effective_depth_grid_units*grid_pitch_y_mm, "Tray must be larger than two fillet-radius offsets plus wall thickness. Reduce chamfer or enlarge tray.");
assert(base_thickness_mm>=0.4 && base_thickness_mm<effective_tray_height_mm, "Base thickness out of range.");
assert(drawer_rim_height_mm>effective_chamfer_mm, "Drawer rim must be higher than the exterior chamfer.");
assert(left_top_offset_mm>=0 && right_top_offset_mm>=0 && front_top_offset_mm>=0 && rear_top_offset_mm>=0, "Exterior draft offsets must be non-negative.");
assert(joiner_min_end_inset_mm >= connector_span_mm/2+connector_wall_reinforcement_mm, "End inset must clear half of the joiner mounting block.");
assert(connector_fit_clearance_mm>=0.01 && connector_fit_clearance_mm<=0.5, "Loose joiner clearance must be between 0.01 and 0.5 mm.");

echo("Part type:", part_type);
echo("Editable tray width/depth (mm):", effective_width_grid_units*grid_pitch_x_mm, effective_depth_grid_units*grid_pitch_y_mm);
echo("Calculated interior fillet radius (mm):", inside_fillet_radius_mm);
echo("Base thickness / vertical wall thickness (mm):", base_thickness_mm, wall_thickness_mm);
echo("Normal clearance over 45-degree bottom chamfer (mm):", (wall_thickness_mm+base_thickness_mm+(2-sqrt(2))*inside_fillet_radius_mm-effective_chamfer_mm)/sqrt(2));
echo("Applied SIDEWALL top offset left/right (mm):", custom_draft_left_mm, custom_draft_right_mm);
echo("Applied ENDWALL top offset front/rear (mm):", effective_front_offset_mm, effective_rear_offset_mm);
echo("Applied sidewall draft angle left/right (degrees):", atan(custom_draft_left_mm/(active_rim_height_mm-effective_chamfer_mm)), atan(custom_draft_right_mm/(active_rim_height_mm-effective_chamfer_mm)));
echo("Metal drawer [top width, flat bottom width, bottom radius, length] mm:", drawer_top_inner_width_mm,drawer_bottom_flat_width_mm,drawer_bottom_inside_radius_mm,drawer_inside_length_mm);
echo("Measured fit: body width at z=chamfer, top outer width, floor outer width (mm):", measured_at_chamfer_width_mm, measured_at_rim_width_mm, measured_at_chamfer_width_mm-2*effective_chamfer_mm);
echo("Measured fit: [front, middle, rear] row depth (mm):", front_tray_depth_mm,measured_middle_depth_mm,rear_tray_depth_mm);
echo("Demo samples use side offsets directly (left/right), even if draft profile = Automatic.");

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

module section(width_grid_units,depth_grid_units,left_wall_cutout_y_units,right_wall_cutout_y_units,front_connector,right_connector,rear_connector,left_connector,rear_knife_riser,front_knife_riser,left_draft_mm,right_draft_mm, front_rim_extension_mm, front_draft_mm=0, rear_draft_mm=0) {
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
x_joiner_stations_mm = joiner_stations(outer_width_mm,grid_pitch_x_mm,width_grid_units,effective_front_rear_joiner_count);
y_joiner_stations_mm = joiner_stations(outer_depth_mm,grid_pitch_y_mm,depth_grid_units,effective_left_right_joiner_count);
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

module section_half(width_grid_units,depth_grid_units,left_wall_cutout_y_units,right_wall_cutout_y_units,front_connector,right_connector,rear_connector,left_connector,rear_knife_riser,front_knife_riser,left_draft_mm,right_draft_mm, front_rim_extension_mm,front_draft_mm=0,rear_draft_mm=0) {

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
                section(width_grid_units,depth_grid_units,left_wall_cutout_y_units,right_wall_cutout_y_units,front_connector,right_connector,rear_connector,left_connector,rear_knife_riser,front_knife_riser,left_draft_mm,right_draft_mm, front_rim_extension_mm,front_draft_mm,rear_draft_mm);
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


// ORIGINAL DEMONSTRATION PIECES (fixed geometry; shape and side offsets are still adjustable)
if(part_type==9001 || part_type==9999) {
// #1 front section for tea spoons
    translate([0,0,0])
        section(width_grid_units=3,depth_grid_units=1,left_wall_cutout_y_units=0,right_wall_cutout_y_units=0,front_connector=0,right_connector=1,rear_connector=1,left_connector=0,rear_knife_riser=0,front_knife_riser=0,left_draft_mm=left_top_offset_mm,right_draft_mm=0, front_rim_extension_mm=front_rim_extension_mm);
}
if(part_type==9002 || part_type==9999) {
// #2 left section for knives
    translate([0,grid_pitch_y_mm+demo_spacing_mm,0])
        section(width_grid_units=1,depth_grid_units=4,left_wall_cutout_y_units=0,right_wall_cutout_y_units=2,front_connector=1,right_connector=1,rear_connector=1,left_connector=0,rear_knife_riser=0,front_knife_riser=0,left_draft_mm=left_top_offset_mm,right_draft_mm=0,front_rim_extension_mm=front_rim_extension_mm);
}
if(part_type==9003 || part_type==9999) {
// #3 middle section for forks
    translate([grid_pitch_x_mm+demo_spacing_mm,grid_pitch_y_mm+demo_spacing_mm,0])
        section(width_grid_units=1,depth_grid_units=4,left_wall_cutout_y_units=2,right_wall_cutout_y_units=2,front_connector=1,right_connector=1,rear_connector=1,left_connector=1,rear_knife_riser=0,front_knife_riser=0,left_draft_mm=0,right_draft_mm=0, front_rim_extension_mm=front_rim_extension_mm);
}
if(part_type==9004 || part_type==9999) {
// #4 right section for spoons
    translate([2*grid_pitch_x_mm+2*demo_spacing_mm,grid_pitch_y_mm+demo_spacing_mm,0])
        section(width_grid_units=1,depth_grid_units=4,left_wall_cutout_y_units=2,right_wall_cutout_y_units=0.91,front_connector=1,right_connector=1,rear_connector=1,left_connector=1,rear_knife_riser=0,front_knife_riser=0,left_draft_mm=0,right_draft_mm=0, front_rim_extension_mm=front_rim_extension_mm);
}
if(part_type==9005 || part_type==9999) {
// #5 front right section for sharp knives
// this an example how to tune some section shorter than integer multiplication
// for depth_grid_units greater than 80% of grid_pitch_y_mm multiplication the last connector is still added
// connectors always stay in grid_pitch_x_mm/grid_pitch_y_mm grid
// in this case i want the length 10 mm shorter, 226 mm (depth_grid_units=226/grid_pitch_y_mm)
    translate([3*grid_pitch_x_mm+3*demo_spacing_mm,0,0])
        section(width_grid_units=1,depth_grid_units=226/grid_pitch_y_mm,left_wall_cutout_y_units=1.91,right_wall_cutout_y_units=0,front_connector=0,right_connector=0,rear_connector=1,left_connector=1,rear_knife_riser=1,front_knife_riser=0,left_draft_mm=0,right_draft_mm=right_top_offset_mm, front_rim_extension_mm=front_rim_extension_mm);
}
if(part_type==9006 || part_type==9999) {
// #6 back right section for steak knives
// this one I needed longer, so 10 mm taken from #5 are added here
// simple depth_grid_units=246/mod would make it longer but we need it in front to maintain connector grid
// so left_wall_cutout_y_units is swapped with right_wall_cutout_y_units, left_connector with right_connector, front_connector with rear_connector and rear_knife_riser with front_knife_riser
// then the whole section is rotated
    translate([4*grid_pitch_x_mm+3*demo_spacing_mm+10,8*grid_pitch_y_mm+2*demo_spacing_mm,0]) rotate([0,0,180])
        section(width_grid_units=1,depth_grid_units=246/grid_pitch_y_mm,left_wall_cutout_y_units=0,right_wall_cutout_y_units=4-1.6,front_connector=0,right_connector=1,rear_connector=1,left_connector=0,rear_knife_riser=0,front_knife_riser=1,left_draft_mm=left_top_offset_mm,right_draft_mm=0, front_rim_extension_mm=front_rim_extension_mm);
}
if(part_type==9007 || part_type==9999) {
// #7 back large bin for any other stuff
    translate([0,5*grid_pitch_y_mm+2*demo_spacing_mm,0])
        section(width_grid_units=3,depth_grid_units=3,left_wall_cutout_y_units=0,right_wall_cutout_y_units=0.6,front_connector=1,right_connector=1,rear_connector=0,left_connector=0,rear_knife_riser=0,front_knife_riser=0,left_draft_mm=left_top_offset_mm,right_draft_mm=0,front_rim_extension_mm=front_rim_extension_mm);
}


// -------------------------------------------------------
// EDITABLE PART OUTPUT: one dropdown, no model numbers to edit.
// -------------------------------------------------------
if (custom_part_selected) {
    is_half = part_type>=200;
    // 1xx = full tray; 2xx = printable half (same drawer-position semantics).
    full_part_type = is_half ? part_type-100 : part_type;

    // Exterior edges NEVER have connectors. Front/rear full-width trays touch
    // left+right outside walls AND their respective end, so exactly ONE joiner row.
    is_front_full_width = full_part_type==103;
    is_rear_full_width  = full_part_type==109;
    default_front_connector = !(full_part_type==103 || full_part_type==104 || full_part_type==107);
    default_rear_connector  = !(full_part_type==109 || full_part_type==105 || full_part_type==106);
    default_left_connector  = !(full_part_type==102 || full_part_type==104 || full_part_type==105 || is_front_full_width || is_rear_full_width);
    default_right_connector = !(full_part_type==108 || full_part_type==106 || full_part_type==107 || is_front_full_width || is_rear_full_width);

    use_front_connector = connector_mode==2 ? true : (connector_mode==1 ? false : default_front_connector);
    use_rear_connector  = connector_mode==2 ? true : (connector_mode==1 ? false : default_rear_connector);
    use_left_connector  = connector_mode==2 ? true : (connector_mode==1 ? false : default_left_connector);
    use_right_connector = connector_mode==2 ? true : (connector_mode==1 ? false : default_right_connector);

    echo("CONNECTOR EDGES [front,right,rear,left] (true=joiner row):",
         use_front_connector,use_right_connector,use_rear_connector,use_left_connector);
    echo("SOCKET LAYOUT [mode, front/rear count, left/right count]:",
         joiner_distribution,
         len(joiner_stations(effective_width_grid_units*grid_pitch_x_mm,grid_pitch_x_mm,effective_width_grid_units,effective_front_rear_joiner_count)),
         len(joiner_stations(effective_depth_grid_units*grid_pitch_y_mm,grid_pitch_y_mm,effective_depth_grid_units,effective_left_right_joiner_count)));

    if (is_half)
        section_half(
            width_grid_units=effective_width_grid_units,
            depth_grid_units=effective_depth_grid_units,
            left_wall_cutout_y_units=left_wall_cutout_y_units,
            right_wall_cutout_y_units=right_wall_cutout_y_units,
            front_connector=use_front_connector,
            right_connector=use_right_connector,
            rear_connector=use_rear_connector,
            left_connector=use_left_connector,
            rear_knife_riser=rear_knife_riser,
            front_knife_riser=front_knife_riser,
            left_draft_mm=custom_draft_left_mm,
            right_draft_mm=custom_draft_right_mm,
            front_rim_extension_mm=front_rim_extension_mm,
            front_draft_mm=effective_front_offset_mm,
            rear_draft_mm=effective_rear_offset_mm
        );
    else
        section(
            width_grid_units=effective_width_grid_units,
            depth_grid_units=effective_depth_grid_units,
            left_wall_cutout_y_units=left_wall_cutout_y_units,
            right_wall_cutout_y_units=right_wall_cutout_y_units,
            front_connector=use_front_connector,
            right_connector=use_right_connector,
            rear_connector=use_rear_connector,
            left_connector=use_left_connector,
            rear_knife_riser=rear_knife_riser,
            front_knife_riser=front_knife_riser,
            left_draft_mm=custom_draft_left_mm,
            right_draft_mm=custom_draft_right_mm,
            front_rim_extension_mm=front_rim_extension_mm,
            front_draft_mm=effective_front_offset_mm,
            rear_draft_mm=effective_rear_offset_mm
        );
}

// Standalone joining components. One selection produces N parts.
if (part_type==1) {
    for(i=[0:connector_quantity-1])
        translate([i*10,-20,0]) connector();
}
if (part_type==51) {
    for(i=[0:connector_quantity-1])
        translate([i*10,-40,0]) connector_half();
}
// Restore the loose joiners that were part of the original full demonstration.
if (part_type==9999) {
    for(i=[0:21])
        translate([i*10,-20,0]) connector();
    for(i=[0:1])
        translate([i*10,-40,0]) connector_half();
}