// ==========================
// PARAMETERS
// ==========================
hole_clearance = 0.3; //mm clearance around the 'oles
rack_width = 330;
post_width = 15.875; // standard post width for rack.
u_height = 44.5; // 1U in mm for post
v_post_height = 2; //this is in standard 1U units, not mm.
post_height = u_height * v_post_height; // total height of posts, in mm.
hole_d = 6.0 + hole_clearance; //screw holes dia
hole_offset_x = post_width/2 + hole_d/2; //should be central
hole_offset_z = 12.7; // standard spacing. half this for between 1U sections.
hole_spacing = 15.875; //rail hole spacing

nut_diameter = 10.0 + hole_clearance; //10mm for m6
nut_diameter_point = nut_diameter / cos(30); // diameter of the hexagon nut point to point
nut_thickness = 5.0 + hole_clearance; //5mm for m6

module post() {
    cube([post_width, post_width, u_height]);

}

module rail_1u_holes_segment() {
// i've bashed this together rather than math it.

    difference() {
        post();
        translate([post_width/2, ((post_width)-nut_thickness/2 ), hole_offset_z/2]) {
            rotate([90,0,0]) {
                cylinder(d=nut_diameter_point, h=nut_thickness, center=true, $fn=6);
            }
        }
        translate([post_width/2, ((post_width)-post_width/2 ), hole_offset_z/2]) {
            rotate([90,0,0]) {
                cylinder(d=hole_d, h=post_width, center=true, $fn=32);
            }
        }

        translate([post_width/2, ((post_width)-nut_thickness/2 ), (hole_offset_z/2) + hole_spacing]) {
            rotate([90,0,0]) {
                cylinder(d=nut_diameter_point, h=nut_thickness, center=true, $fn=6);
            }
        }
        translate([post_width/2, ((post_width)-post_width/2 ), (hole_offset_z/2) + hole_spacing]) {
            rotate([90,0,0]) {
                cylinder(d=hole_d, h=post_width, center=true, $fn=32);
            }
        }

        translate([post_width/2, ((post_width)-nut_thickness/2 ), (hole_offset_z/2)+ (hole_spacing*2)]) {
            rotate([90,0,0]) {
                cylinder(d=nut_diameter_point, h=nut_thickness, center=true, $fn=6);
            }
        }
        translate([post_width/2, ((post_width)-post_width/2 ), (hole_offset_z/2)+ (hole_spacing*2)]) {
            rotate([90,0,0]) {
                cylinder(d=hole_d, h=post_width, center=true, $fn=32);
            }
        }
    }
}

module rail_1u_holes() {
    for (z = [0:v_post_height-1]) {
        translate([0,0,z*u_height]) {
            rail_1u_holes_segment();

        }
    }
}

module assembly() {
    render() {
        rail_1u_holes();
        translate([rack_width - post_width, 0, 0]) {
            rail_1u_holes();
        }
        translate([0, rack_width- post_width, 0]) {        
            rail_1u_holes();
            translate([rack_width - post_width, 0, 0]) {
                rail_1u_holes();
            }
        }
    }
}



assembly();