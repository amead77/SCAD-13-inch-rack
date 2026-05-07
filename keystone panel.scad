//keystone for the tray, for routing cables from switch to stuff in the back. Just a cheap amazon keystone.
//
//
//the keystone gets inserted from the rear of the panel, not the front, so the catch clips in, the front stopper should ride
//over the panel front when the catch is squished, then prevent the keystone from being pushed back into the tray.

ks_width = 14.580;
ks_height = 16.10;
ks_depth = 30.0;
ks_catch_height = 3.7;
ks_catch_width = 9.3;
ks_catch_depth = 13.9;
ks_catch_ypos = 5.0;
ks_catch_edge_depth = 3.0; //the edge part is a tab that sticks up slightly more than the catch
ks_catch_edge_height = 1.0;
ks_side_lip_depth = 1.6;
ks_side_lip_height = 8.0;
ks_side_lip_ypos = 10.0;
ks_side_lip_width = (16.16 - ks_width) / 2;
//there is also a bottom lip, but the catch on top will squish and clip into the case, making the bottom lip a front stopper.
//using this keystone means the front panel is max 2mm thick.




module keystone() {
    color("green") {
        cube([ks_width, ks_depth, ks_height]);
    }
    // catch for the keystone to stop it falling out of the tray.
    translate([(ks_width - ks_catch_width)/2, ks_catch_ypos, ks_height]) {
        color("yellow") {
            cube([ks_catch_width, ks_catch_depth, ks_catch_height]);
        }
    }

    //catch edge 
    translate([(ks_width - ks_catch_width)/2, ks_catch_ypos , ks_height + ks_catch_height]) {
        color("yellow") {
            cube([ks_catch_width, ks_catch_edge_depth, ks_catch_edge_height]);
        }
    }


    // side lips for the keystone to help secure it in the tray. left side
    translate([-(ks_side_lip_width), ks_side_lip_ypos, (ks_height / 2)-(ks_side_lip_height/2)]) {
        color("orange") {
            cube([ks_side_lip_width, ks_side_lip_depth, ks_side_lip_height]);
        }
    }
    //right side
    translate([ks_width, ks_side_lip_ypos, (ks_height / 2)-(ks_side_lip_height/2)]) {
        color("orange") {
            cube([ks_side_lip_width, ks_side_lip_depth, ks_side_lip_height]);
        }
    }

}


keystone();