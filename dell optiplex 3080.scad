// Dell Optiplex 3080 case and tray.
//
//
// it was while creating this, i discovered the dell will not, in fact, fit in a 330 rack tray.


/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/15r01";
*/

include <blank variable tray.scad>;

dell_width = 291.0;
dell_feet_height = 3.5;
dell_height = 96.0 - dell_feet_height; //the height of the case minus the feet, as the tray will sit on the feet. this is important for the cutout height.
dell_depth = 292.0;
dell_rim = 4.0; //the solid rim around the front of hte case
//create a basic inner & lower box to represent the feet
dell_feet_width = dell_width - 20;
dell_feet_depth = dell_depth - 20;


module dell_optiplex_3080() {
    //just a basic box representing the case dimensions
    translate([10, 10, 0]) {
        color("black") {
            cube([dell_feet_width, dell_feet_depth, dell_feet_height]);
        }
    }
    translate([0, 0, dell_feet_height]) {
        color("gray"){
            cube([dell_width, dell_depth, dell_height]);
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


module dell_tray() {
    blank_variable_tray(rack_width = 340, panel_u_size = 3, tray_u_size = 1, tray_depth_scale = 1.0, holes = 4, back_panel = 1, back_panel_height = 0.3, back_panel_thickness = 10.0, side_support = 1, side_support_back = 100, tray_thickness = 8);


}

translate([25, 10, 8]) {
    dell_optiplex_3080();
}
dell_tray();
