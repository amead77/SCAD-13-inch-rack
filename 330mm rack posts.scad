include <330mm rack defines.scad>;


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


module rail_1u_holes(slide_side, doublewide = 0, post_height = v_post_height, v_post_cones = post_cones) {
    difference()  {
        union() {
            for (z = [0:post_height-1]) {
                translate([0,0,z*u_height]) {
                    rail_1u_holes_segment(slide_side, doublewide);
                }
            }
            if (v_post_cones == 1) { //top cones for joining rails
                translate([post_width/2, post_width/2, u_height * post_height]) {
                    rotate([0,0,0]) {
                        cylinder(h=post_cone_height, r1=(post_cone_base_diameter/2)-post_top_cone_clearance, r2=(post_cone_top_diameter/2)-post_top_cone_clearance, center=false, $fn=32);
                    }
                }
                if (doublewide == 1) {
                    translate([post_width + post_width/2, post_width/2, u_height * post_height]) {
                        rotate([0,0,0]) {
                            cylinder(h=post_cone_height, r1=(post_cone_base_diameter/2)-post_top_cone_clearance, r2=(post_cone_top_diameter/2)-post_top_cone_clearance, center=false, $fn=32);
                        }
                    }
                }

            }
        }
        if (v_post_cones == 1) { //bottom cones
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