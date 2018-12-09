$fa = 1;
$fs = 1;

diam = 60;
height = 10;

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
    translate([0, 0, height + 2])
    difference()
    {
        union()
        {
            cylinder(d = diam, h = height); 
            sticks(0);
        }
        sticks(0.5);
    }
}

module outer()
{
    bowl(diam);
}

module inner()
{
    difference()
    {
        translate([0, 0, 2]) bowl(diam - 6);
        cylinder(d1 = diam, d2 = 0, h = 6); 
    }
}

module hole()
{
    translate([0, 0, 2]) cylinder(d = 2.5, h = 5); 
}

difference()
{
    outer();
    inner();
    cutout();
    hole();
}
