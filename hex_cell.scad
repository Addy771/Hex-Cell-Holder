// HEX CELL CAPS
// This script generates a model of end caps for building 
// battery packs using cylindrical cells. 
// Original concept by ES user "SpinningMagnets"
// More info can be found here:
// https://endless-sphere.com/forums/viewtopic.php?f=3&t=90058
//
// This file was created by Addy and is released as public domain
// 11/29/2017 V1.3





// TODO: Add battery cap
// - add warning if top and bottom are different
// - flip part upside down for correct printing orientation. (support in bus grooves)
// - add flat border option
// - add single cell fit test
// - add ability to change cell_diameter without changing overall hexcell to remain compatible with previously printed cells that may have been to tight. You can do this manually by adjusting the wall variable. Maybe?




// CONFIGURATION

opening_dia = 12;   // Circular opening to expose cell 
cell_dia = 18.6;    // Cell diameter
wall = 0.8;           // Wall thickness around a single cell. Spacing between cells is twice this amount.

holder_height = 12; // Total height of cell holder
separation = 1;   	// Separation between cell top and tab slots
slot_height = 3.5;  // Height of all slots (3.5 mm is a good size for 14 awg solid in slots)
col_slot_width = 4; // Width of slots between rows
row_slot_width = 4; // Width of slots along rows

rect_style = 1;     // 1 for rectangular shape pack, 0 for rhombus
style = "bus";    // "strip" to make space to run nickel strips between cells. "bus" to make space for bus wires between rows
part = "both";    // "normal","mirrored", or "both"  You'll want a mirrored piece if the tops and bottom are different ( ie. When there are even rows in rectangular style or any # of rows in rhombus)

num_rows = 4;       
num_cols = 7;


// END OF CONFIGURATION

$fn = 50;       // Number of facets for circular parts.  
extra = 0.1;    // enlarge hexes by this to make them overlap
spacing = 4;    // Spacing between top and bottom pieces




hex_w = cell_dia + 2*wall;
hex_pt = (hex_w/2 + extra) / cos(30);


if (part == "mirrored")
    mirror_pack();
else if(part == "both")
{
    regular_pack();
    if(num_rows % 2 == 1)   // If odd pack
    {
       translate([hex_w/2, 1.5*(hex_pt-extra)*num_rows + spacing,0])
       mirror_pack();
    }
    else
    {
        translate([0,1.5*(hex_pt-extra)*num_rows + spacing,0])
        mirror_pack();
    }
}
else
    regular_pack();


// echos and info
echo(total_height=1.5*(hex_pt-extra)*(num_rows-1)+hex_pt*2);

if (rect_style)
    echo(total_width=hex_w*(num_cols+0.5));
else
    echo(total_width=hex_w*(num_cols+0.5*(num_rows-1)));

  

module regular_pack()
{
    union()
    {
        for(row = [0:num_rows-1])
        {
            
            if (rect_style)
            {
                if ((row % 2) == 0)
                {            
                    translate([0,1.5*(hex_pt-extra)*row,0])
                    for(col = [0:num_cols-1])
                    {
                        translate([hex_w*col,0,0])
                            pick_hex();
                    }                
                }
                else
                {
                    translate([0.5 * hex_w,1.5*(hex_pt-extra)*row,0])
                    for(col = [0:num_cols-1])
                    {
                        translate([hex_w*col,0,0])
                            pick_hex();
                    }
                }
            }
            else if (rect_style == 0)
            {
                translate([row*(0.5 * hex_w),1.5*(hex_pt-extra)*row,0])
                for(col = [0:num_cols-1])
                {
                    translate([hex_w*col,0,0])
                        pick_hex();
                }

            }
        }
    }      
}


module mirror_pack()
{
    union()
    {
        for(row = [0:num_rows-1])
        {
            
            if (rect_style)
            {
                if ((row % 2) == 0)
                {            
                    translate([0,1.5*(hex_pt-extra)*row,0])
                    for(col = [0:num_cols-1])
                    {
                        translate([hex_w*col,0,0])
                            pick_hex();
                    }                
                }
                else
                {
                    translate([-0.5 * hex_w,1.5*(hex_pt-extra)*row,0])
                    for(col = [0:num_cols-1])
                    {
                        translate([hex_w*col,0,0])
                            pick_hex();
                    }
                }
            }
            else if (rect_style == 0)
            {
                translate([-row*(0.5 * hex_w),1.5*(hex_pt-extra)*row,0])
                for(col = [0:num_cols-1])
                {
                    translate([hex_w*col,0,0])
                        pick_hex();
                }

            }
        }
    }      
}


module pick_hex()
{
    if (style == "strip")
        strip_hex();
    else if (style == "bus")
	{
        bus_hex();
	}
    else
        strip_hex();
}


module strip_hex()
{
	mirror([0,0,1])
	{
		difference()
		{
			// Hex block
			linear_extrude(height=holder_height, center=false, convexity=10)
				polygon([ for (a=[0:5])[hex_pt*sin(a*60),hex_pt*cos(a*60)]]); 
					
			// Top opening    
			translate([0,0,-1])
				cylinder(h=holder_height+2,d=opening_dia);
			  
			// Cell space    
			//#translate([0,0,-holder_height])
				//cylinder(h=2*(holder_height-slot_height),d=cell_dia);
				cylinder(h=2 *(holder_height-slot_height-separation) ,d=cell_dia, center=true);
			
			// 1st column slot
			rotate([0,0,60])
				translate([0,0,holder_height])    
					cube([hex_w+1,col_slot_width,2*slot_height], center=true);    
				
			// 2nd column slot
			rotate([0,0,-60])
				translate([0,0,holder_height])    
					cube([hex_w+1,col_slot_width,2*slot_height], center=true);
		   
			// Row slot 
			translate([0,0,holder_height]) 
				cube([hex_w+1,row_slot_width,2*slot_height], center=true);   
		}   
	}
}


module bus_hex()
{
	mirror([0,0,1])
	{
		difference()
		{
			// Hex block
			linear_extrude(height=holder_height, center=false, convexity=10)
				polygon([ for (a=[0:5])[hex_pt*sin(a*60),hex_pt*cos(a*60)]]); 
					
			// Top opening    
			translate([0,0,-1])
				cylinder(h=holder_height+2,d=opening_dia);
			  
			// Cell space    
			//#translate([0,0,-holder_height])
				//cylinder(h=2*(holder_height-slot_height),d=cell_dia);
				cylinder(h=2 *(holder_height-slot_height-separation) ,d=cell_dia, center=true);
			
			bus_width = (hex_pt + wall) - (opening_dia/2);    
				
			// 1st column slot
			rotate([0,0,60])
				translate([0,0,holder_height])    
					cube([hex_w+1,col_slot_width,2*slot_height], center=true);    
				
			// 2nd column slot    
			rotate([0,0,-60])
				translate([0,0,holder_height])    
					cube([hex_w+1,col_slot_width,2*slot_height], center=true);
					
			// Row slot A
			translate([0,(opening_dia/2)+bus_width/2-wall,holder_height]) 
				cube([(2*hex_w)+extra,bus_width,2*slot_height], center=true);  
			  
			// Row slot B    
			translate([0,-((opening_dia/2)+bus_width/2-wall),holder_height]) 
				cube([(2*hex_w)+extra,bus_width,2*slot_height], center=true);              
			
			/*
			translate([0,0,holder_height]) 
				cube([hex_w+1,row_slot_width,2*slot_height], center=true);   
				*/
				
		}
	}	
}

