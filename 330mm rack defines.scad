hole_clearance = 0.3; //mm clearance around the 'oles
rack_width = 330;
post_width = 15.875; // standard post width for rack.
u_height = 44.5; // 1U in mm for post
v_post_height = 3; //this is in standard 1U units, not mm.
post_height = u_height * v_post_height; // total height of posts, in mm.
hole_d = 6.0 + hole_clearance; //screw holes dia
hole_offset_x = post_width/2 + hole_d/2; //should be central
hole_offset_z = 12.7; // standard spacing. half this for between 1U sections.
hole_spacing = 15.875; //rail hole spacing

nut_diameter = 10.0 + hole_clearance; //10mm for m6
nut_diameter_point = nut_diameter / cos(30); // diameter of the hexagon nut point to point
nut_thickness = 5.0 + hole_clearance; //5mm for m6

post_slide_width = 3.0; //this is the width of the cutout for the trays to slide into.
post_slide_cutout = 3.2; //this is the height of the cutout for the trays to slide into

post_sliders = 1; //1= add sliders, 0 = no sliders.

post_cone_base_diameter = 10.0;
post_cone_top_diameter = 4.0;
post_cone_height = 2.0;
post_top_cone_clearance = 0.1; // this is how much smaller the top cone is than the bottom cone, for clearance when joining.
post_cones = 1; //1 = add cones to top and difference from the bottom of the post. This is for joining.

front_panel_thickness = 3.0;
front_panel_undersizing = 0.1; // this is how many mm to undersize the front panel, for better fitting. it affects x and z and is applied to both edges, not just one
front_panel_edge_radius = 2.0; // this is the radius of the rounded edges on the front panel. Set to 0 for square edges.
front_panel_hole_count = 2; //this is per side. 2 or 3.
tray_thickness = 3.0; // this is not affected by post_slide_cutout, as it sits inside
tray_post_clearance = 0.5; //clearance between trays and posts. added to BOTH sides.
tray_side_thickness = 2.0;
tray_slide_thickness = post_slide_cutout - hole_clearance;

footer_height = 10.0;
footer_width = 1; //this is in POST WIDTHS, not mm.


// the next 2 lines are used by my version script which is called by 'run on save'
// AUTO-V
version = "v0.1-2026/05/03r240";


module holes(holes = 2) {
    translate([post_width/2, ((post_width)-post_width/2 ), hole_offset_z/2]) {
        rotate([90,0,0]) {
            cylinder(d=hole_d, h=post_width, center=true, $fn=32);
        }
    }

    if (holes == 3 ) {
        translate([post_width/2, ((post_width)-post_width/2 ), (hole_offset_z/2) + hole_spacing]) {
            rotate([90,0,0]) {
                cylinder(d=hole_d, h=post_width, center=true, $fn=32);
            }
        }
    }

    translate([post_width/2, ((post_width)-post_width/2 ), (hole_offset_z/2)+ (hole_spacing*2)]) {
        rotate([90,0,0]) {
            cylinder(d=hole_d, h=post_width, center=true, $fn=32);
        }
    }
}


module nut_holes(holes = 2) {

        translate([post_width/2, ((post_width)-nut_thickness/2 ), hole_offset_z/2]) {
            rotate([90,0,0]) {
                cylinder(d=nut_diameter_point, h=nut_thickness, center=true, $fn=6);
            }
        }

        translate([post_width/2, ((post_width)-nut_thickness/2 ), (hole_offset_z/2) + hole_spacing]) {
            rotate([90,0,0]) {
                cylinder(d=nut_diameter_point, h=nut_thickness, center=true, $fn=6);
            }
        }

        translate([post_width/2, ((post_width)-nut_thickness/2 ), (hole_offset_z/2)+ (hole_spacing*2)]) {
            rotate([90,0,0]) {
                cylinder(d=nut_diameter_point, h=nut_thickness, center=true, $fn=6);
            }
        }

}