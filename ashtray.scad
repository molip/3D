$fs = 0.1;

base_diam = 60;
base = 1;
body_wall = 4.8;
body_height = 13;

lid_wall = 2.4;
lid_height = 8;

bevel_rad = 8;
bottom_bevel_height = 4;
top_bevel_height = 4;
bevel_inset = 4;

lip_height = 3;
lip_tol = 0.2;

module body()
{
	module shape(diam, bevel_scale = 1)
	{
		minkowski()
		{
			br = bevel_rad * bevel_scale;
			cylinder(d = diam - br * 2, h = body_height - bottom_bevel_height, $fn = 3);
			rotate([0, 0, 180]) cylinder(r1 = br - bevel_inset, r2 = br, h = bottom_bevel_height, $fn = 3);	
		}
	}

	difference()
	{
		shape(base_diam);
		translate([0, 0, base]) shape(base_diam - body_wall * 2, 0.68);
		translate([0, 0, body_height - lip_height]) lid(lip_tol);
	}
}

module lid(wall_extra = 0)
{
	module shape(diam, bevel_scale = 1)
	{
		minkowski()
		{
			br = bevel_rad * bevel_scale;
			cylinder(d = diam - br * 2, h = lid_height - top_bevel_height, $fn = 3);
			rotate([0, 0, 180]) cylinder(r1 = br, r2 = br - bevel_inset, h = top_bevel_height, $fn = 3);	
		}
	}

	difference()
	{
		shape(base_diam);
		translate([0, 0, -base]) shape(base_diam - (lid_wall - wall_extra) * 2, 0.86);
	}
}

body(); 
//#translate([0, 0, body_height - lip_height]) lid();
translate([base_diam, 0, 0]) lid();
