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
//
// The parts...
// Posts. These are in 1U segments. They can be single or double wide. They can also have a slide on one or both sides, for guiding and supporting trays.
// Trays. These are available in 1U, 2U and a variable size. The 1U and 2U ones I created initially to test, the variable one can also have a rear back panel, making it a drawer.
// Panels. These are blanking panels, but the design is also used by the trays.
// Footer/Header. These are added to the post to allow joining the front/rear posts together using the joiner. (optional)
// Joiners. The attach to the footer/header and span the gap between front and rear posts. (optional)
//

// AUTO-V
version = "v0.1-2026/05/04r32";


include <330mm rack posts.scad>;
include <330mm rack tray.scad>;
include <330mm rack defines.scad>; //some of these are overrode below.
include <330mm rack custom tray 01.scad>;

// Chose the part to make, or assembly to see all
part = "assembly"; // [assembly, post, base joiner, top joiner, 1U tray, 2U tray, variable tray, halfUpanel, 1U panel, 2U panel, variable panel]






// ** these are the basic setup for the posts.

//how many U high
post_u_height = 6; 

// 1 for double wide, 0 for single wide.
post_doublewide = 0; // [0, 1]

//0 = none, 1 = left, 2 = right, 3 = both.
slide_side = 0; 


cones = 1; //this is for joining rails
// set to 0 to not include the footer, 1 to include it. The footer is a small piece at the bottom of the rack
footer_include = 1; 
// if you include the header and or footer, this adds a single extra piece to top and bottom of the posts, which is for the joiner to attach to
header_include = 1; 

hole_clearance = 0.3; //mm clearance around the 'oles
hole_d = 6.0 + hole_clearance; //screw holes dia
nut_diameter = 10.0 + hole_clearance; //10mm for m6
nut_thickness = 6.0 + hole_clearance; //5mm for m6


// ** these are the basic setup for the front panel.

front_panel_edge_radius = 2.0;
front_panel_thickness = 3.0;
front_panel_hole_count = 2; //this is per side. 2 or 3 or 4 or 6.
front_panel_height = 1.5; // in U. 1 = 1U high, 2 = 2U high etc.

// ** these are the basic setup for the trays, the trays also use the defines from the front panel.

tray_thickness = 5.0; // this is not affected by post_slide_cutout, as it sits inside

//clearance between trays and posts. added to BOTH sides.
tray_post_clearance = 0.5; 
// thickness of the side of the tray
tray_side_thickness = 2.5;
tray_slide_thickness = post_slide_cutout - hole_clearance;

//this is in hole spacing, 1 = 1 hole up, 2 = 2 holes up etc.
tray_side_height = 1.25; 

// set to 0 for no rear panel, 1 for a rear panel. this creates a drawer
tray_back_panel = 0;

//this is just for the assembly demo.
tray_slide_out = 60; 

base_join = 1;
top_join = 1;
base_panel = 1; //a blanking panel and reinforcement. 0.5U high
top_panel = 1; //a blanking panel and reinforcement. 0.5U high


module assembly() {
// this is used to render/see all the bits together, as an example.
    render() {

        //the posts

        if (post_doublewide == 0) {
        rail_1u_holes(slide_side = 1, doublewide = post_doublewide,  post_u_height, cones);
        } else {
            translate([-post_width, 0, 0]) {
                rail_1u_holes(slide_side = 1, doublewide = post_doublewide, post_u_height, cones);
            }
        }
        translate([rack_width - post_width, 0, 0]) {
            rail_1u_holes(slide_side = 2, doublewide = post_doublewide, post_u_height, cones);
        }
        
        translate([post_width, rack_width, 0]) {        
            rotate([0,0,180]) {
                rail_1u_holes(2, post_doublewide, post_u_height, cones);
            }
            
            if (post_doublewide == 0) {
                translate([rack_width - post_width, 0, 0]) {
                    rotate([0,0,180]) {
                        rail_1u_holes(1, post_doublewide, post_u_height, cones);
                    }
                }
            } else {
                translate([rack_width, 0, 0]) {
                    rotate([0,0,180]) {
                        rail_1u_holes(1, post_doublewide, post_u_height, cones);
                    }
                }
            }

        }

        // the base joins

        if (base_join == 1) {
            if (post_doublewide == 0) {
                base_joiner(doublewide = post_doublewide);
                translate([rack_width - post_width, 0, 0]) {
                    base_joiner(doublewide = post_doublewide);
                }
            } else {
                translate([-post_width, 0, 0]) {
                    base_joiner(doublewide = post_doublewide);
                }
                translate([rack_width - post_width, 0, 0]) {
                    base_joiner(doublewide = post_doublewide);
                }
            }
        }
        if (base_panel == 1) {
            translate([0, -front_panel_thickness, -hole_offset_z*2]) {
                color("orange") {
                    blank_05U_front_panel();
                }
            }
            //also put on on the rear, for added support
             translate([rack_width, rack_width+front_panel_thickness, -hole_offset_z*2]) {
                rotate([0,0,180]) {
                    color("orange") {
                        blank_05U_front_panel();
                    }
                }
            }

        }

        // the top joins

        if (top_join == 1) {
            if (post_doublewide == 0) {
                translate([0, 0, u_height*post_u_height]) {
                    base_joiner(doublewide = post_doublewide, bottom = 0);
                }
                translate([rack_width - post_width, 0, u_height*post_u_height]) {
                    base_joiner(doublewide = post_doublewide, bottom = 0);
                }
            } else {
                translate([-post_width, 0, u_height*post_u_height]) {
                    base_joiner(doublewide = post_doublewide, bottom = 0);
                }
                translate([rack_width - post_width, 0, u_height*post_u_height]) {
                    base_joiner(doublewide = post_doublewide, bottom = 0);
                }
             }
        }

        // the top panel, to join the top of post to bracket

        if (top_panel == 1) {
            translate([0, -front_panel_thickness, (u_height*post_u_height)]) {
                color("orange") {
                    blank_05U_front_panel();
                }
            }
        }
        
        //also put on on the rear, for added support
        
         translate([rack_width, rack_width+front_panel_thickness, (u_height*post_u_height)]) {
            rotate([0,0,180]) {
                color("orange") {
                    blank_05U_front_panel();
                }
            }
        }

        // the trays. These are just for demo purposes. there is a 0.5U one, a 1U one, a 2U one and a variable one.
        // use what you want, the variable one is the better, but the hole spacing for larger sizes can be more annoying
        
        translate([0, -front_panel_thickness, 0]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            color("cyan") {
                blank_variable_tray(1, 0.6, 2);

                //blank_1U_tray(tray_side_height, front_panel_edge_radius, front_panel_hole_count);
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
        translate([0, -front_panel_thickness, u_height * 3]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            color("orange") {
                blank_2U_tray(tray_side_height, front_panel_edge_radius, front_panel_hole_count);
            }
        }
        translate([0, -front_panel_thickness, u_height * 5]) {
            color("green") {
                custom_tray_01();
            }
        }
    }
}

// [assembly, post, base joiner, top joiner, 1U tray, 2U tray, variable tray, halfUpanel, 1U panel, 2U panel, variable panel]
if (part == "assembly") {
    assembly();
}

if (part == "post") {
    render() {
        rail_1u_holes(slide_side = slide_side, doublewide = post_doublewide, post_u_height, cones);
    }
}

if (part == "base joiner") {
    render() {
        if (post_doublewide == 0) {
            base_joiner(doublewide = post_doublewide);
        } else {
            translate([-post_width, 0, 0]) {
                base_joiner(doublewide = post_doublewide);
            }
        }
    }
}

if (part == "top joiner") {
    render() {
        if (post_doublewide == 0) {
            base_joiner(doublewide = post_doublewide, bottom = 0);
        } else {
            translate([-post_width, 0, 0]) {
                base_joiner(doublewide = post_doublewide, bottom = 0);
            }
        }
    }
}

if (part == "1U tray") {
    render() {
        blank_1U_tray(tray_side_height, front_panel_edge_radius, front_panel_hole_count);
    }
} 

if (part == "2U tray") {
    render() {
        blank_2U_tray(tray_side_height, front_panel_edge_radius, front_panel_hole_count);
    }
} 

if (part == "variable tray") {
    render() {
        blank_variable_tray(panel_u_size = front_panel_height, tray_u_size = tray_side_height, holes = front_panel_hole_count, back_panel = tray_back_panel);
    }
}


    
if (part == "halfUpanel") {
    color("orange") {
        blank_05U_front_panel();
    }
}

if (part == "1U panel") {
    color("orange") {
        blank_1U_front_panel(holes = front_panel_hole_count);
    }
}

if (part == "2U panel") {
    color("orange") {
        blank_2U_front_panel(holes = front_panel_hole_count);
    }
}

if (part == "variable panel") {
    color("orange") {
        blank_variable_front_panel(u_size = front_panel_height, holes = front_panel_hole_count);
    }
}