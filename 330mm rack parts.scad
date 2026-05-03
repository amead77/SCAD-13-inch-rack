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
// the next 2 lines are used by my version script which is called by 'run on save'
// AUTO-V
version = "v0.1-2026/05/03r217";

module post(slide_side = 0, doublewide = 0) {
    union() {
        cube([post_width, post_width, u_height]);
        if (doublewide == 1) {
            translate([post_width, 0, 0]) {
                cube([post_width, post_width, u_height]);
            }
        }
        if (post_sliders == 1) {
            if (slide_side == 0) {
                post_slider_left();
            } else {
                if (doublewide == 1) {
                    translate([post_width, 0, 0]) {
                        post_slider_left();
                    }
                }
                post_slider_right();
            }
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

module rail_1u_holes_segment(slide_side, doublewide = 0) {
// i've bashed this together rather than math it.

    difference() {
        post(slide_side, doublewide);
        holes(holes = 3); //1u sections have 3 holes per standard.
        nut_holes(holes = 3);
        if (doublewide == 1) {
            translate([post_width, 0, 0]) {
                holes(holes = 3); //1u sections have 3 holes per standard.
                nut_holes(holes = 3);
            }
        }
    }
}


module rail_1u_holes(slide_side, doublewide = 0) {
    difference()  {
        union() {
            for (z = [0:v_post_height-1]) {
                translate([0,0,z*u_height]) {
                    rail_1u_holes_segment(slide_side, doublewide);
                }
            }
            if (post_cones == 1) { //top cones for joining rails
                translate([post_width/2, post_width/2, u_height * v_post_height]) {
                    rotate([0,0,0]) {
                        cylinder(h=post_cone_height, r1=(post_cone_base_diameter/2)-post_top_cone_clearance, r2=(post_cone_top_diameter/2)-post_top_cone_clearance, center=false, $fn=32);
                    }
                }
                if (doublewide == 1) {
                    translate([post_width + post_width/2, post_width/2, u_height * v_post_height]) {
                        rotate([0,0,0]) {
                            cylinder(h=post_cone_height, r1=(post_cone_base_diameter/2)-post_top_cone_clearance, r2=(post_cone_top_diameter/2)-post_top_cone_clearance, center=false, $fn=32);
                        }
                    }
                }

            }
        }
        if (post_cones == 1) { //bottom cones
            translate([post_width/2, post_width/2, 0]) {
                cylinder(h=post_cone_height-post_top_cone_clearance, r1=(post_cone_base_diameter/2), r2=(post_cone_top_diameter/2), center=false, $fn=32);
            }
            if (doublewide == 1) {
                translate([post_width + post_width/2, post_width/2, 0]) {
                    cylinder(h=post_cone_height-post_top_cone_clearance, r1=(post_cone_base_diameter/2), r2=(post_cone_top_diameter/2), center=false, $fn=32);
                }
            }
        }

    }
}


module blank_1U_front_panel(holes = front_panel_hole_count) {
    difference() {
        union() {
            if (front_panel_edge_radius > 0) {
                translate([front_panel_undersizing + front_panel_edge_radius, 0, front_panel_undersizing + front_panel_edge_radius]) {
                    minkowski() {
                        cube([rack_width - (front_panel_undersizing*2) - (front_panel_edge_radius*2), front_panel_thickness, u_height - (front_panel_undersizing*2) - (front_panel_edge_radius*2)]);
                        rotate([90,0,0]) {
                            cylinder(r=front_panel_edge_radius, h=0.01, center=true, $fn=32);
                        }
                    }
                }
            } else {
                translate([front_panel_undersizing, 0, front_panel_undersizing]) {
                    cube([rack_width - (front_panel_undersizing*2), front_panel_thickness, u_height - (front_panel_undersizing*2)]);
                }
            }
        }
        
        translate([0, -1, 0]){
            holes(holes);
            translate([rack_width - post_width, 0, 0]) {
                holes(holes);
            }
        }
    }
}

module side_slide(count = 3, side = 0) {
    union() {
        if (side == 0) {
            translate([post_width+post_slide_width+tray_post_clearance, front_panel_thickness, 0]) {
                if (count == 1) {
                    cube([tray_side_thickness, rack_width, u_height - hole_spacing * 2]);
                } else if (count == 2) {
                    cube([tray_side_thickness, rack_width, u_height - hole_spacing]);
                } else if (count == 3) {
                cube([tray_side_thickness, rack_width, u_height]);
                }
            }
            if (count >= 1) {
                translate([post_width+tray_post_clearance, front_panel_thickness, (hole_offset_z/2)-(post_slide_cutout/2.1)]) {
                    cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
                }
            }
            if (count >= 2) {
                translate([post_width+tray_post_clearance, front_panel_thickness, (hole_offset_z/2)-(post_slide_cutout/2.1)+ hole_spacing]) {
                    cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
                }
            }
            if (count >= 3) {
                translate([post_width+tray_post_clearance, front_panel_thickness, (hole_offset_z/2)-(post_slide_cutout/2.1)+ hole_spacing * 2]) {
                    cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
                }
            }
        } else {
            translate([rack_width - post_width - post_slide_width - tray_post_clearance - tray_side_thickness, front_panel_thickness, 0]) {
                if (count == 1) {
                    cube([tray_side_thickness, rack_width, u_height - hole_spacing * 2]);
                } else if (count == 2) {
                    cube([tray_side_thickness, rack_width, u_height - hole_spacing]);
                } else if (count == 3) {
                    cube([tray_side_thickness, rack_width, u_height]);
                }
            }
            if (count >= 1) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, (hole_offset_z/2)-(post_slide_cutout/2.1)]) {
                    cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
                }
            }
            if (count >= 2) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, (hole_offset_z/2)-(post_slide_cutout/2.1)+ hole_spacing]) {
                    cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
                }
            }
            if (count >= 3) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, (hole_offset_z/2)-(post_slide_cutout/2.1)+ hole_spacing * 2]) {
                    cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
                }
            }
        }
    }
}



module blank_1U_tray(side_count = 3) {
    //use this as a primitive to make trays.
    blank_1U_front_panel();
    translate([post_width+tray_post_clearance+post_slide_width, 0, front_panel_undersizing]) {
        cube([((rack_width - (post_width*2)) - (tray_post_clearance*2)-(post_slide_width*2)), rack_width+front_panel_thickness, tray_thickness]);
    }
    side_slide(side = 0, count = side_count);
    side_slide(side = 1, count = side_count);
}


module assembly() {
// this is used to render/see all the bits together, as an example.
    render() {
        rail_1u_holes(0);
        
        translate([rack_width - post_width, 0, 0]) {
            rail_1u_holes(slide_side = 1, doublewide = 1);
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

        translate([0, -front_panel_thickness, 0]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            color("cyan") {
                blank_1U_tray(1);
            }
        }
        translate([0, -front_panel_thickness, u_height]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            color("red") {
                blank_1U_tray(2);
            }
        }
        translate([0, -front_panel_thickness, u_height * 2]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            color("cyan") {
                blank_1U_tray(3);
            }
        }
    }
}
assembly();