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

module centred_cube(size, centred = [1, 1, 0])
{
	c = centred;
	translate([c.x ? -size.x : 0, c.y ? -size.y : 0, c.z ? -size.z : 0] / 2)
	cube(size);
}

module centred_cube_x(size)
{
	centred_cube(size, [1, 0, 0]);
}

module centred_cube_y(size)
{
	centred_cube(size, [0, 1, 0]);
}

module hexahedron(verts)
{
    faces = 
    [
        [3, 2, 1, 0], // Bottom
        [4, 5, 6, 7], // Top
        [0, 4, 7, 3], // Front
        [3, 7, 6, 2], // Right
        [2, 6, 5, 1], // Back
        [1, 5, 4, 0], // Left
    ];

	polyhedron(verts, faces);
}

module frustum(x1, y1, x2, y2, h)
{
    verts = 
    [
        [-x1 / 2, -y1 / 2, 0], [-x1 / 2, y1 / 2, 0], [x1 / 2, y1 / 2, 0], [x1 / 2, -y1 / 2, 0],
        [-x2 / 2, -y2 / 2, h], [-x2 / 2, y2 / 2, h], [x2 / 2, y2 / 2, h], [x2 / 2, -y2 / 2, h],
    ];

	hexahedron(verts);
}
