// dimensions and part for fit testing a U-Green UM106X 5 port 2.5gbe switch.
include <330mm blank variable tray.scad>;


ug_tray_fit_wall_thickness = 4.0;

ug_width = 160.0;
ug_height = 27.78;
ug_depth = 105.2;

ug_ports_stickout = 0.2; //for visualisation

ug_ports_4x_xpos = 38.0;
ug_ports_4x_zpos = 7.0;
ug_ports_4x_width = 64.0;
ug_ports_4x_height = 13.5;

ug_port_1x_xpos = 106.0;
ug_port_1x_width = 17.0;

ug_port_sfp_xpos = 134.0;
ug_port_sfp_width = 15.0;
ug_port_sfp_height = 10.0;

ug_power_port_stickout = 30;
ug_power_port_xpos = 27.0;
ug_power_port_zpos = 7.5;
ug_power_port_width = 9.0;
ug_power_port_height = 11.0;

ug_tray_fit_width = ug_width + (2 * ug_tray_fit_wall_thickness);
ug_tray_fit_depth = ug_depth + (2 * ug_tray_fit_wall_thickness);
ug_tray_fit_height = ug_height / 3;

//the front panel cutout for the switch. 4mm = 2mm all round. this is so the switch cannot pull out the front of the tray.
ug_tray_cutout_width = ug_width - 4.0;
ug_tray_cutout_height = ug_height - 4.0;

ug_tray_front_panel_thickness = 4.0;

module ug_um106x() {
    color("gray") {
    cube([ug_width, ug_depth, ug_height]);
    }
    // ports
    translate([ug_ports_4x_xpos, -ug_ports_stickout, ug_ports_4x_zpos]) {
        color("blue") {
        cube([ug_ports_4x_width, ug_ports_stickout, ug_ports_4x_height]);
        }
    }
    translate([ug_port_1x_xpos, -ug_ports_stickout, ug_ports_4x_zpos]) {
        color("blue") {
        cube([ug_port_1x_width, ug_ports_stickout, ug_ports_4x_height]);
        }
    }
    translate([ug_port_sfp_xpos, -ug_ports_stickout, ug_ports_4x_zpos]) {
        color("blue") {
        cube([ug_port_sfp_width, ug_ports_stickout, ug_port_sfp_height]);
        }
    }
    // power port
    translate([ug_power_port_xpos, ug_depth, ug_power_port_zpos]) {
        color("red") {
            cube([ug_power_port_width, ug_power_port_stickout, ug_power_port_height]);
        }
    }
}



module ug_um106x_tray_fit() {
    color("green") {
        //difference() {
            cube([ug_tray_fit_width, ug_tray_fit_depth, ug_tray_fit_height]);
            translate([ug_tray_fit_wall_thickness, ug_tray_fit_wall_thickness, 0]) {
                ug_um106x();
            }
        //}
    }
}


// blank_variable_tray(panel_u_size, tray_u_size, tray_depth_scale, holes, import_file, import_type, import_width, import_height, import_depth, import_offset_x, import_offset_z, import_mode, side_support, side_support_back, tray_side_thickness, front_panel_thickness, side_support_thickness, back_panel, back_panel_thickness, tray_thickness)
// Public — the main variable-size tray module. Preferred over blank_1U_tray / blank_2U_tray for new designs.
// panel_u_size: front panel height in U (can be fractional). tray_u_size: side/base height in U (defaults to panel_u_size).
// tray_depth_scale: tray projection depth as a fraction of full rack depth (1 = full depth, 0.25 = quarter depth).
// holes: mounting holes per side. back_panel: 0=open tray, 1=add rear wall (makes it a drawer).
// side_support: 1=add front gussets when panel is taller than side wall.
// tray_side_thickness: side wall thickness in mm. Default: tray_side_thickness from defines.
// front_panel_thickness: front panel depth (Y) in mm. Default: front_panel_thickness from defines.
// tray_thickness: base floor thickness in mm. Default: tray_thickness from defines.
// Accepts the same import_* parameters as blank_variable_front_panel() for emboss/engrave graphics.
// e.g. blank_variable_tray(panel_u_size=1, tray_u_size=0.75, tray_depth_scale=0.5, holes=2, back_panel=1);
// e.g. blank_variable_tray(panel_u_size=2, tray_u_size=1.5, tray_depth_scale=1, holes=4, import_file="logo.svg", import_type="svg");


module ug_um106x_tray() {
    blank_variable_tray(panel_u_size=1, tray_u_size=0.5, tray_depth_scale=0.5, holes=4, back_panel=0, tray_thickness = 4.0, front_panel_thickness = ug_tray_front_panel_thickness);
    translate([28, 0, 4.0]) {
        ug_um106x_tray_fit();
    }
}