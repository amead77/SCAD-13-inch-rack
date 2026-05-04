# 330mm Rack — Module Reference & Definitions

---

## Definitions (`330mm rack defines.scad`)

These are the global defaults. Many can be overridden in `330mm rack parts.scad` or passed directly as function parameters.

### Rack geometry

| Variable | Default | Notes |
|---|---|---|
| `rack_width` | `330` | Overall rack width in mm. Left edge of left post to right edge of right post (single-width posts). Best left alone. |
| `post_width` | `15.875` | Standard rack post width in mm. |
| `u_height` | `44.5` | Height of one rack unit (1U) in mm. |
| `v_post_height` | `3` | Default post height in U units. Used when `post_height` isn't passed to `rail_1u_holes()`. |
| `post_height` | `u_height × v_post_height` | Computed total post height in mm. Read-only — set `v_post_height` instead. |

### Hole / nut geometry

| Variable | Default | Notes |
|---|---|---|
| `hole_clearance` | `0.3` | Extra clearance added to all hole diameters. |
| `hole_d` | `6.0 + hole_clearance` | Final M6 screw hole diameter. |
| `hole_offset_z` | `12.7` | Vertical distance from the bottom of a 1U segment to the first hole centre. Half this value is used between U sections. |
| `hole_spacing` | `15.875` | Vertical spacing between holes within a 1U segment (standard rack pitch). |
| `nut_diameter` | `10.0 + hole_clearance` | M6 hex nut across-flats diameter with clearance. |
| `nut_diameter_point` | computed | M6 hex nut point-to-point diameter (used for hex cutout). |
| `nut_thickness` | `6.0 + hole_clearance` | Depth of the nut trap. Increase if your screws are short. |

### Post slide rails (for tray sliding)

| Variable | Default | Notes |
|---|---|---|
| `post_slide_width` | `3.0` | Width of the slide rail that protrudes from the post side. |
| `post_slide_cutout` | `3.2` | Height of the slot cut into the slide rail for tray tabs. |

### Alignment cones (for stacking / joining posts)

| Variable | Default | Notes |
|---|---|---|
| `post_cone_base_diameter` | `10.0` | Diameter at the base of the alignment cone. |
| `post_cone_top_diameter` | `4.0` | Diameter at the tip of the alignment cone. |
| `post_cone_height` | `2.0` | Height of the cone. |
| `post_top_cone_clearance` | `0.1` | Amount the male cone is undersized for a slip fit. |
| `post_cones` | `1` | `1` = include cones by default. `0` = omit. |

### Footer / header (post end blocks)

| Variable | Default | Notes |
|---|---|---|
| `footer_height` | `12.7` | Height of the footer block at the bottom of a post. Sized so a 0.5U panel fits between post bottom and joiner beam. |
| `footer_include` | `1` | `1` = generate footer by default. `0` = omit. |
| `header_height` | `12.7` | Height of the header block at the top of a post. Same logic as footer. |
| `header_include` | `1` | `1` = generate header by default. `0` = omit. |

### Joiner beams

| Variable | Default | Notes |
|---|---|---|
| `footer_base_beam_thickness` | `5.0` | Thickness of the bottom joiner beam. Can be overridden directly in the `base_joiner()` call. |
| `header_top_beam_thickness` | `10.0` | Thickness of the top joiner beam. Can be overridden directly in the `base_joiner()` call. |

### Front panels

| Variable | Default | Notes |
|---|---|---|
| `front_panel_thickness` | `3.0` | Panel face thickness. Too thick and screws won't reach. |
| `front_panel_undersizing` | `0.1` | How much to trim the panel perimeter on each edge for a better fit. |
| `front_panel_edge_radius` | `2.0` | Corner rounding radius. `0` for sharp corners. |
| `front_panel_hole_count` | `2` | Default mounting holes per side (`2`, `3`, `4`, or `6`). |

### Trays

| Variable | Default | Notes |
|---|---|---|
| `tray_thickness` | `5.0` | Thickness of the tray floor. |
| `tray_post_clearance` | `0.5` | Gap between the tray side and the post, applied to both sides. |
| `tray_side_thickness` | `2.0` | Wall thickness of the tray sides. |
| `tray_slide_thickness` | `post_slide_cutout - hole_clearance` | Thickness of the tab that slots into the post rail. Computed; do not set manually. |
| `tray_to_panel_support_distance` | `30.0` | How far back from the front panel the side-wall gussets reach. |

---

## Public Modules

### `330mm rack posts.scad`

---

#### `rail_1u_holes()` — Complete rack post

Generates a full-height rack post with M6 holes, nut traps, optional slide rails, footer/header blocks, and alignment cones.

```scad
rail_1u_holes(
    slide_side,                          // required: 0=none, 1=left, 2=right, 3=both
    doublewide      = 0,                 // 0=single post width, 1=double
    post_height     = v_post_height,     // height in U units
    v_post_cones    = post_cones,        // 1=add alignment cones
    include_footer  = footer_include,    // 1=add footer block
    include_header  = header_include     // 1=add header block
)
```

Examples:
```scad
rail_1u_holes(slide_side=1, doublewide=0, post_height=6, v_post_cones=1);
rail_1u_holes(slide_side=3, doublewide=1, post_height=4);
```

---

#### `base_joiner()` — Front-to-rear joiner (bottom or top)

Horizontal beam that spans from front post to rear post, attaching to the footer or header blocks. Can generate extra intermediate support blocks at equal spacing.

```scad
base_joiner(
    doublewide      = 0,    // 0=single, 1=double
    bottom          = 1,    // 1=base/footer joiner, 0=top/header joiner
    supports        = 2,    // min 2 (front + rear); >2 adds equally-spaced intermediate blocks
    beam_thickness  = 5.0   // beam thickness in mm (overrides the define default)
)
```

Examples:
```scad
base_joiner();                                                      // base joiner, single wide, 2 supports
base_joiner(bottom=0, beam_thickness=10);                           // top joiner
base_joiner(supports=4);                                            // base joiner with 2 extra intermediate supports
base_joiner(doublewide=1, supports=3, beam_thickness=6);
```

---

### `330mm rack tray.scad`

---

#### `blank_1U_front_panel()` — 1U blanking panel

Full-width 1U front panel with optional corner rounding and configurable hole count.

```scad
blank_1U_front_panel(holes = front_panel_hole_count)
// holes: 2, 3, 4, or 6 per side
```

Examples:
```scad
blank_1U_front_panel();
blank_1U_front_panel(holes=3);
```

---

#### `blank_2U_front_panel()` — 2U blanking panel

Full-width 2U front panel.

```scad
blank_2U_front_panel(holes = 4)
// holes: 2, 4, or 6 per side
```

---

#### `blank_05U_front_panel()` — 0.5U blanking panel

Fixed half-U panel used at the top and bottom of the rack to bridge the gap between post ends and joiners. No parameters.

```scad
blank_05U_front_panel();
```

---

#### `blank_variable_front_panel()` — Variable-height blanking panel

Front panel at any fractional U height, with optional embossed or engraved SVG/STL artwork.

```scad
blank_variable_front_panel(
    u_size          = 1,                    // panel height in U (can be fractional)
    holes           = front_panel_hole_count,
    import_file     = "",                   // path to SVG or STL file
    import_type     = "none",               // "svg", "stl", or "none"
    import_width    = 0,                    // 0 = auto (50% of panel width)
    import_height   = 0,                    // 0 = auto (50% of panel height)
    import_depth    = 0.8,                  // emboss height / engrave depth in mm
    import_offset_x = 0,                    // X offset from centre
    import_offset_z = 0,                    // Z offset from centre
    import_mode     = "emboss"              // "emboss" (raised) or "engrave" (cut in)
)
```

Examples:
```scad
blank_variable_front_panel(u_size=1.5, holes=2);
blank_variable_front_panel(u_size=2, holes=4, import_file="logo.svg", import_type="svg", import_mode="engrave");
```

---

#### `blank_1U_tray()` — 1U tray

1U tray shell with front panel and side slide tabs. Use as a starting point for custom 1U trays.

```scad
blank_1U_tray(
    side_count  = 3,                    // slide tabs per side (1–3)
    edge_radius = 2,                    // front panel corner radius
    holes       = front_panel_hole_count
)
```

---

#### `blank_2U_tray()` — 2U tray

2U tray shell with front panel and side slide tabs.

```scad
blank_2U_tray(
    side_count  = 3,    // slide tabs per side (1–6)
    edge_radius = 2,
    holes       = 4
)
```

---

#### `blank_variable_tray()` — Variable-size tray *(preferred)*

The main tray module. Supports any fractional U size for both the front panel and the tray body independently, variable depth, optional rear wall (drawer mode), front gussets, and emboss/engrave graphics. Preferred over `blank_1U_tray` / `blank_2U_tray` for new designs.

```scad
blank_variable_tray(
    panel_u_size            = 1,                    // front panel height in U
    tray_u_size             = panel_u_size,         // side/base height in U (defaults to panel_u_size)
    tray_depth_scale        = 1,                    // depth as fraction of rack depth (1 = full, 0.5 = half)
    holes                   = front_panel_hole_count,
    import_file             = "",
    import_type             = "none",               // "svg", "stl", or "none"
    import_width            = 0,
    import_height           = 0,
    import_depth            = 0.8,
    import_offset_x         = 0,
    import_offset_z         = 0,
    import_mode             = "emboss",             // "emboss" or "engrave"
    side_support            = 1,                    // 1=add front gussets where panel is taller than side
    side_support_back       = 40,                   // how far back (mm) the gusset reaches
    side_support_thickness  = tray_side_thickness,
    back_panel              = 0,                    // 1=add rear wall (drawer mode)
    back_panel_thickness    = tray_side_thickness
)
```

Examples:
```scad
blank_variable_tray(panel_u_size=1, tray_u_size=0.75, holes=2);
blank_variable_tray(panel_u_size=1, tray_u_size=0.75, tray_depth_scale=0.5, back_panel=1);
blank_variable_tray(panel_u_size=2, tray_u_size=1.5, holes=4, import_file="logo.svg", import_type="svg", import_mode="emboss");
```

---

#### `post_base_join_panel()` — Post-to-joiner connector panel

Small flat panel sized to one or two post footprints. Provides two M6 holes per post footprint to physically fasten a post to a base joiner at an intermediate support position.

```scad
post_base_join_panel(
    doublewide  = 0,                        // 0=one post width, 1=two post widths
    thickness   = front_panel_thickness     // panel thickness in mm
)
```

Examples:
```scad
post_base_join_panel();
post_base_join_panel(doublewide=1, thickness=4);
```

---

### `330mm rack custom tray 01.scad`

---

#### `standoff_heat_insert()` — Cylindrical standoff with heat-set insert bore

Utility module for placing a single PCB standoff with a heat-set insert hole at the top.

```scad
standoff_heat_insert(
    x, y, z,            // centre position of the standoff base
    h            = 6,   // standoff height
    d            = 7.0, // outer diameter
    insert_d     = 3.8, // bore diameter for heat-set insert
    insert_depth = 4.5  // depth of the bore from the top
)
```

Example:
```scad
standoff_heat_insert(x=20, y=15, z=5, h=6, d=7.0, insert_d=3.8, insert_depth=4.5);
```

---

#### `rpi5_standoffs_left()` — Raspberry Pi 5 standoff set

Places four `standoff_heat_insert()` standoffs at the standard Raspberry Pi 5 mounting hole pattern (58 × 49 mm).

```scad
rpi5_standoffs_left(
    mount_origin_x  = post_width + 14, // X of the bottom-left hole
    mount_origin_y  = front_panel_thickness + 9, // Y of the bottom-left hole
    hole_dx         = 58,              // hole spacing in X
    hole_dy         = 49,              // hole spacing in Y
    standoff_h      = 6,
    standoff_d      = 7.0,
    insert_d        = 3.8,
    insert_depth    = 4.5
)
```

Example:
```scad
rpi5_standoffs_left(mount_origin_x=30, mount_origin_y=23, hole_dx=49, hole_dy=58);
```

---

#### `custom_tray_01()` — Example Raspberry Pi 5 tray

Pre-built 1U tray for a Raspberry Pi 5 with active cooler. Includes an embossed Pi logo, USB/Ethernet IO cutout, and four M3 heat-set standoffs at the Pi 5 hole pattern. Also imports the Pi 5 STL for fitment checking. No parameters — edit the constants inside the module to adjust positioning.

```scad
custom_tray_01();
```

---

## Assembly (`330mm rack parts.scad`)

The `part` variable at the top of this file selects what to render. Set it in the OpenSCAD Customiser or edit directly.

| `part` value | What it renders |
|---|---|
| `"assembly"` | All parts together for a preview of the complete rack |
| `"post"` | A single post at the configured height/width |
| `"base joiner"` | The bottom front-to-rear joiner |
| `"top joiner"` | The top front-to-rear joiner |
| `"1U tray"` | Blank 1U tray |
| `"2U tray"` | Blank 2U tray |
| `"variable tray"` | Variable-size tray |
| `"halfUpanel"` | 0.5U blanking panel |
| `"1U panel"` | 1U blanking panel |
| `"2U panel"` | 2U blanking panel |
| `"variable panel"` | Variable-height blanking panel |
| `"post joins"` | Post-to-joiner connector panels |

### Key assembly parameters

| Variable | Notes |
|---|---|
| `post_u_height` | Post height in U units |
| `post_doublewide` | `0` = single, `1` = double wide |
| `slide_side` | `0`=none, `1`=left, `2`=right, `3`=both |
| `cones` | `1` = alignment cones on posts and joiners |
| `base_support_count` | Number of front-to-rear joiner support positions (min 2). `>2` adds evenly-spaced intermediate posts and joiner blocks. |
| `footer_include` / `header_include` | `1` = include footer/header blocks |
| `base_join` / `top_join` | `1` = include bottom/top joiners in assembly |
| `base_panel` / `top_panel` | `1` = include 0.5U bridging panels at bottom/top |
| `footer_base_beam_thickness` | Beam thickness for the bottom joiner |
| `header_top_beam_thickness` | Beam thickness for the top joiner |
