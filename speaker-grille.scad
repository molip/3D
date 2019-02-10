depth = 5;
pitch = 8;
wall = 2;
lip = 3;
panel = 2;
hole_size = [160, 50, depth];
grille_thickness = 0.8;

use <util.scad> 

module grille_volume()
{
	centred_cube(hole_size - [wall * 2, wall * 2, 0]);
}

module lines(a)
{
	n = floor((hole_size.x + hole_size.y) / pitch);
	
	for (x = [-n / 2: n / 2])
		translate([x * pitch, 0, 0]) 
		rotate([0, 0, a])
		centred_cube([grille_thickness, hole_size.y * sqrt(2), depth]);
}

difference()
{
	union()
	{
		centred_cube([hole_size.x + lip * 2, hole_size.y + lip * 2, panel]);
		centred_cube(hole_size);
	}

	grille_volume();
}

intersection()
{

	union()
	{
		lines(45);
		lines(-45);
	}
	
	grille_volume();
}