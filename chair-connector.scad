$fn=30;

holes = 5;
pitch = 10;

module body_outline()
{
	translate([0, pitch, 0])
	difference()
	{
		hull()
		{
			circle(10);
		
			translate([0, pitch * (holes - 1), 0]) circle(10);
		}
		
		for (i = [0:holes-1])
			translate([0, i * pitch, 0]) circle(3.3);
			
	}
}

module head_outline()
{
	neck_length = 11;
	head_rad = 8.5;

	module neck() translate([0, -neck_length / 2 - 1, 0]) square([6.7, neck_length + 2], center=true);

	module head_inner()
	{
		difference()
		{
			translate([0, 6.2 - head_rad, 0]) circle(head_rad - 2.5);
			translate([0, -neck_length / 2 + 1.6, 0]) square([20, 10], center=true);
		}
	}
	
	translate([0, pitch * (holes + 1) + neck_length, 0]) // Top of neck.
	difference()
	{
		union()
		{
			neck();

			difference()
			{
				translate([0, 6.2 - head_rad, 0]) circle(head_rad);
				translate([0, -neck_length / 2 - 1, 0]) square([20, 10], center=true);

				head_inner();
			}
		}

		polygon([[-2, 3], [2, 3], [0, -7]]);
	}
}

linear_extrude(height = 3)
union()
{
	body_outline();
	head_outline();
}