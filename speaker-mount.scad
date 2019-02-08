$fs = 0.1;

hole = [23, 6, 8];
wall = 2;

width = hole.x + wall * 2;
depth = hole.y + wall * 2;

include <util.scad>

module cup(height)
{
	difference()
	{
		centred_cube_x([width, depth, height]);
		translate([0, wall, height - hole.z]) centred_cube_x(hole);
	}
	
}

module top()
{
	cup(18);

	difference()
	{
		centred_cube_x([width, 20, wall]);
		translate([0, 15, 0]) cylinder(d = 3.2, h = wall);
	}
}

module bottom()
{
	translate([0, 10, wall]) 	
	rotate([90, 0, 0])
	cup(10);
	centred_cube_x([width, 10, 4]);

	difference()
	{
		centred_cube_x([10, 23, 4]);
		translate([0, 18, 0]) cylinder(d = 3.2, h = 4);
	}
}

//top();
bottom();