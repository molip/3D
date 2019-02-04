$fs = 0.1;

_size = [119, 30];
_thickness = 3;
_tube_thickness = 2;
_bevel_height = 8; // Includes panel.

_post_inner = 2;
_post_outer = 8;
_post_inset = 6;

_hmdi_size = [21, 11.5, 20];
_power_size = [19, 10];

_power_hole_x = 26.6; // Distance between centres.

include <util.scad>

module posts(x)
{
	module post()
	{
		difference()
		{
			h = _panel_screw_y - _thickness;
			cylinder(d = _post_outer, h = h);
			cylinder(d = _post_inner, h = h + 1);
		}
	}	

	for (y = [_panel_screw_z1, _panel_screw_z2])
		translate([x, y, _thickness]) post();
}	

module hdmi(hole)
{
	size = _hmdi_size;
	hole_z = _bevel_height + 5;
	boss_width = 5;
	boss_height = 4;

	module shape(add)
	{
		frustum(size.x + _bevel_height + add, size.y + _bevel_height + add, size.x + add, size.y + add, _bevel_height);
		translate([0, 0, _bevel_height]) centred_cube(size + [add, add, 0]);
	}

	shape(hole ? 0 : _tube_thickness * 2);

	if (hole)
		translate([0, 0, hole_z]) rotate([-90, 0, 0]) cylinder(d = 2, h = size.y + 20, center = true);
	else
		centred_cube([boss_width, size.y + (_tube_thickness + boss_height) * 2, hole_z + boss_width / 2]);
}	

module power(hole)
{
	size = _power_size;
	boss_width = 5;
	boss_height = 3;

	module shape(add)
	{
		frustum(size.x + _bevel_height + add, size.y + _bevel_height + add, size.x + add, size.y + add, _bevel_height);
	}

	shape(hole ? 0 : _tube_thickness * 2);

	for (x = [-_power_hole_x / 2, _power_hole_x / 2])
		translate([x, 0, _thickness + (hole ? 2 : 0)]) cylinder(d = hole ? 2.5 : boss_width, h = _bevel_height - _thickness + boss_height);
}	

module remote(hole)
{
	hole_size = [5, 5];
	block_size = hole_size + [_bevel_height, _bevel_height];
	gap = 8;

	if (hole)
	{
		frustum(block_size.x, block_size.y, hole_size.x, hole_size.y, _bevel_height);
		translate([0, 0, _bevel_height]) centred_cube([block_size.x - 4, block_size.y, gap]);
	}
	else
		centred_cube([block_size.x, block_size.y, _bevel_height + gap + 2]);
}	

module panel()
{
	module objects(hole)
	{
		translate([21 + _post_inset, 15, 0]) hdmi(hole);
		translate([58 + _post_inset, 15, 0]) power(hole);
		translate([87 + _post_inset, 15, 0]) remote(hole);
	}

	difference()
	{
		union()
		{
			cube([_size.x, _size.y, _thickness]);

			posts(_post_outer / 2 + _post_inset);
			posts(_size.x - _post_outer / 2);
			
			objects(false);
		}

		objects(true);
	}
}

module test()
{
	intersection()
	{
		panel();
		translate([0, 0, 0]) cube([80, 30, 50]);
	}
}

panel();
//test();