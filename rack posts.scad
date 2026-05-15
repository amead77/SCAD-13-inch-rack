/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/15r06";
*/

// Standalone defaults are defined in each module signature.
// The old rack defines file is no longer required here.


// post(slide_side, doublewide)
// Builds a single 1U post body with optional slide channel(s).
// slide_side: 0=none, 1=left, 2=right, 3=both. doublewide: 0=single, 1=double.
// post_width: width/depth of one post footprint. u_height: one rack unit height in mm.
// post_slide_width/post_slide_cutout: side-slide rail width and slot cutout size.
// hole_offset_z/hole_spacing: vertical hole/slot placement inside each U section.
// e.g. post(slide_side=1, doublewide=0);
module post(
    slide_side = 0,
    doublewide = 0,
    post_width = 15.875,
    u_height = 44.5,
    post_slide_width = 3.0,
    post_slide_cutout = 3.2,
    hole_offset_z = 12.7,
    hole_spacing = 15.875
) {
    union() {
        cube([post_width, post_width, u_height]);
        if (doublewide == 1) {
            translate([post_width, 0, 0]) {
                cube([post_width, post_width, u_height]);
            }
        }
        if (doublewide == 0) {
            if ((slide_side == 1) || (slide_side == 3)) {
                post_slider_left(
                    post_width = post_width,
                    post_slide_width = post_slide_width,
                    post_slide_cutout = post_slide_cutout,
                    u_height = u_height,
                    hole_offset_z = hole_offset_z,
                    hole_spacing = hole_spacing
                );
            }
            if ((slide_side == 2) || (slide_side == 3)) {
                post_slider_right(
                    post_slide_width = post_slide_width,
                    post_width = post_width,
                    post_slide_cutout = post_slide_cutout,
                    u_height = u_height,
                    hole_offset_z = hole_offset_z,
                    hole_spacing = hole_spacing
                );
            }
        } else {
            if ((slide_side == 1) || (slide_side == 3)) {
                post_slider_left(
                    post_width = post_width,
                    post_slide_width = post_slide_width,
                    post_slide_cutout = post_slide_cutout,
                    u_height = u_height,
                    hole_offset_z = hole_offset_z,
                    hole_spacing = hole_spacing
                );
                translate([post_width, 0, 0]) {
                    post_slider_left(
                        post_width = post_width,
                        post_slide_width = post_slide_width,
                        post_slide_cutout = post_slide_cutout,
                        u_height = u_height,
                        hole_offset_z = hole_offset_z,
                        hole_spacing = hole_spacing
                    );
                }
            }
            if ((slide_side == 2) || (slide_side == 3)) {
                post_slider_right(
                    post_slide_width = post_slide_width,
                    post_width = post_width,
                    post_slide_cutout = post_slide_cutout,
                    u_height = u_height,
                    hole_offset_z = hole_offset_z,
                    hole_spacing = hole_spacing
                );
                translate([post_width, 0, 0]) {
                    post_slider_right(
                        post_slide_width = post_slide_width,
                        post_width = post_width,
                        post_slide_cutout = post_slide_cutout,
                        u_height = u_height,
                        hole_offset_z = hole_offset_z,
                        hole_spacing = hole_spacing
                    );
                }
            }
        }
    }
}


// post_slides()
// Internal helper — generates the slide rail geometry that attaches to a post side.
// Not called directly; used by post_slider_left() and post_slider_right().
module post_slides(
    post_slide_width = 3.0,
    post_width = 15.875,
    u_height = 44.5,
    hole_offset_z = 12.7,
    post_slide_cutout = 3.2,
    hole_spacing = 15.875
) {
    difference() {
        cube([post_slide_width, post_width, u_height]);
        translate([0, 0, (hole_offset_z / 2) - (post_slide_cutout / 2)]) {
            cube([post_slide_cutout, post_width, post_slide_cutout]);
        }
        translate([0, 0, (hole_offset_z / 2) - (post_slide_cutout / 2) + hole_spacing]) {
            cube([post_slide_cutout, post_width, post_slide_cutout]);
        }
        translate([0, 0, (hole_offset_z / 2) - (post_slide_cutout / 2) + hole_spacing * 2]) {
            cube([post_slide_cutout, post_width, post_slide_cutout]);
        }
    }
}


// post_slider_left()
// Internal helper — attaches a slide rail to the left side of a post.
module post_slider_left(
    post_width = 15.875,
    post_slide_width = 3.0,
    post_slide_cutout = 3.2,
    u_height = 44.5,
    hole_offset_z = 12.7,
    hole_spacing = 15.875
) {
    translate([post_width, 0, 0]) {
        post_slides(
            post_slide_width = post_slide_width,
            post_width = post_width,
            u_height = u_height,
            hole_offset_z = hole_offset_z,
            post_slide_cutout = post_slide_cutout,
            hole_spacing = hole_spacing
        );
    }
}


// post_slider_right()
// Internal helper — attaches a slide rail to the right side of a post.
module post_slider_right(
    post_slide_width = 3.0,
    post_width = 15.875,
    post_slide_cutout = 3.2,
    u_height = 44.5,
    hole_offset_z = 12.7,
    hole_spacing = 15.875
) {
    translate([-post_slide_width, 0, 0]) {
        post_slides(
            post_slide_width = post_slide_width,
            post_width = post_width,
            u_height = u_height,
            hole_offset_z = hole_offset_z,
            post_slide_cutout = post_slide_cutout,
            hole_spacing = hole_spacing
        );
    }
}


// rail_1u_holes_segment(slide_side, doublewide)
// Internal helper — one 1U post segment with screw holes and nut traps subtracted.
// slide_side: 0=none, 1=left, 2=right, 3=both. doublewide: 0=single, 1=double.
module rail_1u_holes_segment(
    slide_side,
    doublewide = 0,
    post_width = 15.875,
    u_height = 44.5,
    post_slide_width = 3.0,
    post_slide_cutout = 3.2,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    hole_d = 6.3,
    nut_thickness = 6.3,
    nut_diameter_point = 10.3 / cos(30)
) {
    difference() {
        post(
            slide_side = slide_side,
            doublewide = doublewide,
            post_width = post_width,
            u_height = u_height,
            post_slide_width = post_slide_width,
            post_slide_cutout = post_slide_cutout,
            hole_offset_z = hole_offset_z,
            hole_spacing = hole_spacing
        );
        holes(holes = 3, post_width = post_width, hole_offset_z = hole_offset_z, hole_spacing = hole_spacing, hole_d = hole_d);
        nut_holes(holes = 3, post_width = post_width, nut_thickness = nut_thickness, nut_diameter_point = nut_diameter_point, hole_offset_z = hole_offset_z, hole_spacing = hole_spacing);
        if (doublewide == 1) {
            translate([post_width, 0, 0]) {
                holes(holes = 3, post_width = post_width, hole_offset_z = hole_offset_z, hole_spacing = hole_spacing, hole_d = hole_d);
                nut_holes(holes = 3, post_width = post_width, nut_thickness = nut_thickness, nut_diameter_point = nut_diameter_point, hole_offset_z = hole_offset_z, hole_spacing = hole_spacing);
            }
        }
    }
}


// footer_body(doublewide)
// Internal helper — solid block at the bottom of the post for the footer attachment.
// doublewide: 0=single, 1=double.
module footer_body(
    doublewide = 0,
    post_width = 15.875,
    footer_height = 12.7
) {
    translate([0, 0, -footer_height]) {
        cube([post_width, post_width, footer_height]);
    }
    if (doublewide == 1) {
        translate([post_width, 0, -footer_height]) {
            cube([post_width, post_width, footer_height]);
        }
    }
}


// footer_hole_and_nut()
// Internal helper — subtracts the screw hole and nut trap from the footer body.
module footer_hole_and_nut(
    post_width = 15.875,
    hole_offset_z = 12.7,
    hole_d = 6.3,
    nut_thickness = 6.3,
    nut_diameter_point = 10.3 / cos(30)
) {
    translate([post_width / 2, post_width / 2, -(hole_offset_z / 2)]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_d, h = post_width, center = true, $fn = 32);
        }
    }
    translate([post_width / 2, post_width - nut_thickness / 2, -(hole_offset_z / 2)]) {
        rotate([90, 0, 0]) {
            cylinder(d = nut_diameter_point, h = nut_thickness, center = true, $fn = 6);
        }
    }
}


// header_body(post_height, doublewide)
// Internal helper — solid block at the top of the post for the header attachment.
// post_height: number of U units. doublewide: 0=single, 1=double.
module header_body(
    post_height,
    doublewide = 0,
    post_width = 15.875,
    u_height = 44.5,
    header_height = 12.7
) {
    translate([0, 0, u_height * post_height]) {
        cube([post_width, post_width, header_height]);
    }
    if (doublewide == 1) {
        translate([post_width, 0, u_height * post_height]) {
            cube([post_width, post_width, header_height]);
        }
    }
}


// header_hole_and_nut(post_height)
// Internal helper — subtracts the screw hole and nut trap from the header body.
// post_height: number of U units the post is tall.
module header_hole_and_nut(
    post_height,
    post_width = 15.875,
    u_height = 44.5,
    hole_offset_z = 12.7,
    hole_d = 6.3,
    nut_thickness = 6.3,
    nut_diameter_point = 10.3 / cos(30)
) {
    translate([post_width / 2, post_width / 2, u_height * post_height + (hole_offset_z / 2)]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_d, h = post_width, center = true, $fn = 32);
        }
    }
    translate([post_width / 2, post_width - nut_thickness / 2, u_height * post_height + (hole_offset_z / 2)]) {
        rotate([90, 0, 0]) {
            cylinder(d = nut_diameter_point, h = nut_thickness, center = true, $fn = 6);
        }
    }
}


// base_joiner_hole_and_nut()
// Internal helper — subtracts the screw hole and nut trap from a joiner block.
module base_joiner_hole_and_nut(
    post_width = 15.875,
    hole_offset_z = 12.7,
    hole_d = 6.3,
    nut_thickness = 6.3,
    nut_diameter_point = 10.3 / cos(30)
) {
    translate([post_width / 2, post_width / 2, hole_offset_z / 2]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_d, h = post_width, center = true, $fn = 32);
        }
    }
    translate([post_width / 2, post_width - nut_thickness / 2, hole_offset_z / 2]) {
        rotate([90, 0, 0]) {
            cylinder(d = nut_diameter_point, h = nut_thickness, center = true, $fn = 6);
        }
    }
}


// base_joiner_block(doublewide)
// Internal helper — one joiner mounting block with hole and nut trap.
// doublewide: 0=single, 1=double.
module base_joiner_block(
    doublewide = 0,
    post_width = 15.875,
    footer_height = 12.7,
    hole_offset_z = 12.7,
    hole_d = 6.3,
    nut_thickness = 6.3,
    nut_diameter_point = 10.3 / cos(30)
) {
    translate([0, 0, -(footer_height * 2)]) {
        difference() {
            cube([post_width, post_width, footer_height]);
            base_joiner_hole_and_nut(
                post_width = post_width,
                hole_offset_z = hole_offset_z,
                hole_d = hole_d,
                nut_thickness = nut_thickness,
                nut_diameter_point = nut_diameter_point
            );
        }
    }
    if (doublewide == 1) {
        translate([post_width, 0, -(footer_height * 2)]) {
            difference() {
                cube([post_width, post_width, footer_height]);
                base_joiner_hole_and_nut(
                    post_width = post_width,
                    hole_offset_z = hole_offset_z,
                    hole_d = hole_d,
                    nut_thickness = nut_thickness,
                    nut_diameter_point = nut_diameter_point
                );
            }
        }
    }
}


// base_joiner_core(doublewide, bottom, supports, beam_thickness)
// Internal helper — builds the full joiner body (blocks + beam + alignment cones).
// doublewide: 0=single, 1=double. bottom: 1=base joiner, 0=top joiner.
// supports: minimum 2 (front + rear); >2 adds equally-spaced intermediate support blocks.
module base_joiner_core(
    doublewide = 0,
    bottom = 1,
    supports = 2,
    beam_thickness = 5.0,
    post_width = 15.875,
    rack_width = 330,
    footer_height = 12.7,
    hole_offset_z = 12.7,
    hole_d = 6.3,
    nut_thickness = 6.3,
    nut_diameter_point = 10.3 / cos(30),
    post_cone_base_diameter = 10.0,
    post_cone_top_diameter = 4.0,
    post_cone_height = 2.0,
    post_top_cone_clearance = 0.1
) {
    _beam_thickness = beam_thickness;
    union() {
        base_joiner_block(
            doublewide = doublewide,
            post_width = post_width,
            footer_height = footer_height,
            hole_offset_z = hole_offset_z,
            hole_d = hole_d,
            nut_thickness = nut_thickness,
            nut_diameter_point = nut_diameter_point
        );
        translate([0, rack_width - post_width, 0]) {
            if (doublewide == 1) {
                translate([post_width * 2, post_width, 0]) {
                    rotate([0, 0, 180]) {
                        base_joiner_block(
                            doublewide = doublewide,
                            post_width = post_width,
                            footer_height = footer_height,
                            hole_offset_z = hole_offset_z,
                            hole_d = hole_d,
                            nut_thickness = nut_thickness,
                            nut_diameter_point = nut_diameter_point
                        );
                    }
                }
            } else {
                translate([post_width, post_width, 0]) {
                    rotate([0, 0, 180]) {
                        base_joiner_block(
                            doublewide = doublewide,
                            post_width = post_width,
                            footer_height = footer_height,
                            hole_offset_z = hole_offset_z,
                            hole_d = hole_d,
                            nut_thickness = nut_thickness,
                            nut_diameter_point = nut_diameter_point
                        );
                    }
                }
            }
        }
        if (doublewide == 1) {
            translate([0, 0, 0]) {
                base_joiner_block(
                    doublewide = doublewide,
                    post_width = post_width,
                    footer_height = footer_height,
                    hole_offset_z = hole_offset_z,
                    hole_d = hole_d,
                    nut_thickness = nut_thickness,
                    nut_diameter_point = nut_diameter_point
                );
            }
        } else {
            base_joiner_block(
                doublewide = doublewide,
                post_width = post_width,
                footer_height = footer_height,
                hole_offset_z = hole_offset_z,
                hole_d = hole_d,
                nut_thickness = nut_thickness,
                nut_diameter_point = nut_diameter_point
            );
        }

        if (supports > 2) {
            for (i = [1:supports - 2]) {
                translate([0, i * (rack_width - post_width) / (supports - 1), 0]) {
                    base_joiner_block(
                        doublewide = doublewide,
                        post_width = post_width,
                        footer_height = footer_height,
                        hole_offset_z = hole_offset_z,
                        hole_d = hole_d,
                        nut_thickness = nut_thickness,
                        nut_diameter_point = nut_diameter_point
                    );
                }
            }
        }

        translate([0, 0, -((footer_height * 2) + _beam_thickness)]) {
            if (doublewide == 0) {
                cube([post_width, rack_width, _beam_thickness]);
            }
            if (doublewide == 1) {
                cube([post_width * 2, rack_width, _beam_thickness]);
            }
        }

        if (bottom == 1) {
            translate([post_width / 2, post_width / 2, -footer_height]) {
                cylinder(h = post_cone_height, r1 = (post_cone_base_diameter / 2) - post_top_cone_clearance, r2 = (post_cone_top_diameter / 2) - post_top_cone_clearance, center = false, $fn = 32);
            }
            if (doublewide == 1) {
                translate([post_width + post_width / 2, post_width / 2, -footer_height]) {
                    cylinder(h = post_cone_height, r1 = (post_cone_base_diameter / 2) - post_top_cone_clearance, r2 = (post_cone_top_diameter / 2) - post_top_cone_clearance, center = false, $fn = 32);
                }
            }

            translate([post_width / 2, rack_width - post_width / 2, -footer_height]) {
                cylinder(h = post_cone_height, r1 = (post_cone_base_diameter / 2) - post_top_cone_clearance, r2 = (post_cone_top_diameter / 2) - post_top_cone_clearance, center = false, $fn = 32);
            }
            if (doublewide == 1) {
                translate([post_width + post_width / 2, rack_width - post_width / 2, -footer_height]) {
                    cylinder(h = post_cone_height, r1 = (post_cone_base_diameter / 2) - post_top_cone_clearance, r2 = (post_cone_top_diameter / 2) - post_top_cone_clearance, center = false, $fn = 32);
                }
            }

            if (supports > 2) {
                for (i = [1:supports - 2]) {
                    translate([post_width / 2, i * (rack_width - post_width) / (supports - 1) + post_width / 2, -footer_height]) {
                        cylinder(h = post_cone_height, r1 = (post_cone_base_diameter / 2) - post_top_cone_clearance, r2 = (post_cone_top_diameter / 2) - post_top_cone_clearance, center = false, $fn = 32);
                    }
                    if (doublewide == 1) {
                        translate([post_width + post_width / 2, i * (rack_width - post_width) / (supports - 1) + post_width / 2, -footer_height]) {
                            cylinder(h = post_cone_height, r1 = (post_cone_base_diameter / 2) - post_top_cone_clearance, r2 = (post_cone_top_diameter / 2) - post_top_cone_clearance, center = false, $fn = 32);
                        }
                    }
                }
            }
        }
    }
}


// base_joiner(doublewide, bottom, supports, beam_thickness)
// Horizontal joiner that connects a front and rear post pair via the footer/header.
// doublewide: 0=single, 1=double post footprint.
// bottom: 1=base/footer joiner, 0=top/header joiner.
// supports: minimum 2 (front+rear); >2 adds equally-spaced intermediate support blocks.
// beam_thickness: beam thickness in mm.
// post_width/rack_width/footer_height/header_height: joiner body dimensions.
// hole_offset_z/hole_d/nut_thickness/nut_diameter_point: mounting and nut trap geometry.
// post_cone_base_diameter/post_cone_top_diameter/post_cone_height/post_top_cone_clearance: alignment cone geometry.
module base_joiner(
    doublewide = 0,
    bottom = 1,
    supports = 2,
    beam_thickness = 5.0,
    post_width = 15.875,
    rack_width = 330,
    rack_depth = 330,
    footer_height = 12.7,
    header_height = 12.7,
    hole_offset_z = 12.7,
    hole_d = 6.3,
    nut_thickness = 6.3,
    nut_diameter_point = 10.3 / cos(30),
    post_cone_base_diameter = 10.0,
    post_cone_top_diameter = 4.0,
    post_cone_height = 2.0,
    post_top_cone_clearance = 0.1
) {
    if (bottom == 1) {
        base_joiner_core(
            doublewide = doublewide,
            bottom = bottom,
            supports = supports,
            beam_thickness = beam_thickness,
            post_width = post_width,
            rack_width = rack_width,
            //rack_depth = rack_depth,
            footer_height = footer_height,
            hole_offset_z = hole_offset_z,
            hole_d = hole_d,
            nut_thickness = nut_thickness,
            nut_diameter_point = nut_diameter_point,
            post_cone_base_diameter = post_cone_base_diameter,
            post_cone_top_diameter = post_cone_top_diameter,
            post_cone_height = post_cone_height,
            post_top_cone_clearance = post_top_cone_clearance
        );
    } else {
        difference() {
            mirror([0, 0, 1]) {
                base_joiner_core(
                    doublewide = doublewide,
                    bottom = bottom,
                    supports = supports,
                    beam_thickness = beam_thickness,
                    post_width = post_width,
                    rack_width = rack_width,
                    //rack_depth = rack_depth,
                    footer_height = footer_height,
                    hole_offset_z = hole_offset_z,
                    hole_d = hole_d,
                    nut_thickness = nut_thickness,
                    nut_diameter_point = nut_diameter_point,
                    post_cone_base_diameter = post_cone_base_diameter,
                    post_cone_top_diameter = post_cone_top_diameter,
                    post_cone_height = post_cone_height,
                    post_top_cone_clearance = post_top_cone_clearance
                );
            }

            translate([post_width / 2, post_width / 2, header_height]) {
                cylinder(h = post_cone_height - post_top_cone_clearance, r1 = (post_cone_base_diameter / 2), r2 = (post_cone_top_diameter / 2), center = false, $fn = 32);
            }
            if (doublewide == 1) {
                translate([post_width + post_width / 2, post_width / 2, header_height]) {
                    cylinder(h = post_cone_height - post_top_cone_clearance, r1 = (post_cone_base_diameter / 2), r2 = (post_cone_top_diameter / 2), center = false, $fn = 32);
                }
            }

            translate([post_width / 2, rack_depth - post_width / 2, header_height]) {
                cylinder(h = post_cone_height - post_top_cone_clearance, r1 = (post_cone_base_diameter / 2), r2 = (post_cone_top_diameter / 2), center = false, $fn = 32);
            }
            if (doublewide == 1) {
                translate([post_width + post_width / 2, rack_depth - post_width / 2, header_height]) {
                    cylinder(h = post_cone_height - post_top_cone_clearance, r1 = (post_cone_base_diameter / 2), r2 = (post_cone_top_diameter / 2), center = false, $fn = 32);
                }
            }

            if (supports > 2) {
                for (i = [1:supports - 2]) {
                    translate([post_width / 2, i * (rack_depth - post_width) / (supports - 1) + post_width / 2, header_height]) {
                        cylinder(h = post_cone_height - post_top_cone_clearance, r1 = (post_cone_base_diameter / 2), r2 = (post_cone_top_diameter / 2), center = false, $fn = 32);
                    }
                    if (doublewide == 1) {
                        translate([post_width + post_width / 2, i * (rack_depth - post_width) / (supports - 1) + post_width / 2, header_height]) {
                            cylinder(h = post_cone_height - post_top_cone_clearance, r1 = (post_cone_base_diameter / 2), r2 = (post_cone_top_diameter / 2), center = false, $fn = 32);
                        }
                    }
                }
            }
        }
    }
}


// rail_1u_holes(slide_side, doublewide, post_height, v_post_cones, include_footer, include_header)
// Main public module — generates a complete post of post_height U units with holes, nut traps,
// optional slide rails, optional footer/header blocks, and optional alignment cones.
// slide_side: 0=none, 1=left, 2=right, 3=both.
// doublewide: 0=single, 1=double post footprint.
// post_height: post height in U units.
// v_post_cones: 1 adds top cones and bottom sockets for stacking.
// include_footer/include_header: 1 includes corresponding attachment blocks.
// post_width/u_height: post envelope dimensions.
// hole_d/hole_offset_z/hole_spacing: screw-hole geometry and vertical pattern.
// nut_thickness/nut_diameter_point: nut trap dimensions.
// post_slide_width/post_slide_cutout: slide rail dimensions.
// footer_height/header_height: footer/header block heights.
// post_cone_*: alignment cone and clearance dimensions.
module rail_1u_holes(
    slide_side,
    doublewide = 0,
    post_height = 3,
    v_post_cones = 1,
    include_footer = 1,
    include_header = 1,
    post_width = 15.875,
    u_height = 44.5,
    hole_d = 6.3,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    nut_thickness = 6.3,
    nut_diameter_point = 10.3 / cos(30),
    post_slide_width = 3.0,
    post_slide_cutout = 3.2,
    footer_height = 12.7,
    header_height = 12.7,
    post_cone_base_diameter = 10.0,
    post_cone_top_diameter = 4.0,
    post_cone_height = 2.0,
    post_top_cone_clearance = 0.1
) {
    difference() {
        union() {
            for (z = [0:post_height - 1]) {
                translate([0, 0, z * u_height]) {
                    rail_1u_holes_segment(
                        slide_side = slide_side,
                        doublewide = doublewide,
                        post_width = post_width,
                        u_height = u_height,
                        post_slide_width = post_slide_width,
                        post_slide_cutout = post_slide_cutout,
                        hole_offset_z = hole_offset_z,
                        hole_spacing = hole_spacing,
                        hole_d = hole_d,
                        nut_thickness = nut_thickness,
                        nut_diameter_point = nut_diameter_point
                    );
                }
            }
            if (include_footer == 1) {
                footer_body(doublewide = doublewide, post_width = post_width, footer_height = footer_height);
            }
            if (include_header == 1) {
                header_body(post_height = post_height, doublewide = doublewide, post_width = post_width, u_height = u_height, header_height = header_height);
            }
            if (v_post_cones == 1) {
                if (include_header == 1) {
                    translate([post_width / 2, post_width / 2, u_height * post_height + header_height]) {
                        cylinder(h = post_cone_height, r1 = (post_cone_base_diameter / 2) - post_top_cone_clearance, r2 = (post_cone_top_diameter / 2) - post_top_cone_clearance, center = false, $fn = 32);
                    }
                    if (doublewide == 1) {
                        translate([post_width + post_width / 2, post_width / 2, u_height * post_height + header_height]) {
                            cylinder(h = post_cone_height, r1 = (post_cone_base_diameter / 2) - post_top_cone_clearance, r2 = (post_cone_top_diameter / 2) - post_top_cone_clearance, center = false, $fn = 32);
                        }
                    }
                } else {
                    translate([post_width / 2, post_width / 2, u_height * post_height]) {
                        cylinder(h = post_cone_height, r1 = (post_cone_base_diameter / 2) - post_top_cone_clearance, r2 = (post_cone_top_diameter / 2) - post_top_cone_clearance, center = false, $fn = 32);
                    }
                    if (doublewide == 1) {
                        translate([post_width + post_width / 2, post_width / 2, u_height * post_height]) {
                            cylinder(h = post_cone_height, r1 = (post_cone_base_diameter / 2) - post_top_cone_clearance, r2 = (post_cone_top_diameter / 2) - post_top_cone_clearance, center = false, $fn = 32);
                        }
                    }
                }
            }
        }

        if (include_header == 1) {
            header_hole_and_nut(
                post_height = post_height,
                post_width = post_width,
                u_height = u_height,
                hole_offset_z = hole_offset_z,
                hole_d = hole_d,
                nut_thickness = nut_thickness,
                nut_diameter_point = nut_diameter_point
            );
            if (doublewide == 1) {
                translate([post_width, 0, 0]) {
                    header_hole_and_nut(
                        post_height = post_height,
                        post_width = post_width,
                        u_height = u_height,
                        hole_offset_z = hole_offset_z,
                        hole_d = hole_d,
                        nut_thickness = nut_thickness,
                        nut_diameter_point = nut_diameter_point
                    );
                }
            }
        }

        if (include_footer == 1) {
            footer_hole_and_nut(
                post_width = post_width,
                hole_offset_z = hole_offset_z,
                hole_d = hole_d,
                nut_thickness = nut_thickness,
                nut_diameter_point = nut_diameter_point
            );
            if (doublewide == 1) {
                translate([post_width, 0, 0]) {
                    footer_hole_and_nut(
                        post_width = post_width,
                        hole_offset_z = hole_offset_z,
                        hole_d = hole_d,
                        nut_thickness = nut_thickness,
                        nut_diameter_point = nut_diameter_point
                    );
                }
            }
        }

        if (v_post_cones == 1) {
            if (include_footer == 1) {
                translate([post_width / 2, post_width / 2, -footer_height]) {
                    cylinder(h = post_cone_height - post_top_cone_clearance, r1 = (post_cone_base_diameter / 2), r2 = (post_cone_top_diameter / 2), center = false, $fn = 32);
                }
                if (doublewide == 1) {
                    translate([post_width + post_width / 2, post_width / 2, -footer_height]) {
                        cylinder(h = post_cone_height - post_top_cone_clearance, r1 = (post_cone_base_diameter / 2), r2 = (post_cone_top_diameter / 2), center = false, $fn = 32);
                    }
                }
            } else {
                translate([post_width / 2, post_width / 2, 0]) {
                    cylinder(h = post_cone_height - post_top_cone_clearance, r1 = (post_cone_base_diameter / 2), r2 = (post_cone_top_diameter / 2), center = false, $fn = 32);
                }
                if (doublewide == 1) {
                    translate([post_width + post_width / 2, post_width / 2, 0]) {
                        cylinder(h = post_cone_height - post_top_cone_clearance, r1 = (post_cone_base_diameter / 2), r2 = (post_cone_top_diameter / 2), center = false, $fn = 32);
                    }
                }
            }
        }
    }
}


// holes(holes)
// Internal helper — subtracts M6 screw holes through a post face. holes: 2 or 3 per 1U segment.
module holes(
    holes = 2,
    post_width = 15.875,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    hole_d = 6.3
) {
    translate([post_width / 2, post_width / 2, hole_offset_z / 2]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_d, h = post_width, center = true, $fn = 32);
        }
    }

    if (holes == 3) {
        translate([post_width / 2, post_width / 2, (hole_offset_z / 2) + hole_spacing]) {
            rotate([90, 0, 0]) {
                cylinder(d = hole_d, h = post_width, center = true, $fn = 32);
            }
        }
    }

    translate([post_width / 2, post_width / 2, (hole_offset_z / 2) + (hole_spacing * 2)]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_d, h = post_width, center = true, $fn = 32);
        }
    }
}


// nut_holes(holes)
// Internal helper — subtracts M6 hex nut traps from the rear of a post face. holes: 2 or 3.
module nut_holes(
    holes = 2,
    post_width = 15.875,
    nut_thickness = 6.3,
    nut_diameter_point = 10.3 / cos(30),
    hole_offset_z = 12.7,
    hole_spacing = 15.875
) {
    translate([post_width / 2, post_width - (nut_thickness / 2), hole_offset_z / 2]) {
        rotate([90, 0, 0]) {
            cylinder(d = nut_diameter_point, h = nut_thickness, center = true, $fn = 6);
        }
    }

    if (holes == 3) {
        translate([post_width / 2, post_width - (nut_thickness / 2), (hole_offset_z / 2) + hole_spacing]) {
            rotate([90, 0, 0]) {
                cylinder(d = nut_diameter_point, h = nut_thickness, center = true, $fn = 6);
            }
        }
    }

    translate([post_width / 2, post_width - (nut_thickness / 2), (hole_offset_z / 2) + (hole_spacing * 2)]) {
        rotate([90, 0, 0]) {
            cylinder(d = nut_diameter_point, h = nut_thickness, center = true, $fn = 6);
        }
    }
}
/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/15r06";
*/


