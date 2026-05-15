/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/15r00";
*/


// front_panel_hole_at(x_pos, z_pos, post_width, hole_d)
// Internal helper — subtracts a single screw hole through the front panel at the given X and Z position.
module front_panel_hole_at(
    x_pos,
    z_pos,
    post_width = 15.875,
    hole_d = 6.3
) {
    translate([x_pos, post_width / 2, z_pos]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_d, h = post_width, center = true, $fn = 32);
        }
    }
}


// front_panel_2U_holes(holes, post_width, rack_width, u_height, hole_offset_z, hole_spacing, hole_d)
// Internal helper — subtracts the correct pattern of screw holes for a 2U front panel.
module front_panel_2U_holes(
    holes = 4,
    post_width = 15.875,
    rack_width = 330,
    u_height = 44.5,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    hole_d = 6.3
) {
    if (holes == 2) {
        front_panel_hole_at(post_width / 2, hole_offset_z / 2, post_width, hole_d);
        front_panel_hole_at(post_width / 2, u_height + (hole_offset_z / 2) + (hole_spacing * 2), post_width, hole_d);
        front_panel_hole_at(rack_width - post_width / 2, hole_offset_z / 2, post_width, hole_d);
        front_panel_hole_at(rack_width - post_width / 2, u_height + (hole_offset_z / 2) + (hole_spacing * 2), post_width, hole_d);
    } else if (holes == 6) {
        front_panel_hole_at(post_width / 2, hole_offset_z / 2, post_width, hole_d);
        front_panel_hole_at(post_width / 2, hole_offset_z / 2 + hole_spacing, post_width, hole_d);
        front_panel_hole_at(post_width / 2, hole_offset_z / 2 + (hole_spacing * 2), post_width, hole_d);
        front_panel_hole_at(post_width / 2, u_height + hole_offset_z / 2, post_width, hole_d);
        front_panel_hole_at(post_width / 2, u_height + hole_offset_z / 2 + hole_spacing, post_width, hole_d);
        front_panel_hole_at(post_width / 2, u_height + hole_offset_z / 2 + (hole_spacing * 2), post_width, hole_d);

        front_panel_hole_at(rack_width - post_width / 2, hole_offset_z / 2, post_width, hole_d);
        front_panel_hole_at(rack_width - post_width / 2, hole_offset_z / 2 + hole_spacing, post_width, hole_d);
        front_panel_hole_at(rack_width - post_width / 2, hole_offset_z / 2 + (hole_spacing * 2), post_width, hole_d);
        front_panel_hole_at(rack_width - post_width / 2, u_height + hole_offset_z / 2, post_width, hole_d);
        front_panel_hole_at(rack_width - post_width / 2, u_height + hole_offset_z / 2 + hole_spacing, post_width, hole_d);
        front_panel_hole_at(rack_width - post_width / 2, u_height + hole_offset_z / 2 + (hole_spacing * 2), post_width, hole_d);
    } else {
        front_panel_hole_at(post_width / 2, hole_offset_z / 2, post_width, hole_d);
        front_panel_hole_at(post_width / 2, hole_offset_z / 2 + (hole_spacing * 2), post_width, hole_d);
        front_panel_hole_at(post_width / 2, u_height + hole_offset_z / 2, post_width, hole_d);
        front_panel_hole_at(post_width / 2, u_height + hole_offset_z / 2 + (hole_spacing * 2), post_width, hole_d);

        front_panel_hole_at(rack_width - post_width / 2, hole_offset_z / 2, post_width, hole_d);
        front_panel_hole_at(rack_width - post_width / 2, hole_offset_z / 2 + (hole_spacing * 2), post_width, hole_d);
        front_panel_hole_at(rack_width - post_width / 2, u_height + hole_offset_z / 2, post_width, hole_d);
        front_panel_hole_at(rack_width - post_width / 2, u_height + hole_offset_z / 2 + (hole_spacing * 2), post_width, hole_d);
    }
}


// blank_1U_front_panel(...)
// Public — generates a 1U blanking front panel.
// Params:
// holes: holes per side (2/3/4/6). rack_width: total panel width. post_width: rail post width.
// u_height: 1U height. front_panel_thickness: panel depth (Y).
// front_panel_undersizing: fit undersize amount applied on X and Z edges.
// front_panel_edge_radius: corner radius; 0 for square edges.
// hole_d, hole_offset_z, hole_spacing: hole geometry.
module blank_1U_front_panel(
    holes = 2,
    rack_width = 330,
    post_width = 15.875,
    u_height = 44.5,
    front_panel_thickness = 3.0,
    front_panel_undersizing = 0.1,
    front_panel_edge_radius = 2.0,
    hole_d = 6.3,
    hole_offset_z = 12.7,
    hole_spacing = 15.875
) {
    difference() {
        union() {
            if (front_panel_edge_radius > 0) {
                translate([front_panel_undersizing + front_panel_edge_radius, 0, front_panel_undersizing + front_panel_edge_radius]) {
                    minkowski() {
                        cube([
                            rack_width - (front_panel_undersizing * 2) - (front_panel_edge_radius * 2),
                            front_panel_thickness,
                            u_height - (front_panel_undersizing * 2) - (front_panel_edge_radius * 2)
                        ]);
                        rotate([90, 0, 0]) {
                            cylinder(r = front_panel_edge_radius, h = 0.01, center = true, $fn = 32);
                        }
                    }
                }
            } else {
                translate([front_panel_undersizing, 0, front_panel_undersizing]) {
                    cube([
                        rack_width - (front_panel_undersizing * 2),
                        front_panel_thickness,
                        u_height - (front_panel_undersizing * 2)
                    ]);
                }
            }
        }

        translate([0, -1, 0]) {
            if (holes >= 1) {
                front_panel_hole_at(post_width / 2, hole_offset_z / 2, post_width, hole_d);
                front_panel_hole_at(rack_width - post_width / 2, hole_offset_z / 2, post_width, hole_d);
            }
            if (holes >= 3) {
                front_panel_hole_at(post_width / 2, hole_offset_z / 2 + hole_spacing, post_width, hole_d);
                front_panel_hole_at(rack_width - post_width / 2, hole_offset_z / 2 + hole_spacing, post_width, hole_d);
            }
            if (holes >= 2) {
                front_panel_hole_at(post_width / 2, hole_offset_z / 2 + (hole_spacing * 2), post_width, hole_d);
                front_panel_hole_at(rack_width - post_width / 2, hole_offset_z / 2 + (hole_spacing * 2), post_width, hole_d);
            }
        }
    }
}


// blank_2U_front_panel(...)
// Public — generates a 2U blanking front panel.
// Params are the same as blank_1U_front_panel, with holes expected as 2/4/6 per side.
module blank_2U_front_panel(
    holes = 4,
    rack_width = 330,
    post_width = 15.875,
    u_height = 44.5,
    front_panel_thickness = 3.0,
    front_panel_undersizing = 0.1,
    front_panel_edge_radius = 2.0,
    hole_d = 6.3,
    hole_offset_z = 12.7,
    hole_spacing = 15.875
) {
    difference() {
        union() {
            if (front_panel_edge_radius > 0) {
                translate([front_panel_undersizing + front_panel_edge_radius, 0, front_panel_undersizing + front_panel_edge_radius]) {
                    minkowski() {
                        cube([
                            rack_width - (front_panel_undersizing * 2) - (front_panel_edge_radius * 2),
                            front_panel_thickness,
                            (u_height * 2) - (front_panel_undersizing * 2) - (front_panel_edge_radius * 2)
                        ]);
                        rotate([90, 0, 0]) {
                            cylinder(r = front_panel_edge_radius, h = 0.01, center = true, $fn = 32);
                        }
                    }
                }
            } else {
                translate([front_panel_undersizing, 0, front_panel_undersizing]) {
                    cube([
                        rack_width - (front_panel_undersizing * 2),
                        front_panel_thickness,
                        (u_height * 2) - (front_panel_undersizing * 2)
                    ]);
                }
            }
        }

        translate([0, -1, 0]) {
            front_panel_2U_holes(holes, post_width, rack_width, u_height, hole_offset_z, hole_spacing, hole_d);
        }
    }
}


// blank_05U_front_panel(...)
// Public — generates a 0.5U blanking front panel.
// Params:
// rack_width, post_width: rail geometry. front_panel_thickness: panel depth.
// front_panel_undersizing, front_panel_edge_radius: fit and edge shaping.
// hole_d, hole_offset_z: hole geometry; this module uses a fixed 2-hole-per-side 0.5U pattern.
module blank_05U_front_panel(
    rack_width = 330,
    post_width = 15.875,
    front_panel_thickness = 3.0,
    front_panel_undersizing = 0.1,
    front_panel_edge_radius = 2.0,
    hole_d = 6.3,
    hole_offset_z = 12.7
) {
    half_u = hole_offset_z * 2;
    difference() {
        union() {
            if (front_panel_edge_radius > 0) {
                translate([front_panel_undersizing + front_panel_edge_radius, 0, front_panel_undersizing + front_panel_edge_radius]) {
                    minkowski() {
                        cube([
                            rack_width - (front_panel_undersizing * 2) - (front_panel_edge_radius * 2),
                            front_panel_thickness,
                            half_u - (front_panel_undersizing * 2) - (front_panel_edge_radius * 2)
                        ]);
                        rotate([90, 0, 0]) {
                            cylinder(r = front_panel_edge_radius, h = 0.01, center = true, $fn = 32);
                        }
                    }
                }
            } else {
                translate([front_panel_undersizing, 0, front_panel_undersizing]) {
                    cube([
                        rack_width - (front_panel_undersizing * 2),
                        front_panel_thickness,
                        half_u - (front_panel_undersizing * 2)
                    ]);
                }
            }
        }

        translate([0, -1, 0]) {
            front_panel_hole_at(post_width / 2, hole_offset_z / 2, post_width, hole_d);
            front_panel_hole_at(post_width / 2, hole_offset_z * 3 / 2, post_width, hole_d);
            front_panel_hole_at(rack_width - post_width / 2, hole_offset_z / 2, post_width, hole_d);
            front_panel_hole_at(rack_width - post_width / 2, hole_offset_z * 3 / 2, post_width, hole_d);
        }
    }
}


// post_base_join_panel(...)
// Public — compact panel to join one post footprint (or two for doublewide) to a base joiner.
// Params:
// doublewide: 0 single post footprint, 1 double. thickness: panel thickness.
// post_width: rail post width. hole_offset_z and hole_d: hole geometry.
module post_base_join_panel(
    doublewide = 0,
    thickness = 3.0,
    post_width = 15.875,
    hole_offset_z = 12.7,
    hole_d = 6.3
) {
    panel_width = (doublewide == 1) ? (post_width * 2) : post_width;
    panel_height = hole_offset_z * 2;

    difference() {
        cube([panel_width, thickness, panel_height]);
        for (x_pos = (doublewide == 1) ? [post_width / 2, post_width + post_width / 2] : [post_width / 2]) {
            translate([x_pos, thickness / 2, hole_offset_z / 2]) {
                rotate([90, 0, 0]) {
                    cylinder(d = hole_d, h = thickness + 2, center = true, $fn = 32);
                }
            }
            translate([x_pos, thickness / 2, hole_offset_z * 3 / 2]) {
                rotate([90, 0, 0]) {
                    cylinder(d = hole_d, h = thickness + 2, center = true, $fn = 32);
                }
            }
        }
    }
}



/**

// side_slide(...)
// Internal helper — builds the 1U tray side wall and slide tabs.
module side_slide(
    count = 3,
    side = 0,
    rack_width = 330,
    post_width = 15.875,
    u_height = 44.5,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    post_slide_width = 3.0,
    post_slide_cutout = 3.2,
    hole_clearance = 0.3,
    tray_post_clearance = 0.5,
    tray_side_thickness = 2.0,
    front_panel_thickness = 3.0
) {
    union() {
        if (side == 0) {
            translate([post_width + post_slide_width + tray_post_clearance, front_panel_thickness, 0]) {
                if (count == 1) {
                    cube([tray_side_thickness, rack_width, u_height - hole_spacing * 2]);
                } else if (count == 2) {
                    cube([tray_side_thickness, rack_width, u_height - hole_spacing]);
                } else if (count >= 3) {
                    cube([tray_side_thickness, rack_width, u_height - 1]);
                }
            }
            if (count >= 1) {
                translate([post_width + tray_post_clearance, front_panel_thickness, (hole_offset_z / 2) - (post_slide_cutout / 2.1)]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 2) {
                translate([post_width + tray_post_clearance, front_panel_thickness, (hole_offset_z / 2) - (post_slide_cutout / 2.1) + hole_spacing]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 3) {
                translate([post_width + tray_post_clearance, front_panel_thickness, (hole_offset_z / 2) - (post_slide_cutout / 2.1) + hole_spacing * 2]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
        } else {
            translate([rack_width - post_width - post_slide_width - tray_post_clearance - tray_side_thickness, front_panel_thickness, 0]) {
                if (count == 1) {
                    cube([tray_side_thickness, rack_width, u_height - hole_spacing * 2]);
                } else if (count == 2) {
                    cube([tray_side_thickness, rack_width, u_height - hole_spacing]);
                } else if (count >= 3) {
                    cube([tray_side_thickness, rack_width, u_height - 1]);
                }
            }
            if (count >= 1) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, (hole_offset_z / 2) - (post_slide_cutout / 2.1)]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 2) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, (hole_offset_z / 2) - (post_slide_cutout / 2.1) + hole_spacing]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 3) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, (hole_offset_z / 2) - (post_slide_cutout / 2.1) + hole_spacing * 2]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
        }
    }
}


// tray_side_height_2U(...)
// Internal helper — generates the side wall body for a 2U tray at the correct height.
module tray_side_height_2U(
    count = 3,
    tray_side_thickness = 2.0,
    rack_width = 330,
    u_height = 44.5,
    hole_spacing = 15.875
) {
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


// side_slide_2U(...)
// Internal helper — builds the 2U tray side wall and slide tabs.
module side_slide_2U(
    count = 3,
    side = 0,
    rack_width = 330,
    post_width = 15.875,
    u_height = 44.5,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    post_slide_width = 3.0,
    post_slide_cutout = 3.2,
    hole_clearance = 0.3,
    tray_post_clearance = 0.5,
    tray_side_thickness = 2.0,
    front_panel_thickness = 3.0
) {
    union() {
        if (side == 0) {
            translate([post_width + post_slide_width + tray_post_clearance, front_panel_thickness, 0]) {
                tray_side_height_2U(count, tray_side_thickness, rack_width, u_height, hole_spacing);
            }
            if (count >= 1) {
                translate([post_width + tray_post_clearance, front_panel_thickness, (hole_offset_z / 2) - (post_slide_cutout / 2.1)]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 2) {
                translate([post_width + tray_post_clearance, front_panel_thickness, (hole_offset_z / 2) - (post_slide_cutout / 2.1) + hole_spacing]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 3) {
                translate([post_width + tray_post_clearance, front_panel_thickness, (hole_offset_z / 2) - (post_slide_cutout / 2.1) + hole_spacing * 2]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 4) {
                translate([post_width + tray_post_clearance, front_panel_thickness, u_height + (hole_offset_z / 2) - (post_slide_cutout / 2.1)]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 5) {
                translate([post_width + tray_post_clearance, front_panel_thickness, u_height + (hole_offset_z / 2) - (post_slide_cutout / 2.1) + hole_spacing]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 6) {
                translate([post_width + tray_post_clearance, front_panel_thickness, u_height + (hole_offset_z / 2) - (post_slide_cutout / 2.1) + hole_spacing * 2]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
        } else {
            translate([rack_width - post_width - post_slide_width - tray_post_clearance - tray_side_thickness, front_panel_thickness, 0]) {
                tray_side_height_2U(count, tray_side_thickness, rack_width, u_height, hole_spacing);
            }
            if (count >= 1) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, (hole_offset_z / 2) - (post_slide_cutout / 2.1)]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 2) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, (hole_offset_z / 2) - (post_slide_cutout / 2.1) + hole_spacing]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 3) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, (hole_offset_z / 2) - (post_slide_cutout / 2.1) + hole_spacing * 2]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 4) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, u_height + (hole_offset_z / 2) - (post_slide_cutout / 2.1)]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 5) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, u_height + (hole_offset_z / 2) - (post_slide_cutout / 2.1) + hole_spacing]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
            if (count >= 6) {
                translate([rack_width - post_width - tray_post_clearance - post_slide_width, front_panel_thickness, u_height + (hole_offset_z / 2) - (post_slide_cutout / 2.1) + hole_spacing * 2]) {
                    cube([post_slide_width, rack_width, post_slide_cutout - hole_clearance]);
                }
            }
        }
    }
}


// blank_1U_tray(...)
// Public — generates a 1U tray with front panel and side slides.
// Params:
// side_count: slide tab count per side (1-3). edge_radius: front corner radius.
// holes: panel holes per side. tray_thickness, tray_side_thickness: tray structure.
// tray_post_clearance: post clearance per side. post_slide_width/post_slide_cutout: slide geometry.
// hole_clearance, hole_offset_z, hole_spacing, hole_d: hole and slot geometry.
// rack_width, post_width, u_height: overall rack geometry.
// front_panel_thickness, front_panel_undersizing: front panel geometry.
module blank_1U_tray(
    side_count = 3,
    edge_radius = 2.0,
    holes = 2,
    rack_width = 330,
    post_width = 15.875,
    u_height = 44.5,
    front_panel_thickness = 3.0,
    front_panel_undersizing = 0.1,
    hole_d = 6.3,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    tray_thickness = 5.0,
    tray_post_clearance = 0.5,
    tray_side_thickness = 2.0,
    post_slide_width = 3.0,
    post_slide_cutout = 3.2,
    hole_clearance = 0.3
) {
    blank_1U_front_panel(
        holes,
        rack_width,
        post_width,
        u_height,
        front_panel_thickness,
        front_panel_undersizing,
        edge_radius,
        hole_d,
        hole_offset_z,
        hole_spacing
    );
    translate([post_width + tray_post_clearance + post_slide_width, 0, front_panel_undersizing]) {
        cube([
            ((rack_width - (post_width * 2)) - (tray_post_clearance * 2) - (post_slide_width * 2)),
            rack_width + front_panel_thickness,
            tray_thickness
        ]);
    }
    side_slide(
        count = side_count,
        side = 0,
        rack_width = rack_width,
        post_width = post_width,
        u_height = u_height,
        hole_offset_z = hole_offset_z,
        hole_spacing = hole_spacing,
        post_slide_width = post_slide_width,
        post_slide_cutout = post_slide_cutout,
        hole_clearance = hole_clearance,
        tray_post_clearance = tray_post_clearance,
        tray_side_thickness = tray_side_thickness,
        front_panel_thickness = front_panel_thickness
    );
    side_slide(
        count = side_count,
        side = 1,
        rack_width = rack_width,
        post_width = post_width,
        u_height = u_height,
        hole_offset_z = hole_offset_z,
        hole_spacing = hole_spacing,
        post_slide_width = post_slide_width,
        post_slide_cutout = post_slide_cutout,
        hole_clearance = hole_clearance,
        tray_post_clearance = tray_post_clearance,
        tray_side_thickness = tray_side_thickness,
        front_panel_thickness = front_panel_thickness
    );
}


// blank_2U_tray(...)
// Public — generates a 2U tray with front panel and side slides.
// Params are the same as blank_1U_tray, with side_count expected as 1-6 and holes 2/4/6.
module blank_2U_tray(
    side_count = 3,
    edge_radius = 2.0,
    holes = 4,
    rack_width = 330,
    post_width = 15.875,
    u_height = 44.5,
    front_panel_thickness = 3.0,
    front_panel_undersizing = 0.1,
    hole_d = 6.3,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    tray_thickness = 5.0,
    tray_post_clearance = 0.5,
    tray_side_thickness = 2.0,
    post_slide_width = 3.0,
    post_slide_cutout = 3.2,
    hole_clearance = 0.3
) {
    blank_2U_front_panel(
        holes,
        rack_width,
        post_width,
        u_height,
        front_panel_thickness,
        front_panel_undersizing,
        edge_radius,
        hole_d,
        hole_offset_z,
        hole_spacing
    );
    translate([post_width + tray_post_clearance + post_slide_width, 0, front_panel_undersizing]) {
        cube([
            ((rack_width - (post_width * 2)) - (tray_post_clearance * 2) - (post_slide_width * 2)),
            rack_width + front_panel_thickness,
            tray_thickness
        ]);
    }
    side_slide_2U(
        count = side_count,
        side = 0,
        rack_width = rack_width,
        post_width = post_width,
        u_height = u_height,
        hole_offset_z = hole_offset_z,
        hole_spacing = hole_spacing,
        post_slide_width = post_slide_width,
        post_slide_cutout = post_slide_cutout,
        hole_clearance = hole_clearance,
        tray_post_clearance = tray_post_clearance,
        tray_side_thickness = tray_side_thickness,
        front_panel_thickness = front_panel_thickness
    );
    side_slide_2U(
        count = side_count,
        side = 1,
        rack_width = rack_width,
        post_width = post_width,
        u_height = u_height,
        hole_offset_z = hole_offset_z,
        hole_spacing = hole_spacing,
        post_slide_width = post_slide_width,
        post_slide_cutout = post_slide_cutout,
        hole_clearance = hole_clearance,
        tray_post_clearance = tray_post_clearance,
        tray_side_thickness = tray_side_thickness,
        front_panel_thickness = front_panel_thickness
    );
}
**/