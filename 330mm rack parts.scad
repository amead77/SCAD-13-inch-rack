//
// 330mm / 13 inch rack parts. This is for larger format printers, such as Creality K2 plus, Prusa XL etc
// 
// I designed this specifically to allow the rear of the tray to slide into the post.
// This is for added support on the rear, and because other designs with front and rear attachment
// required dismantling the rack to take out a tray with front and rear attachments.
//
// (c) 2026 Adam Mead.
// 
// This is 330mm from the left edge of the left post, to the right edge of the right post, assuming single posts.

hole_clearance = 0.3; //mm clearance around the 'oles
rack_width = 330;
post_width = 15.875; // standard post width for rack.
u_height = 44.5; // 1U in mm for post
v_post_height = 2; //this is in standard 1U units, not mm.
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

front_panel_thickness = 3.0;
front_panel_undersizing = 0.1; // this is how many mm to undersize the front panel, for better fitting. it affects x and z and is applied to both edges, not just one
front_panel_edge_radius = 0.0; // this is the radius of the rounded edges on the front panel. Set to 0 for square edges.

tray_thickness = 3.0; // this is not affected by post_slide_cutout, as it sits inside
tray_post_clearance = 0.5; //clearance between trays and posts. added to BOTH sides.
tray_side_thickness = 2.0;
tray_slide_thickness = post_slide_cutout - hole_clearance;
// the next 2 lines are used by my version script which is called by 'run on save'
// AUTO-V
version = "v0.1-2026/05/03r78";

module post(slide_side) {
    cube([post_width, post_width, u_height]);
    if (post_sliders == 1) {
        if (slide_side == 0) {
            post_slider_left();
        } else {
            post_slider_right();
        }
    }
}

module post_slides() {
    difference() {
        cube([post_slide_width, post_width, u_height]);    
        translate([0, 0, (hole_offset_z/2)-(post_slide_cutout/2)]) {
            cube([post_slide_cutout, post_width, post_slide_cutout]);
        }
        translate([0, 0, (hole_offset_z/2)-(post_slide_cutout/2)+ hole_spacing]) {
            cube([post_slide_cutout, post_width, post_slide_cutout]);
        }
        translate([0, 0, (hole_offset_z/2)-(post_slide_cutout/2)+ hole_spacing * 2]) {
            cube([post_slide_cutout, post_width, post_slide_cutout]);
        }
    }
}

module post_slider_left() {
    translate([post_width, 0, 0]) {
        post_slides();
    }
}


module post_slider_right() {
    translate([-post_slide_width, 0, 0]) {
        post_slides();
    }
}

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

module rail_1u_holes_segment(slide_side) {
// i've bashed this together rather than math it.

    difference() {
        post(slide_side);
        holes(holes = 3); //1u sections have 3 holes per standard.
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
}


module rail_1u_holes(slide_side) {
    for (z = [0:v_post_height-1]) {
        translate([0,0,z*u_height]) {
            rail_1u_holes_segment(slide_side);
        }
    }
}


module blank_1U_front_panel(holes = 2) {
    difference() {
        if (front_panel_edge_radius > 0) {
            minkowski() {
                cube([rack_width - (front_panel_undersizing*2), front_panel_thickness, u_height - (front_panel_undersizing*2)]);
                rotate([90,0,0]) {
                    cylinder(r=front_panel_edge_radius, h=front_panel_thickness, center=true, $fn=32);
                }
            }
        } else {
            translate([front_panel_undersizing, 0, front_panel_undersizing]) {
                cube([rack_width - (front_panel_undersizing*2), front_panel_thickness, u_height - (front_panel_undersizing*2)]);
            }
        }
        
        holes(holes);
        translate([rack_width - post_width, 0, 0]) {
            holes(holes);
        }
    }
}

module side_slide(count = 3, side = 0) {

    if (side == 0) {
        translate([post_width+post_slide_width+tray_post_clearance, 0, 0]) {
            cube([tray_side_thickness, rack_width, u_height]);
        }
        translate([post_width+tray_post_clearance, 0, (hole_offset_z/2)-(post_slide_cutout/2.1)]) {
            cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
        }
        if (count > 1) {
            translate([post_width+tray_post_clearance, 0, (hole_offset_z/2)-(post_slide_cutout/2.1)+ hole_spacing]) {
                cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
            }
        }
        if (count > 2) {
            translate([post_width+tray_post_clearance, 0, (hole_offset_z/2)-(post_slide_cutout/2.1)+ hole_spacing * 2]) {
                cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
            }
        }
    } else {



    }
}

module tray_left_slide() {
        rear_slide(count = 3, side = 0);
    }


module blank_1U_tray() {
    blank_1U_front_panel();
    translate([post_width+tray_post_clearance+post_slide_width, 0, front_panel_undersizing]) {
        cube([((rack_width - (post_width*2)) - (tray_post_clearance*2)-(post_slide_width*2)), rack_width, tray_thickness]);
    }
    side_slide(count = 3);
}


module assembly() {
// this is used to render/see all the bits together, as an example.
    render() {
        rail_1u_holes(0);
        
        translate([rack_width - post_width, 0, 0]) {
            rail_1u_holes(1);
        }
        
        translate([post_width, rack_width, 0]) {        
            rotate([0,0,180]) {
                rail_1u_holes(1);
            }
            translate([rack_width - post_width, 0, 0]) {
                rotate([0,0,180]) {
                    rail_1u_holes(0);
                }
            }
        }

        translate([0,-5, 0]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            blank_1U_tray();
        }
    }
}
assembly();