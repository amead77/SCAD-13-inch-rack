include <330mm rack tray.scad>;

// AUTO-V
version = "v0.1-2026/05/04r09";


module rpi5_io_cutout_left(
    cutout_x = post_width + 8,
    cutout_z = 10,
    cutout_w = 56,
    cutout_h = 18,
    clearance = 0.6
) {
    // Cut through the full front panel thickness with a little overlap for reliable subtraction.
    translate([cutout_x - clearance, -0.5, cutout_z - clearance]) {
        cube([cutout_w + (clearance * 2), front_panel_thickness + 1.0, cutout_h + (clearance * 2)]);
    }
}


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
        // Bore for heat-set insert, entering from standoff top.
        translate([x, y, z + h - insert_depth]) {
            cylinder(h = insert_depth + 0.2, d = insert_d, center = false, $fn = 32);
        }
    }
}


module rpi5_standoffs_left(
    mount_origin_x = post_width + 14,
    mount_origin_y = front_panel_thickness + 9,
    hole_dx = 58,
    hole_dy = 49,
    standoff_h = 6,
    standoff_d = 7.0,
    insert_d = 3.8,
    insert_depth = 4.5
) {
    standoff_z = front_panel_undersizing + tray_thickness;

    standoff_heat_insert(mount_origin_x,           mount_origin_y,           standoff_z, standoff_h, standoff_d, insert_d, insert_depth);
    standoff_heat_insert(mount_origin_x + hole_dx, mount_origin_y,           standoff_z, standoff_h, standoff_d, insert_d, insert_depth);
    standoff_heat_insert(mount_origin_x,           mount_origin_y + hole_dy, standoff_z, standoff_h, standoff_d, insert_d, insert_depth);
    standoff_heat_insert(mount_origin_x + hole_dx, mount_origin_y + hole_dy, standoff_z, standoff_h, standoff_d, insert_d, insert_depth);
}


module custom_tray_01() {
    // Tray + panel with Pi 5 left-side I/O cutout on the USB/Ethernet side.
    difference() {
        blank_variable_tray(
            panel_u_size = 1,
            tray_u_size = 0.75,
            holes = 2,
            import_file = "raspberry-pi.svg",
            import_type = "svg",
            import_width = 16,
            import_height = 20,
            import_depth = 0.2,
            import_offset_x = 140,
            import_offset_z = 0,
            import_mode = "emboss",
            side_support = 1,
            back_panel = 1
        );

        rpi5_io_cutout_left(
            cutout_x = post_width + 26,
            cutout_z = 8+tray_thickness,
            cutout_w = 56,
            cutout_h = 18,
            clearance = 0.6
        );
    }

    // Pi 5 mounting standoffs (58x49 hole pattern) for heat-set inserts.
    rpi5_standoffs_left(
        mount_origin_x = post_width + 29.5,
        mount_origin_y = front_panel_thickness + 23,
        hole_dx = 49,
        hole_dy = 58,
        standoff_h = 6,
        standoff_d = 7.0,
        insert_d = 3.8,
        insert_depth = 4.5
    );

    //import raspberry pi 5 model to test fitment
    translate([post_width + 14, front_panel_thickness + 9, front_panel_undersizing + tray_thickness]) {
        translate([40, 33, 7]) { // move the model so the mounting holes are at the origin, for easier positioning
            rotate([90, 0, 270]) {
                color("blue") {
                    import("raspberry_pi_5_with_active_cooler.stl", convexity = 10);
                }
             }
        }   
    }
}