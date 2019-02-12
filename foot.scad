$fn = 60;

outer_rad = 15;
inner_rad = 5;
hole_rad = 2;
curve_rad = 4;
height = 12;
base = 3;

//rotate([90, 0, 0])
rotate_extrude()
{
	difference()
	{
		union()
		{
			square([inner_rad, base]);
			square([outer_rad, height - curve_rad]);
			square([outer_rad - curve_rad, height]);
			translate([outer_rad - curve_rad, height - curve_rad]) circle(r = curve_rad);
		}
		
		square([hole_rad, base]);
		translate([0, base]) square([inner_rad, height]);
	}
}
