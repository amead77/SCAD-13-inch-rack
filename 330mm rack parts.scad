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
include <330mm rack defines.scad>;












module assembly() {
// this is used to render/see all the bits together, as an example.
    render() {
        rail_1u_holes(slide_side = 1, doublewide = 0);

        translate([rack_width - post_width, 0, 0]) {
            rail_1u_holes(slide_side = 1, doublewide = 1);
        }
        
        translate([post_width, rack_width, 0]) {        
            rotate([0,0,180]) {
                rail_1u_holes(1, 0);
            }
            translate([rack_width - post_width, 0, 0]) {
                rotate([0,0,180]) {
                    rail_1u_holes(1, 1);
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