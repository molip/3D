base = 0.6;
wall = 2;
inner = [18, 60, 20];
outer = inner + [wall * 2, wall, base];

module shape(size)
{
	union()
	{
		cube(size);
		
		rotate([0, 0, -90])
		translate([-size.x, 0, 0])
		cube(size);
	}
}

difference()
{
	shape(outer);

	translate([wall, wall, base])
	shape(inner + [0, 1, 1]);
}
