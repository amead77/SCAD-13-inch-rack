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



include <330mm rack posts.scad>;
include <330mm rack tray.scad>;
include <330mm rack defines.scad>; //some of these are overrode below.


part = 0; // 0 = assembly, 1 = posts, 2 = trays, 3 = feet.





// these are the basic setup for the posts.
post_u_height = 1; //how many UI high
post_doublewide = 0; // 1 for double wide, 0 for single wide. This is used by the post module, and the rail_1u_holes_segment module, which calls the post module. The post module is used by the assembly module, which is what is rendered when part = 0. So changing this will change the posts in the assembly render, but not if you render just the posts by setting part = 1.
post_slider = 1;
post_sliders = 1; //1= add sliders, 0 = no sliders.
cones = 1; //this is for joining rails
hole_clearance = 0.3; //mm clearance around the 'oles
hole_d = 6.0 + hole_clearance; //screw holes dia
nut_diameter = 10.0 + hole_clearance; //10mm for m6
nut_thickness = 5.0 + hole_clearance; //5mm for m6

//these are the basic setup for the front panel.
front_panel_edge_radius = 2.0;
front_panel_thickness = 3.0;
front_panel_hole_count = 2; //this is per side. 2 or 3.

//these are the basic setup for the trays, the trays also use the defines from the front panel.
tray_thickness = 3.0; // this is not affected by post_slide_cutout, as it sits inside
tray_post_clearance = 0.5; //clearance between trays and posts. added to BOTH sides.
tray_side_thickness = 2.0;
tray_slide_thickness = post_slide_cutout - hole_clearance;
tray_side_height = 2;

tray_slide_out = 60; //this is just for the assembly demo.

module assembly() {
// this is used to render/see all the bits together, as an example.
    render() {
        rail_1u_holes(slide_side = 0, doublewide = 0,  post_u_height, cones);

        translate([rack_width - post_width, 0, 0]) {
            rail_1u_holes(slide_side = 1, doublewide = 0, post_u_height, cones);
        }
        
        translate([post_width, rack_width, 0]) {        
            rotate([0,0,180]) {
                rail_1u_holes(1, 0, post_u_height, cones);
            }
            translate([rack_width - post_width, 0, 0]) {
                rotate([0,0,180]) {
                    rail_1u_holes(0, 0, post_u_height, cones);
                }
            }
        }

        translate([0, -front_panel_thickness, 0]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            color("cyan") {
                blank_1U_tray(tray_side_height, front_panel_edge_radius, front_panel_hole_count);
            }
        }
        translate([0, -front_panel_thickness-tray_slide_out, u_height]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            color("red") {
                blank_1U_tray(tray_side_height, front_panel_edge_radius, front_panel_hole_count);
            }
        }
        translate([0, -front_panel_thickness, u_height * 2]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            color("cyan") {
                blank_1U_tray(tray_side_height, front_panel_edge_radius, front_panel_hole_count);
            }
        }
    }
}


if (part == 0) {

    assembly();
} else {
    if (part == 1) {
        render() {
            rail_1u_holes(slide_side = post_slider, doublewide = post_doublewide, post_u_height, cones);
        }
    } else {
        if (part == 2) {
            render() {
                blank_1U_tray(tray_side_height, front_panel_edge_radius, front_panel_hole_count);
            }
        } else {
            if (part == 3) {
        render() {
            footer();
        }
            }
        }
    }
}