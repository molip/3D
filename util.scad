_screw_post_dia = 10;
_screw_post_height = 10;

module screwPost(hole)
{
	screw_slope_z = 2.8;
	screw_dia = 4.5;
	screw_head = 9;

	if (hole)
	{
		$fn = 20;
		cylinder(h=_screw_post_height+1, d=screw_dia);
		
		translate([0, 0, _screw_post_height - screw_slope_z])
		cylinder(h=screw_slope_z, d1=screw_dia, d2=screw_head);
	}
	else
	{
		cylinder(h=_screw_post_height, d=_screw_post_dia);
	}
}
