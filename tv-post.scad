$fn=40;
hole_mult = 1.1;

post_dia = 7;
post_height = 58;
nub_dia = 3.9;
nub_height = 4;
slot_centre = 13; // From post centre.
slot_dia = 5 * hole_mult;
slot_length = 3; // Centre to centre.
base_width = 10;
base_length = base_width / 2 + 13 + slot_length / 2 + slot_dia / 2 + (base_width - slot_dia) / 2;
size = [base_width, base_length, 15];
hole_dia = 2.8;
hole_depth = 10;

difference()
{
	union()
	{
		hull()
		{
			translate([0, size.x / 2, 0])
			cylinder(h = size.z, d = size.x);

			translate([0, size.y - size.x / 2, 0])
			cylinder(h = size.z, d = size.x);
		}
				
		translate([0, size.x / 2, 0])
		{
			difference()
			{
				translate([0, 0, size.z])
				cylinder(h=post_height - size.z, d=size.x);

				translate([0, 0, post_height - hole_depth])
				cylinder(h=hole_depth + 1, d=hole_dia);
				
			}
		}
	}

	translate([0, size.x / 2 + slot_centre - slot_length / 2, 0])
	hull()
	{
		cylinder(h=size.z + 1, d=slot_dia);
		
		translate([0, slot_length, 0])
		cylinder(h=size.z + 1, d=slot_dia);
	}	
	
}