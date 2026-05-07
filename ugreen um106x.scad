//
//
// U-Green UM106X 5 port 2.5gbe switch Tray.
//
//
//************************************************************************
// go to the end of the file to see the tray assembly with switch model **
// comment out the model line for just the tray.                        **
//************************************************************************
//
//



/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/07r10";
*/

include <330mm blank variable tray.scad>;

ug_tray_support_oversize = 0.5; // this is how much larger the switch support is than the switch itself.

ug_tray_fit_wall_thickness = 3.0;
ug_tray_thickness = 4.0;
ug_tray_back_panel_height = 2.0;

ug_width = 160.0;
ug_height = 27.78;
ug_depth = 105.4;

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
ug_power_port_height = ug_height - ug_power_port_zpos; //this has been done to create a larger cutout

ug_tray_fit_width = ug_width + (2* ug_tray_fit_wall_thickness)+ ug_tray_support_oversize;
ug_tray_fit_depth = ug_depth + ug_tray_support_oversize;
ug_tray_fit_height = ug_height / 3;
ug_tray_fit_height_rear = ug_height;

//the front panel cutout for the switch. 4mm = 2mm all round. this is so the switch cannot pull out the front of the tray.
ug_tray_cutout_width = ug_width - 4.0;
ug_tray_cutout_height = ug_height - 4.0;
ug_tray_cutout_lip = 2.0; //this is based on 4.0mm above.
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

module ug_um106x_front_panel() {
    // this creates the switch, then uses ug_tray_cutout_width/height to subtract from the outer dimensions of the switch,
    // with a Y depth of ug_tray_front_panel_thickness. effectively creating the switch, then removing a rectangular ring around the edges.

    //create cube for the front panel, then subtract the cutout for the switch.
//     difference() {
//        cube([ug_width, ug_tray_front_panel_thickness+0.2, ug_height]);
//        translate([ug_tray_cutout_lip, 0, ug_tray_cutout_lip]) {
            cube([ug_tray_cutout_width, ug_tray_front_panel_thickness+0.2, ug_tray_cutout_height]);
//        }
//    }
}

module ug_um106x_tray_internal_support() {
    // U-shaped internal support: left side wall, right side wall, and rear wall only.
    // Open at the front to allow the switch to slide in from the front panel.
    // Prevents the switch from moving sideways or being pushed to the rear of the tray.

    union() {
        // left side wall
        cube([ug_tray_fit_wall_thickness, ug_tray_fit_depth+ug_tray_fit_wall_thickness, ug_tray_fit_height]);
        // right side wall
        translate([ug_tray_fit_width - ug_tray_fit_wall_thickness, 0, 0]) {
            cube([ug_tray_fit_wall_thickness, ug_tray_fit_depth+ug_tray_fit_wall_thickness, ug_tray_fit_height]);
        }
        // rear wall
        translate([0, ug_tray_fit_depth, 0]) {
            cube([ug_tray_fit_width, ug_tray_fit_wall_thickness, ug_tray_fit_height_rear]);
        }
    }
}


module tray_assembly() {
    union() {
        blank_variable_tray(
            panel_u_size = 1,
            tray_u_size = 0.6,
            tray_depth_scale = 0.33,
            holes = 4,
            back_panel = 1,
            back_panel_height = 0.2, //U height
            side_support_back = ug_tray_back_panel_height,
            tray_thickness = ug_tray_thickness,
            front_panel_thickness = ug_tray_front_panel_thickness,
            side_support = 2
        );
        translate([28, ug_tray_front_panel_thickness, ug_tray_thickness]) { //pushed out to view the structure, when complete it will be pushed back to position.
            ug_um106x_tray_internal_support();
        }
    } //union

}

module ug_um106x_tray() {
    render() {
        difference() {
            tray_assembly();
            translate([32+ug_tray_cutout_lip, -0.1, ug_tray_thickness+ug_tray_cutout_lip]) { //pushed out to view the structure, when complete it will be pushed back to position.
                ug_um106x_front_panel();
            }
            // the next bit is for subtracting the switch power port from the tray.
            translate([32, ug_tray_front_panel_thickness, ug_tray_thickness]) {
                ug_um106x();
            }
        } 

        //*************************************************************************
        //** these next 3 lines are for visualisation of the switch in the tray. **
        //*************************************************************************
        translate([32, ug_tray_front_panel_thickness, ug_tray_thickness]) { 
            // COMMENT OUT THE NEXT LINE TO VIEW THE TRAY WITHOUT THE SWITCH MODEL. ALSO FOR PRINTING
            ug_um106x();
        }


    }
}