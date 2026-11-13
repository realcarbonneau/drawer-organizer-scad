// DRAWER ORGANIZER v9
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
base_thickness_mm = 2.0; // [0.8:0.1:5]
// Additional reinforcements around the dogbone sockets use this thickness.
wall_thickness_mm = 2.0; // [0.8:0.1:5]
// Same bottom INSIDE rounding on all four sides. Automatically sized to
// preserve the minimum base thickness at the exterior bottom chamfer.
// Exposed top edges get a small protective rounding, limited below T/2.
soft_edge_radius_mm = 0.6; // [0:0.1:1.5]

/* [04 - Connector Specifications] */
// One continuous connector center-spacing target on every joining segment.
connector_spacing_mm = 59; // [18:1:160]
// Thickness of the straight rectangular center, in the XY plane.
connector_center_thickness_mm = 4; // [2:0.5:12]
// Radial protrusion on EACH side of a circular lobe, beyond center thickness.
// Example: 4 mm center + 1 mm per side = 6 mm lobe diameter.
connector_diameter_protrusion_mm = 1; // [0.25:0.25:5]
// Maximum vertical connector height. The two lobes are progressively trimmed
// to follow the bottom inside fillet and preserve stock above each blind socket.
connector_height_mm = 6; // [1:0.2:8]
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
cutout_row_04 = true;
cutout_row_05 = false;
cutout_row_06 = false;
cutout_row_07 = false;
cutout_row_08 = false;
cutout_row_09 = false;
cutout_row_10 = false;
// Width at the LOWEST point of the rounded, angled notch.
// The two shoulders expand upwards with the selected printing angle.
cutout_base_width_mm = 25; // [8:1:65]
// Diameter of curved transitions into/out of the cutout risers.
cutout_round_diameter_mm = 20; // [0:1:40]
// Wall-face cutout riser inclination, from the horizontal surface.
cutout_riser_angle_deg = 60; // [45:1:90]

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
// An enabled rim is ONE straight outward slope, from metal rim level
// directly to the top surface. No straight vertical return after the slope.
// Actual rim angle may become STEEPER than the minimum printing angle to
// maintain a requested above-rim height with a short horizontal projection.
HAS_RIM=rim_left||rim_right||rim_front||rim_rear;
LIP_Z=HAS_RIM ? max(tray_height_above_rim_mm,rim_projection_mm*tan(ALPHA)) : tray_height_above_rim_mm;
ZTOP=H+LIP_Z;
ROW_DEPTH=DY/grid_rows;
// Nominal logical-grid pitch, before exterior drafts, fillets and wall stock.
GRID_UNIT_WIDTH=W0/grid_columns;
WEB_R=connector_center_thickness_mm/2;
HEAD_R=connector_center_thickness_mm/2+connector_diameter_protrusion_mm;
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
CONNECTOR_HEIGHT=connector_height_mm;
// Pocket opens ONLY at Z=0 and stops at CONNECTOR_HEIGHT.
// A closed ROOF at least B thick remains above it. The lower 2D contour
// is a clean circle-rectangle-circle shape with no retention undercuts.
SOCKET_R=HEAD_R+connector_clearance_mm;
SOCKET_STOCK=max(B,T);
PAD_HEIGHT=CONNECTOR_HEIGHT+SOCKET_STOCK+0.4; // design envelope; NO inside pads
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
LOBE_REACH=max(0,HEAD_IN+HEAD_R+connector_clearance_mm-T);
LOBE_TIP_STOCK=min(CONNECTOR_HEIGHT,0.8)+0.25;
CONNECTOR_FILLET_R=LOBE_REACH+LOBE_TIP_STOCK+sqrt(2*LOBE_REACH*LOBE_TIP_STOCK);
INNER_BOTTOM_R=max(B,CHAMFER_X*0.65,CONNECTOR_FILLET_R);
SOFT_R=min(max(0,soft_edge_radius_mm),max(0,min(B,T)/2-0.1));

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
assert(connector_diameter_protrusion_mm>0 && connector_center_thickness_mm>=2,
       "Dogbone lobe diameter protrusion must be positive.");
assert(CONNECTOR_HEIGHT>=1 && CONNECTOR_HEIGHT < H-2*B,
       "Connector height must fit underneath the tray walls.");
assert(JOIN_Z<=B,"Elephant foot relief must be no deeper than the base thickness.");
// Notch width is clipped to each row's room; no hard failure on a short row.

// ----------- 2D section profiles; generated from the measured drawer -----------
// Each profile is a closed XY polygon where (x,z) or (y,z) become its axes.
// Extended top profiles remain collinear through the rim ramp so eroding
// these sections also produces a CONTINUOUS parallel sloped inner lip.
function lip_run_at_z(z)=(ZTOP<=H || rim_projection_mm<=0) ? 0
    : rim_projection_mm*(z-H)/(ZTOP-H);
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
// Upper inner wall profiles use an EXACT offset from the straight sidewall,
// with a delayed transition to the lip. Relying on offset(delta=-B) at the
// sharp sidewall/lip junction rounded/mitred the inside kink erratically.
// We retain the eroded + uniformly FILLETED cavity at the BOTTOM; above the
// fillet's endpoint the cross-section is analytic and has ONE intended kink.
SIDE_K=(SIDE_EXPAND-CHAMFER_X)/max(0.01,H-CHAMFER_Z);
LIP_K=rim_projection_mm/max(0.01,LIP_Z);
function inner_x_left_at(z,outer,rim)=
    !outer ? B :
    (rim && rim_projection_mm>0 && LIP_Z>B) ?
        (z<=H+B
          ? -SIDE_EXPAND-(z-H)*SIDE_K+B*sqrt(1+SIDE_K*SIDE_K)
          : -SIDE_EXPAND-B*SIDE_K+B*sqrt(1+SIDE_K*SIDE_K)-(z-H-B)*LIP_K)
        : (z<=H
          ? -SIDE_EXPAND-(z-H)*SIDE_K+B*sqrt(1+SIDE_K*SIDE_K)
          : -SIDE_EXPAND+B*sqrt(1+SIDE_K*SIDE_K));
function inner_y_front_at(z,outer,rim)=
    !outer ? B :
    (rim && rim_projection_mm>0 && LIP_Z>B && z>H+B)
       ? B-(z-H-B)*LIP_K : B;
module analytic_upper_cavity(w,left_outer,right_outer,left_rim,right_rim,is_x=true,zstart=43) {
    zlast=ZTOP+101;
    za=min(ZTOP-E,H);
    zb=min(ZTOP-E,H+B);
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
            analytic_upper_cavity(w,left_outer,right_outer,rim_left,rim_right,true,zcut);
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
            analytic_upper_cavity(d,front_outer,rear_outer,rim_front,rim_rear,false,zcut);
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
        xo0=top_outer_coord(z,left_outer,rim_left&&left_outer,true)+e,
        xo1=w-top_outer_coord(z,right_outer,rim_right&&right_outer,true)-e,
        yo0=top_outer_coord(z,front_outer,rim_front&&front_outer,false)+e,
        yo1=d-top_outer_coord(z,rear_outer,rim_rear&&rear_outer,false)-e,
        xi0=top_inner_coord(z,left_outer,rim_left&&left_outer,true)-e,
        xi1=w-top_inner_coord(z,right_outer,rim_right&&right_outer,true)+e,
        yi0=top_inner_coord(z,front_outer,rim_front&&front_outer,false)-e,
        yi1=d-top_inner_coord(z,rear_outer,rim_rear&&rear_outer,false)+e)
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
        nc=max(16,ceil(render_facets/2));
        nz=max(24,ceil(render_facets));
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
function connection_cap_at(y) =
    let(t=max(0,(abs(y)-T)/INNER_BOTTOM_R),
        rounded_stock=max(0,INNER_BOTTOM_R*(1-sqrt(max(0,2*t-t*t)))-0.25))
    abs(y)<=T ? CONNECTOR_HEIGHT :
    t>=1 ? 0 : min(CONNECTOR_HEIGHT,rounded_stock);
module connector_height_envelope(full=true) {
    R=INNER_BOTTOM_R;
    // Match the cap to the display facet budget instead of oversampling at
    // every connector. Approx. 16 segments at the default $fn=20 is adequate;
    // increasing render_facets increases the cap precision with it.
    steps=max(12,ceil(render_facets*0.8));
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
            polygon(concat([[0,-0.02]],[[0,CONNECTOR_HEIGHT]],
                [for(i=[0:steps]) let(y=T+R*i/steps)
                    [y,connection_cap_at(y)]],[[T+R+1,-0.02]]));
}
module socket_opening_3d() {
    intersection() {
        translate([0,0,-E]) linear_extrude(height=CONNECTOR_HEIGHT+E)
            half_dogbone_2d(connector_clearance_mm);
        // Only what fits beneath the B-thick interior bottom is removed.
        connector_height_envelope(false);
    }
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
    if(connectors_enabled) {
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
// Circular tangent construction, not a generic polygon offset.
// The lower R-arc leaves the FLAT base horizontally, meets the straight
// riser at the selected angle, and the upper R-arc meets the top surface
// horizontally again. Both transitions use the same user-selected diameter.
// The LEFT edge mirrors the RIGHT edge, so the notch is symmetric.
function cutout_effective_r(zbase,ztop) =
    let(a=cutout_riser_angle_deg)
    min(max(0,cutout_round_diameter_mm/2),
        max(0,(ztop-zbase-0.5)/(2*(1-cos(a)))));
function cutout_right_side(width,zbase,ztop,r,a,n=12) =
    let(ang=max(45,min(90,a)),
        dz=max(0,(ztop-zbase)-2*r*(1-cos(ang))),
        slope_dx=dz/max(0.001,tan(ang)),
        upper_x=width/2 + 2*r*sin(ang)+slope_dx,
        upper_z=ztop-r,
        base_x=width/2,
        low_cz=zbase+r)
    concat(
        // Bottom R: tangent to horizontal, then tangent to inclined riser.
        [for(i=[0:n]) let(t=-90+ang*i/n)
          [base_x+r*cos(t), low_cz+r*sin(t)]],
        // Top R: tangent to inclined riser, then tangent to horizontal top.
        [for(i=[0:n]) let(t=90+ang-ang*i/n)
          [upper_x+r*cos(t),upper_z+r*sin(t)]]);
module access_notch_profile_2d(width,top_height) {
    zbase=PAD_HEIGHT+B+1;
    ztop=top_height;
    r=cutout_effective_r(zbase,ztop);
    n=max(8,ceil(render_facets*0.65));
    right=cutout_right_side(width,zbase,ztop,r,cutout_riser_angle_deg,n);
    left=[for(j=[len(right)-1:-1:0]) [-right[j][0],right[j][1]]];
    x_top=right[len(right)-1][0];
    // Cutter is open beyond the tray roof; the vertical lines here are
    // ABOVE the physical tray, not unwanted vertical edges inside it.
    polygon(concat(
        [[-width/2,zbase]], right,
        [[x_top,top_height+6],[-x_top,top_height+6]],left));
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

// OpenCSG F5 normalizer expands nested offset/intersection/subtraction
// combinations exponentially. Rendering the FINAL one-tray boundary once
// gives a single cached polyhedron to the preview scene, instead of
// >100,000 CSG leaves. F6 exports the normal (exact) one_tray geometry.
module display_tray(start,col,report=true) {
    if($preview) render(convexity=10) one_tray(start,col,report);
    else one_tray(start,col,report);
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
                    display_tray(r,c,false);
        }
}

// ----------- Output and non-fatal invalid selection handling -----------
echo("DRAWER v9 | profile",W0,WT,DY,"metal rim",H,"printed height",ZTOP);
echo("ANGLE / OUTER CHAMFER run, rise / lip projection, rise",ALPHA,CHAMFER_X,CHAMFER_Z,rim_projection_mm,LIP_Z);
echo("BASE MIN THICKNESS / BOTTOM INNER R / WALL REINFORCEMENT",B,INNER_BOTTOM_R,T);
echo("DOGBONE max height / lobe diameter / straight center length / interior bottom R",
     CONNECTOR_HEIGHT,2*HEAD_R,CONNECTOR_STRAIGHT_LENGTH,INNER_BOTTOM_R);
// Explain the logical pitch independently of the per-row split count.
// Example: usable W0=189, columns=3 => width pitch 63;
// usable DY=474, rows=6 => depth pitch 79.
echo("GRID UNIT NOMINAL WIDTH x DEPTH (mm, before walls)",
     GRID_UNIT_WIDTH,ROW_DEPTH);
echo("GRID UNIT ESTIMATED CLEAR WIDTH x DEPTH (mm, before fillets)",
     max(0,GRID_UNIT_WIDTH-2*T),max(0,ROW_DEPTH-2*T));
for(r=[1:grid_rows]) if(splits_at(r)>0)
    echo(str("GRID GROUP rows ",r,"-",group_end(r),
             " (",splits_at(r)," tray(s)): NOMINAL WIDTH x DEPTH (mm)"),
         W0/splits_at(r),group_depth(r));
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
        else display_tray(start,selected_column);
} else if(output_mode==2) {
    stride=2*(HEAD_IN+HEAD_R)+4;
    for(i=[0:loose_connector_quantity-1])
        translate([((i%10)+0.5)*stride,-(floor(i/10)+1.5)*stride,0])
            loose_dogbone();
} else echo("OUTPUT INVALID: choose Full layout, Selected tray or Loose dogbones.");
