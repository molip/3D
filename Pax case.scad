$fs = 0.5;

_wall = 1;
_base = 1;
_inner = [31.5, 22.3, 28];
_lid_angle = 26;
_lid_gap = 0;
_lid_height = 8; // Outer height from top, y=0
_no_base = false;



_hinge = [0, 0, 22]; // From top. x not used.
_hinge_angle = 64;
_hinge_boss_radius = 3.5;
_hinge_hole_radius = 2;

_outer = [_inner.x + _wall * 2, _inner.y + _wall * 2, _inner.z + _base * 2];
_lid_height_delta = sin(_lid_angle) * _outer.y;

module cylinder2(height, radius, center=false)
{
	cylinder(height, radius, radius, center);
}

module outline() 
{
	data_extents = [[950.464, 897.76], [1323.82, 1159.95]];

	scale([_inner.x / (data_extents[1].x - data_extents[0].x), _inner.y / (data_extents[1].y - data_extents[0].y)])
	translate([-data_extents[0].x, -data_extents[0].y])
	translate([(data_extents[0].x - data_extents[1].x) / 2, (data_extents[0].y - data_extents[1].y) / 2])
	polygon
	([
		[1108.56399023,897.973521484], [1077.75648438,899.779046875], [1062.09858765,901.752113037], [1046.58201758,904.691142578], [1031.43984106,908.785456299], [1016.905125,914.224375], [1003.21093628,921.197219482], [990.590341797,929.893310547], [979.276408447,940.501968994], [969.502203125,953.212515625], [961.500792725,968.21427124], [955.505244141,985.696556641], [951.748624268,1005.84869263], [950.464,1028.86], [951.748624268,1051.86990967], [955.505244141,1072.02083984], [961.500792725,1089.50209229], [969.502203125,1104.50296875], [979.276408447,1117.212771], [990.590341797,1127.82080078], [1003.21093628,1136.51635986], [1016.905125,1143.48875], [1031.43984106,1148.92727295], [1046.58201758,1153.02123047], [1062.09858765,1155.95992432], [1077.75648438,1157.93265625], [1108.56399023,1159.73744141], [1137.14,1159.95], [1165.71597656,1159.73744141], [1196.5234375,1157.93265625], [1212.18133301,1155.95992432], [1227.69792969,1153.02123047], [1242.8401709,1148.92727295], [1257.375,1143.48875], [1271.06936035,1136.51635986], [1283.69019531,1127.82080078], [1295.00444824,1117.212771], [1304.7790625,1104.50296875], [1312.78098145,1089.50209229], [1318.77714844,1072.02083984], [1322.53450684,1051.86990967], [1323.82,1028.86], [1322.53450684,1005.84869263], [1318.77714844,985.696556641], [1312.78098145,968.21427124], [1304.7790625,953.212515625], [1295.00444824,940.501968994], [1283.69019531,929.893310547], [1271.06936035,921.197219482], [1257.375,914.224375], [1242.8401709,908.785456299], [1227.69792969,904.691142578], [1212.18133301,901.752113037], [1196.5234375,899.779046875], [1165.71597656,897.973521484], [1137.14,897.76]	
	]);
}

module clip(height)
{
	s = [_outer.x * 2, _outer.y * 2, _lid_height_delta * 2];
	translate([0, 0, height])
	rotate([_lid_angle, 0, 0])
	translate([-s.x / 2, -s.y / 2, 0])
	cube(s);
}

module tube(outer_height, inner)
{
	extend = (inner && _no_base) ? _base * 2 : 0;
	offset = inner ? 0 : _wall;
	bottom = inner ? _base - extend: 0;
	h = _wall + outer_height + _lid_height_delta / 2 + extend;
	difference()
	{
		translate([0, 0, bottom]) linear_extrude(h) offset(r=offset) outline();
		if (!inner)
			clip(outer_height);
	}
}

module body()
{
	module hole()
	{
		translate([0, _hinge.y, _outer.z - _hinge.z]) 
		rotate([0, 90, 0])
		cylinder2(_outer.x + 5, _hinge_hole_radius + 0.1, center = true);
	}

	color("yellow") 
	difference()
	{
		tube(_outer.z - _lid_height, false);
		tube(_outer.z - _lid_height, true);

		hole();
	}
}

module hinge()
{
	union()
	{
		length = _hinge.z - _lid_height / 2;
		hull()
		{
			cylinder2(_wall, _hinge_boss_radius);
			
			translate([length, 0, 0])
			cylinder2(_wall, _hinge_boss_radius);
		}
		
		translate([length, 0, _wall])
		cylinder2(_wall + 0.5, _hinge_hole_radius, _hinge_hole_radius);
	}
}

module lid()
{
	module boss()
	{
		translate([_outer.x / 2 - _wall, 0, _lid_height / 2]) 
		rotate([0, 90, 0])
		cylinder2(_wall, _hinge_boss_radius);
	}

	color("red") 
	union()
	{
		difference()
		{
			tube(_lid_height, false);
			tube(_lid_height, true);
		}

		boss();
		mirror([1, 0, 0]) boss();
	}
}

module main()
{
	module move_lid()
	{
		move_hinge_centre()
		translate([0, -_hinge.y, _hinge.z + _lid_gap])	
		rotate([180, 0, 0])
		children();
	}

	module move_hinge_centre()
	{
		angle = _hinge_angle * $t;

		translate([0, _hinge.y, _outer.z - _hinge.z])	
		rotate([angle, 0, 0])	
		children();
	}

	module move_hinge()
	{
		move_hinge_centre()
		translate([_outer.x / 2 + _wall, 0, _hinge.z - _lid_height / 2]) 
		rotate([180, 90, 0])
		children();
	}

	body();
	move_lid() lid();
	move_hinge() hinge();
	mirror([1, 0, 0]) move_hinge() hinge();
}

module print()
{
	body();
	translate([0, 30, 0]) lid();
	translate([-8, -20, 0]) hinge();
	translate([-8, -30, 0]) hinge();
}

main();
//print();