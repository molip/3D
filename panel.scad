$fs = 0.1;

_size = [200, 30];
_thickness = 3;
_tube_thickness = 2;
_bevel_height = 8; // Includes panel.

_post_inner = 3;
_post_outer = 8;
_post_height = 10;

_hmdi_size = [21.3, 11.8, 20];
_power_size = [19, 10];

_power_hole_x = 26.6; // Distance between centres.

use <util.scad>

module posts(x)
{
	module post()
	{
		difference()
		{
			cylinder(d = _post_outer, h = _post_height);
			cylinder(d = _post_inner, h = _post_height + 1);
		}
	}	

	translate([x, _post_outer / 2, _thickness]) post();
	translate([x, _size.y - _post_outer / 2, _thickness]) post();
}	

module hdmi(hole)
{
	size = _hmdi_size;
	hole_z = _bevel_height + 5;
	boss_width = 5;
	boss_height = 3;

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

module objects(hole)
{
	translate([30, 15, 0]) hdmi(hole);
	translate([70, 15, 0]) power(hole);
}

module panel()
{
	module objects(hole)
	{
		translate([30, 15, 0]) hdmi(hole);
		translate([70, 15, 0]) power(hole);
	}

	difference()
	{
		union()
		{
			cube([_size.x, _size.y, _thickness]);

			posts(_post_outer / 2);
			posts(_size.x / 2);
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
		translate([10, 0, 0]) cube([80, 30, 50]);
	}
}

//panel();
test();