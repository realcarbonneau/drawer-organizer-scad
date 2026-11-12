// DRAWER ORGANIZER v8
// Independent parametric model for a measured, metal-sided kitchen drawer.
// OpenSCAD 2021.01; no libraries or external geometry required.
//
// TOP VIEW: stand at the FRONT of the open drawer and look DOWN.
// Row 1 = REAR / farthest away. Increasing rows approach the FRONT.
// Column 1 = LEFT. Increasing columns move RIGHT.
// A row split of 0 extends the preceding row's trays into that row.
// All dimensions are millimetres; angle is measured FROM THE PRINT BED.

/* [01 - Drawer dimensions] */
// Inner width across the TOP of the metal drawer.
drawer_top_width_mm = 218; // [60:1:1000]
// Flat bottom width between the curved metal floor corners.
drawer_floor_width_mm = 190; // [50:1:1000]
// Approximate floor-to-side corner radius of the metal drawer.
drawer_floor_corner_radius_mm = 10; // [0:0.5:35]
// Clear front-to-rear length of the drawer.
drawer_inside_length_mm = 475; // [60:1:1200]
// Height of metal rim above drawer floor.
drawer_rim_height_mm = 65; // [20:1:200]
// Total lateral and front/rear clearance, shared between opposite sides.
drawer_total_clearance_mm = 1; // [0:0.1:6]

/* [02 - Drawer logical grid] */
// Maximum number of left-to-right compartments in a row.
grid_columns = 3; // [1:1:10]
// Number of equally deep logical rows, REAR to FRONT.
grid_rows = 6; // [1:1:10]
// Row 1 must begin a group; it cannot continue another row.
row_01_splits = 1; // [1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
// Row 2: zero continues the previous row's tray group.
row_02_splits = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
// Row 3.
row_03_splits = 3; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
// Row 4.
row_04_splits = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
// Row 5.
row_05_splits = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
// Row 6.
row_06_splits = 1; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
// Row 7.
row_07_splits = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
// Row 8.
row_08_splits = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
// Row 9.
row_09_splits = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
// Row 10.
row_10_splits = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]

/* [03 - Drawer, rim, print slopes and shared tray geometry] */
// Angle from horizontal, shared by all ramps, beveled entry and bottom chamfers.
print_overhang_angle_deg = 60; // [25:1:75]
// Upper tray wall height above the metal rim, excluding any extra rise needed for rim flare.
tray_height_above_rim_mm = 10; // [0:0.5:50]
// Lip flares outward immediately at the metal rim, WITHOUT a vertical gap.
rim_left = true;
rim_right = true;
rim_front = false;
rim_rear = false;
// Horizontal outward projection of enabled rim flares.
rim_projection_mm = 3; // [0:0.5:18]
// Maximum rise of the lower EXTERIOR chamfer in AUTO fit mode.
// Its actual rise may be reduced to maintain the requested print angle.
outer_bottom_chamfer_max_rise_mm = 10; // [0:0.5:30]
// Bottom elephant-foot relief along joining edges, excluding connector mouths.
join_edge_elephant_foot_mm = 1; // [0:0.1:4]

// Shared tray geometry (same drawer-level section).
// Floor thickness is also the MINIMUM distance to every outer wall surface.
base_thickness_mm = 1.8; // [0.8:0.1:5]
// Additional reinforcements around the dogbone sockets use this thickness.
wall_thickness_mm = 1.8; // [0.8:0.1:5]
// Bottom INSIDE fillet is derived from the base thickness; upper internal edges remain sharp.
// Upper internal horizontal edges: leave square for reliable printing.

/* [04 - Rounded dogbone joining system] */
// One continuous connector center-spacing target on every joining segment.
connector_spacing_mm = 59; // [18:1:160]
// Width of the rectangular middle web in the XY plane.
connector_web_width_mm = 3.6; // [2:0.2:12]
// Added diameter of each circular lobe compared to the web width.
// Example: 3.6 mm web + 1.6 mm addition = 5.2 mm diameter ends.
connector_diameter_addition_mm = 1.6; // [0.4:0.2:10]
// Each half is a straight-sided pocket: only clearance is added; NO
// locking taper, mouth flare, entry bevel, or internal socket chamfer.
connector_clearance_mm = 0.2; // [0:0.05:0.6]
// Connector count is automatically inferred from adjoining-edge length.
// All actual shared edges get matching blind underside sockets.
connectors_enabled = true;

/* [05 - Interior divider access cutouts] */
// Check a row to put a matching access notch in EVERY INNER left/right
// divider spanning that row. A one-column row has no inner dividers.
// Row 1 is REAR; final row is FRONT (top-down, drawer open to viewer).
cutout_row_01 = false;
cutout_row_02 = false;
cutout_row_03 = false;
cutout_row_04 = false;
cutout_row_05 = false;
cutout_row_06 = false;
cutout_row_07 = false;
cutout_row_08 = false;
cutout_row_09 = false;
cutout_row_10 = false;
// Width at the LOWEST point of the rounded, angled notch.
// The two shoulders expand upwards with the selected printing angle.
cutout_base_width_mm = 25; // [8:1:65]

/* [06 - Manual standalone tray (optional)] */
// Set grid_columns=1, grid_rows=1, row_01_splits=1 to use these controls.
manual_joiner_override = false;
manual_join_left = false;
manual_join_right = false;
manual_join_front = false;
manual_join_rear = false;

/* [07 - Part selection and preview] */
// Only the selected tray is intended for STL export.
output_mode = 0; // [0:Full layout preview,1:Selected tray,2:Loose dogbone connectors]
// Selected row 1=REAR; a continued row selects its whole multi-row tray.
selected_row = 1; // [1:Selected row 1,2:Selected row 2,3:Selected row 3,4:Selected row 4,5:Selected row 5,6:Selected row 6,7:Selected row 7,8:Selected row 8,9:Selected row 9,10:Selected row 10]
// Selected column 1=LEFT.
selected_column = 1; // [1:Selected column 1,2:Selected column 2,3:Selected column 3,4:Selected column 4,5:Selected column 5,6:Selected column 6,7:Selected column 7,8:Selected column 8,9:Selected column 9,10:Selected column 10]
// Quantity to arrange when output = loose bottom-up dogbone connectors.
loose_connector_quantity = 8; // [1:1:60]
// Increase the gap only for inspection. Zero for dimensional preview.
preview_separation_mm = 0; // [0:1:50]
// Circular arcs and rounded dogbone precision.
render_facets = 20; // [3:1:200]

/* [Hidden] */
$fn=render_facets;
E=0.015;
row_values=[row_01_splits,row_02_splits,row_03_splits,row_04_splits,row_05_splits,
            row_06_splits,row_07_splits,row_08_splits,row_09_splits,row_10_splits];
cutout_values=[cutout_row_01,cutout_row_02,cutout_row_03,cutout_row_04,cutout_row_05,
               cutout_row_06,cutout_row_07,cutout_row_08,cutout_row_09,cutout_row_10];

// Width at the floor is a measured, theoretical sharp-corner position.
// Both sides expand symmetrically as the metal walls rise to the rim.
W0=drawer_floor_width_mm-drawer_total_clearance_mm;
WT=drawer_top_width_mm-drawer_total_clearance_mm;
DY=drawer_inside_length_mm-drawer_total_clearance_mm;
H=drawer_rim_height_mm;
B=base_thickness_mm;
T=wall_thickness_mm;
SIDE_EXPAND=(WT-W0)/2;
ALPHA=print_overhang_angle_deg;
// For a ramp of horizontal travel X and angle A, vertical rise = X*tan(A).
// Auto fit limits travel to half of the drawer's actual measured widening.
CHAMFER_X=min(max(0,SIDE_EXPAND-0.4),outer_bottom_chamfer_max_rise_mm/tan(ALPHA));
CHAMFER_Z=CHAMFER_X*tan(ALPHA);
JOIN_Z=join_edge_elephant_foot_mm;
JOIN_X=JOIN_Z/tan(ALPHA);
LIP_Z=rim_projection_mm*tan(ALPHA);
ZTOP=max(H+tray_height_above_rim_mm,H+((rim_left||rim_right||rim_front||rim_rear)?LIP_Z:0));
ROW_DEPTH=DY/grid_rows;
WEB_R=connector_web_width_mm/2;
HEAD_R=(connector_web_width_mm+connector_diameter_addition_mm)/2;
// Derive lobe depth from web width, head radius and minimum socket side wall.
HEAD_IN=HEAD_R+max(B,T)+1;
// Connector height is derived, not a user choice: shallow enough to leave
// minimum material above the blind pocket without erasing bottom rounding.
CONNECTOR_HEIGHT=max(2.5,min(5,B+2));
// Pocket opens ONLY at Z=0 and stops at CONNECTOR_HEIGHT.
// A closed ROOF at least B thick remains above it. The lower 2D contour
// is a clean circle-rectangle-circle shape with no retention undercuts.
SOCKET_R=HEAD_R+connector_clearance_mm;
SOCKET_STOCK=max(B,T);
PAD_HEIGHT=CONNECTOR_HEIGHT+SOCKET_STOCK+0.4;
// Use B for MINIMUM stock and a visibly rounded interior junction.
// Filleting a concave cavity corner REMOVES void, not solid, so it cannot
// violate the base thickness below the fillet or the normal wall offset.
INNER_BOTTOM_R=max(B,CHAMFER_X*0.65);

function splits_at(row) = row_values[row-1];
function notch_at(row) = cutout_values[row-1];
function group_start(row) = max([for (k=[1:row]) if(splits_at(k)>0) k]);
function group_end(start) = min(concat([for(k=[1:grid_rows]) if(k>start && splits_at(k)>0) k],[grid_rows+1]))-1;
function group_depth(start)=(group_end(start)-start+1)*ROW_DEPTH;
function group_y(start)=(grid_rows-group_end(start))*ROW_DEPTH;
function group_count(row)=splits_at(group_start(row));
function is_standalone()=grid_rows==1&&grid_columns==1&&row_01_splits==1;
// Fixed target pitch. If a segment has >=2 pitches, use two joiners at half
// pitch from each end, leaving the excess length as symmetric end margins.
// With only one joiner, it is centered. No extra count controls are necessary.
function clip_count(L)=L>=2*(HEAD_IN+HEAD_R+SOCKET_STOCK)+1 ? max(1,floor(L/connector_spacing_mm)) : 0;
function clip_stations(L)=
    let(n=clip_count(L),margin=(L-(n-1)*connector_spacing_mm)/2)
    n==0 ? [] : [for (i=[0:n-1]) margin+i*connector_spacing_mm];
// All connectors across a band transition share these exact GLOBAL x positions,
// even if adjacent row-groups have different column counts.
function cross_seam_stations(n,c,other_n)=
    [for (j=[1:other_n])
      let(lo=max((c-1)*W0/n,(j-1)*W0/other_n),
          hi=min(c*W0/n,j*W0/other_n),
          L=hi-lo)
      if (L>2*(HEAD_IN+SOCKET_R+T)+1)
        for(p=clip_stations(L)) lo+p-(c-1)*W0/n];
// Clamp is only for preview generation; invalid explicit selections are empty.
function is_join(side,outer) = (is_standalone() && manual_joiner_override)
    ? (side=="left"?manual_join_left:side=="right"?manual_join_right:side=="front"?manual_join_front:manual_join_rear)
    : connectors_enabled && !outer;

assert(grid_columns>=1&&grid_columns<=10&&grid_rows>=1&&grid_rows<=10,"Grid range must be 1..10.");
assert(row_01_splits>=1,"Row 1 must start a tray group.");
assert(min([for(r=[1:grid_rows]) splits_at(r)])>=0&&max([for(r=[1:grid_rows]) splits_at(r)])<=grid_columns,"A row split exceeds grid_columns.");
assert(drawer_top_width_mm>drawer_floor_width_mm,"Top opening must exceed flat floor width.");
assert(W0>10&&DY>20&&H>15&&B>0&&T>0&&H>B+5,"Drawer dimensions or thicknesses are invalid.");
assert(ALPHA>=20&&ALPHA<85,"Printing angle must be between 20 and 85 degrees.");
assert(connector_spacing_mm>=2*(HEAD_R+T+2)&&connector_spacing_mm>0,"Connector spacing is too short for dogbone heads.");
assert(connector_diameter_addition_mm>0 && connector_web_width_mm>=2,
       "Dogbone lobe diameter must exceed web width.");
assert(PAD_HEIGHT<H-5,"Underside socket pad is taller than the available wall height.");
assert(PAD_HEIGHT-CONNECTOR_HEIGHT>=B,
       "Blind underside socket must retain at least the base thickness overhead.");
assert(JOIN_Z<=B,"Elephant foot relief must be no deeper than the base thickness.");
// Notch width is clipped to each row's room; no hard failure on a short row.

// ----------- 2D section profiles; generated from the measured drawer -----------
// Each profile is a closed XY polygon where (x,z) or (y,z) become its axes.
function left_profile(outside, rim, top_extra=0)=
    outside ? concat([[0,0],[-CHAMFER_X,CHAMFER_Z],[-SIDE_EXPAND,H]],
              rim && rim_projection_mm>0 ? [[-SIDE_EXPAND-rim_projection_mm,H+LIP_Z]] : [],
              [[-SIDE_EXPAND-(rim?rim_projection_mm:0),ZTOP+top_extra]])
            : [[JOIN_X,0],[0,JOIN_Z],[0,ZTOP+top_extra]];
function right_profile(w,outside,rim,top_extra=0)=
    [for(p=left_profile(outside,rim,top_extra)) [w-p[0],p[1]]];
// Front and rear are vertical at the metal rim (side-wall widening is X only).
// Front/back drawer ends are VERTICAL: the X-axis widening applies to
// METAL SIDES ONLY. There must be no bottom-to-rim inward lean at rear/front.
// An exterior end can optionally have an upper rim flare but no large side
// chamfer. The small internal joiner-edge chamfer remains at internal seams.
function end_profile(outside,rim,top_extra=0)=
    outside ? concat([[0,0],[0,H]],
             rim&&rim_projection_mm>0?[[-rim_projection_mm,H+LIP_Z]]:[],
             [[-(rim?rim_projection_mm:0),ZTOP+top_extra]])
            : [[JOIN_X,0],[0,JOIN_Z],[0,ZTOP+top_extra]];
function profile_polygon(a,b)=concat(a,[for(i=[len(b)-1:-1:0]) b[i]]);

// Local coordinate systems. XZ section extrudes in Y; YZ section extrudes in X.
module xz_extrude_2d(span) {
    translate([0,span+50,0]) rotate([90,0,0]) linear_extrude(height=span+100,convexity=8) children();
}
module yz_extrude_2d(span) {
    translate([-50,0,0]) rotate([0,0,90]) rotate([90,0,0])
        linear_extrude(height=span+100,convexity=8) children();
}

// 2D material envelopes. At joining edges, the mini-chamfer starts at the
// floor and runs continuously under the entire socket pad footprint.
module xz_outer_2d(w,left_outer,right_outer,extra=0) {
    polygon(profile_polygon(left_profile(left_outer,rim_left&&left_outer,extra),
                            right_profile(w,right_outer,rim_right&&right_outer,extra)));
}
module yz_outer_2d(d,front_outer,rear_outer,extra=0) {
    // Y=0 is FRONT side of this tray; rear is at Y=d.
    a=end_profile(front_outer,rim_front&&front_outer,extra);
    b=[for(p=end_profile(rear_outer,rim_rear&&rear_outer,extra)) [d-p[0],p[1]]];
    polygon(profile_polygon(a,b));
}

// Build the inner cavity by ERODING the outside cross-section by base B.
// This is a Euclidean (normal-distance) offset, not a horizontal guess:
//   - the minimum outside-to-inside stock in either profile is >= B;
//   - bottom transitions get an R=B blend by a local morphological opening;
//   - the upper section is NOT rounded (sharp upper horizontal edges).
// Artificial upper extension opens the tray without curving or capping the rim.
module safe_inner_2d(bottom_cutoff) {
    union() {
        intersection() {
            offset(r=INNER_BOTTOM_R) offset(delta=-INNER_BOTTOM_R) children();
            translate([-2000,-2000]) square([4000,2000+bottom_cutoff]);
        }
        intersection() {
            children();
            translate([-2000,bottom_cutoff-E]) square([4000,3000]);
        }
    }
}
module xz_void_2d(w,left_outer,right_outer) {
    // min ~halfway between lower chamfer and upper rim, safely beyond R.
    cut=min(H-2*B,max(CHAMFER_Z+3*B,5*B));
    module eroded() { offset(delta=-B) xz_outer_2d(w,left_outer,right_outer,100); }
    safe_inner_2d(cut) eroded();
}
module yz_void_2d(d,front_outer,rear_outer) {
    cut=min(H-2*B,max(CHAMFER_Z+3*B,5*B));
    module eroded() { offset(delta=-B) yz_outer_2d(d,front_outer,rear_outer,100); }
    safe_inner_2d(cut) eroded();
}
module tray_shell(w,d,left_outer,right_outer,front_outer,rear_outer) {
    difference() {
        intersection() {
            xz_extrude_2d(d) xz_outer_2d(w,left_outer,right_outer);
            yz_extrude_2d(w) yz_outer_2d(d,front_outer,rear_outer);
        }
        intersection() {
            xz_extrude_2d(d) xz_void_2d(w,left_outer,right_outer);
            yz_extrude_2d(w) yz_void_2d(d,front_outer,rear_outer);
        }
    }
}

// ----------- Bottom-up dogbone: TWO CIRCLES + RECTANGLE -----------
// Both joiner and pocket share one constant XY outline, with a SMALL
// radial clearance on the FEMALE side. The socket has a sealed roof.
module half_dogbone_2d(clearance=0) {
    union() {
        translate([0,HEAD_IN]) circle(r=HEAD_R+clearance);
        translate([-WEB_R-clearance,-E])
            square([2*(WEB_R+clearance),HEAD_IN+E]);
    }
}
module full_dogbone_2d(clearance=0) {
    union() {
        translate([0,-HEAD_IN]) circle(r=HEAD_R+clearance);
        translate([0, HEAD_IN]) circle(r=HEAD_R+clearance);
        translate([-WEB_R-clearance,-HEAD_IN])
            square([2*(WEB_R+clearance),2*HEAD_IN]);
    }
}
// Pad protrudes into the tray, providing socket-side stock even at the
// lower INNER fillet. Pad starts exactly on seam; does not extend outside.
module socket_pad_footprint_2d() {
    intersection() {
        offset(delta=SOCKET_STOCK) half_dogbone_2d(connector_clearance_mm);
        translate([-50,0]) square([100,HEAD_IN+HEAD_R+SOCKET_STOCK+5]);
    }
}
module socket_opening_3d() {
    translate([0,0,-E])
        linear_extrude(height=CONNECTOR_HEIGHT+E)
            half_dogbone_2d(connector_clearance_mm);
}
module socket_pad_3d() {
    linear_extrude(height=PAD_HEIGHT) socket_pad_footprint_2d();
}
module edge_station(side,at) {
    if(side=="front") translate([at,0,0]) children();
    if(side=="rear") translate([at,0,0]) rotate([0,0,180]) children();
    if(side=="left") translate([0,at,0]) rotate([0,0,-90]) children();
    if(side=="right") translate([0,at,0]) rotate([0,0,90]) children();
}
module sockets_or_pads(w,d,front_c,rear_c,left_c,right_c,
                        front_stations,rear_stations,side_stations,make_pads=true) {
    for(p=front_stations) if(front_c) edge_station("front",p)
        if(make_pads) socket_pad_3d(); else socket_opening_3d();
    for(p=rear_stations) if(rear_c) translate([0,d,0]) edge_station("rear",p)
        if(make_pads) socket_pad_3d(); else socket_opening_3d();
    for(p=side_stations) if(left_c) edge_station("left",p)
        if(make_pads) socket_pad_3d(); else socket_opening_3d();
    for(p=side_stations) if(right_c) translate([w,0,0]) edge_station("right",p)
        if(make_pads) socket_pad_3d(); else socket_opening_3d();
}
module loose_dogbone() {
    linear_extrude(height=CONNECTOR_HEIGHT) full_dogbone_2d();
}

// ----------- Joining-edge elephant-foot relief -----------
// Cut the exposed joining edge after the socket pads are joined to the shell.
// A small keep-out at each socket mouth prevents the outside relief from
// becoming a chamfer INSIDE a female dogbone socket. The socket profile itself
// remains straight through its complete Z depth, with no entry bevel.
module join_foot_relief(w,d,left_join,right_join,front_join,rear_join,
                        front_stations,rear_stations,side_stations) {
    if(JOIN_Z>0) difference() {
      union() {
        if(left_join)
            xz_extrude_2d(d)
                polygon([[-20,-E],[JOIN_X+E,-E],[JOIN_X,0],[0,JOIN_Z],[-20,JOIN_Z+20]]);
        if(right_join)
            xz_extrude_2d(d)
                polygon([[w+20,-E],[w-JOIN_X-E,-E],[w-JOIN_X,0],[w,JOIN_Z],[w+20,JOIN_Z+20]]);
        if(front_join)
            yz_extrude_2d(w)
                polygon([[-20,-E],[JOIN_X+E,-E],[JOIN_X,0],[0,JOIN_Z],[-20,JOIN_Z+20]]);
        if(rear_join)
            yz_extrude_2d(w)
                polygon([[d+20,-E],[d-JOIN_X-E,-E],[d-JOIN_X,0],[d,JOIN_Z],[d+20,JOIN_Z+20]]);
      }
      // Keep the full-width vertical web opening of each underside socket.
      // The protected region is only about one web width across each joint.
      if(connectors_enabled) {
        keep=WEB_R+connector_clearance_mm+0.6;
        if(front_join) for(p=front_stations)
            translate([p-keep,-JOIN_X-2,-E]) cube([2*keep,2*JOIN_X+4,JOIN_Z+2*E]);
        if(rear_join) for(p=rear_stations)
            translate([p-keep,d-JOIN_X-2,-E]) cube([2*keep,2*JOIN_X+4,JOIN_Z+2*E]);
        if(left_join) for(p=side_stations)
            translate([-JOIN_X-2,p-keep,-E]) cube([2*JOIN_X+4,2*keep,JOIN_Z+2*E]);
        if(right_join) for(p=side_stations)
            translate([w-JOIN_X-2,p-keep,-E]) cube([2*JOIN_X+4,2*keep,JOIN_Z+2*E]);
      }
    }
}

// Rounded shoulders and controlled print slope. Notch reaches down to
// a safe height ABOVE the socket-pad ROOF, so connectors keep their stock.
// Ends broaden outwards at print_overhang_angle_deg, then remain vertical.
module access_notch_profile_2d(width,top_height) {
    zbase=PAD_HEIGHT+B+1;
    ramp_h=min(20,max(4,(ROW_DEPTH-width-4)*tan(ALPHA)/2));
    spread=ramp_h/tan(ALPHA);
    rr=min(4,width/6);
    // A radius opening on a polygon produces rounded internal notch corners.
    // The profile stays bounded and remains open all the way through the top.
    offset(r=rr) offset(delta=-rr)
        polygon([[-width/2,zbase], [width/2,zbase],
                 [width/2+spread,zbase+ramp_h],
                 [width/2+spread,top_height+4],
                 [-width/2-spread,top_height+4],
                 [-width/2-spread,zbase+ramp_h]]);
}
// Project the 2D (y,z) notch completely through the joining-wall thickness.
// Restrict the notch to the actual shared divider thickness. Do NOT use
// yz_extrude_2d() here: that helper deliberately extends 50 mm beyond both
// ends for large envelope booleans and would cut through neighboring trays.
module access_notch_3d(xcenter,ycenter) {
    span=T+2;
    translate([xcenter-span/2,ycenter,0])
        rotate([0,0,90]) rotate([90,0,0])
            linear_extrude(height=span,convexity=8)
                access_notch_profile_2d(cutout_base_width_mm,ZTOP);
}
module joining_wall_cutouts(w,d,start,last,col,cols) {
    if(cols>1) for(r=[start:last]) if(notch_at(r)) {
        yc=(last-r+0.5)*ROW_DEPTH;
        // Only inner dividers: a matching cut on each side of the seam.
        if(col<cols) access_notch_3d(w-T/2,yc);
        if(col>1) access_notch_3d(T/2,yc);
    }
}

module one_tray(start,col,report=true) {
    last=group_end(start);
    n=splits_at(start);
    w=W0/n;
    d=group_depth(start);
    left_outer=col==1;
    right_outer=col==n;
    rear_outer=start==1;
    front_outer=last==grid_rows;
    left_join=is_join("left",left_outer);
    right_join=is_join("right",right_outer);
    front_join=is_join("front",front_outer);
    rear_join=is_join("rear",rear_outer);
    side_stations=clip_stations(d);
    front_stations=front_outer ? clip_stations(w) : cross_seam_stations(n,col,group_count(last+1));
    rear_stations=rear_outer ? clip_stations(w) : cross_seam_stations(n,col,group_count(start-1));
    if(report) {
        echo(str("TRAY rows ",start,"-",last," column ",col," / ",n));
        echo("BOTTOM SIZE (mm)",w,d,"CONNECTORS (front rear left right)",front_join,rear_join,left_join,right_join);
        echo("CONNECTOR STATIONS (front/rear/side)",front_stations,rear_stations,side_stations);
    }
    difference() {
        union() {
            tray_shell(w,d,left_outer,right_outer,front_outer,rear_outer);
            sockets_or_pads(w,d,front_join,rear_join,left_join,right_join,
                            front_stations,rear_stations,side_stations,true);
        }
        sockets_or_pads(w,d,front_join,rear_join,left_join,right_join,
                        front_stations,rear_stations,side_stations,false);
        join_foot_relief(w,d,left_join,right_join,front_join,rear_join,
                         front_stations,rear_stations,side_stations);
        joining_wall_cutouts(w,d,start,last,col,n);
    }
}

// Count tray GROUP boundaries in front of (closer to the viewer than) this group.
// Separation is applied once PER TRAY JOIN, not once per logical row.
function groups_ahead(start) = len([for(k=[1:grid_rows]) if(k>start && splits_at(k)>0) k]);
module all_trays() {
    for(r=[1:grid_rows]) if(splits_at(r)>0)
        for(c=[1:splits_at(r)]) {
            // One equal gap between each pair of physically adjacent parts.
            // Rows with a split of 0 are continuations, not new group gaps.
            w=W0/splits_at(r);
            d=group_depth(r);
            x=(c-1)*w+(c-(splits_at(r)+1)/2)*preview_separation_mm;
            y=group_y(r)+groups_ahead(r)*preview_separation_mm;
            echo("PREVIEW ORIGIN (row, column, x, y, w, depth)",r,c,x,y,w,d);
            translate([x,y,0])
                color([0.78+0.03*((r+c)%3),0.84,0.91-0.04*(c%3)])
                    one_tray(r,c,false);
        }
}

// ----------- Output and non-fatal invalid selection handling -----------
echo("DRAWER v8 | profile",W0,WT,DY,"metal rim",H,"printed height",ZTOP);
echo("ANGLE / OUTER CHAMFER run, rise / lip projection, rise",ALPHA,CHAMFER_X,CHAMFER_Z,rim_projection_mm,LIP_Z);
echo("BASE MIN THICKNESS / BOTTOM INNER R / WALL REINFORCEMENT",B,INNER_BOTTOM_R,T);
echo("DOGBONE straight height / lobe diameter / pocket roof minimum",CONNECTOR_HEIGHT,
     2*HEAD_R,PAD_HEIGHT-CONNECTOR_HEIGHT);
echo("GRID rear->front",[for(r=[1:grid_rows]) splits_at(r)]);

if(output_mode==0) {
    all_trays();
} else if(output_mode==1) {
    if(selected_row<1||selected_row>grid_rows)
        echo(str("SELECTION INVALID: Row ",selected_row," does not exist (1..",grid_rows,"). Nothing drawn."));
    else let(start=group_start(selected_row))
        if(selected_column<1||selected_column>splits_at(start))
            echo(str("SELECTION INVALID: Column ",selected_column," does not exist in row ",selected_row,
                     " (1..",splits_at(start),"). Nothing drawn."));
        else one_tray(start,selected_column);
} else if(output_mode==2) {
    stride=2*(HEAD_IN+HEAD_R)+4;
    for(i=[0:loose_connector_quantity-1])
        translate([((i%10)+0.5)*stride,-(floor(i/10)+1.5)*stride,0])
            loose_dogbone();
} else echo("OUTPUT INVALID: choose Full layout, Selected tray or Loose dogbones.");
