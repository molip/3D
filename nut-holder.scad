hole_factor = 1.15;
screw_hole_pos = [25, 10];
bolt_dia = 5 * hole_factor;
nut_rad_min = 4 * hole_factor;
nut_rad_max = 4.5 * hole_factor;
nut_depth = 3.6;
nut_centre = 12;
post = [13, 5];
arm_width = 5;
$fn = 40;

nut_shape = [for (a = [0:60:300]) nut_rad_min * [sin(a), cos(a)]];

include <util.scad>

module arm()
{
	x1 = post.x / 2;
	x2 = screw_hole_pos.x;
	y = screw_hole_pos.y - _screw_post_dia / 2;
	poly = [[x1, 0], [x1, arm_width], [x2, y + arm_width], [x2, y]];
	linear_extrude(height=_screw_post_height) polygon(poly);
}

module screwPosts(hole)
{
	for (x = [-screw_hole_pos.x, screw_hole_pos.x])
		translate([x, screw_hole_pos.y, 0]) screwPost(hole);
}

difference()
{
	union()
	{
		translate([-post.x/ 2, 0, 0]) cube([post.x, post.y, nut_centre]);

		translate([0, 0, nut_centre]) 
		rotate([-90, 0, 0])
		cylinder(h=post.y, d=post.x);
		
		screwPosts(false);
		
		arm();
		mirror([1, 0, 0]) arm();
	}	

	screwPosts(true);
	
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
