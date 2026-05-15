// tray for a raspberry pi 5. the pi is inside and there is no need for direct port access, every needed port has a port extension to the front panel.


/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/15r04";
*/


rpi5_screw_hole_diameter = 2.7;


include <blank variable tray.scad>;
include <keystone panel.scad>;


c_show_rpi = false;

c_cutout_depth = 3;

c_eth_plug_width = 17;
c_eth_plug_height = 14.6;
c_eth_plug_depth = 1.5;
c_eth_plug_screw_dia = 4.2;
c_eth_plug_screw_dist = 27;

c_usbc_roundplug_dia = 22;

//my usb 2.0 ext panel mount socket is the same as the usb 3 one, so i use the same values
c_usb3_plug_screw_dist = 30;
c_usb3_screw_dia = 4.2;
c_usb3_plug_width = 16;
c_usb3_plug_height = 8;

c_rpi5_extension_width = 120;
c_rpi5_extension_height = 50;
c_rpi5_extension_panel_thickness = 2.2;

c_rpi5_extension_panel_shroud_thickness = 2;
c_rpi5_extension_panel_shroud_z = 4;
c_rpi5_extension_panel_base_length = 30; //how long along the base the extension is
c_rpi5_extension_panel_base_height = 10; //how high up the panel it goes

c_hdmi_plug_width = 16; //plug isn't square, but I am lazy
c_hdmi_plug_height = 6.5;
c_hdmi_plug_screw_dia = 4;
c_hdmi_plug_screw_dist = 26.5;


module eth_plug() {
    translate([-c_eth_plug_width/2, -c_eth_plug_height/2, -2.5]) {
        cube([c_eth_plug_width, c_eth_plug_height, c_cutout_depth * 2]);
    };
    translate([c_eth_plug_screw_dist/2, 0, 0]) {
        cylinder(d = c_eth_plug_screw_dia, h = c_cutout_depth * 2, center = true);
    };
    translate([-c_eth_plug_screw_dist/2, 0, 0]) {
        cylinder(d = c_eth_plug_screw_dia, h = c_cutout_depth * 2, center = true);
    };
};


module usbc_roundplug() {
    cylinder(d = c_usbc_roundplug_dia, h = c_cutout_depth * 2, center = true);
};


module usb3_plug() {
    translate([-c_usb3_plug_width/2, -c_usb3_plug_height/2, -2]) {
        cube([c_usb3_plug_width, c_usb3_plug_height, c_cutout_depth * 2]);
    };

    translate([c_usb3_plug_screw_dist/2, 0, 0]) {
        cylinder(d = c_usb3_screw_dia, h = c_cutout_depth * 2, center = true);
    };
    translate([-c_usb3_plug_screw_dist/2, 0, 0]) {
        cylinder(d = c_usb3_screw_dia, h = c_cutout_depth * 2, center = true);
    };
};


module hdmi_plug() {
    color("gray") {
        translate([-c_hdmi_plug_width/2, -c_hdmi_plug_height/2, -3]) {
            cube([c_hdmi_plug_width, c_hdmi_plug_height, c_cutout_depth * 2]);
        };

        translate([c_hdmi_plug_screw_dist/2, 0, 0]) {
            cylinder(d = c_hdmi_plug_screw_dia, h = c_cutout_depth * 2, center = true);
        };
        translate([-c_hdmi_plug_screw_dist/2, 0, 0]) {
            cylinder(d = c_hdmi_plug_screw_dia, h = c_cutout_depth * 2, center = true);
        };
    }
};

module rpi5_model() {
    //translate([42.5, 28, 6]) {
        //rotate([90, 0, 0]) {
            color("SlateBlue") {
                import("RASPBERRY_PI_5_WITH_ACTIVE_COOLER.stl");
            };
        //};
    //};
};


module standoff() {
    c_outer_dia = 6;
    c_height = 5;
    c_screw_dia = 2.2;
    c_screw_height = 5;
    
    difference() {
        cylinder(d = c_outer_dia, h = c_height, center = false);
        translate([0, 0, c_height-(c_screw_height+0.1)]) {
            cylinder(d = c_screw_dia, h = c_screw_height+0.2, center = false);
        };
    };
};


module standoffs() {
    
    pos_offset_x = 0;//8.5; //these have been disabled due to translating instead in the render
    pos_offset_y = 0;//7.5;
    pos_offset_z = 0; //5.0; //tray thickness
    x1 = 0+pos_offset_x;
    y1 = 0+pos_offset_y;
    x2 = 0+pos_offset_x;
    y2 = 49+pos_offset_y;
    x3 = 58+pos_offset_x;
    y3 = 0+pos_offset_y;
    x4 = 58+pos_offset_x;
    y4 = 49+pos_offset_y;

    translate([x1, y1, pos_offset_z]) {
        standoff();
    };
    translate([x2, y2, pos_offset_z]) {
        standoff();
    };
    translate([x3, y3, pos_offset_z]) {
        standoff();
    };
    translate([x4, y4, pos_offset_z]) {
        standoff();
    };
};


module panel_cutouts_for_rpi5() {
    translate([32, 2, 24]) {
        rotate([90, 90, 0]) {
            color("Gray") {
                hdmi_plug();
            }
        }
    }


    translate([57, 2, 24]) {
        rotate([90, 0, 0]) {
            color("Gray") {
                usbc_roundplug();
            }
        }
    }

    translate([80, -8, 12]) {
        //rotate([90, 0, 0]) {
            color("Gray") {
                keystone();
                //eth_plug();
            }
            translate([-1,10,0]){
                color("red") {
                    cube([17, 2, 20]);
                }
            }
        //}
    }

    translate([122, 2, 12]) {
        rotate([90, 0, 0]) {
            color("Gray") {
                usb3_plug();
            }
        }
    }

    translate([122, 2, 32]) {
        rotate([90, 0, 0]) {
            color("Gray") {
                usb3_plug();
            }
        }
    }

}

/**

module blank_variable_tray(
    panel_u_size            = 1, // front panel height in U
    tray_u_size             = undef, // side/base height in U. if undef, defaults to panel_u_size. if 0.6 is used, you can get 2 slides per side, 0.5 would only make the sides high enough for 1 slide
    tray_depth_scale        = 1, // 0 to 1, fraction of rack_width. 1 = full rack_width depth (330mm), 0.5 = rack_width/2 depth (165mm), etc.
    holes                   = 2, // mounting holes PER SIDE (2, 3, 4, or 6). I need to revisit this, as '2' would put 4 holes in each side of a 2U panel, but you might only want 2 each side (top/bottom)
    import_file             = "", //used for importing an SVG or STL/3MF onto the front panel face, see variable_front_panel_face_import() parameters below.
    import_type             = "none", //"svg", "stl", or "none"
    import_width            = 0, //if 0, defaults to 50% of the front panel inner width. used for imported SVGs and STLs/3MFs.
    import_height           = 0, //if 0, defaults to 50% of the front panel inner height. used for imported SVGs and STLs/3MFs.
    import_depth            = 0.8, //how far the imported design is embossed (positive) or engraved (negative). if 0, defaults to 0.8mm for SVGs, and 50% of the target width for STLs/3MFs.
    import_offset_x         = 0, //X offset for imported design from exact center of front panel. positive values move right, negative values move left.
    import_offset_z         = 0, //Z offset for imported design from exact center of front panel. positive values move up, negative values move down.
    import_mode             = "emboss", // "emboss" (raised from front face) or "engrave" (cut into front face)
    side_support            = 1, //0 or 1 to add gussets between front panel and sides when panel is taller than sides
    side_support_back       = 40, //how far back the gussets extend (mm)
    side_support_thickness  = 2.0, //normally the same as tray_side_thickness, but can be different if you want thinner gussets
    tray_side_thickness     = 2.0, //thickness of the tray side walls in mm.
    front_panel_thickness   = 3.0, //consider your screw lengths. 3mm is usually fine for m6x16 screws.
    back_panel              = 0, //0 or 1 to add a rear wall to make a drawer. rear wall height controlled by back_panel_height (in U).
    back_panel_thickness    = 2.0, //the rear wall thickness, if you have back_panel=1.
    back_panel_height       = 1.0, //in U units, converted to mm internally
    tray_thickness          = 5.0, //thickness of the tray base in mm.
    rack_width              = 330, //this is the external width of the rack, if single-width, using this and post_width is what determines the panel and tray widths and depths.
    post_width              = 15.875, //a normal single-width rack. If using double-width and/or sliders, this will be wider, but calculated automatically based on this.
    hole_d                  = 6.4, //holes sized for m6 screws, but slightly oversized for clearance.
    u_height                = 44.5, //standard U height in mm.
    hole_offset_z           = 12.7, //initial hole offset from the bottom panel/rack post in mm.
    hole_spacing            = 15.875, //spacing between holes in mm, standard U spacing.
    front_panel_undersizing = 0.1, //mm the front panel is undersized by on each edge to ensure it doesn't interfere with other panels
    front_panel_edge_radius = 2.0, //mm radius for front panel edges. set to 0 for sharp edges.
    tray_post_clearance     = 0.5, //0.5mm clearance, this makes 1mm total tray clearance. adjust as needed. modifying this might require tweaking the post_slide_cutout and hole_clearance to ensure the holes still clear properly.
    post_slide_width        = 3.0, //*these next 3 are for the slides that go into the posts on the rack.
    post_slide_cutout       = 3.2, //*ideally you should create a 1U post for testing the fit of these before printing everything.
    hole_clearance          = 0.3  //*you would be better off adjusting the post dimensions, rather than changing the tray dimensions, and create posts to fit the trays. making the side slides smaller to fit would make them weaker. So make the post cutouts bigger instead.
) {

**/
module rpi5_tray(rack_width = 330) {
    difference() {
        union() {
            blank_variable_tray(
                panel_u_size=1.0,
                tray_u_size=0.6,
                tray_depth_scale=0.9,
                holes=2,
                import_file="",
                import_type="none",
                import_width=50,
                import_height=50,
                import_depth=0,
                import_offset_x=0,
                import_offset_z=0,
                import_mode="emboss",
                side_support=1,
                side_support_back=80,
                side_support_thickness=3.0,
                tray_side_thickness=3.0,
                front_panel_thickness=3.0,
                back_panel=0,
                back_panel_thickness=2.0,
                back_panel_height=1.0,
                tray_thickness=5.0,
                rack_width=rack_width,
                post_width=15.875,
                hole_d=6.5, 
                u_height=44.5,
                hole_offset_z=12.7,
                hole_spacing=15.875,
                front_panel_undersizing=0.15,
                front_panel_edge_radius=2.0,
                tray_post_clearance=0.5,
                post_slide_width=3.0,
                post_slide_cutout=3.2
            );

            translate([120, 180, 5]) {
                rotate([0, 0, 90]) {
                    standoffs();
                    translate([19, 24.5, 5]) {
                        rotate([90, 0, 180]) {
                            rpi5_model();
                        }
                    }
                }
            }
        } //union

        panel_cutouts_for_rpi5();
    } //difference
}