$fs = 0.1;

_size = [118, 30];
_oldThickness = 3;
_tube_thickness = 2.5;
_bevel_height = 8;

_post_inner = 2;
_post_outer = 8;
_post_inset = 6;

_hmdi_size = [21, 11.5, 15];
_power_size = [19, 10];
_power_boss_height = 3;
_power_hole_x = 26.6; // Distance between centres.

_thickness = _bevel_height + _power_boss_height;


include <util.scad>

module posts2(x, hole)
{
	hole_depth = 12;
	z = _panel_screw_y - hole_depth;

	if (hole)
		for (y = [_panel_screw_z1, _panel_screw_z2])
			translate([x, y, z]) 
				cylinder(d = _post_inner, h = hole_depth);
	else
		translate([x, 0, 0]) centred_cube_x([_post_outer, _size.y, _panel_screw_y ]);
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
		translate([0, 0, hole_z]) rotate([-90, 0, 0]) cylinder(d = 2.2, h = size.y + 20, center = true);
	else
		centred_cube([boss_width, size.y + (_tube_thickness + boss_height) * 2, hole_z + boss_width / 2]);
}	

module power(hole)
{
	size = _power_size;
	boss_width = 5;
	boss_height = 3;
	hole_depth = 5.5;

	module shape(add)
	{
		frustum(size.x + _bevel_height + add, size.y + _bevel_height + add, size.x + add, size.y + add, _bevel_height);
	}

	shape(hole ? 0 : _tube_thickness * 2);

	if (hole)
	{
		translate([0, 0, _bevel_height]) centred_cube([20.5, _size.y, 10]);

		for (x = [-_power_hole_x / 2, _power_hole_x / 2])
			translate([x, 0, _thickness - hole_depth]) cylinder(d = 2.5, h = hole_depth);
	}
}	

module remote(hole)
{
	hole_size = [5, 5];
	block_size = hole_size + [_bevel_height, _bevel_height];
	gap = 6;

	if (hole)
	{
		frustum(block_size.x, block_size.y, hole_size.x, hole_size.y, _bevel_height);
		translate([0, 0, _bevel_height]) centred_cube([5.8, _size.y, gap]);
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

	module posts(hole)
	{
		posts2(_post_outer / 2 + _post_inset, hole);
		posts2(_size.x - _post_outer / 2, hole);
	}

	difference()
	{
		union()
		{
			cube([_size.x, _size.y, _thickness]);

			
			posts(false);
			objects(false);
		}

		posts(true);
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