base = 1.5;
wall = 2;

inner_z1 = 3;
inner_z2 = 3;

inner_r1 = 12.75;
inner_r2 = 11.5;

difference()
{
	union()
	{
		cylinder(r = inner_r1 + wall, h = base + inner_z1);

		translate([0, 0, base + inner_z1])
		cylinder(r1 = inner_r1 + wall, r2 = inner_r2 + wall, h = inner_z1);
	}

	translate([0, 0, base])
	cylinder(r = inner_r1, h = inner_z1);

	translate([0, 0, base + inner_z1])
	cylinder(r1 = inner_r1, r2 = inner_r2, h = inner_z1);

}
