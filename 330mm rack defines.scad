//some of these are overrode by calling the functions with different parameters, these are defaults if not specified.
//in the main assembly/"rack parts" files, some of these get overridden by assignments there. this is deliberate as below is defaults if that other file isn't found.

hole_clearance = 0.3; //mm clearance around the 'oles
rack_width = 330; //maybe leave this alone
post_width = 15.875; // standard post width for rack.
u_height = 44.5; // 1U in mm for post
v_post_height = 3; //this is in standard 1U units, not mm.
post_height = u_height * v_post_height; // total height of posts, in mm.
hole_d = 6.0 + hole_clearance; //screw holes dia
hole_offset_x = post_width/2 + hole_d/2; //should be central
hole_offset_z = 12.7; // standard spacing. half this for between 1U sections.
hole_spacing = 15.875; //rail hole spacing

nut_diameter = 10.0 + hole_clearance; //10mm for m6
nut_diameter_point = nut_diameter / cos(30); // diameter of the hexagon nut point to point
nut_thickness = 6.0 + hole_clearance; //5mm for m6 - CONSIDER YOUR SCREW DEPTH AND PANEL THICKNESS HERE (my screws didn't reach far enough, so increased depth to counter)

post_slide_width = 3.0; //this is the width of the cutout for the trays to slide into.
post_slide_cutout = 3.2; //this is the height of the cutout for the trays to slide into


post_cone_base_diameter = 10.0; // base diameter of the alignment cone on top of posts
post_cone_top_diameter = 4.0; // tip diameter of the alignment cone
post_cone_height = 2.0; // height of the alignment cone
post_top_cone_clearance = 0.1; // this is how much smaller the top cone is than the bottom cone, for clearance when joining.
post_cones = 1; //1 = add cones to top and difference from the bottom of the post. This is for joining.

front_panel_thickness = 3.0; // how thick the front panel is, go too thick and your screws might not reach.
front_panel_undersizing = 0.1; // this is how many mm to undersize the front panel, for better fitting. it affects x and z and is applied to both edges, not just one
front_panel_edge_radius = 2.0; // this is the radius of the rounded edges on the front panel. Set to 0 for square edges.
front_panel_hole_count = 2; //this is per side. 2 or 3 or 4 or 6. for certain panels and hole spacing just play with this.
tray_thickness = 5.0; // this is not affected by post_slide_cutout, as it sits inside
tray_post_clearance = 0.5; //clearance between trays and posts. added to BOTH sides.
tray_side_thickness = 2.0; // thickness of the side wall of the tray.
tray_slide_thickness = post_slide_cutout - hole_clearance; // thickness of the tray slide tab that fits into the post slot.
tray_to_panel_support_distance = 30.0; //this is the distance the front panel support reaches back to the side slides.

footer_height = 12.7; //this and the header height are the same, the distance is so a 0.5U panel joins them
footer_width = 1; //this is in POST WIDTHS, not mm.
footer_include = 1; // set to 0 to not include the footer, 1 to include it. The footer is a small piece at the bottom of the rack
header_height = 12.7; // same as footer_height, distance is so a 0.5U panel joins them.
header_width = 1; //this is in POST WIDTHS, not mm.
header_include = 1; // set to 0 to not include the header, 1 to include it. The header is a small piece at the top of the rack

// the next 2 lines are used for creating joining beams for the front and rear of the rack, connecting the posts.
// they are the same connector apart as the footer/header.
header_top_beam_thickness = 10.0; // the top beam for connecting 2 posts/rails together, front to rear.
footer_base_beam_thickness = 5.0; // the base beam for connecting 2 posts/rails together, front to rear.
beam_thickness = 4; //this is used internally, do not adjust.

/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/04r57";
*/



