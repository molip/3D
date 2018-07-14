hole_factor = 1.15;
screw_hole_pos = [25, 10];
screw_slope_z = 2.8;
screw_dia = 4 * hole_factor;
bolt_dia = 5 * hole_factor;
screw_head = 7.8 * hole_factor;
nut_rad_min = 4 * hole_factor;
nut_rad_max = 4.5 * hole_factor;
nut_depth = 3.6;
nut_centre = 12;
screw_post = [10, 10, 10];
post = [13, 5];
arm_width = 5;
$fn = 40;

nut_shape = [for (a = [0:60:300]) nut_rad_min * [sin(a), cos(a)]];

module screwPost()
{
	translate(screw_hole_pos) cylinder(h=screw_post.z, d=screw_post.x);
}

module screwHole()
{
	$fn = 20;
	translate(screw_hole_pos) 
	{
		cylinder(h=screw_post.z+1, d=screw_dia);
		
		translate([0, 0, screw_post.z - screw_slope_z])
		cylinder(h=screw_slope_z, d1=screw_dia, d2=screw_head);
	}
}

module arm()
{
	x1 = post.x / 2;
	x2 = screw_hole_pos.x;
	y = screw_hole_pos.y - screw_post.y / 2;
	poly = [[x1, 0], [x1, arm_width], [x2, y + arm_width], [x2, y]];
	linear_extrude(height=screw_post.z) polygon(poly);
}

difference()
{
	union()
	{
		translate([-post.x/ 2, 0, 0]) cube([post.x, post.y, nut_centre]);

		translate([0, 0, nut_centre]) 
		rotate([-90, 0, 0])
		cylinder(h=post.y, d=post.x);
		
		screwPost();
		mirror([1, 0, 0]) screwPost();
		
		arm();
		mirror([1, 0, 0]) arm();
	}	

	screwHole();
	mirror([1, 0, 0]) screwHole();
	
	translate([0, 0, nut_centre]) 
	rotate([-90, 0, 0])
	{
		cylinder(h=post.y+2, d=bolt_dia);
		linear_extrude(height=nut_depth) polygon(nut_shape);
	}
	
	rotate([45, 0, 0])
	cube([40, 2, 2], center=true);
	//translate([])
	
}
