include <330mm rack defines.scad>;
include <330mm rack posts.scad>;

// AUTO-V
version = "v0.1-2026/05/04r03";

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


module front_panel_hole_at(x_pos, z_pos) {
    translate([x_pos, post_width/2, z_pos]) {
        rotate([90,0,0]) {
            cylinder(d=hole_d, h=post_width, center=true, $fn=32);
        }
    }
}


module front_panel_2U_holes(holes = 4) {
    if (holes == 2) {
        front_panel_hole_at(post_width/2, hole_offset_z/2);
        front_panel_hole_at(post_width/2, u_height + (hole_offset_z/2) + (hole_spacing * 2));
        front_panel_hole_at(rack_width - post_width/2, hole_offset_z/2);
        front_panel_hole_at(rack_width - post_width/2, u_height + (hole_offset_z/2) + (hole_spacing * 2));
    } else if (holes == 6) {
        front_panel_hole_at(post_width/2, hole_offset_z/2);
        front_panel_hole_at(post_width/2, hole_offset_z/2 + hole_spacing);
        front_panel_hole_at(post_width/2, hole_offset_z/2 + (hole_spacing * 2));
        front_panel_hole_at(post_width/2, u_height + hole_offset_z/2);
        front_panel_hole_at(post_width/2, u_height + hole_offset_z/2 + hole_spacing);
        front_panel_hole_at(post_width/2, u_height + hole_offset_z/2 + (hole_spacing * 2));

        front_panel_hole_at(rack_width - post_width/2, hole_offset_z/2);
        front_panel_hole_at(rack_width - post_width/2, hole_offset_z/2 + hole_spacing);
        front_panel_hole_at(rack_width - post_width/2, hole_offset_z/2 + (hole_spacing * 2));
        front_panel_hole_at(rack_width - post_width/2, u_height + hole_offset_z/2);
        front_panel_hole_at(rack_width - post_width/2, u_height + hole_offset_z/2 + hole_spacing);
        front_panel_hole_at(rack_width - post_width/2, u_height + hole_offset_z/2 + (hole_spacing * 2));
    } else {
        // Default 2U pattern: 4 holes per side using the 2-hole 1U pattern repeated across both U sections.
        front_panel_hole_at(post_width/2, hole_offset_z/2);
        front_panel_hole_at(post_width/2, hole_offset_z/2 + (hole_spacing * 2));
        front_panel_hole_at(post_width/2, u_height + hole_offset_z/2);
        front_panel_hole_at(post_width/2, u_height + hole_offset_z/2 + (hole_spacing * 2));

        front_panel_hole_at(rack_width - post_width/2, hole_offset_z/2);
        front_panel_hole_at(rack_width - post_width/2, hole_offset_z/2 + (hole_spacing * 2));
        front_panel_hole_at(rack_width - post_width/2, u_height + hole_offset_z/2);
        front_panel_hole_at(rack_width - post_width/2, u_height + hole_offset_z/2 + (hole_spacing * 2));
    }
}


module blank_2U_front_panel(holes = 4) {
    difference() {
        union() {
            if (front_panel_edge_radius > 0) {
                translate([front_panel_undersizing + front_panel_edge_radius, 0, front_panel_undersizing + front_panel_edge_radius]) {
                    minkowski() {
                        cube([rack_width - (front_panel_undersizing*2) - (front_panel_edge_radius*2), front_panel_thickness, (u_height * 2) - (front_panel_undersizing*2) - (front_panel_edge_radius*2)]);
                        rotate([90,0,0]) {
                            cylinder(r=front_panel_edge_radius, h=0.01, center=true, $fn=32);
                        }
                    }
                }
            } else {
                translate([front_panel_undersizing, 0, front_panel_undersizing]) {
                    cube([rack_width - (front_panel_undersizing*2), front_panel_thickness, (u_height * 2) - (front_panel_undersizing*2)]);
                }
            }
        }

        translate([0, -1, 0]) {
            front_panel_2U_holes(holes);
        }
    }
}


module blank_05U_front_panel() {
    // 0.5U panel: height = hole_offset_z (12.7mm), one hole per side centred at hole_offset_z/2
    half_u = hole_offset_z * 2;
    difference() {
        union() {
            if (front_panel_edge_radius > 0) {
                translate([front_panel_undersizing + front_panel_edge_radius, 0, front_panel_undersizing + front_panel_edge_radius]) {
                    minkowski() {
                        cube([rack_width - (front_panel_undersizing*2) - (front_panel_edge_radius*2), front_panel_thickness, half_u - (front_panel_undersizing*2) - (front_panel_edge_radius*2)]);
                        rotate([90,0,0]) {
                            cylinder(r=front_panel_edge_radius, h=0.01, center=true, $fn=32);
                        }
                    }
                }
            } else {
                translate([front_panel_undersizing, 0, front_panel_undersizing]) {
                    cube([rack_width - (front_panel_undersizing*2), front_panel_thickness, half_u - (front_panel_undersizing*2)]);
                }
            }
        }

        // 2 holes per side, centred vertically in the 0.5U panel
        translate([0, -1, 0]) {
            translate([post_width/2, post_width/2, hole_offset_z/2]) {
                rotate([90,0,0]) {
                    cylinder(d=hole_d, h=post_width, center=true, $fn=32);
                }
            }
            translate([post_width/2, post_width/2, hole_offset_z*3/2]) {
                rotate([90,0,0]) {
                    cylinder(d=hole_d, h=post_width, center=true, $fn=32);
                }
            }


            translate([rack_width - post_width/2, post_width/2, hole_offset_z/2]) {
                rotate([90,0,0]) {
                    cylinder(d=hole_d, h=post_width, center=true, $fn=32);
                }
            }
            translate([rack_width - post_width/2, post_width/2, hole_offset_z*3/2]) {
                rotate([90,0,0]) {
                    cylinder(d=hole_d, h=post_width, center=true, $fn=32);
                }
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
                } else if (count >= 3) {
                cube([tray_side_thickness, rack_width, u_height-1]);
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
                } else if (count >= 3) {
                    cube([tray_side_thickness, rack_width, u_height-1]);
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


module tray_side_height_2U(count = 3) {
    if (count <= 1) {
        cube([tray_side_thickness, rack_width, u_height - hole_spacing * 2]);
    } else if (count == 2) {
        cube([tray_side_thickness, rack_width, u_height - hole_spacing]);
    } else if (count == 3) {
        cube([tray_side_thickness, rack_width, u_height - 1]);
    } else if (count == 4) {
        cube([tray_side_thickness, rack_width, u_height + (u_height - hole_spacing * 2)]);
    } else if (count == 5) {
        cube([tray_side_thickness, rack_width, u_height + (u_height - hole_spacing)]);
    } else {
        cube([tray_side_thickness, rack_width, (u_height * 2) - 1]);
    }
}


module side_slide_2U(count = 3, side = 0) {
    union() {
        if (side == 0) {
            translate([post_width+post_slide_width+tray_post_clearance, front_panel_thickness, 0]) {
                tray_side_height_2U(count);
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
            if (count >= 4) {
                translate([post_width+tray_post_clearance, front_panel_thickness, u_height + (hole_offset_z/2)-(post_slide_cutout/2.1)]) {
                    cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
                }
            }
            if (count >= 5) {
                translate([post_width+tray_post_clearance, front_panel_thickness, u_height + (hole_offset_z/2)-(post_slide_cutout/2.1)+ hole_spacing]) {
                    cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
                }
            }
            if (count >= 6) {
                translate([post_width+tray_post_clearance, front_panel_thickness, u_height + (hole_offset_z/2)-(post_slide_cutout/2.1)+ hole_spacing * 2]) {
                    cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
                }
            }
        } else {
            translate([rack_width - post_width - post_slide_width - tray_post_clearance - tray_side_thickness, front_panel_thickness, 0]) {
                tray_side_height_2U(count);
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
            if (count >= 4) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, u_height + (hole_offset_z/2)-(post_slide_cutout/2.1)]) {
                    cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
                }
            }
            if (count >= 5) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, u_height + (hole_offset_z/2)-(post_slide_cutout/2.1)+ hole_spacing]) {
                    cube([post_slide_width, rack_width, post_slide_cutout-hole_clearance]);
                }
            }
            if (count >= 6) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, u_height + (hole_offset_z/2)-(post_slide_cutout/2.1)+ hole_spacing * 2]) {
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


module blank_2U_tray(side_count = 3, edge_radius = 2, holes = 4) {
    blank_2U_front_panel(holes);
    translate([post_width+tray_post_clearance+post_slide_width, 0, front_panel_undersizing]) {
        cube([((rack_width - (post_width*2)) - (tray_post_clearance*2)-(post_slide_width*2)), rack_width+front_panel_thickness, tray_thickness]);
    }
    side_slide_2U(side = 0, count = side_count);
    side_slide_2U(side = 1, count = side_count);
}


function variable_holes_per_u(holes) = (holes >= 6) ? 3 : ((holes >= 4) ? 2 : holes);


module front_panel_variable_holes(panel_height, holes = front_panel_hole_count) {
    holes_per_u = variable_holes_per_u(holes);
    max_u_segments = ceil(panel_height / u_height);

    for (u_seg = [0:max_u_segments-1]) {
        if (holes_per_u >= 1) {
            z1 = (u_seg * u_height) + (hole_offset_z/2);
            if (z1 <= panel_height - (hole_offset_z/2) + 0.001) {
                front_panel_hole_at(post_width/2, z1);
                front_panel_hole_at(rack_width - post_width/2, z1);
            }
        }
        if (holes_per_u >= 2) {
            z2 = (u_seg * u_height) + (hole_offset_z/2) + (hole_spacing * 2);
            if (z2 <= panel_height - (hole_offset_z/2) + 0.001) {
                front_panel_hole_at(post_width/2, z2);
                front_panel_hole_at(rack_width - post_width/2, z2);
            }
        }
        if (holes_per_u >= 3) {
            z3 = (u_seg * u_height) + (hole_offset_z/2) + hole_spacing;
            if (z3 <= panel_height - (hole_offset_z/2) + 0.001) {
                front_panel_hole_at(post_width/2, z3);
                front_panel_hole_at(rack_width - post_width/2, z3);
            }
        }
    }
}


module variable_front_panel_body(panel_height) {
    if (front_panel_edge_radius > 0) {
        translate([front_panel_undersizing + front_panel_edge_radius, 0, front_panel_undersizing + front_panel_edge_radius]) {
            minkowski() {
                cube([
                    rack_width - (front_panel_undersizing*2) - (front_panel_edge_radius*2),
                    front_panel_thickness,
                    panel_height - (front_panel_undersizing*2) - (front_panel_edge_radius*2)
                ]);
                rotate([90,0,0]) {
                    cylinder(r=front_panel_edge_radius, h=0.01, center=true, $fn=32);
                }
            }
        }
    } else {
        translate([front_panel_undersizing, 0, front_panel_undersizing]) {
            cube([rack_width - (front_panel_undersizing*2), front_panel_thickness, panel_height - (front_panel_undersizing*2)]);
        }
    }
}


module variable_front_panel_face_import(
    panel_height,
    import_file = "",
    import_type = "none",
    import_width = 0,
    import_height = 0,
    import_depth = 0.8,
    import_offset_x = 0,
    import_offset_z = 0,
    import_mode = "emboss"
) {
    if ((import_type != "none") && (import_file != "")) {
        panel_inner_width = rack_width - (front_panel_undersizing * 2);
        panel_inner_height = panel_height - (front_panel_undersizing * 2);

        target_width = (import_width > 0) ? import_width : panel_inner_width * 0.5;
        target_height = (import_height > 0) ? import_height : panel_inner_height * 0.5;
        target_depth = (import_depth > 0) ? import_depth : 0.8;

        x_pos = front_panel_undersizing + (panel_inner_width / 2) + import_offset_x;
        z_pos = front_panel_undersizing + (panel_inner_height / 2) + import_offset_z;

        if (import_type == "svg") {
            if (import_mode == "engrave") {
                // Use a tiny overlap so CSG subtraction reliably intersects the panel volume.
                // Keep the same orientation as emboss, but shift it into the panel.
                translate([x_pos, target_depth + 0.01, z_pos]) {
                    rotate([90,0,0]) {
                        linear_extrude(height = target_depth + 0.02) {
                            resize([target_width, target_height], auto = true) {
                                import(file = import_file, center = true);
                            }
                        }
                    }
                }
            } else {
                // Emboss out from the front face (y = -depth to 0)
                translate([x_pos, 0, z_pos]) {
                    rotate([90,0,0]) {
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


module blank_variable_front_panel(
    u_size = 1,
    holes = front_panel_hole_count,
    import_file = "",
    import_type = "none",
    import_width = 0,
    import_height = 0,
    import_depth = 0.8,
    import_offset_x = 0,
    import_offset_z = 0,
    import_mode = "emboss"
) {
    panel_height = u_height * u_size;

    difference() {
        union() {
            variable_front_panel_body(panel_height);
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
                    import_mode
                );
            }
        }

        translate([0, -1, 0]) {
            front_panel_variable_holes(panel_height, holes);
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
                import_mode
            );
        }
    }
}


module side_slide_variable(tray_u_size = 1, side = 0) {
    tray_height = max((u_height * tray_u_size) - 1, post_slide_cutout-hole_clearance);
    tab_height = post_slide_cutout-hole_clearance;
    z_base = (hole_offset_z/2)-(post_slide_cutout/2.1);
    max_u_segments = ceil(tray_u_size) + 1;

    if (side == 0) {
        translate([post_width+post_slide_width+tray_post_clearance, front_panel_thickness, 0]) {
            cube([tray_side_thickness, rack_width, tray_height]);
        }
        for (u_seg = [0:max_u_segments-1]) {
            for (slot = [0:2]) {
                z_pos = (u_seg * u_height) + z_base + (slot * hole_spacing);
                if (z_pos + tab_height <= tray_height + 0.001) {
                    translate([post_width+tray_post_clearance, front_panel_thickness, z_pos]) {
                        cube([post_slide_width, rack_width, tab_height]);
                    }
                }
            }
        }
    } else {
        translate([rack_width - post_width - post_slide_width - tray_post_clearance - tray_side_thickness, front_panel_thickness, 0]) {
            cube([tray_side_thickness, rack_width, tray_height]);
        }
        for (u_seg = [0:max_u_segments-1]) {
            for (slot = [0:2]) {
                z_pos = (u_seg * u_height) + z_base + (slot * hole_spacing);
                if (z_pos + tab_height <= tray_height + 0.001) {
                    translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, z_pos]) {
                        cube([post_slide_width, rack_width, tab_height]);
                    }
                }
            }
        }
    }
}


module variable_tray_front_gusset(panel_u_size = 1, tray_u_size = 1, side = 0, support_back = 20, support_thickness = tray_side_thickness) {
    panel_top = (u_height * panel_u_size) - 1;
    tray_top = max((u_height * tray_u_size) - 1, post_slide_cutout-hole_clearance);
    x0 = (side == 0)
        ? (post_width + post_slide_width + tray_post_clearance)
        : (rack_width - post_width - post_slide_width - tray_post_clearance - support_thickness);
    x1 = x0 + support_thickness;
    y0 = front_panel_thickness;
    y1 = front_panel_thickness + support_back;
    eps = 0.01;

    // Only build gussets when the panel is taller than the side wall.
    if ((panel_top > tray_top + 0.01) && (support_back > 0) && (support_thickness > 0)) {
        // Robust triangular gusset made by hulling three tiny anchor blocks.
        hull() {
            translate([x0, y0, panel_top-eps]) {
                cube([support_thickness, eps, eps]);
            }
            translate([x0, y0, tray_top]) {
                cube([support_thickness, eps, eps]);
            }
            translate([x0, y1, tray_top]) {
                cube([support_thickness, eps, eps]);
            }
        }
    }
}


module blank_variable_tray(
    panel_u_size = 1,
    tray_u_size = panel_u_size,
    holes = front_panel_hole_count,
    import_file = "",
    import_type = "none",
    import_width = 0,
    import_height = 0,
    import_depth = 0.8,
    import_offset_x = 0,
    import_offset_z = 0,
    import_mode = "emboss",
    side_support = 1,
    side_support_back = 40,
    side_support_thickness = tray_side_thickness,
    back_panel = 0,
    back_panel_thickness = tray_side_thickness
) {
    tray_height = max((u_height * tray_u_size) - 1, post_slide_cutout-hole_clearance);
    tray_x0 = post_width + tray_post_clearance + post_slide_width;
    tray_w = (rack_width - (post_width*2)) - (tray_post_clearance*2) - (post_slide_width*2);

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
        import_mode
    );
    translate([tray_x0, 0, front_panel_undersizing]) {
        cube([tray_w, rack_width+front_panel_thickness, tray_thickness]);
    }
    side_slide_variable(tray_u_size, side = 0);
    side_slide_variable(tray_u_size, side = 1);

    if (back_panel == 1) {
        // Rear wall to connect side panels, matching tray side height.
        translate([tray_x0, front_panel_thickness + rack_width - back_panel_thickness, 0]) {
            cube([tray_w, back_panel_thickness, tray_height]);
        }
    }

    if (side_support == 1) {
        variable_tray_front_gusset(panel_u_size, tray_u_size, side = 0, support_back = side_support_back, support_thickness = side_support_thickness);
        variable_tray_front_gusset(panel_u_size, tray_u_size, side = 1, support_back = side_support_back, support_thickness = side_support_thickness);
    }
}
