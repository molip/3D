add = 0.1;
slot = [4.1 + add, 19.7 + add, 17];
hole = 40.3;
base = 3;
gap = 4;
bevel = 5;

size = [bevel * 2 + gap * 3 + hole + slot.x, bevel * 2 + gap * 2 + hole, slot.z + base];

$fs = 0.1;
$fn = 40;

module box(size)
{
	b = bevel;
	c = 2;

	module shape()
	{
		cylinder(r1 = b - c, r2 = b, h = c);
		translate([0, 0, c]) 
		intersection()
		{
			sphere(r = b);
			translate([-b, -b]) cube(b * 2);
		}
	}

	translate([b, b, b]) 
	minkowski()
	{
		translate([0, 0, -b]) cube(size - [b * 2, b * 2, b + c]);
		shape();
	}
}

difference()
{
	box(size);
	translate([bevel + gap + hole / 2, size.y / 2, base]) cylinder(d = hole, h = slot.z);
	translate([bevel + gap + hole + gap, (size.y - slot.y) / 2, base]) cube(slot);
}
