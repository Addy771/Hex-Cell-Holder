// Generate a tool for checking optimal cell fit

size_list = [18.0,18.2,18.4,18.6];

wall_thickness = 1.6;
cell_depth = 10;


union(){

    for(i = [0:len(size_list)-1])
    {
        
        translate([i*(max(size_list)+2*wall_thickness),0,0])
            cell_gauge(size_list[i]);

    }
    
    hull(){
        translate([0,0,-(cell_depth+wall_thickness)/2])
            cylinder(h=wall_thickness, d=size_list[0]+2*wall_thickness, center=true);
            //cylinder(h=wall_thickness, d=1, center=true);
        
        last_index = len(size_list)-1;
        translate([(max(size_list)+2*wall_thickness)*last_index,0,-(cell_depth+wall_thickness)/2])
            cylinder(h=wall_thickness, d=size_list[last_index]+2*wall_thickness, center=true);
            //cylinder(h=wall_thickness, d=1, center=true);
    }

}

$fn=50;

module cell_gauge(diameter)
{
    difference()
    {
        // Outer cylinder
        cylinder(h=cell_depth+wall_thickness, d=diameter+2*wall_thickness, center=true);
        
        // Cell cutout
        translate([0,0,wall_thickness/2+0.005])
            cylinder(h=cell_depth+0.01, d=diameter, center=true);
        
        // Embossed text
        translate([0,0,-(cell_depth/2-0.01)])
            linear_extrude(wall_thickness/2+0.01)
                text(str(diameter), size=diameter/3, halign="center", valign="center");
    
    }

};
