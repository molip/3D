$fs = 0.1;
boss_dia = 8;
boss_depth = 5;
metal_height = 25;

base_screw_y1 = 10;
brace_width = 3;
brace_depth = 30;

panel_screw_hole = 3;
panel_boss_y = 3 + 10;

step_height = 1.6;
step_width = 25;

include <util.scad>

module panelScrews(hole)
{
	for (z = [_panel_screw_z1, _panel_screw_z2])
		translate([0, _panel_screw_y, metal_height + z]) rotate([-90, 0, 0]) cylinder(d = hole ? panel_screw_hole : boss_dia, h = boss_depth);
}

module brace(hole)
{
	y1 = brace_depth - _screw_post_dia / 2;
	y2 = brace_depth;
	z1 = metal_height + _panel_screw_z2;
	z2 = _screw_post_height;
	points = [[0, 0], [z1, 0], [z2, y1], [z2, y2], [0, y2]];

	translate([-2.7, _panel_screw_y + 0.8, 0])
	rotate([0, 0, 30])
	{
		if (!hole)
			translate([brace_width / 2, 0, 0])
			rotate([0, -90, 0]) 
			linear_extrude(height = brace_width) polygon(points);

		translate([0, brace_depth, 0]) screwPost(hole);
	}
}

difference()
{
	union()
	{
		panelScrews(false);
		translate([0, _panel_screw_y, 0]) centred_cube_x([boss_dia, boss_depth, _panel_screw_z2 + metal_height]);
		translate([0, base_screw_y1, 0]) centred_cube_x([boss_dia, _screw_post_dia / 2, _screw_post_height]);
		
		translate([0, base_screw_y1, 0]) screwPost(false);

		brace(false);
	}

	translate([0, base_screw_y1, 0]) screwPost(true);
	panelScrews(true);
	brace(true);

	centred_cube_x([40, step_width, step_height]);
}
