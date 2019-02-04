tube = 1;
panel = 2;
lip = 2;
tube_inner = [90, 23, 18.5];
tube_outer = tube_inner + [tube, tube, 0] * 2;

use<util.scad>

difference()
{
	union()
	{
		centred_cube([tube_outer.x + lip * 2, tube_outer.y + lip * 2, panel]);	
		centred_cube(tube_outer);	
	}
	centred_cube(tube_inner);
}