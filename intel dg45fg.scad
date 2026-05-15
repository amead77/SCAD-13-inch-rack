/*
 mini-itx intel dg45fg retro board in rack mount tray.

*/


/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/15r36";
*/

$fn = 32;

//spec out the holes for mini-itx board

itx_holes = [   
    [0, 0],
    [157.58, 0],
    [0, 154.94],
    [157.48, 132.08]
];

itx_board_origin_position_x = 170 - 163.83;
itx_board_origin_position_y = 170 - 165.1;

itx_board_dimensions = [170, 170]; //square board, but this is the max dimensions. holes are within this.
itx_board_clearance = 6.5;
itx_board_thickness = 1.6;

//this is the diameter for the heat insert, not the screw itself.
itx_heat_insert_diameter = 4.7; //6-32 UNC screw normally. But using metric here. M3.5x0.6 is equiv, but i have M3
itx_heat_insert_outer_diameter = itx_heat_insert_diameter + 4.0;
itx_screw_diameter = 3.0;
itx_screw_length = 5.0;

module itx_screw_standoff() {
    difference() {
        cylinder(h = itx_board_clearance, d = itx_heat_insert_outer_diameter, center = true);
        cylinder(h = itx_board_clearance, d = itx_heat_insert_diameter, center = true);
    }
}


module itx_holes() {
    for (i = [0 : len(itx_holes) - 1]) {
        translate([itx_holes[i][0], itx_holes[i][1], 0])
            itx_screw_standoff();
            //cylinder(h = 10, d = itx_screw_diameter + itx_board_clearance, center = true);
    }
}

module itx_screws() {
//    translate([itx_board_origin_position_x, itx_board_origin_position_y, 0]) {

        for (i = [0 : len(itx_holes) - 1]) {
            translate([itx_holes[i][0], itx_holes[i][1], 0])
                cylinder(h = itx_screw_length, d = itx_screw_diameter, center = true);
        }
//    }

}

module itx_board() {
    difference() {
        cube([itx_board_dimensions[0], itx_board_dimensions[1], itx_board_thickness], center = false);
        translate([itx_board_origin_position_x, itx_board_origin_position_y, 0]) {
            //itx_holes();
            itx_screws();
        }
    }
}

translate([0, 0, itx_board_clearance]) {
    itx_board();
}

translate([itx_board_origin_position_x, itx_board_origin_position_y, itx_board_clearance/2]) {
    itx_holes();
}

