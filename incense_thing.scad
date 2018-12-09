$fa = 1;
$fs = 1;

diam = 70;
height = 7;

module bowl(d)
{
        translate([0, 0, height]) 
        {
            rotate_extrude() translate([d / 2 - height, 0, 0]) circle(r = height);
        }
        cylinder(d = d - height * 2, h = height);
        
}

module sticks(add)
{
    d = 3.14159 * diam * 45 / 360 / 2;
    
    for (i = [0:4])
        rotate([90, 0, (i + add) * 45]) translate([0, 0, -diam / 2]) cylinder(d = d, h = diam);
}

module cutout()
{
    r = diam / 2 + 1;
    h = height;
    n = 180;
    step = 360 / n;
    verts = 
    [
        [0, 0, 0], [0, 0, h], 
        for (a =[0 : step : 360]) [r * sin(a), r * (cos(a)), sin(a * 12)],
        for (a =[0 : step : 360]) [r * sin(a), r * (cos(a)), h]
    ];
    echo(len(verts));
    faces = 
    [
        for (a =[0 : n - 1]) [0, a + 3, a + 2], // Bottom
        for (a =[0 : n - 1]) [a + 2, a + 3, a + n + 4, a + n + 3], // Sides
        for (a =[0 : n - 1]) [1, a + n + 3, a + n + 4] // Top
    ];
    
    translate([0, 0, height + 2])
    {
        union()    
        {
            polyhedron(verts, faces);
            translate([0, 0, -1])cylinder(d = 50, h = 12);
        }
    }
}

module outer()
{
    cylinder(d = diam, h = height + 3);
}

module inner()
{
    translate([0, 0, 2]) 
    difference()
    {
        bowl(diam - 4);
        union()
        {
            translate([0, 0, 2]) 
            difference()
            {
                cylinder(d = 13, h = 4); 
                rotate_extrude() translate([12.7, 11, 0]) circle(r = 12);
            }
            cylinder(d1 = diam, d2 = 8, h = 3); 
        }
    }
}

module hole()
{
    translate([0, 0, 1]) cylinder(d = 3, h = 10); 
}

difference()
{
    outer();
    inner();
    cutout();
    hole();
}
