include <330mm rack defines.scad>;
include <330mm rack posts.scad>;

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



module blank_1U_tray(side_count = 3, edge_radius = 2, holes = front_panel_hole_count) {
    //use this as a primitive to make trays.
    blank_1U_front_panel(holes);
    translate([post_width+tray_post_clearance+post_slide_width, 0, front_panel_undersizing]) {
        cube([((rack_width - (post_width*2)) - (tray_post_clearance*2)-(post_slide_width*2)), rack_width+front_panel_thickness, tray_thickness]);
    }
    side_slide(side = 0, count = side_count);
    side_slide(side = 1, count = side_count);
}
