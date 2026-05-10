/**

side panel for 330mm deep rack.
has lip at front and rear to come around the front and the rear and screw into the double wide posts.
this is why double wide posts are useful, as the normal panels use the inner holes, and the side panel the outer holes.

**/

/*
//next 2 lines used only by my 'on save' script. can be ignored otherwise.
//AUTO-V
version = "v0.1-2026/05/10r36";
*/


include <honeycomb.scad>;
//include <330mm rack posts.scad>;

$fn = 32;

//define the basic panel dimensions.
cv_panel_u_height = 6; //the height of the panel in U.
c_u_height                = 44.5;

c_foot_add = 0; //12.7;
c_head_add = 0; //12.7;


c_panel_height = (cv_panel_u_height * c_u_height) + c_foot_add + c_head_add; //the height of the panel in mm, calculated from cv_panel_u_height and c_u_height.
c_panel_oversizing = 0.2; //mm the panel is oversized to ensure it fits properly. This is added to the depth of the panel only
cv_panel_depth = 330; //the depth of the panel in mm.
c_panel_depth = cv_panel_depth + c_panel_oversizing; //the depth of the panel in mm, calculated from cv_panel_depth and c_panel_oversizing.
c_panel_thickness = 3; //the thickness of the panel in mm.


//define the lip dimensions, for connecting front and rear post holes.
c_lip_thickness = 3;
//c_lip_width = 


//mm clearance around the 'oles
c_hole_clearance = 0.2; 

//screw holes dia
c_hole_d = 6.0 + c_hole_clearance; 


cv_post_width              = 15.875; //a normal single-width rack. If using double-width and/or sliders, this will be wider, but calculated automatically based on this.
c_post_width = cv_post_width - 0.2; //the post here is calculated slightly narrower than standard, to ensure the panel lips don't interfere with any panels or trays that are using the inner holes.
c_hole_offset_z           = 12.7; //initial hole offset from the bottom panel/rack post in mm.
c_hole_spacing            = 15.875; //spacing between holes in mm, standard U spacing.
c_front_panel_edge_radius = 2.0; //mm radius for front panel edges. set to 0 for sharp edges.


//pattern for the side panel. not required.
c_pattern = "honeycomb"; // [none, honeycomb, circles, squares, slots]
c_pattern_margin = 20; //the margin front the edges of the panel for the pattern to sit within
c_pattern_hole_dia = 20;
c_pattern_offset_y = 1;
c_pattern_offset_z = 1;
c_pattern_edge_offset_left = 1; //these are the edges that get chopped when offsetting the pattern.
c_pattern_edge_offset_bottom = 1; //set to zero to reverse the offset, so the pattern is chopped at the top and right instead of the bottom and left. this is because the pattern is generated starting from the bottom left corner, so the bottom and left edges are more likely to be chopped when offsetting.
/**
module honeycomb(x, y, dia, wall)  {
	// Diagram
	//          ______     ___
	//         /     /\     |
	//        / dia /  \    | smallDia
	//       /     /    \  _|_
	//       \          /   ____ 
	//        \        /   / 
	//     ___ \______/   / 
	// wall |            /
	//     _|_  ______   \
	//         /      \   \
	//        /        \   \
	//                 |---|
	//                   projWall
	//
**/


module p_side_panel_blank() {
    translate([0, c_panel_thickness, 0]) {
        cube([c_panel_thickness, c_panel_depth, c_panel_height]);
    }
}

module p_side_panel_honeycomb() {
    difference() {
        p_side_panel_blank();
        translate([0, c_panel_thickness+ c_pattern_margin, c_pattern_margin]) {
            rotate([90, 0, 90]) {
                difference() {
                    cube([c_panel_depth - (2 * c_pattern_margin), c_panel_height - (2 * c_pattern_margin), c_panel_thickness]);
                    linear_extrude(height = c_panel_thickness) {
                            honeycomb(c_panel_depth - (2 * c_pattern_margin), c_panel_height - (2 * c_pattern_margin), c_pattern_hole_dia, c_panel_thickness);
                    }
                }
            }
        }
    }
}

module p_side_panel() {
    //the main panel part.
    if (c_pattern == "none") {
        p_side_panel_blank();
    }
    else if (c_pattern == "honeycomb") {
        p_side_panel_honeycomb();
    }
}


// holes(holes)
// Internal helper — subtracts M6 screw holes through a post face. holes: 2 or 3 per 1U segment.
module p_holes(
    holes = 3,
    post_width = 15.875,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    hole_d = 6.3
) {
    translate([0, 0, hole_offset_z / 2]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_d, h =  c_panel_depth + 20, center = true, $fn = 32);
        }
    }

    if (holes == 3) {
        translate([0, 0, (hole_offset_z / 2) + hole_spacing]) {
            rotate([90, 0, 0]) {
                cylinder(d = hole_d, h =  c_panel_depth + 20, center = true, $fn = 32);
            }
        }
    }

    translate([0, 0, (hole_offset_z / 2) + (hole_spacing * 2)]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_d, h =  c_panel_depth + 20, center = true, $fn = 32);
        }
    }
}


module p_side_panel_holes() {
    //the holes for the screws to attach the panel to the posts. these are sized for M6 screws, but can be adjusted.
    for (i = [0 : cv_panel_u_height - 1]) {
        translate([c_panel_thickness+(cv_post_width/2), c_panel_depth / 2, (i * c_u_height)]) {
            //rotate([90, 0, 0]) {
            //    cylinder(h = c_panel_depth + 20, r = c_hole_d/2, center = true);
            //}
            p_holes(holes = 3, post_width = cv_post_width, hole_offset_z = c_hole_offset_z, hole_spacing = c_hole_spacing, hole_d = c_hole_d);
        }
    }
}



module p_side_panel_lips() {
    //the front lip, this is the part that comes around the front of the rack and screws into the posts.
    translate([0, 0, 0]) {
        cube([c_post_width + c_panel_thickness, c_panel_thickness, c_panel_height]);
    }

    //the rear lip, this is the part that comes around the rear of the rack and screws into the posts.
    translate([0, c_panel_depth + c_panel_thickness, 0]) {
        cube([c_post_width + c_panel_thickness, c_panel_thickness, c_panel_height]);
    }
}

module p_top_edge_radius() {
    difference() {
        cube([c_front_panel_edge_radius *2, c_panel_depth+30, c_front_panel_edge_radius *2]);
        
        translate([0, c_panel_depth/2, 0]) {
            rotate([90, 0, 0]) {
                cylinder(h = c_panel_depth+30, r = c_front_panel_edge_radius, center = true);
            }
        }
    }
}

module p_bottom_edge_radius() {
    rotate([0, 90, 0]) {
        p_top_edge_radius();
    }
}



module side_panel() {
    p_side_panel();
    difference() {
        p_side_panel_lips();
        p_side_panel_holes();
        translate([c_post_width+c_front_panel_edge_radius/2, -10, c_panel_height - (c_front_panel_edge_radius)]) {
            p_top_edge_radius();
        }
        translate([c_post_width+c_front_panel_edge_radius/2, -10, c_front_panel_edge_radius]) {
            p_bottom_edge_radius();
        }
    }

}

