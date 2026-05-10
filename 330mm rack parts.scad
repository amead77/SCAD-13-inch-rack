//
// ***************************************************************************************
// ***    This is the main file for creating parts, use the customiser in OpenSCAD.    ***
// *** To create custom trays, look at "330mm rack custom tray 01.scad" for an example ***
// ***************************************************************************************
//
// 330mm / 13 inch rack parts. This is for larger format printers, such as Creality K2 plus, Prusa XL etc
// This is 330mm from the left edge of the left post, to the right edge of the right post, assuming single posts.
//
// THERE IS NOT REQUIREMENT FOR IT TO BE 330mm. You can override all of the defaults.
//
// I designed this specifically to allow the rear of the tray to slide into the post.
// This is for added support on the rear, and because other designs with front and rear attachment
// required dismantling the rack to take out a tray with front and rear attachments.
// Before printing, make some small test pieces to check tolerances etc.
//
// (c) 2026 Adam Mead. But go nuts with it. GPLv3
// 
//
// The parts...
// Posts. These are in 1U segments. They can be single or double wide. They can also have a slide on one or both sides, for guiding and supporting trays.
// Trays. These are available in 1U, 2U and a variable size. The 1U and 2U ones I created initially to test, the variable one can also have a rear back panel, making it a drawer.
// Panels. These are blanking panels, but the design is also used by the trays.
// Footer/Header. These are added to the post to allow joining the front/rear posts together using the joiner. (optional)
// Joiners. The attach to the footer/header and span the gap between front and rear posts. (optional)
//
// The front panels/trays can have a logo embossed/etched. This is built into the function. See the custom tray for example. "330mm rack custom tray 01.scad".
//
// AI use notes: The variable size tray/panel is AI created. The rest was 99% me, with some help from AI when getting stuck. I should probably go through and comment my code better :S
// AI is not good at 3d design (yet), so if you want to create custom parts using AI, at least get the basic design done by hand, then get AI to assist with bits you're stuck on.
// I was going to up to github, then realised I had only commented a small part, so AI did ~70% of the comments.



/**
//next 2 lines used only by my 'on save' script. can be ignored otherwise.
//AUTO-V
version = "v0.1-2026/05/10r60";
**/

include <330mm rack posts.scad>;
include <330mm rack tray.scad>;
include <330mm rack defines.scad>; //some of these are overrode below.
include <330mm rack custom tray 01.scad>;
include <ugreen um106x.scad>; // switch dimensions
include <rpi5.scad>;
include <330mm rack side panel.scad>;

// Chose the part to make, or assembly to see all
part = "assembly"; // [assembly, post, base joiner, top joiner, 1U tray, 2U tray, variable tray, halfUpanel, 1U panel, 2U panel, variable panel, post joins, um106x, rpi5, side panel]


// ** these are the basic setup for the posts.

//how many U high
post_u_height = 6; 

// 1 for double wide, 0 for single wide.
post_doublewide = 1; // [0, 1]

//0 = none, 1 = left, 2 = right, 3 = both.
slide_side = 0; 


//this is for joining rails or header/footer joins. creates a cone on the top of the post, and a matching cone on the bottom of the joiner, to allow them to slot together for easier assembly
cones = 1; 

// set to 0 to not include the footer, 1 to include it. The footer is a small piece at the bottom of the rack
footer_include = 1; 

// if you include the header and or footer, this adds a single extra piece to top and bottom of the posts, which is for the joiner to attach to
header_include = 1; 

//mm clearance around the 'oles
hole_clearance = 0.3; 

//screw holes dia
hole_d = 6.0 + hole_clearance; 

//10mm for m6
nut_diameter = 10.0 + hole_clearance; 

//5mm for m6 ** I increased this from 5 to 6 because my screws are a bit stumpy. extra 1mm embeds it deeper. (that's what she said)
nut_thickness = 6.0 + hole_clearance; 

// set to 1 to add the side panel, 0 for no side panel. the side panel is designed to work with the double wide posts, but can be used with single wide and longer screws if you want.
add_side_panel = 1; 

// ** these are the basic setup for the front panel.

// [[the 2.01 and 2.99 values are because of OpenSCAD customiser, if i put 2.0, it will not allow you to use decimal values, so 2, 3, 4
// is accepted, but 2.5 will not be enterable]

// rounding of the front panel edges. set to 0 for square edges.
front_panel_edge_radius = 2.01; //should be 2.0, but customiser...

// how thick the front panel is, go too thick and your screws might not reach.
front_panel_thickness = 2.99; //should be 3.0

//this is per side. 2 or 3 or 4 or 6. for certain panels and hole spacing just play with this.
front_panel_hole_count = 2; 

// this is how many U high the front panel is. 1 = 1U high, 2 = 2U high etc.
front_panel_height = 1.5;

// ** these are the basic setup for the trays, the trays also use the defines from the front panel.

// how thick the tray base is.
tray_thickness = 5.0; 

//clearance between trays and posts. added to BOTH sides.
tray_post_clearance = 0.5; 

// thickness of the side of the tray, the wall.
tray_side_thickness = 2.5;
tray_slide_thickness = post_slide_cutout - hole_clearance;

//this is in hole spacing, 1 = 1 hole up, 2 = 2 holes up etc. 0.25 for a low profile tray. Experiment with the sizes.
tray_side_height = 1.25; 

// set to 0 for no rear panel, 1 for a rear panel. this creates a drawer
tray_back_panel = 0;

// how far back the tray projects
tray_y = 0.99;

//this is just for the assembly demo. has no other function other than to show a tray partially slid out.
tray_slide_out = 150; 

//this is how many supports the base and top joins have. you can have more than just the 4 corners.
base_support_count = 3;

// the top beam for connecting 2 posts/rails together, front to rear.
header_top_beam_thickness = 10.0;
// the base beam for connecting 2 posts/rails together, front to rear.
footer_base_beam_thickness = 5.0; 



base_join = 1;
top_join = 1;
base_panel = 1; //a blanking panel and reinforcement. 0.5U high
top_panel = 1; //a blanking panel and reinforcement. 0.5U high


module assembly() {
// this is used to render/see all the bits together, as an example.
    render() {

        //POST CREATION
        support_count = (base_support_count < 2) ? 2 : base_support_count;
        for (i = [0:support_count-1]) {
            y_pos = i * (rack_width - post_width) / (support_count - 1);
            is_rear_post = (i == (support_count - 1));
            post_span_x = (post_doublewide == 1) ? (post_width * 2) : post_width;

            // Left-side post at this support position
            if (post_doublewide == 0) {
                translate([0, y_pos, 0]) {
                    if (is_rear_post) {
                        // Rear posts face the opposite way so nut traps are on the rack-inside face.
                        translate([post_span_x, post_width, 0]) {
                            rotate([0, 0, 180]) {
                                rail_1u_holes(slide_side = 2, doublewide = post_doublewide, post_u_height, cones);
                            }
                        }
                    } else {
                        rail_1u_holes(slide_side = 1, doublewide = post_doublewide, post_u_height, cones);
                    }
                }
            } else {
                translate([-post_width, y_pos, 0]) {
                    if (is_rear_post) {
                        translate([post_span_x, post_width, 0]) {
                            rotate([0, 0, 180]) {
                                rail_1u_holes(slide_side = 2, doublewide = post_doublewide, post_u_height, cones);
                            }
                        }
                    } else {
                        rail_1u_holes(slide_side = 1, doublewide = post_doublewide, post_u_height, cones);
                    }
                }
            }

            // Right-side post at this support position
            translate([rack_width - post_width, y_pos, 0]) {
                if (is_rear_post) {
                    translate([post_span_x, post_width, 0]) {
                        rotate([0, 0, 180]) {
                            rail_1u_holes(slide_side = 1, doublewide = post_doublewide, post_u_height, cones);
                        }
                    }
                } else {
                    rail_1u_holes(slide_side = 2, doublewide = post_doublewide, post_u_height, cones);
                }
            }
        }
        //END POST CREATION

        // the base joins

        if (base_join == 1) {
            color("blue") {
                if (post_doublewide == 0) {
                    base_joiner(doublewide = post_doublewide, supports = base_support_count, bottom = 1, beam_thickness = footer_base_beam_thickness);
                    translate([rack_width - post_width, 0, 0]) {
                        base_joiner(doublewide = post_doublewide, supports = base_support_count, bottom = 1, beam_thickness = footer_base_beam_thickness);
                    }
                } else {
                    translate([-post_width, 0, 0]) {
                        base_joiner(doublewide = post_doublewide, supports = base_support_count, bottom = 1, beam_thickness = footer_base_beam_thickness);
                    }
                    translate([rack_width - post_width, 0, 0]) {
                        base_joiner(doublewide = post_doublewide, supports = base_support_count, bottom = 1, beam_thickness = footer_base_beam_thickness);
                    }
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
            color("blue") {
                if (post_doublewide == 0) {
                    translate([0, 0, u_height*post_u_height]) {
                        base_joiner(doublewide = post_doublewide, bottom = 0, supports = base_support_count, beam_thickness = header_top_beam_thickness);
                    }
                    translate([rack_width - post_width, 0, u_height*post_u_height]) {
                        base_joiner(doublewide = post_doublewide, bottom = 0, supports = base_support_count, beam_thickness = header_top_beam_thickness);
                    }
                } else {
                    translate([-post_width, 0, u_height*post_u_height]) {
                        base_joiner(doublewide = post_doublewide, bottom = 0, supports = base_support_count, beam_thickness = header_top_beam_thickness);
                    }
                    translate([rack_width - post_width, 0, u_height*post_u_height]) {
                        base_joiner(doublewide = post_doublewide, bottom = 0, supports = base_support_count, beam_thickness = header_top_beam_thickness);
                    }
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


        //the side panel, use with a doublewide post OR a single wide post and longer screws.
        if (add_side_panel == 1) {
            if (post_doublewide == 0) {
                translate([-c_panel_thickness, 0, 0]) {
                    side_panel();
                }
            } else {
                 translate([-(post_width+ c_panel_thickness), -c_panel_thickness, 0]) {
                    side_panel();
                }
            }
            
        }




        // the trays. These are just for demo purposes. there is a 0.5U one, a 1U one, a 2U one and a variable one.
        // use what you want, the variable one is the better, but the hole spacing for larger sizes can be more annoying
        
        translate([0, -front_panel_thickness, 0]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            color("cyan") {
                blank_variable_tray(1, 0.6, 1, back_panel = tray_back_panel);

                //blank_1U_tray(tray_side_height, front_panel_edge_radius, front_panel_hole_count);
            }
        }
        translate([0, -(front_panel_thickness+tray_slide_out), u_height]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            //color("red") {
            rpi5_tray();
            //}
        }
        translate([0, -front_panel_thickness, u_height * 2]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            //color("cyan") {
            //    blank_1U_tray(tray_side_height, front_panel_edge_radius, front_panel_hole_count);
            //}
            ug_um106x_tray(showmodel = true);
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

module assembly_info_panel() {
    panel_w = 420;
    panel_h = 40;
    panel_t = 2;
    text_t = 1;
    text_size = 5.5;
    text_line = 9;



    color("black") {
        translate([0, 0, 0]) {
            rotate([0, 0, 0]) {
                linear_extrude(height = text_t) {
                    text("Assembly view is demo-only. Use Customizer for individual parts.", size = text_size);
                }
            }
        }

        translate([0, -20, 0]) {
            rotate([0, 0, 0]) {
                linear_extrude(height = text_t) {
                    text("Set base_join/top_join for joiners, base_panel/top_panel for blanking panels, add_side_panel for side panel.", size = text_size);
                }
            }
        }

        translate([0, -40, 0]) {
            rotate([0, 0, 0]) {
                linear_extrude(height = text_t) {
                    text("If using post joiners, enable header_include/footer_include so joiners can attach.", size = text_size);
                }
            }
        }
    }
}

// [assembly, post, base joiner, top joiner, 1U tray, 2U tray, variable tray, halfUpanel, 1U panel, 2U panel, variable panel]
if (part == "assembly") {
    assembly();
    translate([-300, -150, 0]) {
        assembly_info_panel();
    }

    echo("The assembly view is for demonstration purposes. use the customiser to create individual parts.");
    echo("If you want top/bottom (front to rear post joiners), set base_join and top_join to 1. If you want the front panel to be a blanking panel, set base_panel and top_panel to 1. If you want the side panel, set add_side_panel to 1.");
    echo("Notes that if you use post joiners, you'll need to use the header_include and footer_include options to add the extra pieces to the top and bottom of the posts for the joiners to attach to.");

}

if (part == "post") {
    render() {
        rail_1u_holes(slide_side = slide_side, doublewide = post_doublewide, post_u_height, cones);
    }
}

if (part == "base joiner") {
    render() {
        if (post_doublewide == 0) {
            base_joiner(doublewide = post_doublewide, supports = base_support_count, bottom = 1, beam_thickness = footer_base_beam_thickness);
        } else {
            translate([-post_width, 0, 0]) {
                base_joiner(doublewide = post_doublewide, supports = base_support_count, bottom = 1, beam_thickness = footer_base_beam_thickness);
            }
        }
    }
}

if (part == "top joiner") {
    render() {
        if (post_doublewide == 0) {
            base_joiner(doublewide = post_doublewide, bottom = 0, supports = base_support_count, beam_thickness = header_top_beam_thickness);
        } else {
            translate([-post_width, 0, 0]) {
                base_joiner(doublewide = post_doublewide, bottom = 0, supports = base_support_count, beam_thickness = header_top_beam_thickness);
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
        blank_variable_tray(panel_u_size = front_panel_height, tray_u_size = tray_side_height, holes = front_panel_hole_count, back_panel = tray_back_panel, tray_depth_scale = tray_y);
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

/*
// post_base_join_panel(doublewide, thickness)
// Public — compact panel to join one post footprint (or two for doublewide) to a base joiner using 2 holes per post.
// doublewide: 0=single post width, 1=double post width. thickness: panel thickness in mm.
// e.g. post_base_join_panel();
// e.g. post_base_join_panel(doublewide=1, thickness=4);
module post_base_join_panel(doublewide = 0, thickness = front_panel_thickness) {
*/
if (part == "post joins") {
    post_base_join_panel(doublewide = post_doublewide, thickness = front_panel_thickness);
}

if (part == "um106x") {
    render() {
        ug_um106x_tray(showmodel = false);
    }
}

if (part == "rpi5") {
    render() {
        rpi5_tray();
    }
}

if (part == "side panel") {
    render() {
        side_panel();
    }
}