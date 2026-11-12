// MODULAR DRAWER ORGANIZER — CAD terminology / Customizer edition (2026-11-12)
// Original design by fotrik: https://www.printables.com/model/816729-modular-drawer-organizer-remix/
// Original remix permitted with attribution. Geometry based on original section()/section_half().
// OpenSCAD 2021.01 compatible; no external libraries required.
//
// QUICK START
// 1. Select the Part type dropdown. The initial choice is a complete LEFT-edge tray.
// 2. Sidewall draft -> Automatic applies a draft ONLY to the selected OUTER side.
// 3. Change Left/Right sidewall top offset in millimeters; F5 preview (F6 export).
// 4. With "Interior tray", automatic draft = zero. Choose "Both sides" to override.
// 5. "Front rim extension" is a front lip overhang, NOT a rear-wall draft.
// 6. Only Example parts use hard-coded grid dimensions; custom parts use your dimensions.
// 7. For no joining tabs, select "No connectors" in the joinery dropdown.
//
// AXES: X = left/right across drawer, Y = front/rear, Z = height.
// SIDEWALL DRAFT: top offset in X from lower wall at z=bottom chamfer leg.
// Positive offsets lean outward: left towards -X, right towards +X.
// 8.3 mm offset on a 52mm height with 10mm chamfer = ~11.2 degrees from vertical.

/* [01 - Part selection] */
// Part type (editable trays or the author's sample examples)
part_type = 102; // [101:Interior tray - full, 102:Left outside edge - full, 108:Right outside edge - full, 103:Front or rear edge - full, 104:Front left corner - full, 105:Rear left corner - full, 106:Rear right corner - full, 107:Front right corner - full, 201:Interior tray - print half, 202:Left outside edge - print half, 208:Right outside edge - print half, 203:Front or rear edge - print half, 204:Front left corner - print half, 205:Rear left corner - print half, 206:Rear right corner - print half, 207:Front right corner - print half, 1:Standard joining tabs only, 51:Half tray joining tabs only, 9001:Sample 1 - teaspoons, 9002:Sample 2 - knives, 9003:Sample 3 - forks, 9004:Sample 4 - spoons, 9005:Sample 5 - chef knives, 9006:Sample 6 - steak knives, 9007:Sample 7 - utility compartment, 9999:Full original demo layout]
// Interlocking tabs (applies to editable tray parts, not fixed examples)
connector_mode = 0; // [0:Use tabs appropriate to selected location, 1:No tabs - plain tray, 2:Tabs on all four edges]
// Number of loose joiner components (only for "joining tabs only" part types)
connector_quantity = 6; // [1:1:40]

/* [02 - Sidewall draft] */
// Where sidewall draft is applied to editable trays
sidewall_profile = 0; // [0:Automatic - only selected outer edge, 1:Vertical - no draft, 2:Left side only, 3:Right side only, 4:Both left and right sides]
// Left sidewall OUTWARD top offset, measured in mm (0 = vertical)
left_top_offset_mm = 8.3; // [0:0.1:30]
// Right sidewall OUTWARD top offset, measured in mm (0 = vertical)
right_top_offset_mm = 8.3; // [0:0.1:30]

/* [03 - Tray geometry] */
// X-direction pitch of layout grid, mm
grid_pitch_x_mm = 59; // [25:0.5:150]
// Y-direction pitch of layout grid, mm
grid_pitch_y_mm = 59; // [25:0.5:150]
// Outer tray width in X-grid units (decimals are supported)
tray_width_grid_units = 1; // [1:0.1:10]
// Outer tray depth in Y-grid units (decimals are supported)
tray_depth_grid_units = 4; // [1:0.1:10]
// Exterior height of tray, mm
tray_height_mm = 52; // [20:1:100]
// Nominal wall and floor thickness, mm
wall_thickness_mm = 1.8; // [0.6:0.1:5]
// Interior bottom-to-wall fillet radius, mm
inside_fillet_radius_mm = 15; // [5:0.5:35]
// External lower edge 45-degree chamfer leg, mm (original edgec)
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
connector_fit_clearance_mm = 0.1;
epsilon_mm = 0.01;

// Editable part placement: outer edges only are tapered in Auto mode.
custom_part_selected = part_type>=101 && part_type<=208;
left_outer_location = (part_type==102 || part_type==104 || part_type==105 || part_type==202 || part_type==204 || part_type==205);
right_outer_location = (part_type==108 || part_type==106 || part_type==107 || part_type==208 || part_type==206 || part_type==207);
apply_left_draft = sidewall_profile==2 || sidewall_profile==4 || (sidewall_profile==0 && left_outer_location);
apply_right_draft = sidewall_profile==3 || sidewall_profile==4 || (sidewall_profile==0 && right_outer_location);
effective_left_offset_mm = apply_left_draft ? left_top_offset_mm : 0;
effective_right_offset_mm = apply_right_draft ? right_top_offset_mm : 0;

assert(tray_width_grid_units>=1 && tray_depth_grid_units>=1, "Tray grid unit counts must be at least 1.");
assert(tray_height_mm>0 && wall_thickness_mm>=0.45, "Tray height and wall thickness must be positive.");
assert(bottom_chamfer_leg_mm>=0 && bottom_chamfer_leg_mm<tray_height_mm, "Chamfer leg must be less than tray height.");
assert(2*inside_fillet_radius_mm<grid_pitch_x_mm && 2*inside_fillet_radius_mm<grid_pitch_y_mm, "Inside fillet diameter must fit both grid pitches.");
assert(inside_fillet_radius_mm>bottom_chamfer_leg_mm+wall_thickness_mm/2, "For continuous base, increase fillet radius or decrease bottom chamfer.");
assert(left_top_offset_mm>=0 && right_top_offset_mm>=0, "Sidewall top offsets must be non-negative.");

echo("Part type:", part_type);
echo("Editable tray width/depth (mm):", tray_width_grid_units*grid_pitch_x_mm, tray_depth_grid_units*grid_pitch_y_mm);
echo("Applied SIDEWALL top offset left/right (mm):", effective_left_offset_mm, effective_right_offset_mm);
echo("Applied sidewall draft angle left/right (degrees):", atan(effective_left_offset_mm/(tray_height_mm-bottom_chamfer_leg_mm)), atan(effective_right_offset_mm/(tray_height_mm-bottom_chamfer_leg_mm)));
echo("Demo samples use side offsets directly (left/right), even if draft profile = Automatic.");

// ----------------------------------------------
// GEOMETRY ENGINE (descriptive parameter names)
// ----------------------------------------------

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
                    cylinder(tray_height_mm-inside_fillet_radius_mm-wall_thickness_mm,inside_fillet_radius_mm,inside_fillet_radius_mm);
                }
            }
        }
        translate([-0.1,-0.1,10+wall_thickness_mm]) cube([width_grid_units*grid_pitch_x_mm,depth_grid_units*grid_pitch_y_mm,tray_height_mm]);
        translate([-0.1,-0.1,wall_thickness_mm]) cube([width_grid_units*grid_pitch_x_mm,(depth_grid_units-1.1)*grid_pitch_y_mm,tray_height_mm]);
    }
 }

module section(width_grid_units,depth_grid_units,left_wall_cutout_y_units,right_wall_cutout_y_units,front_connector,right_connector,rear_connector,left_connector,rear_knife_riser,front_knife_riser,left_draft_mm,right_draft_mm, front_rim_extension_mm) {
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


    module conbody(rot) {
        y= 2*connector_tab_width_mm+connector_wall_reinforcement_mm<bottom_chamfer_leg_mm ? bottom_chamfer_leg_mm : 2*connector_tab_width_mm+connector_wall_reinforcement_mm;
        z= 2*connector_tab_height_mm+connector_wall_reinforcement_mm<bottom_chamfer_leg_mm ? bottom_chamfer_leg_mm : 2*connector_tab_height_mm+connector_wall_reinforcement_mm;
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

    
    // Draws the main body of the box. Follows outer shape only. 
    module rawbody(outer_width_mm, outer_depth_mm, left_draft_mm, right_draft_mm, front_rim_extension_mm)
    {
    difference() {
        // Main shape  already contains left and right bootom edges and tilts
        // color("blue", alpha=0.5)
        translate([0,outer_depth_mm,0]) rotate([90,0,0])
            linear_extrude(height=outer_depth_mm+front_rim_extension_mm)
            polygon([[bottom_chamfer_leg_mm,0],[outer_width_mm-bottom_chamfer_leg_mm,0],[outer_width_mm,bottom_chamfer_leg_mm],
                [outer_width_mm+right_draft_mm,tray_height_mm],[0-left_draft_mm,tray_height_mm], [0,bottom_chamfer_leg_mm]]);
                
         
        //remove bottom part of extended front panel to create the front_rim_extension_mm
        colh = 1; // front_rim_extension_mm tray_height_mm at the end.

        translate ([outer_width_mm+right_draft_mm+epsilon_mm, 0,0]) rotate([90,0,-90])        
        linear_extrude(height=outer_width_mm+left_draft_mm+right_draft_mm+2*epsilon_mm)
            polygon([[0,0-epsilon_mm],[0,tray_height_mm-front_rim_extension_mm-colh],[front_rim_extension_mm+epsilon_mm,tray_height_mm-colh+epsilon_mm],
                [front_rim_extension_mm+epsilon_mm,0-epsilon_mm]]);

        // Removing front a back bottom edges
        // front (low y edge)
        translate([0-epsilon_mm,0,bottom_chamfer_leg_mm]) rotate([0,90,0])
            linear_extrude(outer_width_mm+2*epsilon_mm)
            polygon([[bottom_chamfer_leg_mm+epsilon_mm,bottom_chamfer_leg_mm+epsilon_mm],[bottom_chamfer_leg_mm+epsilon_mm,0-epsilon_mm],[0-epsilon_mm,0-epsilon_mm]]);
                
        // back (high y edge) 
        translate([0+epsilon_mm,outer_depth_mm-bottom_chamfer_leg_mm,bottom_chamfer_leg_mm]) rotate([0,90,0])
            linear_extrude(outer_width_mm+2*epsilon_mm)
            polygon([[bottom_chamfer_leg_mm+epsilon_mm,bottom_chamfer_leg_mm+epsilon_mm],[bottom_chamfer_leg_mm+epsilon_mm,0-epsilon_mm],[0-epsilon_mm,bottom_chamfer_leg_mm+epsilon_mm]]);
        }
}

    difference() {
        // the outer body
        union() {
            rawbody(outer_width_mm, outer_depth_mm, left_draft_mm, right_draft_mm, front_rim_extension_mm);

            // extend bottom part on the openings:
            if(right_wall_cutout_y_units) {
                translate([outer_width_mm-bottom_chamfer_leg_mm-wall_thickness_mm,right_wall_cutout_y_units*grid_pitch_y_mm-grid_pitch_y_mm/2+connector_span_mm/2,0])
                 cube([bottom_chamfer_leg_mm+wall_thickness_mm,grid_pitch_y_mm-connector_span_mm,bottom_chamfer_leg_mm+wall_thickness_mm]);
            }
            if(left_wall_cutout_y_units) {
                translate([0,left_wall_cutout_y_units*grid_pitch_y_mm-grid_pitch_y_mm/2+connector_span_mm/2,0])
                 cube([bottom_chamfer_leg_mm+wall_thickness_mm,grid_pitch_y_mm-connector_span_mm,bottom_chamfer_leg_mm+wall_thickness_mm]);
            }
            // connection to next module
            if(front_connector) {
                for(i=[0:1:width_grid_units-1]) {
                    translate([(i+0.5)*grid_pitch_x_mm,0,0]) conbody(0);
                }
            }
            if(right_connector) {
                for(i=[0:1:depth_grid_units-0.8]) {
                    translate([outer_width_mm,(i+0.5)*grid_pitch_y_mm,0]) conbody(90);
                }
            }
            if(rear_connector) {
                for(i=[0:1:width_grid_units-1]) {
                    translate([(i+0.5)*grid_pitch_x_mm,outer_depth_mm,0]) conbody(180);
                }
            }
            if(left_connector) {
                for(i=[0:1:depth_grid_units-0.8]) {
                    translate([0,(i+0.5)*grid_pitch_y_mm,0]) conbody(270);
                }
            }
        } // union
        union() {
            // main iner hole
            translate([inside_fillet_radius_mm+wall_thickness_mm,inside_fillet_radius_mm+wall_thickness_mm,inside_fillet_radius_mm+wall_thickness_mm]) {
                minkowski() {
                translate ([0,outer_depth_mm-2*inside_fillet_radius_mm-2*wall_thickness_mm,0]) rotate([90,0,0])
                    linear_extrude(outer_depth_mm-2*inside_fillet_radius_mm-2*wall_thickness_mm)
                    polygon ([[0,0],[0-left_draft_mm,tray_height_mm-inside_fillet_radius_mm],
                        [outer_width_mm-2*inside_fillet_radius_mm-2*wall_thickness_mm+right_draft_mm,tray_height_mm-inside_fillet_radius_mm],
                        [outer_width_mm-2*inside_fillet_radius_mm-2*wall_thickness_mm,0]]);
                        
                sphere(inside_fillet_radius_mm);
                }                
            }
            // optional cut in right wall_thickness_mm
            if(right_wall_cutout_y_units && depth_grid_units>2) {
                difference() {
                    union() {
                        translate([outer_width_mm/2,right_wall_cutout_y_units*grid_pitch_y_mm-12,wall_thickness_mm]) cube([width_grid_units*grid_pitch_x_mm,24,tray_height_mm]);
                        translate([outer_width_mm/2,right_wall_cutout_y_units*grid_pitch_y_mm-12,wall_thickness_mm]) rotate([-25,0]) cube([outer_width_mm,24,2*tray_height_mm]);
                        translate([outer_width_mm/2,right_wall_cutout_y_units*grid_pitch_y_mm+12,wall_thickness_mm]) mirror([0,1,0]) rotate([-25,0,0]) cube([outer_width_mm,24,2*tray_height_mm]);
                    }
                    translate([outer_width_mm/2,0,-20]) cube([outer_width_mm,outer_depth_mm,20+wall_thickness_mm]);
                }
            }
            // optional cut in left wall_thickness_mm
            if(left_wall_cutout_y_units && depth_grid_units>2) {
                difference() {
                    union() {
                        translate([-outer_width_mm/2,left_wall_cutout_y_units*grid_pitch_y_mm-12,wall_thickness_mm]) cube([outer_width_mm,24,tray_height_mm]);
                        translate([-outer_width_mm/2,left_wall_cutout_y_units*grid_pitch_y_mm-12,wall_thickness_mm]) rotate([-25,0]) cube([outer_width_mm,24,2*tray_height_mm]);
                        translate([-outer_width_mm/2,left_wall_cutout_y_units*grid_pitch_y_mm+12,wall_thickness_mm]) mirror([0,1,0]) rotate([-25,0,0]) cube([outer_width_mm,24,2*tray_height_mm]);
                    }
                    translate([-outer_width_mm/2,0,-20]) cube([outer_width_mm,outer_depth_mm,20+wall_thickness_mm]);
                }
            }
            // connection to next module
            if(front_connector) {
                for(i=[0:1:width_grid_units-1]) {
                    translate([(i+0.5)*grid_pitch_x_mm,0,0]) conhole(0);
                }
            }
            if(right_connector) {
                for(i=[0:1:depth_grid_units-0.8]) {
                    if(i+0.75<right_wall_cutout_y_units || i+0.25>right_wall_cutout_y_units) {
                        translate([outer_width_mm,(i+0.5)*grid_pitch_y_mm,0]) conhole(90);
                    }
                }
            }
            if(rear_connector) {
                for(i=[0:1:width_grid_units-1]) {
                    translate([(i+0.5)*grid_pitch_x_mm,outer_depth_mm,0]) conhole(180);
                }
            }
            if(left_connector) {
                for(i=[0:1:depth_grid_units-0.8]) {
                    if(i+0.75<left_wall_cutout_y_units || i+0.25>left_wall_cutout_y_units) {
                        translate([0,(i+0.5)*grid_pitch_y_mm,0]) conhole(270);
                    }
                }
            }
        } // union
    } // difference
    // add optional support step
    if(rear_knife_riser) { step(width_grid_units,depth_grid_units,grid_pitch_x_mm,grid_pitch_y_mm); }
    if(front_knife_riser) { translate([outer_width_mm,outer_depth_mm,0]) rotate([0,0,180]) step(width_grid_units,depth_grid_units,grid_pitch_x_mm,grid_pitch_y_mm); }
} // module

module section_half(width_grid_units,depth_grid_units,left_wall_cutout_y_units,right_wall_cutout_y_units,front_connector,right_connector,rear_connector,left_connector,rear_knife_riser,front_knife_riser,left_draft_mm,right_draft_mm, front_rim_extension_mm) {

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
                section(width_grid_units,depth_grid_units,left_wall_cutout_y_units,right_wall_cutout_y_units,front_connector,right_connector,rear_connector,left_connector,rear_knife_riser,front_knife_riser,left_draft_mm,right_draft_mm, front_rim_extension_mm);
            //Base for half-connectors: add a material for carving connector holes
            translate([0,outer_depth_mm/2-connector_span_mm/2-wall_thickness_mm,bottom_chamfer_leg_mm]) rotate([-90,0,0])
                linear_extrude(connector_span_mm/2+wall_thickness_mm) polygon([[0,bottom_chamfer_leg_mm],[bottom_chamfer_leg_mm,bottom_chamfer_leg_mm],[0,0]]);
            translate([outer_width_mm-bottom_chamfer_leg_mm,outer_depth_mm/2-connector_span_mm/2-wall_thickness_mm,bottom_chamfer_leg_mm]) rotate([-90,0,0])
                linear_extrude(connector_span_mm/2+wall_thickness_mm) polygon([[bottom_chamfer_leg_mm,bottom_chamfer_leg_mm],[bottom_chamfer_leg_mm,0],[0,bottom_chamfer_leg_mm]]);
        }
        translate([-left_draft_mm-epsilon_mm,outer_depth_mm/2,-epsilon_mm]) cube([outer_width_mm+left_draft_mm+right_draft_mm+front_rim_extension_mm+0.1,outer_depth_mm+0.1,tray_height_mm+0.1]);
        
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
    // The hundreds digit encodes whether the part is an intact tray or a split half.
    full_part_type = is_half ? part_type-100 : part_type;

    // The original positional connector layout is kept as the default.
    default_front_connector = (full_part_type!=103 && full_part_type!=104 && full_part_type!=107);
    default_rear_connector = (full_part_type!=105 && full_part_type!=106 && full_part_type!=107);
    default_left_connector = (full_part_type!=102 && full_part_type!=104 && full_part_type!=105);
    default_right_connector = (full_part_type!=106 && full_part_type!=108);

    use_front_connector = connector_mode==2 ? true : (connector_mode==1 ? false : default_front_connector);
    use_rear_connector  = connector_mode==2 ? true : (connector_mode==1 ? false : default_rear_connector);
    use_left_connector  = connector_mode==2 ? true : (connector_mode==1 ? false : default_left_connector);
    use_right_connector = connector_mode==2 ? true : (connector_mode==1 ? false : default_right_connector);

    if (is_half)
        section_half(
            width_grid_units=tray_width_grid_units,
            depth_grid_units=tray_depth_grid_units,
            left_wall_cutout_y_units=left_wall_cutout_y_units,
            right_wall_cutout_y_units=right_wall_cutout_y_units,
            front_connector=use_front_connector,
            right_connector=use_right_connector,
            rear_connector=use_rear_connector,
            left_connector=use_left_connector,
            rear_knife_riser=rear_knife_riser,
            front_knife_riser=front_knife_riser,
            left_draft_mm=effective_left_offset_mm,
            right_draft_mm=effective_right_offset_mm,
            front_rim_extension_mm=front_rim_extension_mm
        );
    else
        section(
            width_grid_units=tray_width_grid_units,
            depth_grid_units=tray_depth_grid_units,
            left_wall_cutout_y_units=left_wall_cutout_y_units,
            right_wall_cutout_y_units=right_wall_cutout_y_units,
            front_connector=use_front_connector,
            right_connector=use_right_connector,
            rear_connector=use_rear_connector,
            left_connector=use_left_connector,
            rear_knife_riser=rear_knife_riser,
            front_knife_riser=front_knife_riser,
            left_draft_mm=effective_left_offset_mm,
            right_draft_mm=effective_right_offset_mm,
            front_rim_extension_mm=front_rim_extension_mm
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