$fn=40;

thickness = 1.6;

neck_dia = 19.5;
neck_height = 5;

body_height = 30;
body_dia = 50;

difference()
{
	union()
	{
		cylinder(h=neck_height, d=neck_dia);
		translate([0, 0, neck_height]) cylinder(h=body_height, d1=neck_dia, d2=body_dia);
	}

	union()
	{
		cylinder(h=neck_height + 1, d=neck_dia-thickness);
		translate([0, 0, neck_height]) cylinder(h=body_height+1, d1=neck_dia-thickness, d2=body_dia-thickness);
	}
}
