// 330mm blank variable tray.scad
// Variable-height front panel and tray modules.
// All rack dimensions are explicit parameters — no external defines file required.
// Default values match the 330mm rack standard (front_panel_thickness=3, rack_width=330, etc.).
//
// Public modules:
//   blank_variable_front_panel(...)  — variable-height blanking front panel
//   blank_variable_tray(...)         — variable-height tray with front panel and side slides
//
// All parameters have sensible defaults so the modules work out of the box for a standard
// 330mm rack, but every dimension can be overridden on the call.


// =============================================================================
// Internal helpers
// =============================================================================

// variable_holes_per_u(holes)
// Converts a total holes-per-side value into a per-U-segment count (1, 2, or 3).
function variable_holes_per_u(holes) = (holes >= 6) ? 3 : ((holes >= 4) ? 2 : holes);


// variable_front_panel_hole_at(x_pos, z_pos, post_width, hole_d)
// Subtracts a single screw hole through the front panel at the given X and Z position.
module variable_front_panel_hole_at(
    x_pos,
    z_pos,
    post_width = 15.875,
    hole_d     = 6.3
) {
    translate([x_pos, post_width / 2, z_pos]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_d, h = post_width, center = true, $fn = 32);
        }
    }
}


// variable_front_panel_holes(panel_height, holes, u_height, hole_offset_z, hole_spacing, post_width, rack_width, hole_d)
// Subtracts the correct pattern of screw holes across a variable-height front panel.
// holes: mounting holes per side (2, 3, 4, or 6).
module variable_front_panel_holes(
    panel_height,
    holes        = 2,
    u_height     = 44.5,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    post_width   = 15.875,
    rack_width   = 330,
    hole_d       = 6.3
) {
    holes_per_u    = variable_holes_per_u(holes);
    max_u_segments = ceil(panel_height / u_height);

    for (u_seg = [0 : max_u_segments - 1]) {
        if (holes_per_u >= 1) {
            z1 = (u_seg * u_height) + (hole_offset_z / 2);
            if (z1 <= panel_height - (hole_offset_z / 2) + 0.001) {
                variable_front_panel_hole_at(post_width / 2,             z1, post_width, hole_d);
                variable_front_panel_hole_at(rack_width - post_width / 2, z1, post_width, hole_d);
            }
        }
        if (holes_per_u >= 2) {
            z2 = (u_seg * u_height) + (hole_offset_z / 2) + (hole_spacing * 2);
            if (z2 <= panel_height - (hole_offset_z / 2) + 0.001) {
                variable_front_panel_hole_at(post_width / 2,             z2, post_width, hole_d);
                variable_front_panel_hole_at(rack_width - post_width / 2, z2, post_width, hole_d);
            }
        }
        if (holes_per_u >= 3) {
            z3 = (u_seg * u_height) + (hole_offset_z / 2) + hole_spacing;
            if (z3 <= panel_height - (hole_offset_z / 2) + 0.001) {
                variable_front_panel_hole_at(post_width / 2,             z3, post_width, hole_d);
                variable_front_panel_hole_at(rack_width - post_width / 2, z3, post_width, hole_d);
            }
        }
    }
}


// variable_front_panel_body(panel_height, front_panel_thickness, rack_width, front_panel_undersizing, front_panel_edge_radius)
// Generates the solid panel body at the given height in mm, with optional edge rounding.
module variable_front_panel_body(
    panel_height,
    front_panel_thickness  = 3.0,
    rack_width             = 330,
    front_panel_undersizing = 0.1,
    front_panel_edge_radius = 2.0
) {
    if (front_panel_edge_radius > 0) {
        translate([
            front_panel_undersizing + front_panel_edge_radius,
            0,
            front_panel_undersizing + front_panel_edge_radius
        ]) {
            minkowski() {
                cube([
                    rack_width   - (front_panel_undersizing * 2) - (front_panel_edge_radius * 2),
                    front_panel_thickness,
                    panel_height - (front_panel_undersizing * 2) - (front_panel_edge_radius * 2)
                ]);
                rotate([90, 0, 0]) {
                    cylinder(r = front_panel_edge_radius, h = 0.01, center = true, $fn = 32);
                }
            }
        }
    } else {
        translate([front_panel_undersizing, 0, front_panel_undersizing]) {
            cube([
                rack_width   - (front_panel_undersizing * 2),
                front_panel_thickness,
                panel_height - (front_panel_undersizing * 2)
            ]);
        }
    }
}


// variable_front_panel_face_import(panel_height, import_file, import_type, import_width, import_height, import_depth, import_offset_x, import_offset_z, import_mode, rack_width, front_panel_undersizing)
// Embosses or engraves an SVG or STL/3MF onto the front panel face.
// import_type: "svg", "stl", or "none". import_mode: "emboss" (raised) or "engrave" (cut in).
// Called by blank_variable_front_panel(); not normally used directly.
module variable_front_panel_face_import(
    panel_height,
    import_file             = "",
    import_type             = "none",
    import_width            = 0,
    import_height           = 0,
    import_depth            = 0.8,
    import_offset_x         = 0,
    import_offset_z         = 0,
    import_mode             = "emboss",
    rack_width              = 330,
    front_panel_undersizing = 0.1
) {
    if ((import_type != "none") && (import_file != "")) {
        panel_inner_width  = rack_width   - (front_panel_undersizing * 2);
        panel_inner_height = panel_height - (front_panel_undersizing * 2);

        target_width  = (import_width  > 0) ? import_width  : panel_inner_width  * 0.5;
        target_height = (import_height > 0) ? import_height : panel_inner_height * 0.5;
        target_depth  = (import_depth  > 0) ? import_depth  : 0.8;

        x_pos = front_panel_undersizing + (panel_inner_width  / 2) + import_offset_x;
        z_pos = front_panel_undersizing + (panel_inner_height / 2) + import_offset_z;

        if (import_type == "svg") {
            if (import_mode == "engrave") {
                // Use a tiny overlap so CSG subtraction reliably intersects the panel volume.
                translate([x_pos, target_depth + 0.01, z_pos]) {
                    rotate([90, 0, 0]) {
                        linear_extrude(height = target_depth + 0.02) {
                            resize([target_width, target_height], auto = true) {
                                import(file = import_file, center = true);
                            }
                        }
                    }
                }
            } else {
                // Emboss out from the front face (y = -depth to 0).
                translate([x_pos, 0, z_pos]) {
                    rotate([90, 0, 0]) {
                        linear_extrude(height = target_depth) {
                            resize([target_width, target_height], auto = true) {
                                import(file = import_file, center = true);
                            }
                        }
                    }
                }
            }
        } else {
            // STL/3MF: assumes mesh uses X=width, Z=height, Y=depth.
            y_pos = (import_mode == "engrave") ? (target_depth / 2) : -(target_depth / 2);
            translate([x_pos, y_pos, z_pos]) {
                resize([target_width, target_depth, target_height], auto = false) {
                    import(file = import_file, center = true);
                }
            }
        }
    }
}


// variable_side_slide(tray_u_size, side, tray_depth, front_panel_thickness, u_height, post_slide_cutout, hole_clearance, hole_offset_z, tray_side_thickness, post_slide_width, post_width, tray_post_clearance, hole_spacing, rack_width)
// Builds the side wall and slide tabs for a variable-height tray.
// tray_u_size: side wall height in U units (can be fractional). side: 0=left, 1=right.
// tray_depth: tray projection depth in mm along Y axis.
module variable_side_slide(
    tray_u_size           = 1,
    side                  = 0,
    tray_depth            = 330,
    front_panel_thickness = 3.0,
    u_height              = 44.5,
    post_slide_cutout     = 3.2,
    hole_clearance        = 0.3,
    hole_offset_z         = 12.7,
    tray_side_thickness   = 2.0,
    post_slide_width      = 3.0,
    post_width            = 15.875,
    tray_post_clearance   = 0.5,
    hole_spacing          = 15.875,
    rack_width            = 330
) {
    tray_height    = max((u_height * tray_u_size) - 1, post_slide_cutout - hole_clearance);
    tab_height     = post_slide_cutout - hole_clearance;
    z_base         = (hole_offset_z / 2) - (post_slide_cutout / 2.1);
    max_u_segments = ceil(tray_u_size) + 1;

    if (side == 0) {
        translate([post_width + post_slide_width + tray_post_clearance, front_panel_thickness, 0]) {
            cube([tray_side_thickness, tray_depth, tray_height]);
        }
        for (u_seg = [0 : max_u_segments - 1]) {
            for (slot = [0 : 2]) {
                z_pos = (u_seg * u_height) + z_base + (slot * hole_spacing);
                if (z_pos + tab_height <= tray_height + 0.001) {
                    translate([post_width + tray_post_clearance, front_panel_thickness, z_pos]) {
                        cube([post_slide_width, tray_depth, tab_height]);
                    }
                }
            }
        }
    } else {
        translate([rack_width - post_width - post_slide_width - tray_post_clearance - tray_side_thickness, front_panel_thickness, 0]) {
            cube([tray_side_thickness, tray_depth, tray_height]);
        }
        for (u_seg = [0 : max_u_segments - 1]) {
            for (slot = [0 : 2]) {
                z_pos = (u_seg * u_height) + z_base + (slot * hole_spacing);
                if (z_pos + tab_height <= tray_height + 0.001) {
                    translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, z_pos]) {
                        cube([post_slide_width, tray_depth, tab_height]);
                    }
                }
            }
        }
    }
}


// variable_tray_front_gusset(panel_u_size, tray_u_size, side, support_back, support_thickness, front_panel_thickness, u_height, post_slide_cutout, hole_clearance, post_width, post_slide_width, tray_post_clearance, rack_width)
// Adds a triangular gusset between the front panel and the tray side wall when the panel is taller than the side.
// panel_u_size: front panel height in U. tray_u_size: side wall height in U. side: 0=left, 1=right.
// support_back: how far back the gusset extends (mm). support_thickness: gusset thickness (mm).
module variable_tray_front_gusset(
    panel_u_size          = 1,
    tray_u_size           = 1,
    side                  = 0,
    support_back          = 20,
    support_thickness     = 2.0,
    front_panel_thickness = 3.0,
    u_height              = 44.5,
    post_slide_cutout     = 3.2,
    hole_clearance        = 0.3,
    post_width            = 15.875,
    post_slide_width      = 3.0,
    tray_post_clearance   = 0.5,
    rack_width            = 330
) {
    panel_top = (u_height * panel_u_size) - 1;
    tray_top  = max((u_height * tray_u_size) - 1, post_slide_cutout - hole_clearance);
    x0 = (side == 0)
        ? (post_width + post_slide_width + tray_post_clearance)
        : (rack_width - post_width - post_slide_width - tray_post_clearance - support_thickness);
    x1  = x0 + support_thickness;
    y0  = front_panel_thickness;
    y1  = front_panel_thickness + support_back;
    eps = 0.01;

    if ((panel_top > tray_top + 0.01) && (support_back > 0) && (support_thickness > 0)) {
        hull() {
            translate([x0, y0, panel_top - eps]) { cube([support_thickness, eps, eps]); }
            translate([x0, y0, tray_top])        { cube([support_thickness, eps, eps]); }
            translate([x0, y1, tray_top])        { cube([support_thickness, eps, eps]); }
        }
    }
}


// =============================================================================
// Public modules
// =============================================================================

// blank_variable_front_panel(u_size, holes, import_file, import_type, import_width, import_height, import_depth, import_offset_x, import_offset_z, import_mode, front_panel_thickness, rack_width, post_width, hole_d, u_height, hole_offset_z, hole_spacing, front_panel_undersizing, front_panel_edge_radius)
// Public — generates a variable-height blanking front panel, optionally with an embossed or engraved logo/image.
// u_size: panel height in U units (can be fractional, e.g. 1.5). holes: mounting holes per side (2, 3, 4, or 6).
// import_file: path to SVG or STL file. import_type: "svg", "stl", or "none". import_mode: "emboss" or "engrave".
// All rack dimension parameters have defaults matching the 330mm rack standard.
// e.g. blank_variable_front_panel(u_size=1.5, holes=2);
// e.g. blank_variable_front_panel(u_size=1, front_panel_thickness=20, rack_width=330, u_height=44.5);
// e.g. blank_variable_front_panel(u_size=2, holes=4, import_file="logo.svg", import_type="svg", import_mode="emboss");
module blank_variable_front_panel(
    u_size                  = 1,
    holes                   = 2,
    import_file             = "",
    import_type             = "none",
    import_width            = 0,
    import_height           = 0,
    import_depth            = 0.8,
    import_offset_x         = 0,
    import_offset_z         = 0,
    import_mode             = "emboss",
    front_panel_thickness   = 3.0,
    rack_width              = 330,
    post_width              = 15.875,
    hole_d                  = 6.3,
    u_height                = 44.5,
    hole_offset_z           = 12.7,
    hole_spacing            = 15.875,
    front_panel_undersizing = 0.1,
    front_panel_edge_radius = 2.0
) {
    panel_height = u_height * u_size;

    difference() {
        union() {
            variable_front_panel_body(
                panel_height,
                front_panel_thickness,
                rack_width,
                front_panel_undersizing,
                front_panel_edge_radius
            );
            if (import_mode != "engrave") {
                variable_front_panel_face_import(
                    panel_height,
                    import_file,
                    import_type,
                    import_width,
                    import_height,
                    import_depth,
                    import_offset_x,
                    import_offset_z,
                    import_mode,
                    rack_width,
                    front_panel_undersizing
                );
            }
        }

        translate([0, -1, 0]) {
            variable_front_panel_holes(
                panel_height,
                holes,
                u_height,
                hole_offset_z,
                hole_spacing,
                post_width,
                rack_width,
                hole_d
            );
        }

        if (import_mode == "engrave") {
            variable_front_panel_face_import(
                panel_height,
                import_file,
                import_type,
                import_width,
                import_height,
                import_depth,
                import_offset_x,
                import_offset_z,
                import_mode,
                rack_width,
                front_panel_undersizing
            );
        }
    }
}


// blank_variable_tray(panel_u_size, tray_u_size, tray_depth_scale, holes, import_file, import_type, import_width, import_height, import_depth, import_offset_x, import_offset_z, import_mode, side_support, side_support_back, tray_side_thickness, front_panel_thickness, side_support_thickness, back_panel, back_panel_thickness, tray_thickness, rack_width, post_width, hole_d, u_height, hole_offset_z, hole_spacing, front_panel_undersizing, front_panel_edge_radius, tray_post_clearance, post_slide_width, post_slide_cutout, hole_clearance)
// Public — the main variable-size tray module.
// panel_u_size: front panel height in U (can be fractional). tray_u_size: side/base height in U (defaults to panel_u_size).
// tray_depth_scale: tray projection depth as a fraction of rack_width (1 = full depth, 0.25 = quarter depth).
// holes: mounting holes per side (2, 3, 4, or 6). back_panel: 0=open tray, 1=add rear wall (makes a drawer).
// side_support: 1=add front gussets when panel is taller than side wall.
// All rack dimension parameters have defaults matching the 330mm rack standard.
// Accepts the same import_* parameters as blank_variable_front_panel() for emboss/engrave graphics.
// e.g. blank_variable_tray(panel_u_size=1, tray_u_size=0.75, tray_depth_scale=0.5, holes=2, back_panel=1);
// e.g. blank_variable_tray(panel_u_size=1, tray_u_size=0.5, tray_depth_scale=0.5, holes=4, tray_thickness=4.0, front_panel_thickness=20.0);
// e.g. blank_variable_tray(panel_u_size=2, tray_u_size=1.5, tray_depth_scale=1, holes=4, import_file="logo.svg", import_type="svg");
module blank_variable_tray(
    panel_u_size            = 1,
    tray_u_size             = panel_u_size,
    tray_depth_scale        = 1,
    holes                   = 2,
    import_file             = "",
    import_type             = "none",
    import_width            = 0,
    import_height           = 0,
    import_depth            = 0.8,
    import_offset_x         = 0,
    import_offset_z         = 0,
    import_mode             = "emboss",
    side_support            = 1,
    side_support_back       = 40,
    tray_side_thickness     = 2.0,
    front_panel_thickness   = 3.0,
    side_support_thickness  = 2.0,
    back_panel              = 0,
    back_panel_thickness    = 2.0,
    tray_thickness          = 5.0,
    rack_width              = 330,
    post_width              = 15.875,
    hole_d                  = 6.3,
    u_height                = 44.5,
    hole_offset_z           = 12.7,
    hole_spacing            = 15.875,
    front_panel_undersizing = 0.1,
    front_panel_edge_radius = 2.0,
    tray_post_clearance     = 0.5,
    post_slide_width        = 3.0,
    post_slide_cutout       = 3.2,
    hole_clearance          = 0.3
) {
    tray_height      = max((u_height * tray_u_size) - 1, post_slide_cutout - hole_clearance);
    tray_depth       = max(rack_width * tray_depth_scale, 0.01);
    back_panel_depth = min(back_panel_thickness, tray_depth);
    tray_x0          = post_width + tray_post_clearance + post_slide_width;
    tray_w           = (rack_width - (post_width * 2)) - (tray_post_clearance * 2) - (post_slide_width * 2);

    blank_variable_front_panel(
        panel_u_size,
        holes,
        import_file,
        import_type,
        import_width,
        import_height,
        import_depth,
        import_offset_x,
        import_offset_z,
        import_mode,
        front_panel_thickness,
        rack_width,
        post_width,
        hole_d,
        u_height,
        hole_offset_z,
        hole_spacing,
        front_panel_undersizing,
        front_panel_edge_radius
    );

    translate([tray_x0, 0, front_panel_undersizing]) {
        cube([tray_w, tray_depth + front_panel_thickness, tray_thickness]);
    }

    variable_side_slide(
        tray_u_size,
        side                = 0,
        tray_depth          = tray_depth,
        front_panel_thickness = front_panel_thickness,
        u_height            = u_height,
        post_slide_cutout   = post_slide_cutout,
        hole_clearance      = hole_clearance,
        hole_offset_z       = hole_offset_z,
        tray_side_thickness = tray_side_thickness,
        post_slide_width    = post_slide_width,
        post_width          = post_width,
        tray_post_clearance = tray_post_clearance,
        hole_spacing        = hole_spacing,
        rack_width          = rack_width
    );
    variable_side_slide(
        tray_u_size,
        side                = 1,
        tray_depth          = tray_depth,
        front_panel_thickness = front_panel_thickness,
        u_height            = u_height,
        post_slide_cutout   = post_slide_cutout,
        hole_clearance      = hole_clearance,
        hole_offset_z       = hole_offset_z,
        tray_side_thickness = tray_side_thickness,
        post_slide_width    = post_slide_width,
        post_width          = post_width,
        tray_post_clearance = tray_post_clearance,
        hole_spacing        = hole_spacing,
        rack_width          = rack_width
    );

    if (back_panel == 1) {
        // Rear wall to connect side panels, matching tray side height.
        translate([tray_x0, front_panel_thickness + tray_depth - back_panel_depth, 0]) {
            cube([tray_w, back_panel_depth, tray_height]);
        }
    }

    if (side_support == 1) {
        variable_tray_front_gusset(
            panel_u_size,
            tray_u_size,
            side              = 0,
            support_back      = side_support_back,
            support_thickness = side_support_thickness,
            front_panel_thickness = front_panel_thickness,
            u_height          = u_height,
            post_slide_cutout = post_slide_cutout,
            hole_clearance    = hole_clearance,
            post_width        = post_width,
            post_slide_width  = post_slide_width,
            tray_post_clearance = tray_post_clearance,
            rack_width        = rack_width
        );
        variable_tray_front_gusset(
            panel_u_size,
            tray_u_size,
            side              = 1,
            support_back      = side_support_back,
            support_thickness = side_support_thickness,
            front_panel_thickness = front_panel_thickness,
            u_height          = u_height,
            post_slide_cutout = post_slide_cutout,
            hole_clearance    = hole_clearance,
            post_width        = post_width,
            post_slide_width  = post_slide_width,
            tray_post_clearance = tray_post_clearance,
            rack_width        = rack_width
        );
    }
}
