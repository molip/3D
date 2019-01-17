$fs = 0.1;

base_diam = 40;
base = 1;
body_wall = 4;
body_height = 20;

lid_wall = 2;
lid_height = 10;

bevel_rad = 5;
bottom_bevel_height = 4;
top_bevel_height = 4;

lip_height = 3;
lip_tol = 0.2;

module body()
{
	module shape(diam)
	{
		minkowski()
		{
			inner_bevel_rad = bevel_rad * (diam < base_diam ? 0.75 * diam / base_diam : 1);
			cylinder(d = diam - inner_bevel_rad * 2, h = body_height - bottom_bevel_height, $fn = 3);
			rotate([0, 0, 180]) cylinder(r1 = inner_bevel_rad - 3, r2 = inner_bevel_rad, h = bottom_bevel_height, $fn = 3);	
		}
	}

	difference()
	{
		shape(base_diam);
		translate([0, 0, base]) shape(base_diam - body_wall * 2);
		translate([0, 0, body_height - lip_height]) lid(lip_tol);
	}
}

module lid(wall_extra = 0)
{
	module shape(diam)
	{
		minkowski()
		{
			inner_bevel_rad = bevel_rad * (diam < base_diam ? 0.9 * diam / base_diam : 1);
			cylinder(d = diam - inner_bevel_rad * 2, h = lid_height - top_bevel_height, $fn = 3);
			rotate([0, 0, 180]) cylinder(r1 = inner_bevel_rad, r2 = inner_bevel_rad - 3, h = top_bevel_height, $fn = 3);	
		}
	}

	difference()
	{
		shape(base_diam);
		translate([0, 0, -base]) shape(base_diam - (lid_wall - wall_extra) * 2 );
	}
}

body(); //#translate([0, 0, body_height - lip_height]) lid();
//lid();