/**

side panel for 330mm deep rack.
has lip at front and rear to come around the front and the rear and screw into the double wide posts.
this is why double wide posts are useful, as the normal panels use the inner holes, and the side panel the outer holes.

**/

/*
//next 2 lines used only by my 'on save' script. can be ignored otherwise.
//AUTO-V
version = "v0.1-2026/05/10r173";
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
c_pattern_offset_y = 4;
c_pattern_offset_z = 0.5;
c_pattern_edge_offset_left = 1.3; //these are the edges that get chopped when offsetting the pattern.
c_pattern_edge_offset_bottom = 1; //set to zero to reverse the offset, so the pattern is chopped at the top and right instead of the bottom and left. this is because the pattern is generated starting from the bottom left corner, so the bottom and left edges are more likely to be chopped when offsetting.
c_pattern_grid_layout = "offset"; // [inline, offset] used by circles/squares.

c_side_panel_logo = false;
c_side_panel_logo_shape = "hexagon"; // [square, circle, hexagon]
c_side_panel_logo_rotation = 60; //rotation for the logo, or technically for the shape the logo goes onto. the logo has its own rotation.
c_side_panel_logo_size = 100;
c_side_panel_logo_import_file = ""; //svg or png or stl/3mf
//c_side_panel_logo_import_scale = 0.5; //scale for the imported logo, if using an imported file. this is a multiplier for the size of the imported logo, so 1.0 means it will be imported at its original size, 0.5 means it will be half the original size, etc.
c_side_panel_logo_import_width = 40; //changed from scaling, as scaling created streched logo.
c_side_panel_logo_import_height = 50;
c_side_panel_logo_import_rotation = [0, 0, 90]; //rotation for the imported logo, if using an imported file. this is a vector of [x, y, z] rotation in degrees.
c_side_panel_logo_import_ypos = 160; //this is because a imported logo dimensions may not leave it central on the shape
c_side_panel_logo_import_zpos = 135; //this is reversed because of rotation.
c_side_panel_logo_ypos = (c_panel_depth / 2); //y position for the logo, defaults to the centre of the panel depth.
c_side_panel_logo_zpos = (c_panel_height / 2); //z position for the logo, defaults to the centre of the panel height.
c_side_panel_import_mode = "recessed"; // [raised, recessed] this is how the logo is applied to the panel. cutout will subtract the logo shape from the panel, raised will add the logo shape on top of the panel, recessed will subtract the logo shape from the panel and then add it back in at a smaller size to create a recessed effect.
c_side_panel_logo_depth = 1.0; //this is the depth of the cut/raise for the logo, in mm. using the same depth as the panel thickness creates a cutout.


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


module p_side_panel_blank(
    panel_thickness = c_panel_thickness,
    panel_depth = c_panel_depth,
    panel_height = c_panel_height
) {
    translate([0, panel_thickness, 0]) {
        cube([panel_thickness, panel_depth, panel_height]);
    }
}

module circles_pattern(x, y, dia, wall, row_offset = false) {
    step = dia + wall;
    rows = ceil(y / step) + 1;
    cols = ceil(x / step) + 1;

    difference() {
        square([x, y]);
        for (r = [0 : rows]) {
            y_offset = r * step;
            row_shift = row_offset && ((r % 2) == 1) ? step / 2 : 0;
            for (c = [0 : cols]) {
                translate([c * step + row_shift, y_offset]) {
                    circle(d = dia);
                }
            }
        }
    }
}

module squares_pattern(x, y, size, wall, row_offset = false) {
    step = size + wall;
    rows = ceil(y / step) + 1;
    cols = ceil(x / step) + 1;

    difference() {
        square([x, y]);
        for (r = [0 : rows]) {
            y_offset = r * step;
            row_shift = row_offset && ((r % 2) == 1) ? step / 2 : 0;
            for (c = [0 : cols]) {
                translate([c * step + row_shift, y_offset]) {
                    square([size, size], center = true);
                }
            }
        }
    }
}

module slots_pattern(x, y, slot_length, slot_width, wall, row_offset = false, rounded = false, slot_rotation = 0) {
    // Use axis-aligned bounds of the rotated slot so spacing is independent and predictable.
    rot_w = abs(slot_length * cos(slot_rotation)) + abs(slot_width * sin(slot_rotation));
    rot_h = abs(slot_length * sin(slot_rotation)) + abs(slot_width * cos(slot_rotation));
    x_step = rot_w + wall;
    y_step = rot_h + wall;
    rows = ceil(y / y_step) + 1;
    cols = ceil(x / x_step) + 1;

    difference() {
        square([x, y]);
        for (r = [0 : rows]) {
            y_offset = r * y_step;
            row_shift = row_offset && ((r % 2) == 1) ? x_step / 2 : 0;
            for (c = [0 : cols]) {
                translate([c * x_step + row_shift, y_offset]) {
                    rotate(slot_rotation) {
                        //square([slot_length, slot_width], center = true);
                        if (rounded) {
                            hull() {
                                translate([(-slot_length/2)-(slot_width), 0, 0]) {
                                    circle(d = slot_width);
                                }
                                translate([-slot_width, 0, 0]) {
                                    circle(d = slot_width);
                                }
                            }
                        } else {
                            square([slot_length, slot_width], center = true);
                        }
                    }
                }
            }
        }
    }
}

module p_pattern_source_2d(
    pattern_type, width, height,
    pattern_hole_dia = c_pattern_hole_dia,
    panel_thickness = c_panel_thickness,
    pattern_grid_layout = c_pattern_grid_layout,
    slot_length = 50,
    slot_width = 15,
    slot_wall = 2,
    slot_rounded = true,
    slot_rotation = 45
) {
    if (pattern_type == "honeycomb") {
        honeycomb(width, height, pattern_hole_dia, panel_thickness);
    }
    else if (pattern_type == "circles") {
        circles_pattern(width, height, pattern_hole_dia, panel_thickness, pattern_grid_layout == "offset");
    }
    else if (pattern_type == "squares") {
        squares_pattern(width, height, pattern_hole_dia, panel_thickness, pattern_grid_layout == "offset");
    }
    else if (pattern_type == "slots") {
        slots_pattern(
            width, height,
            slot_length, slot_width, slot_wall,
            pattern_grid_layout == "offset",
            slot_rounded, slot_rotation
        );
    }
}

module p_panel_pattern_2d(
    pattern_type, width, height,
    pattern_offset_y = c_pattern_offset_y,
    pattern_offset_z = c_pattern_offset_z,
    edge_offset_left = c_pattern_edge_offset_left,
    edge_offset_bottom = c_pattern_edge_offset_bottom,
    pattern_hole_dia = c_pattern_hole_dia,
    panel_thickness = c_panel_thickness,
    pattern_grid_layout = c_pattern_grid_layout,
    slot_length = 50,
    slot_width = 15,
    slot_wall = 2,
    slot_rounded = true,
    slot_rotation = 45
) {
    pattern_width = width + pattern_offset_y;
    pattern_height = height + pattern_offset_z;
    pattern_shift_y = edge_offset_left ? -pattern_offset_y : 0;
    pattern_shift_z = edge_offset_bottom ? -pattern_offset_z : 0;

    intersection() {
        square([width, height]);
        translate([pattern_shift_y, pattern_shift_z]) {
            p_pattern_source_2d(
                pattern_type, pattern_width, pattern_height,
                pattern_hole_dia, panel_thickness, pattern_grid_layout,
                slot_length, slot_width, slot_wall, slot_rounded, slot_rotation
            );
        }
    }
}

module p_side_panel_patterned(
    panel_depth = c_panel_depth,
    panel_height = c_panel_height,
    pattern_margin = c_pattern_margin,
    panel_thickness = c_panel_thickness,
    pattern = c_pattern,
    pattern_offset_y = c_pattern_offset_y,
    pattern_offset_z = c_pattern_offset_z,
    edge_offset_left = c_pattern_edge_offset_left,
    edge_offset_bottom = c_pattern_edge_offset_bottom,
    pattern_hole_dia = c_pattern_hole_dia,
    pattern_grid_layout = c_pattern_grid_layout,
    slot_length = 50,
    slot_width = 15,
    slot_wall = 2,
    slot_rounded = true,
    slot_rotation = 45
) {
    pattern_width = panel_depth - (2 * pattern_margin);
    pattern_height_val = panel_height - (2 * pattern_margin);

    difference() {
        p_side_panel_blank(panel_thickness, panel_depth, panel_height);
        translate([0, panel_thickness + pattern_margin, pattern_margin]) {
            rotate([90, 0, 90]) {
                difference() {
                    cube([pattern_width, pattern_height_val, panel_thickness]);
                    linear_extrude(height = panel_thickness) {
                        p_panel_pattern_2d(
                            pattern, pattern_width, pattern_height_val,
                            pattern_offset_y, pattern_offset_z,
                            edge_offset_left, edge_offset_bottom,
                            pattern_hole_dia, panel_thickness,
                            pattern_grid_layout,
                            slot_length, slot_width, slot_wall, slot_rounded, slot_rotation
                        );
                    }
                }
            }
        }
    }
}

module p_side_panel(
    pattern = c_pattern,
    panel_depth = c_panel_depth,
    panel_height = c_panel_height,
    pattern_margin = c_pattern_margin,
    panel_thickness = c_panel_thickness,
    pattern_offset_y = c_pattern_offset_y,
    pattern_offset_z = c_pattern_offset_z,
    edge_offset_left = c_pattern_edge_offset_left,
    edge_offset_bottom = c_pattern_edge_offset_bottom,
    pattern_hole_dia = c_pattern_hole_dia,
    pattern_grid_layout = c_pattern_grid_layout,
    slot_length = 50,
    slot_width = 15,
    slot_wall = 2,
    slot_rounded = true,
    slot_rotation = 45
) {
    //the main panel part.
    if (pattern == "none") {
        p_side_panel_blank(panel_thickness, panel_depth, panel_height);
    }
    else if ((pattern == "honeycomb") || (pattern == "circles") || (pattern == "squares") || (pattern == "slots")) {
        p_side_panel_patterned(
            panel_depth, panel_height,
            pattern_margin, panel_thickness, pattern,
            pattern_offset_y, pattern_offset_z,
            edge_offset_left, edge_offset_bottom,
            pattern_hole_dia, pattern_grid_layout,
            slot_length, slot_width, slot_wall, slot_rounded, slot_rotation
        );
    }
    else {
        echo(str("Unknown c_pattern: ", pattern, ". Falling back to blank panel."));
        p_side_panel_blank(panel_thickness, panel_depth, panel_height);
    }
}


// holes(holes)
// Internal helper — subtracts M6 screw holes through a post face. holes: 2 or 3 per 1U segment.
module p_holes(
    holes = 3,
    post_width = 15.875,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    hole_d = 6.3,
    panel_depth = c_panel_depth
) {
    translate([0, 0, hole_offset_z / 2]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_d, h = panel_depth + 20, center = true, $fn = 32);
        }
    }

    if (holes == 3) {
        translate([0, 0, (hole_offset_z / 2) + hole_spacing]) {
            rotate([90, 0, 0]) {
                cylinder(d = hole_d, h = panel_depth + 20, center = true, $fn = 32);
            }
        }
    }

    translate([0, 0, (hole_offset_z / 2) + (hole_spacing * 2)]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_d, h = panel_depth + 20, center = true, $fn = 32);
        }
    }
}


module p_side_panel_holes(
    u_height = cv_panel_u_height,
    panel_thickness = c_panel_thickness,
    post_width = cv_post_width,
    panel_depth = c_panel_depth,
    u_size = c_u_height,
    hole_offset_z = c_hole_offset_z,
    hole_spacing = c_hole_spacing,
    hole_d = c_hole_d
) {
    //the holes for the screws to attach the panel to the posts. these are sized for M6 screws, but can be adjusted.
    for (i = [0 : u_height - 1]) {
        translate([panel_thickness + (post_width / 2), panel_depth / 2, (i * u_size)]) {
            p_holes(
                holes = 3, post_width = post_width,
                hole_offset_z = hole_offset_z, hole_spacing = hole_spacing,
                hole_d = hole_d, panel_depth = panel_depth
            );
        }
    }
}



module p_side_panel_lips(
    post_width = c_post_width,
    panel_thickness = c_panel_thickness,
    panel_height = c_panel_height,
    panel_depth = c_panel_depth
) {
    //the front lip, this is the part that comes around the front of the rack and screws into the posts.
    translate([0, 0, 0]) {
        cube([post_width + panel_thickness, panel_thickness, panel_height]);
    }

    //the rear lip, this is the part that comes around the rear of the rack and screws into the posts.
    translate([0, panel_depth + panel_thickness, 0]) {
        cube([post_width + panel_thickness, panel_thickness, panel_height]);
    }
}

module p_top_edge_radius(
    edge_radius = c_front_panel_edge_radius,
    panel_depth = c_panel_depth
) {
    difference() {
        cube([edge_radius * 2, panel_depth + 30, edge_radius * 2]);
        
        translate([0, panel_depth / 2, 0]) {
            rotate([90, 0, 0]) {
                cylinder(h = panel_depth + 30, r = edge_radius, center = true);
            }
        }
    }
}

module p_bottom_edge_radius(
    edge_radius = c_front_panel_edge_radius,
    panel_depth = c_panel_depth
) {
    rotate([0, 90, 0]) {
        p_top_edge_radius(edge_radius, panel_depth);
    }
}


// side_panel_logo_base_shape(shape, size)
// Internal helper — creates the base geometric shape for the logo panel.
// shape: "square", "circle", or "hexagon". size: shape dimension in mm.
module side_panel_logo_base_shape(shape = "square", size = 30) {
    if (shape == "square") {
        square([size, size], center = true);
    }
    else if (shape == "circle") {
        circle(d = size, $fn = 32);
    }
    else if (shape == "hexagon") {
        circle(d = size, $fn = 6);
    }
    else {
        square([size, size], center = true);
    }
}


// side_panel_logo_with_import(shape, size, import_file, import_type, import_width, import_height, import_rotation, import_mode)
// Internal helper — returns a 2D mask from imported SVG/PNG/STL/3MF content.
module side_panel_logo_with_import(
    shape = "square",
    size = 30,
    import_file = "",
    import_type = "none",
    import_width = 0,
    import_height = 0,
    import_rotation = [0, 0, 0],
    import_mode = "cutout"
) {
    if ((import_type != "none") && (import_file != "")) {
        target_width = (import_width > 0) ? import_width : size * 0.8;
        target_height = (import_height > 0) ? import_height : size * 0.8;
        file_is_svg = (len(search(".svg", import_file)) > 0) || (len(search(".SVG", import_file)) > 0);
        file_is_png = (len(search(".png", import_file)) > 0) || (len(search(".PNG", import_file)) > 0);
        file_is_stl = (len(search(".stl", import_file)) > 0) || (len(search(".STL", import_file)) > 0);
        file_is_3mf = (len(search(".3mf", import_file)) > 0) || (len(search(".3MF", import_file)) > 0);

        if (file_is_svg || (import_type == "svg")) {
            // SVG: direct 2D import.
            rotate(import_rotation[2]) {
                resize([target_width, target_height], auto = true) {
                    import(file = import_file, center = true);
                }
            }
        }
        else if (file_is_png || (import_type == "png")) {
            // PNG: build a 3D height map then project to 2D silhouette.
            projection(cut = false) {
                rotate([0, 0, import_rotation[2]]) {
                    resize([target_width, target_height, target_height], auto = true) {
                        surface(file = import_file, center = true, invert = true);
                    }
                }
            }
        }
        else if (file_is_stl || file_is_3mf || (import_type == "stl") || (import_type == "3mf")) {
            // STL/3MF: import mesh and project to 2D silhouette.
            projection(cut = false) {
                rotate(import_rotation) {
                    resize([target_width, target_height, target_height], auto = true) {
                        import(file = import_file, center = true);
                    }
                }
            }
        }
    }
}


// side_panel_logo(enabled, ypos, zpos, shape, size, rotation, import_file, import_type, import_width, import_height, import_ypos, import_zpos, import_rotation, import_mode, depth)
// Creates an inner panel (shape/logo) within the outer panel with optional import.
// enabled: 0 or 1. import_mode: "recessed" (default) or "raised".
// depth: engraving/relief depth in mm. Set depth >= panel thickness to fully cut through.
module side_panel_logo(
    enabled = false,
    ypos = 165,
    zpos = 0,
    shape = "square",
    size = 30,
    rotation = 0,
    import_file = "",
    import_type = "none",
    import_width = 0,
    import_height = 0,
    import_ypos = ypos,
    import_zpos = zpos,
    import_rotation = [0, 0, 0],
    import_mode = "recessed",
    depth = 1.0,
    panel_thickness = c_panel_thickness
) {
    // ypos is panel depth (Y axis), zpos is height (Z axis).
    // This module creates the base inner panel shape that fills the pattern in that region.
    logo_target_size = size * 0.8;

    if (enabled) {
        translate([0, panel_thickness + ypos, zpos]) {
            rotate([0, 90, 0]) {
                if (import_file != "") {
                    if (import_mode == "recessed") {
                        difference() {
                            linear_extrude(height = panel_thickness) {
                                rotate(rotation) {
                                    side_panel_logo_base_shape(shape, size);
                                }
                            }

                            // Cut a shallow recess from the outside face (y- side).
                            translate([0, 0, -0.01]) {
                                linear_extrude(height = min(depth, panel_thickness) + 0.02) {
                                    intersection() {
                                        rotate(rotation) {
                                            side_panel_logo_base_shape(shape, size);
                                        }
                                        translate([import_zpos - zpos, import_ypos - ypos]) {
                                            side_panel_logo_with_import(
                                                shape = shape,
                                                size = size,
                                                import_file = import_file,
                                                import_type = import_type,
                                                import_width = import_width,
                                                import_height = import_height,
                                                import_rotation = import_rotation,
                                                import_mode = import_mode
                                            );
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else {
                        // raised on the outside face (y- side)
                        linear_extrude(height = panel_thickness) {
                            rotate(rotation) {
                                side_panel_logo_base_shape(shape, size);
                            }
                        }

                        translate([0, 0, -depth]) {
                            linear_extrude(height = depth) {
                                intersection() {
                                    rotate(rotation) {
                                        side_panel_logo_base_shape(shape, size);
                                    }
                                    translate([import_zpos - zpos, import_ypos - ypos]) {
                                            side_panel_logo_with_import(
                                                shape = shape,
                                                size = size,
                                                import_file = import_file,
                                                import_type = import_type,
                                                import_width = import_width,
                                                import_height = import_height,
                                                import_rotation = import_rotation,
                                                import_mode = import_mode
                                            );
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    // No import: just fill the inner panel shape.
                    linear_extrude(height = panel_thickness) {
                        rotate(rotation) {
                            side_panel_logo_base_shape(shape, size);
                        }
                    }
                }
            }
        }
    }
}


// side_panel_logo_mask(ypos, zpos, shape, size, rotation)
// Internal helper — subtracts the logo panel footprint from the side panel so the insert fully replaces that region.
module side_panel_logo_mask(
    ypos = 165,
    zpos = 0,
    shape = "square",
    size = 30,
    rotation = 0,
    panel_thickness = c_panel_thickness
) {
    translate([-0.01, panel_thickness + ypos, zpos]) {
        rotate([0, 90, 0]) {
            linear_extrude(height = panel_thickness + 0.02) {
                rotate(rotation) {
                    side_panel_logo_base_shape(shape, size);
                }
            }
        }
    }
}


module side_panel(
    p_cv_panel_u_height = 6,
    p_c_u_height = 44.5,
    p_c_foot_add = 0,
    p_c_head_add = 0,
    p_c_panel_oversizing = 0.2,
    p_cv_panel_depth = 330,
    p_c_panel_thickness = 3,
    p_c_lip_thickness = 3,
    p_c_hole_clearance = 0.2,
    p_cv_post_width = 15.875,
    p_c_hole_offset_z = 12.7,
    p_c_hole_spacing = 15.875,
    p_c_front_panel_edge_radius = 2.0,

    p_c_pattern = "honeycomb",
    p_c_pattern_margin = 20,
    p_c_pattern_hole_dia = 20,
    p_c_pattern_offset_y = 0,
    p_c_pattern_offset_z = 0,
    p_c_pattern_edge_offset_left = 1.3,
    p_c_pattern_edge_offset_bottom = 1,
    p_c_pattern_grid_layout = "offset",
    p_c_pattern_slot_length = 50,
    p_c_pattern_slot_width = 15,
    p_c_pattern_slot_wall = 2,
    p_c_pattern_slot_rounded = true,
    p_c_pattern_slot_rotation = 45,

    p_c_side_panel_logo = false,
    p_c_side_panel_logo_shape = "hexagon",
    p_c_side_panel_logo_rotation = 60,
    p_c_side_panel_logo_size = 100,
    p_c_side_panel_logo_import_file = "",
    p_c_side_panel_logo_import_width = 40,
    p_c_side_panel_logo_import_height = 50,
    p_c_side_panel_logo_import_rotation = [0, 0, 90],
    p_c_side_panel_logo_import_ypos = 160,
    p_c_side_panel_logo_import_zpos = 135,
    p_c_side_panel_logo_ypos = -1,
    p_c_side_panel_logo_zpos = -1,
    p_c_side_panel_import_mode = "recessed",
    p_c_side_panel_logo_depth = 1.0
) {
    // Derived values computed directly from parameters.
    c_panel_height = (p_cv_panel_u_height * p_c_u_height) + p_c_foot_add + p_c_head_add;
    c_panel_depth  = p_cv_panel_depth + p_c_panel_oversizing;
    c_hole_d       = 6.0 + p_c_hole_clearance;
    c_post_width   = p_cv_post_width - 0.2;

    // Logo position defaults: -1 means "centre of panel".
    c_side_panel_logo_ypos = (p_c_side_panel_logo_ypos < 0) ? (c_panel_depth / 2) : p_c_side_panel_logo_ypos;
    c_side_panel_logo_zpos = (p_c_side_panel_logo_zpos < 0) ? (c_panel_height / 2) : p_c_side_panel_logo_zpos;

    union() {
        difference() {
            p_side_panel(
                pattern          = p_c_pattern,
                panel_depth      = c_panel_depth,
                panel_height     = c_panel_height,
                pattern_margin   = p_c_pattern_margin,
                panel_thickness  = p_c_panel_thickness,
                pattern_offset_y = p_c_pattern_offset_y,
                pattern_offset_z = p_c_pattern_offset_z,
                edge_offset_left   = p_c_pattern_edge_offset_left,
                edge_offset_bottom = p_c_pattern_edge_offset_bottom,
                pattern_hole_dia   = p_c_pattern_hole_dia,
                pattern_grid_layout = p_c_pattern_grid_layout,
                slot_length  = p_c_pattern_slot_length,
                slot_width   = p_c_pattern_slot_width,
                slot_wall    = p_c_pattern_slot_wall,
                slot_rounded = p_c_pattern_slot_rounded,
                slot_rotation = p_c_pattern_slot_rotation
            );
            if (p_c_side_panel_logo) {
                side_panel_logo_mask(
                    ypos      = c_side_panel_logo_ypos,
                    zpos      = c_side_panel_logo_zpos,
                    shape     = p_c_side_panel_logo_shape,
                    size      = p_c_side_panel_logo_size,
                    rotation  = p_c_side_panel_logo_rotation,
                    panel_thickness = p_c_panel_thickness
                );
            }
        }

        if (p_c_side_panel_logo) {
            side_panel_logo(
                enabled       = p_c_side_panel_logo,
                ypos          = c_side_panel_logo_ypos,
                zpos          = c_side_panel_logo_zpos,
                shape         = p_c_side_panel_logo_shape,
                size          = p_c_side_panel_logo_size,
                rotation      = p_c_side_panel_logo_rotation,
                import_file   = p_c_side_panel_logo_import_file,
                import_type   = "auto",
                import_width  = p_c_side_panel_logo_import_width,
                import_height = p_c_side_panel_logo_import_height,
                import_ypos   = p_c_side_panel_logo_import_ypos,
                import_zpos   = p_c_side_panel_logo_import_zpos,
                import_rotation = p_c_side_panel_logo_import_rotation,
                import_mode   = p_c_side_panel_import_mode,
                depth         = p_c_side_panel_logo_depth,
                panel_thickness = p_c_panel_thickness
            );
        }
    }

    difference() {
        p_side_panel_lips(
            post_width      = c_post_width,
            panel_thickness = p_c_panel_thickness,
            panel_height    = c_panel_height,
            panel_depth     = c_panel_depth
        );
        p_side_panel_holes(
            u_height        = p_cv_panel_u_height,
            panel_thickness = p_c_panel_thickness,
            post_width      = p_cv_post_width,
            panel_depth     = c_panel_depth,
            u_size          = p_c_u_height,
            hole_offset_z   = p_c_hole_offset_z,
            hole_spacing    = p_c_hole_spacing,
            hole_d          = c_hole_d
        );
        translate([c_post_width + p_c_front_panel_edge_radius / 2, -10, c_panel_height - p_c_front_panel_edge_radius]) {
            p_top_edge_radius(p_c_front_panel_edge_radius, c_panel_depth);
        }
        translate([c_post_width + p_c_front_panel_edge_radius / 2, -10, p_c_front_panel_edge_radius]) {
            p_bottom_edge_radius(p_c_front_panel_edge_radius, c_panel_depth);
        }
    }

}


