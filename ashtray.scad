$fs = 0.1;

base_diam = 80;
base = 1;
body_wall = 4.8;
body_height = 13;

lid_wall = 2.4;
lid_height = 8;

bevel_rad = 14;
bevel_height = 4;
bevel_inset = 4;

lip_height = 3;
lip_tol = 0.2;

module shape(diam, height, bevel_scale)
{
	minkowski()
	{
		br = bevel_rad * bevel_scale;
		cylinder(d = diam - br * 2, h = height - bevel_height, $fn = 3);
		rotate([0, 0, 180]) cylinder(r1 = br - bevel_inset, r2 = br, h = bevel_height, $fn = 3);	
	}
}

module body()
{
	difference()
	{
		shape(base_diam, body_height, 1);
		translate([0, 0, base]) shape(base_diam - body_wall * 2, body_height, 0.8);
		translate([0, 0, body_height - lip_height]) lid(lip_tol);
	}
}

module lid(wall_extra = 0)
{
	translate([0, 0, lid_height]) 
	rotate([180, 0, 0])
	difference()
	{
		shape(base_diam, lid_height, 1);
		translate([0, 0, base]) shape(base_diam - (lid_wall + wall_extra) * 2, lid_height, 0.88);
	}
}

body(); 
//#translate([0, 0, body_height - lip_height]) lid();
translate([base_diam, 0, 0]) lid();
