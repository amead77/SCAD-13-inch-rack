include <blank variable tray.scad>;

/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/15r00";
*/


// rpi5_io_cutout_left(cutout_x, cutout_z, cutout_w, cutout_h, clearance, front_panel_thickness)
// Internal helper — subtracts a rectangular IO port cutout from the front panel.
module rpi5_io_cutout_left(
    cutout_x = 15.875 + 8,
    cutout_z = 10,
    cutout_w = 56,
    cutout_h = 18,
    clearance = 0.6,
    front_panel_thickness = 3.0
) {
    translate([cutout_x - clearance, -0.5, cutout_z - clearance]) {
        cube([cutout_w + (clearance * 2), front_panel_thickness + 1.0, cutout_h + (clearance * 2)]);
    }
}


// standoff_heat_insert(x, y, z, h, d, insert_d, insert_depth)
// Utility — generates a cylindrical standoff with a heat-set insert bore at the top.
module standoff_heat_insert(
    x,
    y,
    z,
    h = 6,
    d = 7.0,
    insert_d = 3.8,
    insert_depth = 4.5
) {
    difference() {
        translate([x, y, z]) {
            cylinder(h = h, d = d, center = false, $fn = 48);
        }
        translate([x, y, z + h - insert_depth]) {
            cylinder(h = insert_depth + 0.2, d = insert_d, center = false, $fn = 32);
        }
    }
}


// rpi5_standoffs_left(...)
// Utility — places four standoffs in the standard Raspberry Pi 5 mounting hole pattern.
module rpi5_standoffs_left(
    mount_origin_x = 15.875 + 14,
    mount_origin_y = 3.0 + 9,
    hole_dx = 58,
    hole_dy = 49,
    standoff_h = 6,
    standoff_d = 7.0,
    insert_d = 3.8,
    insert_depth = 4.5,
    front_panel_undersizing = 0.1,
    tray_thickness = 5.0
) {
    standoff_z = front_panel_undersizing + tray_thickness;

    standoff_heat_insert(mount_origin_x,           mount_origin_y,           standoff_z, standoff_h, standoff_d, insert_d, insert_depth);
    standoff_heat_insert(mount_origin_x + hole_dx, mount_origin_y,           standoff_z, standoff_h, standoff_d, insert_d, insert_depth);
    standoff_heat_insert(mount_origin_x,           mount_origin_y + hole_dy, standoff_z, standoff_h, standoff_d, insert_d, insert_depth);
    standoff_heat_insert(mount_origin_x + hole_dx, mount_origin_y + hole_dy, standoff_z, standoff_h, standoff_d, insert_d, insert_depth);
}


// custom_tray_01(...)
// Public — example custom tray for a Raspberry Pi 5 with active cooler.
// Params:
// panel_u_size, tray_u_size, tray_depth_scale, holes: tray and panel sizing.
// post_width, front_panel_thickness, front_panel_undersizing, tray_thickness: geometry references for cutout and standoff placement.
// side_support, back_panel: structural options.
// import_file and import dimensions/offsets/mode: front face emboss/engrave.
// e.g. custom_tray_01();
/**
module custom_tray_01(
    panel_u_size = 1,
    tray_u_size = 0.75,
    tray_depth_scale = 1,
    holes = 2,
    side_support = 1,
    back_panel = 1,
    post_width = 15.875,
    front_panel_thickness = 3.0,
    front_panel_undersizing = 0.1,
    tray_thickness = 5.0,
    import_file = "raspberry-pi.svg",
    import_type = "svg",
    import_width = 16,
    import_height = 20,
    import_depth = 0.2,
    import_offset_x = 140,
    import_offset_z = 0,
    import_mode = "emboss"
) {
    difference() {
        blank_variable_tray(
            panel_u_size = panel_u_size,
            tray_u_size = tray_u_size,
            tray_depth_scale = tray_depth_scale,
            holes = holes,
            import_file = import_file,
            import_type = import_type,
            import_width = import_width,
            import_height = import_height,
            import_depth = import_depth,
            import_offset_x = import_offset_x,
            import_offset_z = import_offset_z,
            import_mode = import_mode,
            side_support = side_support,
            back_panel = back_panel,
            front_panel_thickness = front_panel_thickness,
            tray_thickness = tray_thickness,
            post_width = post_width,
            front_panel_undersizing = front_panel_undersizing
        );

        rpi5_io_cutout_left(
            cutout_x = post_width + 26,
            cutout_z = 8 + tray_thickness,
            cutout_w = 56,
            cutout_h = 18,
            clearance = 0.6,
            front_panel_thickness = front_panel_thickness
        );
    }

    rpi5_standoffs_left(
        mount_origin_x = post_width + 29.5,
        mount_origin_y = front_panel_thickness + 23,
        hole_dx = 49,
        hole_dy = 58,
        standoff_h = 6,
        standoff_d = 7.0,
        insert_d = 3.8,
        insert_depth = 4.5,
        front_panel_undersizing = front_panel_undersizing,
        tray_thickness = tray_thickness
    );

    translate([post_width + 14, front_panel_thickness + 9, front_panel_undersizing + tray_thickness]) {
        translate([40, 33, 7]) {
            rotate([90, 0, 270]) {
                color("blue") {
                    import("raspberry_pi_5_with_active_cooler.stl", convexity = 10);
                }
            }
        }
    }
}
**/