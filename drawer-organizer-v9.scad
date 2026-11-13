// DRAWER ORGANIZER v9
// Independent parametric model for a measured, metal-sided kitchen drawer.
// OpenSCAD 2021.01; no libraries or external geometry required.
//
// TOP VIEW: stand at the FRONT of the open drawer and look DOWN.
// Row 1 is at the rear; row numbers increase toward the front.
// Column 1 is on the left; column numbers increase rightward.
// Dimensions are millimetres; angles are measured from the print bed.

/* [01 - Drawer dimensions] */
// Inner width across the TOP of the metal drawer.
Drawer_top_width_mm = 218; // [60:1:1000]
Drawer_floor_width_mm = 190; // [50:1:1000]
// Approximate floor-to-side corner radius of the metal drawer.
Drawer_floor_corner_radius_mm = 10; // [0:0.5:35]
Drawer_inside_length_mm = 475; // [60:1:1200]
Drawer_rim_height_mm = 65; // [20:1:200]
// Total lateral and front/rear clearance, shared between opposite sides.
Drawer_total_clearance_mm = 1; // [0:0.1:6]

/* [02 - Drawer logical grid] */
// Maximum compartments allowed in any row; increase when a row needs more.
Grid_columns = 3; // [1:1:10]
// Rear to front.
Grid_rows = 6; // [1:1:10]
Row_01 = 1; // [1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
Row_02 = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
Row_03 = 3; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
Row_04 = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
Row_05 = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
Row_06 = 1; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
Row_07 = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
Row_08 = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
Row_09 = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]
Row_10 = 0; // [0:Continue previous,1:1 compartment,2:2 compartments,3:3 compartments,4:4 compartments,5:5 compartments,6:6 compartments,7:7 compartments,8:8 compartments,9:9 compartments,10:10 compartments]

/* [03 - Tray geometry and printing] */
// Angle from horizontal, shared by all ramps, beveled entry and bottom chamfers.
Print_overhang_angle_deg = 60; // [25:1:75]
// Determines outward flare automatically with the overhang angle.
Tray_height_above_rim_mm = 10; // [0:0.5:50]
// Choose which outer edges flare beyond the drawer rim.
Rim_left = true;
Rim_right = true;
Rim_front = false;
Rim_rear = false;
// Maximum rise of the lower EXTERIOR chamfer in AUTO fit mode.
// Its actual rise may be reduced to maintain the requested print angle.
Outer_bottom_chamfer_max_rise_mm = 10; // [0:0.5:30]
// Bottom elephant-foot relief along joining edges, excluding connector mouths.
Join_edge_elephant_foot_mm = 1; // [0:0.1:4]

// Shared tray geometry (same drawer-level section).
// Floor thickness is also the MINIMUM distance to every outer wall surface.
Base_thickness_mm = 2.0; // [0.8:0.1:5]
// Additional reinforcements around the dogbone sockets use this thickness.
Wall_thickness_mm = 2.0; // [0.8:0.1:5]
// Same bottom INSIDE rounding on all four sides. Automatically sized to
// preserve the minimum base thickness at the exterior bottom chamfer.
// Exposed edges are capped below half the material thickness.
Soft_edge_radius_mm = 0.6; // [0:0.1:1.5]

/* [04 - Connector specifications] */
Connector_spacing_mm = 59; // [18:1:160]
Connector_center_thickness_mm = 4; // [2:0.5:12]
// Radial protrusion on EACH side of a circular lobe, beyond center thickness.
// Example: 4 mm center + 1 mm per side = 6 mm lobe diameter.
Connector_diameter_protrusion_mm = 1; // [0.25:0.25:5]
// Lobe ends automatically shorten near the bottom fillet.
Connector_height_mm = 6; // [1:0.2:8]
// TOTAL side clearance across two opposing faces: 0.2 mm means 0.1 mm
// radial allowance on EACH side of the female pocket, not 0.2 per side.
Connector_side_clearance_total_mm = 0.2; // [0:0.05:1]
// Vertical air gap ABOVE the male connector (under its blind socket roof).
// Kept independently from side clearance for printer overhang quality.
Connector_top_clearance_mm = 1; // [0:0.1:3]
// No locking taper, mouth flare, entry bevel, or internal socket chamfer.
// Connector count is automatically inferred from adjoining-edge length.
// All actual shared edges get matching blind underside sockets.
Connectors_enabled = true;

/* [05 - Interior divider cutouts] */
// One checkbox per row; every interior divider in that row is cut.
Cutout_row_01 = false;
Cutout_row_02 = false;
Cutout_row_03 = false;
Cutout_row_04 = true;
Cutout_row_05 = false;
Cutout_row_06 = false;
Cutout_row_07 = false;
Cutout_row_08 = false;
Cutout_row_09 = false;
Cutout_row_10 = false;
// Unrounded base gap, where the straight risers meet the notch floor.
Cutout_base_width_mm = 25;
Cutout_round_diameter_mm = 20; // [0:1:40]
// Riser angle from horizontal; the input has no minimum.
Cutout_riser_angle_deg = 75;

/* [06 - Standalone tray (optional)] */
// Only applies when the grid is one row by one column.
Manual_joiner_override = false;
Manual_join_left = false;
Manual_join_right = false;
Manual_join_front = false;
Manual_join_rear = false;

/* [07 - Part selection and preview] */
// Full layout is for inspection; select one tray when exporting an STL.
Output_mode = 0; // [0:Full layout preview,1:Selected tray,2:Loose dogbone connectors]
// Selected row 1=REAR; a continued row selects its whole multi-row tray.
Selected_row = 1; // [1:Selected row 1,2:Selected row 2,3:Selected row 3,4:Selected row 4,5:Selected row 5,6:Selected row 6,7:Selected row 7,8:Selected row 8,9:Selected row 9,10:Selected row 10]
Selected_column = 1; // [1:Selected column 1,2:Selected column 2,3:Selected column 3,4:Selected column 4,5:Selected column 5,6:Selected column 6,7:Selected column 7,8:Selected column 8,9:Selected column 9,10:Selected column 10]
Loose_connector_quantity = 8; // [1:1:60]
// Visual spacing between parts; does not affect an individual tray.
Preview_separation_mm = 0; // [0:1:50]
Render_facets = 20; // [3:1:200]

/* [Hidden] */
$fn=Render_facets;
E=0.015;
row_values=[Row_01,Row_02,Row_03,Row_04,Row_05,
            Row_06,Row_07,Row_08,Row_09,Row_10];
cutout_values=[Cutout_row_01,Cutout_row_02,Cutout_row_03,Cutout_row_04,Cutout_row_05,
               Cutout_row_06,Cutout_row_07,Cutout_row_08,Cutout_row_09,Cutout_row_10];

// Width at the floor is a measured, theoretical sharp-corner position.
// Both sides expand symmetrically as the metal walls rise to the rim.
W0=Drawer_floor_width_mm-Drawer_total_clearance_mm;
WT=Drawer_top_width_mm-Drawer_total_clearance_mm;
DY=Drawer_inside_length_mm-Drawer_total_clearance_mm;
H=Drawer_rim_height_mm;
B=Base_thickness_mm;
T=Wall_thickness_mm;
SIDE_EXPAND=(WT-W0)/2;
ALPHA=Print_overhang_angle_deg;
// For a ramp of horizontal travel X and angle A, vertical rise = X*tan(A).
// Auto fit limits travel to half of the drawer's actual measured widening.
CHAMFER_X=min(max(0,SIDE_EXPAND-0.4),Outer_bottom_chamfer_max_rise_mm/tan(ALPHA));
CHAMFER_Z=CHAMFER_X*tan(ALPHA);
JOIN_Z=Join_edge_elephant_foot_mm;
JOIN_X=JOIN_Z/tan(ALPHA);
// The print angle and specified tray height are the ONLY independent rim
// dimensions. Its horizontal run is mathematically derived, never another
// Customizer input: run = rise / tan(angle from the print bed).
// With rim faces disabled, the above-rim section remains vertical.
LIP_Z=Tray_height_above_rim_mm;
HAS_RIM=LIP_Z>0 && (Rim_left||Rim_right||Rim_front||Rim_rear);
RIM_PROJECTION=HAS_RIM ? LIP_Z/tan(ALPHA) : 0;
ZTOP=H+LIP_Z;
ROW_DEPTH=DY/Grid_rows;
// Nominal logical-grid pitch, before exterior drafts, fillets and wall stock.
GRID_UNIT_WIDTH=W0/Grid_columns;
WEB_R=Connector_center_thickness_mm/2;
HEAD_R=Connector_center_thickness_mm/2+Connector_diameter_protrusion_mm;
// In the XY silhouette each circular lobe meets the rectangular center
// at the circle/rectangle chord (x=+/-WEB_R). Keep exactly one wall
// thickness of exposed STRAIGHT center bar on EACH side of the tray seam:
//   2*(HEAD_IN - sqrt(HEAD_R^2-WEB_R^2)) = 2*T.
// This shortens the connector independently of the lobe diameter.
LOBE_CHORD=sqrt(max(0,HEAD_R*HEAD_R-WEB_R*WEB_R));
HEAD_IN=T+LOBE_CHORD;
CONNECTOR_STRAIGHT_LENGTH=2*(HEAD_IN-LOBE_CHORD);
// Connector height is derived, not a user choice: shallow enough to leave
// minimum material above the blind pocket without erasing bottom rounding.
CONNECTOR_HEIGHT=Connector_height_mm;
// Pocket opens ONLY at Z=0 and stops at CONNECTOR_HEIGHT.
// A closed ROOF at least B thick remains above it. The lower 2D contour
// is a clean circle-rectangle-circle shape with no retention undercuts.
SOCKET_SIDE_CLEARANCE=Connector_side_clearance_total_mm/2;
SOCKET_TOP_CLEARANCE=Connector_top_clearance_mm;
SOCKET_R=HEAD_R+SOCKET_SIDE_CLEARANCE;
SOCKET_STOCK=max(B,T);
PAD_HEIGHT=CONNECTOR_HEIGHT+SOCKET_TOP_CLEARANCE+SOCKET_STOCK+0.4; // design envelope; NO inside pads
// Use B for MINIMUM stock and a visibly rounded interior junction.
// Filleting a concave cavity corner REMOVES void, not solid, so it cannot
// violate the base thickness below the fillet or the normal wall offset.
// Uniform bottom fillet for all interior walls. A larger outside chamfer
// demands more rounding at the cavity/vertical-wall transition. Eroding the
// outside by B and subtracting the softened cavity preserves >=B stock.
// Ensure even the far end of each dogbone lobe retains printable height
// WITHOUT raising localized socket pads into the usable tray cavity.
// With k=reach beyond wall and h=height needed at lobe tip, a fillet
// radius R >= k+h+sqrt(2*k*h) provides that much stock above the floor.
LOBE_REACH=max(0,HEAD_IN+HEAD_R+SOCKET_SIDE_CLEARANCE-T);
// Leave one whole millimetre of vertical socket clearance ALSO at the
// furthest ends of the lobes; derive a uniformly larger inner bottom fillet
// to preserve B mm of material above the blind pocket everywhere.
LOBE_TIP_STOCK=min(CONNECTOR_HEIGHT,0.8)+SOCKET_TOP_CLEARANCE+0.25;
CONNECTOR_FILLET_R=LOBE_REACH+LOBE_TIP_STOCK+sqrt(2*LOBE_REACH*LOBE_TIP_STOCK);
INNER_BOTTOM_R=max(B,CHAMFER_X*0.65,CONNECTOR_FILLET_R);
SOFT_R=min(max(0,Soft_edge_radius_mm),max(0,min(B,T)/2-0.1));

function splits_at(row) = row_values[row-1];
function notch_at(row) = cutout_values[row-1];
function group_start(row) = max([for (k=[1:row]) if(splits_at(k)>0) k]);
function group_end(start) = min(concat([for(k=[1:Grid_rows]) if(k>start && splits_at(k)>0) k],[Grid_rows+1]))-1;
function group_depth(start)=(group_end(start)-start+1)*ROW_DEPTH;
function group_y(start)=(Grid_rows-group_end(start))*ROW_DEPTH;
function group_count(row)=splits_at(group_start(row));
function is_standalone()=Grid_rows==1&&Grid_columns==1&&Row_01==1;
// Fixed target pitch. If a segment has >=2 pitches, use two joiners at half
// pitch from each end, leaving the excess length as symmetric end margins.
// With only one joiner, it is centered. No extra count controls are necessary.
function clip_count(L)=L>=2*(HEAD_IN+HEAD_R+SOCKET_STOCK)+1 ? max(1,floor(L/Connector_spacing_mm)) : 0;
function clip_stations(L)=
    let(n=clip_count(L),margin=(L-(n-1)*Connector_spacing_mm)/2)
    n==0 ? [] : [for (i=[0:n-1]) margin+i*Connector_spacing_mm];
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
function is_join(side,outer) = (is_standalone() && Manual_joiner_override)
    ? (side=="left"?Manual_join_left:side=="right"?Manual_join_right:side=="front"?Manual_join_front:Manual_join_rear)
    : Connectors_enabled && !outer;

assert(Grid_rows>=1&&Grid_rows<=10&&Grid_columns>=1&&Grid_columns<=10,"Grid rows and columns must be 1..10.");
assert(Row_01>=1,"Row 1 must start a tray group.");
assert(min([for(r=[1:Grid_rows]) splits_at(r)])>=0&&max([for(r=[1:Grid_rows]) splits_at(r)])<=10,"Each row must have 0..10 compartments.");
// A row may request more than the configured grid width, but that is a
// user-fixable configuration mismatch, not a fatal assertion.
GRID_OVERFLOW_ROWS=[for(r=[1:Grid_rows]) if(splits_at(r)>Grid_columns) r];
assert(Drawer_top_width_mm>Drawer_floor_width_mm,"Top opening must exceed flat floor width.");
assert(W0>10&&DY>20&&H>15&&B>0&&T>0&&H>B+5,"Drawer dimensions or thicknesses are invalid.");
assert(ALPHA>=20&&ALPHA<85,"Printing angle must be between 20 and 85 degrees.");
assert(Connector_spacing_mm>=2*(HEAD_R+T+2)&&Connector_spacing_mm>0,"Connector spacing is too short for dogbone heads.");
assert(Connector_side_clearance_total_mm>=0 && Connector_top_clearance_mm>=0,
       "Connector clearances must not be negative.");
assert(Connector_diameter_protrusion_mm>0 && Connector_center_thickness_mm>=2,
       "Dogbone lobe diameter protrusion must be positive.");
assert(CONNECTOR_HEIGHT>=1 && CONNECTOR_HEIGHT < H-2*B,
       "Connector height must fit underneath the tray walls.");
assert(JOIN_Z<=B,"Elephant foot relief must be no deeper than the base thickness.");
// Cutouts are clipped by the divider geometry; no restriction on entered gap.

// ----------- 2D section profiles; generated from the measured drawer -----------
// Each profile is a closed XY polygon where (x,z) or (y,z) become its axes.
// Extended top profiles remain collinear through the rim ramp so eroding
// these sections also produces a CONTINUOUS parallel sloped inner lip.
function lip_run_at_z(z)=HAS_RIM ? (z-H)/tan(ALPHA) : 0;
function left_profile(outside, rim, top_extra=0)=
    outside ? concat([[0,0],[-CHAMFER_X,CHAMFER_Z],[-SIDE_EXPAND,H]],
              [[-SIDE_EXPAND-(rim?lip_run_at_z(ZTOP+top_extra):0),ZTOP+top_extra]])
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
             [[-(rim?lip_run_at_z(ZTOP+top_extra):0),ZTOP+top_extra]])
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
    polygon(profile_polygon(left_profile(left_outer,Rim_left&&left_outer,extra),
                            right_profile(w,right_outer,Rim_right&&right_outer,extra)));
}
module yz_outer_2d(d,front_outer,rear_outer,extra=0) {
    // Y=0 is FRONT side of this tray; rear is at Y=d.
    a=end_profile(front_outer,Rim_front&&front_outer,extra);
    b=[for(p=end_profile(rear_outer,Rim_rear&&rear_outer,extra)) [d-p[0],p[1]]];
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
// Upper inner wall profiles use an EXACT offset from the straight sidewall,
// with a delayed transition to the lip. Relying on offset(delta=-B) at the
// sharp sidewall/lip junction rounded/mitred the inside kink erratically.
// We retain the eroded + uniformly FILLETED cavity at the BOTTOM; above the
// fillet's endpoint the cross-section is analytic and has ONE intended kink.
SIDE_K=(SIDE_EXPAND-CHAMFER_X)/max(0.01,H-CHAMFER_Z);
LIP_K=HAS_RIM ? 1/tan(ALPHA) : 0;
// For shallow above-rim heights, limit the inner-ramp transition
// to preserve a continuous profile; normally it starts B mm higher.
INNER_LIP_DELAY=min(B,max(0,LIP_Z/2));
function inner_x_left_at(z,outer,rim)=
    !outer ? B :
    (rim && HAS_RIM) ?
        (z<=H+INNER_LIP_DELAY
          ? -SIDE_EXPAND-(z-H)*SIDE_K+B*sqrt(1+SIDE_K*SIDE_K)
          : -SIDE_EXPAND-INNER_LIP_DELAY*SIDE_K+B*sqrt(1+SIDE_K*SIDE_K)-(z-H-INNER_LIP_DELAY)*LIP_K)
        : (z<=H
          ? -SIDE_EXPAND-(z-H)*SIDE_K+B*sqrt(1+SIDE_K*SIDE_K)
          : -SIDE_EXPAND+B*sqrt(1+SIDE_K*SIDE_K));
function inner_y_front_at(z,outer,rim)=
    !outer ? B :
    (rim && HAS_RIM && z>H+INNER_LIP_DELAY)
       ? B-(z-H-INNER_LIP_DELAY)*LIP_K : B;
module analytic_upper_cavity(w,left_outer,right_outer,left_rim,right_rim,is_x=true,zstart=43) {
    zlast=ZTOP+101;
    za=min(ZTOP-E,H);
    zb=min(ZTOP-E,H+INNER_LIP_DELAY);
    lp=[for(z=[zstart,za,zb,zlast])
         [is_x?inner_x_left_at(z,left_outer,left_rim):inner_y_front_at(z,left_outer,left_rim),z]];
    rp=[for(z=[zstart,za,zb,zlast])
         [w-(is_x?inner_x_left_at(z,right_outer,right_rim):inner_y_front_at(z,right_outer,right_rim)),z]];
    polygon(profile_polygon(lp,rp));
}
module xz_void_2d(w,left_outer,right_outer) {
    zcut=min(ZTOP-2*B,max(CHAMFER_Z+INNER_BOTTOM_R+3,H-18));
    floor_cut=min(H-2*B,max(CHAMFER_Z+3*B,5*B));
    union() {
        intersection() {
            safe_inner_2d(floor_cut)
                offset(delta=-B) xz_outer_2d(w,left_outer,right_outer,100);
            translate([-2000,-100]) square([4000,zcut+100+E]);
        }
        intersection() {
            analytic_upper_cavity(w,left_outer,right_outer,Rim_left,Rim_right,true,zcut);
            translate([-2000,zcut-E]) square([4000,2000]);
        }
    }
}
module yz_void_2d(d,front_outer,rear_outer) {
    zcut=min(ZTOP-2*B,max(CHAMFER_Z+INNER_BOTTOM_R+3,H-18));
    floor_cut=min(H-2*B,max(CHAMFER_Z+3*B,5*B));
    union() {
        intersection() {
            safe_inner_2d(floor_cut)
                offset(delta=-B) yz_outer_2d(d,front_outer,rear_outer,100);
            translate([-2000,-100]) square([4000,zcut+100+E]);
        }
        intersection() {
            analytic_upper_cavity(d,front_outer,rear_outer,Rim_front,Rim_rear,false,zcut);
            translate([-2000,zcut-E]) square([4000,2000]);
        }
    }
}

// --- Unified top rim: true 2-way edge arcs and 3-way corner transitions. ---
// The earlier pair of independently rounded XZ/YZ extrusions overlapped
// at corners. A 2D plan mask plus a separate hull created facet seams.
// Instead, generate ONE continuous, closed polygonal collar. Its edge
// insets follow a quarter circle (two-face blend); at each of its EIGHT
// corners, a 3D spherical-style transition raises the XY corner radius smoothly from
// zero to SOFT_R, with zero end slopes. Adjacent surfaces share every vertex.
// It is deliberately restricted to the last 2*SOFT_R mm to leave the
// lower chamfer and the common inner bottom fillet completely unchanged.
// The polyhedron uses flat triangles with shared indices: no co-planar
// corner patches, overlapping hulls or vertical corner clipping artifacts.
module xz_wall_2d(w,left_outer,right_outer) {
    difference() { xz_outer_2d(w,left_outer,right_outer); xz_void_2d(w,left_outer,right_outer); }
}
module yz_wall_2d(d,front_outer,rear_outer) {
    difference() { yz_outer_2d(d,front_outer,rear_outer); yz_void_2d(d,front_outer,rear_outer); }
}
function top_outer_coord(z, outside, rim, along_x=true) =
    !outside ? 0 :
    along_x ? -SIDE_EXPAND - (rim ? lip_run_at_z(z) : 0) :
    -(rim ? lip_run_at_z(z) : 0);
function top_inner_coord(z, outside, rim, along_x=true) =
    along_x ? inner_x_left_at(z,outside,rim) : inner_y_front_at(z,outside,rim);
// The curve is flat-tangent to the vertical side at its lower end, and
// flat-tangent to the top at the upper end. The taper outside is included
// in top_outer_coord(), not approximated by a vertical cuboid's bounds.
function top_edge_inset(z) =
    SOFT_R<=0 || z<=ZTOP-SOFT_R ? 0 :
    let(h=z-(ZTOP-SOFT_R))
        SOFT_R-sqrt(max(0,SOFT_R*SOFT_R-h*h));
// The 3-way corner must share the roundover height and curvature of the
// 2-way top edge. It must not make an unrelated bump in the vertical corner.
function top_corner_radius(z) =
    // Three-face blend is restricted to the SAME height as the soft top-edge
    // roundover. Below it, the vertical tray corners remain geometrically
    // straight; there is no independent full-height vertical-corner fillet.
    // Reuse the two-face edge inset so there is no second easement or hump
    // in the top plane from two independently changing radii.
    SOFT_R<=0 ? 0 : max(0.002,top_edge_inset(z));
// CCW perimeter with matching vertices on outer and inner loops. Every
// transition is captured by one shared polyhedron surface at all z levels.
function corner_loop(x0,x1,y0,y1,r,n) = concat(
   [for(j=[0:n]) [x1-r+r*cos(-90+j*90/n),y0+r+r*sin(-90+j*90/n)]],
   [for(j=[0:n]) [x1-r+r*cos(j*90/n),y1-r+r*sin(j*90/n)]],
   [for(j=[0:n]) [x0+r+r*cos(90+j*90/n),y1-r+r*sin(90+j*90/n)]],
   [for(j=[0:n]) [x0+r+r*cos(180+j*90/n),y0+r+r*sin(180+j*90/n)]]
);
function top_ring_points(z,w,d,left_outer,right_outer,front_outer,rear_outer,n) =
    let(e=top_edge_inset(z),cr=top_corner_radius(z),
        xo0=top_outer_coord(z,left_outer,Rim_left&&left_outer,true)+e,
        xo1=w-top_outer_coord(z,right_outer,Rim_right&&right_outer,true)-e,
        yo0=top_outer_coord(z,front_outer,Rim_front&&front_outer,false)+e,
        yo1=d-top_outer_coord(z,rear_outer,Rim_rear&&rear_outer,false)-e,
        xi0=top_inner_coord(z,left_outer,Rim_left&&left_outer,true)-e,
        xi1=w-top_inner_coord(z,right_outer,Rim_right&&right_outer,true)+e,
        yi0=top_inner_coord(z,front_outer,Rim_front&&front_outer,false)-e,
        yi1=d-top_inner_coord(z,rear_outer,Rim_rear&&rear_outer,false)+e)
    concat(
        [for(p=corner_loop(xo0,xo1,yo0,yo1,cr,n)) [p[0],p[1],z]],
        [for(p=corner_loop(xi0,xi1,yi0,yi1,cr,n)) [p[0],p[1],z]]
    );
// Indexed collar topology: outer side, inner side, top annulus, bottom annulus.
// Render facets controls the number of circular arc samples; no Minkowski.
function collar_idx(k,side,j,N)=k*2*N+side*N+j;
function collar_z(k,nz)=ZTOP-2*SOFT_R-E+(2*SOFT_R+E)*k/nz;
module top_edge_and_corner_collar(w,d,left_outer,right_outer,front_outer,rear_outer) {
    if(SOFT_R>0) {
        nc=max(16,ceil(Render_facets/2));
        nz=max(24,ceil(Render_facets));
        N=4*(nc+1);
        vertices=[for(k=[0:nz]) each top_ring_points(
            collar_z(k,nz),w,d,left_outer,right_outer,front_outer,rear_outer,nc)];
        faces=concat(
          [for(k=[0:nz-1],j=[0:N-1]) each [
             [collar_idx(k,0,j,N),collar_idx(k,0,(j+1)%N,N),collar_idx(k+1,0,(j+1)%N,N)],
             [collar_idx(k,0,j,N),collar_idx(k+1,0,(j+1)%N,N),collar_idx(k+1,0,j,N)],
             [collar_idx(k,1,(j+1)%N,N),collar_idx(k,1,j,N),collar_idx(k+1,1,j,N)],
             [collar_idx(k,1,(j+1)%N,N),collar_idx(k+1,1,j,N),collar_idx(k+1,1,(j+1)%N,N)]
          ]],
          [for(j=[0:N-1]) each [
             [collar_idx(nz,0,j,N),collar_idx(nz,0,(j+1)%N,N),collar_idx(nz,1,(j+1)%N,N)],
             [collar_idx(nz,0,j,N),collar_idx(nz,1,(j+1)%N,N),collar_idx(nz,1,j,N)],
             [collar_idx(0,0,j,N),collar_idx(0,1,(j+1)%N,N),collar_idx(0,0,(j+1)%N,N)],
             [collar_idx(0,0,j,N),collar_idx(0,1,j,N),collar_idx(0,1,(j+1)%N,N)]
          ]]
        );
        polyhedron(points=vertices,faces=faces,convexity=10);
    }
}
module raw_tray_shell(w,d,left_outer,right_outer,front_outer,rear_outer) {
    union() {
      intersection() {
         xz_extrude_2d(d) xz_wall_2d(w,left_outer,right_outer);
         yz_extrude_2d(w) yz_outer_2d(d,front_outer,rear_outer);
      }
      intersection() {
         yz_extrude_2d(w) yz_wall_2d(d,front_outer,rear_outer);
         xz_extrude_2d(d) xz_outer_2d(w,left_outer,right_outer);
      }
    }
}
module tray_shell(w,d,left_outer,right_outer,front_outer,rear_outer) {
    if(SOFT_R<=0) raw_tray_shell(w,d,left_outer,right_outer,front_outer,rear_outer);
    else union() {
        intersection() {
            raw_tray_shell(w,d,left_outer,right_outer,front_outer,rear_outer);
            translate([-1500,-1500,-100])
                cube([3000,3000,ZTOP-2*SOFT_R+100+E/2]);
        }
        top_edge_and_corner_collar(w,d,left_outer,right_outer,front_outer,rear_outer);
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
// The connector is solidly flat against the drawer floor (z=0) and has a
// flat top near the joining plane. At both outward lobes, its upper face is
// TRUNCATED following the shared bottom fillet. The socket is the same solid
// plus XY clearance: a blind underside cut, not a raised internal floor pad.
// The analytic cap is a conservative approximation of the R fillet above the
// B-thick floor. A safety margin absorbs tessellation and socket clearance.
// Conservative upper bound on socket roof depth, already including the
// minimum B-mm solid layer under the inner tray fillet. The pocket never
// exceeds this bound, even when the requested vertical clearance is high.
function socket_roof_safe_cap_at(y) =
    let(t=max(0,(abs(y)-T)/INNER_BOTTOM_R),
        stock=max(0,INNER_BOTTOM_R*(1-sqrt(max(0,2*t-t*t)))-0.25))
    abs(y)<=T ? CONNECTOR_HEIGHT+SOCKET_TOP_CLEARANCE :
    t>=1 ? 0 : min(CONNECTOR_HEIGHT+SOCKET_TOP_CLEARANCE,stock);
// The male is shortened by the full requested top clearance from the
// corresponding female socket cap. At its flat center it retains the
// specified CONNECTOR_HEIGHT; towards the lobes it follows the floor fillet.
function connection_cap_at(y) =
    max(0,min(CONNECTOR_HEIGHT,socket_roof_safe_cap_at(y)-SOCKET_TOP_CLEARANCE));
module connector_height_envelope(full=true) {
    R=INNER_BOTTOM_R;
    // Match the cap to the display facet budget instead of oversampling at
    // every connector. Approx. 16 segments at the default $fn=20 is adequate;
    // increasing Render_facets increases the cap precision with it.
    steps=max(12,ceil(Render_facets*0.8));
    // y ranges from 0 to T+R. No connector solid projects into the cavity
    // below the B-thick base when that distance is reached.
    if(full) rotate([90,0,90])
            linear_extrude(height=200,center=true,convexity=5)
                polygon(concat(
                    [[-T-R-1,-0.02]],
                    [for(i=[steps:-1:0]) let(y=T+R*i/steps) [-y,connection_cap_at(y)]],
                    [for(i=[0:steps]) let(y=T+R*i/steps) [y,connection_cap_at(y)]],
                    [[T+R+1,-0.02]]));
    else rotate([90,0,90])
        linear_extrude(height=200,center=true,convexity=5)
            polygon(concat([[0,-0.02]],[[0,CONNECTOR_HEIGHT+SOCKET_TOP_CLEARANCE]],
                [for(i=[0:steps]) let(y=T+R*i/steps)
                    [y,socket_roof_safe_cap_at(y)]],[[T+R+1,-0.02]]));
}
// One closed polyhedron per female pocket: rectangular stem, rounded lobe,
// and the SAME calculated roof-height envelope used by the male dogbone.
// This is not a preview approximation. F5 and F6 evaluate this exact object.
// Avoid intersecting two high-facet CSG extrusions for every socket: five
// trays with many separate intersections previously overflowed the OpenCSG
// normalizer (>100,000 nodes) when all parts were previewed together.
function socket_half_width_at(y) =
    max(y<=HEAD_IN ? WEB_R+SOCKET_SIDE_CLEARANCE : 0,
        abs(y-HEAD_IN)<SOCKET_R ?
            sqrt(max(0,SOCKET_R*SOCKET_R-(y-HEAD_IN)*(y-HEAD_IN))) : 0);
function socket_y_samples() =
    let(n=max(12,ceil(Render_facets)),
        transition=HEAD_IN-sqrt(max(0,SOCKET_R*SOCKET_R-(WEB_R+SOCKET_SIDE_CLEARANCE)*(WEB_R+SOCKET_SIDE_CLEARANCE))),
        tip=HEAD_IN+SOCKET_R-0.0001)
    concat([for(j=[0:n]) transition*j/n],
           [for(j=[1:n]) transition+(HEAD_IN-transition)*j/n],
           [for(j=[1:n]) HEAD_IN+(tip-HEAD_IN)*j/n]);
function socket_vertex(i,k,ys) =
    let(y=ys[i],w=socket_half_width_at(y),h=socket_roof_safe_cap_at(y))
    k==0 ? [-w,y,-E] :
    k==1 ? [w,y,-E] :
    k==2 ? [-w,y,h] : [w,y,h];
module socket_opening_3d() {
    ys=socket_y_samples();
    n=len(ys);
    pts=[for(i=[0:n-1],k=[0:3]) socket_vertex(i,k,ys)];
    faces=concat(
       [for(i=[0:n-2]) each [
          [4*i+0,4*(i+1)+0,4*(i+1)+1,4*i+1],
          [4*i+2,4*i+3,4*(i+1)+3,4*(i+1)+2],
          [4*i+1,4*(i+1)+1,4*(i+1)+3,4*i+3],
          [4*i+0,4*i+2,4*(i+1)+2,4*(i+1)+0]]],
       [[0,1,3,2],
        [4*(n-1)+1,4*(n-1)+0,4*(n-1)+2,4*(n-1)+3]]
    );
    polyhedron(points=pts,faces=faces,convexity=10);
}
module edge_station(side,at) {
    if(side=="front") translate([at,0,0]) children();
    if(side=="rear") translate([at,0,0]) rotate([0,0,180]) children();
    if(side=="left") translate([0,at,0]) rotate([0,0,-90]) children();
    if(side=="right") translate([0,at,0]) rotate([0,0,90]) children();
}
// Every socket is a subtraction. No extra reinforcing blocks protrude into
// the tray cavity; the rounded lower wall provides socket roof thickness.
module sockets(w,d,front_c,rear_c,left_c,right_c,
               front_stations,rear_stations,side_stations) {
    if(Connectors_enabled) {
        if(front_c) for(p=front_stations) edge_station("front",p) socket_opening_3d();
        if(rear_c) for(p=rear_stations) translate([0,d,0]) edge_station("rear",p) socket_opening_3d();
        if(left_c) for(p=side_stations) edge_station("left",p) socket_opening_3d();
        if(right_c) for(p=side_stations) translate([w,0,0]) edge_station("right",p) socket_opening_3d();
    }
}
module loose_dogbone() {
    intersection() {
        linear_extrude(height=CONNECTOR_HEIGHT) full_dogbone_2d();
        connector_height_envelope(true);
    }
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
      if(Connectors_enabled) {
        keep=WEB_R+SOCKET_SIDE_CLEARANCE+0.6;
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

// Notch floor clears the underside connector roofs. Fillets round the
// theoretical sharp corners of the requested base opening OUTWARD into the
// notch: the input is the gap BEFORE rounding, not the finished flat width.
// The remaining flat is allowed to shrink to zero without rejecting inputs.
function cutout_angle(a)=max(0,min(90,a));
function cutout_effective_r(zbase,ztop,width,a)=
    let(ang=cutout_angle(a),base=max(0,width))
    min(max(0,Cutout_round_diameter_mm/2),
        max(0,(ztop-zbase-0.5)/max(0.00001,2*(1-cos(ang)))),
        base/max(0.00001,2*tan(ang/2)));
function cutout_run(dz,ang)=
    ang<=0 ? DY+10 : min(DY+10,dz/max(0.00001,tan(ang)));
function cutout_right_side(width,zbase,ztop,r,a,n=12)=
    let(ang=cutout_angle(a),
        dz=max(0,(ztop-zbase)-2*r*(1-cos(ang))),
        slope_dx=cutout_run(dz,ang),
        base_x=max(0,width)/2-r*tan(ang/2),
        upper_x=base_x+2*r*sin(ang)+slope_dx,
        upper_z=ztop-r,
        low_cz=zbase+r)
    concat(
        // Bottom arc is tangent to the floor, then to the inclined riser.
        [for(i=[0:n]) let(t=-90+ang*i/n)
          [base_x+r*cos(t),low_cz+r*sin(t)]],
        // Top arc is tangent to the same riser, then the top surface.
        [for(i=[0:n]) let(t=90+ang-ang*i/n)
          [upper_x+r*cos(t),upper_z+r*sin(t)]]);
module access_notch_profile_2d(width,top_height) {
    zbase=PAD_HEIGHT+B+1;
    ztop=top_height;
    base=max(0,width);
    ang=cutout_angle(Cutout_riser_angle_deg);
    r=cutout_effective_r(zbase,ztop,base,ang);
    n=max(8,ceil(Render_facets*0.65));
    if(ang<=0) {
        // Zero degrees means no rising edge. Clear the full divider above
        // the notch floor without dividing the tray floor itself.
        extent=DY+base+20;
        polygon([[-extent,zbase],[extent,zbase],
                 [extent,ztop+6],[-extent,ztop+6]]);
    } else if(r<=0.00001) {
        // For zero gap/rounding, use two straight edges instead of
        // coincident zero-radius arc vertices.
        x0=base/2;
        xtop=x0+cutout_run(ztop-zbase,ang);
        polygon([[-x0,zbase],[x0,zbase],[xtop,ztop],
                 [xtop,ztop+6],[-xtop,ztop+6],[-xtop,ztop]]);
    } else {
        right=cutout_right_side(base,zbase,ztop,r,ang,n);
        left=[for(j=[len(right)-1:-1:0]) [-right[j][0],right[j][1]]];
        x_top=right[len(right)-1][0];
        x_flat=base/2-r*tan(ang/2);
        polygon(concat(
            [[-x_flat,zbase]],right,
            [[x_top,ztop+6],[-x_top,ztop+6]],left));
    }
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
                access_notch_profile_2d(Cutout_base_width_mm,ZTOP);
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
    front_outer=last==Grid_rows;
    left_join=is_join("left",left_outer);
    right_join=is_join("right",right_outer);
    front_join=is_join("front",front_outer);
    rear_join=is_join("rear",rear_outer);
    side_stations=clip_stations(d);
    front_stations=front_outer ? clip_stations(w) : cross_seam_stations(n,col,group_count(last+1));
    rear_stations=rear_outer ? clip_stations(w) : cross_seam_stations(n,col,group_count(start-1));
    if(report) {
        echo(str("TRAY rows ",start,"-",last," column ",col," / ",n));
        // The outer nominal footprint is measured before sidewall drafts and
        // chamfers. The estimated clear footprint subtracts two wall thicknesses;
        // the actual usable area near radii / connector mouths is smaller.
        echo("SELECTED TRAY NOMINAL WIDTH x DEPTH (mm)",w,d);
        echo("SELECTED TRAY ESTIMATED CLEAR WIDTH x DEPTH (mm, before fillets)",
             max(0,w-2*T),max(0,d-2*T));
        echo("BOTTOM SIZE (mm)",w,d,"CONNECTORS (front rear left right)",front_join,rear_join,left_join,right_join);
        echo("CONNECTOR STATIONS (front/rear/side)",front_stations,rear_stations,side_stations);
    }
    difference() {
        tray_shell(w,d,left_outer,right_outer,front_outer,rear_outer);
        sockets(w,d,front_join,rear_join,left_join,right_join,
                front_stations,rear_stations,side_stations);
        join_foot_relief(w,d,left_join,right_join,front_join,rear_join,
                         front_stations,rear_stations,side_stations);
        joining_wall_cutouts(w,d,start,last,col,n);
    }
}

// One geometry definition for both preview and final render. OpenSCAD's
// own F5/F6 controls decide the evaluation mode; never force render().
module display_tray(start,col,report=true) {
    one_tray(start,col,report);
}
// Count tray GROUP boundaries in front of (closer to the viewer than) this group.
// Separation is applied once PER TRAY JOIN, not once per logical row.
function groups_ahead(start) = len([for(k=[1:Grid_rows]) if(k>start && splits_at(k)>0) k]);
module all_trays() {
    for(r=[1:Grid_rows]) if(splits_at(r)>0)
        for(c=[1:splits_at(r)]) {
            // One equal gap between each pair of physically adjacent parts.
            // "Continue previous" rows are not new group gaps.
            w=W0/splits_at(r);
            d=group_depth(r);
            x=(c-1)*w+(c-(splits_at(r)+1)/2)*Preview_separation_mm;
            y=group_y(r)+groups_ahead(r)*Preview_separation_mm;
            echo("PREVIEW ORIGIN (row, column, x, y, w, depth)",r,c,x,y,w,d);
            translate([x,y,0])
                color([0.78+0.03*((r+c)%3),0.84,0.91-0.04*(c%3)])
                    display_tray(r,c,false);
        }
}

// ----------- Output and non-fatal invalid selection handling -----------
echo("DRAWER v9 | profile",W0,WT,DY,"metal rim",H,"printed height",ZTOP);
echo("ANGLE / OUTER CHAMFER run, rise",ALPHA,CHAMFER_X,CHAMFER_Z);
echo("RIM (angle FROM PRINT BED / fixed height / derived projection)",
     HAS_RIM ? ALPHA : 0, LIP_Z, RIM_PROJECTION);
echo("CONNECTOR CLEARANCES (total side / each side / top)",
     Connector_side_clearance_total_mm, SOCKET_SIDE_CLEARANCE, SOCKET_TOP_CLEARANCE);
echo("CONNECTOR ROOF CAPS (at seam)",connection_cap_at(0),socket_roof_safe_cap_at(0));
echo("BASE MIN THICKNESS / BOTTOM INNER R / WALL REINFORCEMENT",B,INNER_BOTTOM_R,T);
// Report the entered pre-rounding gap as well as the finished dimensions.
let(z0=PAD_HEIGHT+B+1,
    ang=cutout_angle(Cutout_riser_angle_deg),
    base=max(0,Cutout_base_width_mm),
    radius=cutout_effective_r(z0,ZTOP,base,ang),
    side=cutout_right_side(base,z0,ZTOP,radius,ang))
    echo("CUTOUT widths (pre-rounding base / flat floor / lower risers / top opening, mm)",
         base,
         max(0,base-2*radius*tan(ang/2)),
         max(0,base-2*radius*tan(ang/2))+2*radius*sin(ang),
         ang<=0 ? 2*(DY+base+20) : 2*side[len(side)-1][0]);
echo("DOGBONE max height / lobe diameter / straight center length / interior bottom R",
     CONNECTOR_HEIGHT,2*HEAD_R,CONNECTOR_STRAIGHT_LENGTH,INNER_BOTTOM_R);
// Explain the logical pitch independently of the per-row split count.
// Example: usable W0=189, columns=3 => width pitch 63;
// usable DY=474, rows=6 => depth pitch 79.
echo("GRID UNIT NOMINAL WIDTH x DEPTH (mm, before walls)",
     GRID_UNIT_WIDTH,ROW_DEPTH);
echo("GRID UNIT ESTIMATED CLEAR WIDTH x DEPTH (mm, before fillets)",
     max(0,GRID_UNIT_WIDTH-2*T),max(0,ROW_DEPTH-2*T));
for(r=[1:Grid_rows]) if(splits_at(r)>0)
    echo(str("GRID GROUP rows ",r,"-",group_end(r),
             " (",splits_at(r)," tray(s)): NOMINAL WIDTH x DEPTH (mm)"),
         W0/splits_at(r),group_depth(r));
echo("GRID rear->front",[for(r=[1:Grid_rows]) splits_at(r)]);

if(len(GRID_OVERFLOW_ROWS)>0) {
    for(r=GRID_OVERFLOW_ROWS)
        echo(str("GRID SIZE MISMATCH: Row ",r," requests ",splits_at(r),
                 " compartments, but Grid_columns is ",Grid_columns,
                 ". Increase Grid_columns to at least ",splits_at(r),
                 " (or reduce Row_",r,"). Nothing rendered."));
} else if(Output_mode==0) {
    all_trays();
} else if(Output_mode==1) {
    if(Selected_row<1||Selected_row>Grid_rows)
        echo(str("SELECTION INVALID: Row ",Selected_row," does not exist (1..",Grid_rows,"). Nothing drawn."));
    else let(start=group_start(Selected_row))
        if(Selected_column<1||Selected_column>splits_at(start))
            echo(str("SELECTION INVALID: Column ",Selected_column," does not exist in row ",Selected_row,
                     " (1..",splits_at(start),"). Nothing drawn."));
        else display_tray(start,Selected_column);
} else if(Output_mode==2) {
    stride=2*(HEAD_IN+HEAD_R)+4;
    for(i=[0:Loose_connector_quantity-1])
        translate([((i%10)+0.5)*stride,-(floor(i/10)+1.5)*stride,0])
            loose_dogbone();
} else echo("OUTPUT INVALID: choose Full layout, Selected tray or Loose dogbones.");
