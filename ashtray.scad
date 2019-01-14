$fs = 0.1;

diam = 40;
base = 1;
wall = 2;
body_height = 20;
lid_height = 10;

bevel_rad = 5;
bottom_bevel_height = 4;

lip_height = 3;

module body(wall_extra = 0)
{
	module shape(diam)
	{
		minkowski()
		{
			cylinder(d = diam - bevel_rad * 2, h = body_height - bottom_bevel_height, $fn = 3);
			cylinder(r1 = bevel_rad - 2, r2 = bevel_rad, h = bottom_bevel_height);	
		}
	}

	difference()
	{
		shape(diam);
		translate([0, 0, base]) shape(diam - wall - wall_extra);
	}
}

module lid()
{
	module shape(diam)
	{
		minkowski()
		{
			cylinder(d = diam - bevel_rad * 2, h = lid_height - bevel_rad, $fn = 3);
			intersection()
			{
				sphere(r = bevel_rad);	
				translate([-bevel_rad, -bevel_rad, 0]) cube([bevel_rad * 2, bevel_rad * 2, bevel_rad]);
			}
		}
	}

	difference()
	{
		shape(diam);
		translate([0, 0, -base]) shape(diam - wall);
		
		s = (diam - 0.0) / diam;
		scale([s, s])
		translate([0, 0, -body_height + lip_height]) body(0.2);
	}
}

//body();
lid();