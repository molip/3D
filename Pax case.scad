$fs = 0.3;

_wall = 2;
_base = 4;
_dimensions = [31.2, 22.0, 105.5];
//_dimensions = [31.2, 22.0, 50];
_no_base = false;

_hinge_radius = 2;
_hinge_inner_radius = 0.85 + 0.15;
_hinge_thickness = 5;

_magnet_diam = 3 + 0.3;
_magnet_height = 2 + 0.3;
_magnet_wall_x = 0.8;
_magnet_wall_y = 1.1;
_magnet_inset = 12;

_flange = [12, 8, 2];
_flange_inner = 8;

_inner = [_dimensions.y, _dimensions.x, _dimensions.z];
_outer = [_inner.x + _wall * 2, _inner.y + _wall * 2, _inner.z + _base * 2];

_upper_inset = _base + 0.2;

module trapezium(width1, width2, height)
{
	inset = (width1 - width2) / 2;
	polygon([[0, 0], [width1, 0], [width1 - inset, height], [inset, height]]);
}

module trapezoid_y(x1, x2, z, y)
{
	translate([0, 0, z])
	rotate([-90, 0, 0])
	linear_extrude(y) trapezium(x1, x2, z);
}

module cylinder2(height, radius, center=false)
{
	cylinder(height, radius, radius, center);
}

module outline() 
{
	data_extents = [[950.464, 897.76], [1323.82, 1159.95]];

	rotate([0, 0, 90])
	scale([_dimensions.x / (data_extents[1].x - data_extents[0].x), _dimensions.y / (data_extents[1].y - data_extents[0].y)])
	translate([-data_extents[0].x, -data_extents[0].y])
	translate([(data_extents[0].x - data_extents[1].x) / 2, (data_extents[0].y - data_extents[1].y) / 2])
	polygon
	([
		[1108.56399023,897.973521484], [1077.75648438,899.779046875], [1062.09858765,901.752113037], [1046.58201758,904.691142578], [1031.43984106,908.785456299], [1016.905125,914.224375], [1003.21093628,921.197219482], [990.590341797,929.893310547], [979.276408447,940.501968994], [969.502203125,953.212515625], [961.500792725,968.21427124], [955.505244141,985.696556641], [951.748624268,1005.84869263], [950.464,1028.86], [951.748624268,1051.86990967], [955.505244141,1072.02083984], [961.500792725,1089.50209229], [969.502203125,1104.50296875], [979.276408447,1117.212771], [990.590341797,1127.82080078], [1003.21093628,1136.51635986], [1016.905125,1143.48875], [1031.43984106,1148.92727295], [1046.58201758,1153.02123047], [1062.09858765,1155.95992432], [1077.75648438,1157.93265625], [1108.56399023,1159.73744141], [1137.14,1159.95], [1165.71597656,1159.73744141], [1196.5234375,1157.93265625], [1212.18133301,1155.95992432], [1227.69792969,1153.02123047], [1242.8401709,1148.92727295], [1257.375,1143.48875], [1271.06936035,1136.51635986], [1283.69019531,1127.82080078], [1295.00444824,1117.212771], [1304.7790625,1104.50296875], [1312.78098145,1089.50209229], [1318.77714844,1072.02083984], [1322.53450684,1051.86990967], [1323.82,1028.86], [1322.53450684,1005.84869263], [1318.77714844,985.696556641], [1312.78098145,968.21427124], [1304.7790625,953.212515625], [1295.00444824,940.501968994], [1283.69019531,929.893310547], [1271.06936035,921.197219482], [1257.375,914.224375], [1242.8401709,908.785456299], [1227.69792969,904.691142578], [1212.18133301,901.752113037], [1196.5234375,899.779046875], [1165.71597656,897.973521484], [1137.14,897.76]	
	]);
}

module clip(upper)
{
	s = [_outer.x / 2 + 1, _outer.y + _magnet_diam * 2 + 1, _inner.z + (upper ? 2 : 0)];
	translate([-s.x, -s.y / 2, upper ? -1 : _base])
	cube(s);
}

module inner_tube(upper)
{
	translate([0, 0, upper ? -_base : _base]) linear_extrude(_outer.z + _base * (upper ? 2 : -2)) outline();
}

module outer_tube(inset)
{
	translate(0, 0, inset)
	linear_extrude(_outer.z - inset * 2) offset(r=_wall) outline();
}

module hinge(z)
{
	x_offset = 0.1;
	translate([0, _outer.y / 2, z])
	{
		difference()
		{
			union()
			{
				translate([0, -2, 0]) cube([_hinge_radius - x_offset, _hinge_radius + 2, _hinge_thickness]);
				translate([-x_offset, _hinge_radius, 0]) cylinder2(_hinge_thickness, _hinge_radius);
			}

			translate([-x_offset, _hinge_radius, -1]) cylinder2(_hinge_thickness + 2, _hinge_inner_radius);
		}
	}
}

module body(upper)
{
	inset = upper ? _upper_inset : 0;
	hinge_inset = upper ? _hinge_thickness + 0.1 : 0;

	module slot(z)
	{
		translate([_magnet_wall_x, -_inner.y / 2 - _magnet_diam, z - _magnet_diam / 2])
		cube([_magnet_height, _magnet_diam + 1, _magnet_diam]);
	}

	tube_y_offset = -_magnet_diam - _magnet_wall_y + _wall;
	
	module groove(x, y)
	{
		translate([x, y + tube_y_offset -_outer.y / 2, _outer.z / 2 - inset]) 
		cylinder2(_inner.z - 10, 0.5, true);
	}

	difference()
	{
		union()
		{
			difference()
			{
				union()
				{
					outer_tube(inset);
					
					translate([0, tube_y_offset, 0]) 
					outer_tube(inset);
				}

				clip(upper);
			}
			
			hinge_centres = _outer.z - _hinge_thickness ;
			hinge(hinge_inset - inset + _base);
			hinge(hinge_centres / 3 +  hinge_inset - inset);
			hinge(_outer.z - _hinge_thickness - hinge_centres / 3 - hinge_inset - inset);
			hinge(_outer.z - _hinge_thickness - hinge_inset - inset - _base);
		}
		inner_tube(upper);
		slot(_magnet_inset - inset);
		slot(_outer.z - inset - _magnet_inset);
		slot(_outer.z / 2 - inset);
		
		groove(2.5, 0.05);
		groove(4, 0.35);
		groove(5.5, 0.8);

		mirror([0, 0, 1])
		flange_female();

		translate([0, 0, _outer.z])
		flange_female();
	}
}

module lower_body()
{
	color("yellow") 
	body(false);
}

module upper_body()
{
	color("gray") 
	mirror([1, 0, 0])
	body(true);
}

module flange_male()
{
	union()
	{
		linear_extrude(_base - 1) offset(r = _wall) outline();
		
		color("blue")
		translate([-_flange.x / 2, -_flange.y / 2, base - 1])
		trapezoid_y(_flange.x, _flange_inner, _flange.z, _flange.y);
	}
}

module flange_female() // -z from surface.
{
	gap = [0.1, 0.1, 0];
	hole = _flange + gap;
	hole_inner = _flange_inner + gap.x;

	translate([-hole.x / 2, -hole.y / 2, 0])
	mirror([0, 0, 1])
	trapezoid_y(hole.x, hole_inner, hole.z, hole.y);

	translate([-hole_inner / 2, -hole.y / 2, 0])
	cube([hole_inner, hole.y, hole.z + 1]);
	
	translate([-hole.x / 2, -hole.y * 3 / 2, - hole.z])
	cube([hole.x, hole.y, hole.z + 1]);
}

module main()
{
	module move_hinge()
	{
		//angle = 90 * $t;
		angle = 45;

		offset = [0, _outer.y / 2 + _hinge_radius, _outer.x / 2];
		translate(offset) 
		rotate([-angle, 0, 0]) 
		translate(-offset) 
		children();
	}

	module move_body()
	{
		rotate([0, 90, 0]) 
		translate([-_outer.x / 2, 0, -_outer.z / 2]) 
		children();
	}

	move_body() lower_body();
	move_hinge() move_body() translate([0, 0, _upper_inset]) upper_body();
}

module print()
{
	lower_body();
	translate([30, 0, 0]) upper_body();
}

main();
//print();