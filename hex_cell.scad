// HEX CELL CAPS
// This script generates a model of end caps for building 
// battery packs using cylindrical cells. 
// Original concept by ES user "SpinningMagnets"
// More info can be found here:
// https://endless-sphere.com/forums/viewtopic.php?f=3&t=90058
//
// This file was created by Addy and is released as public domain
// 09/26/2017 V1.1


// CONFIGURATION

opening_dia = 10;   // Circular opening to expose cell 
cell_dia = 18.5;    // Cell diameter
wall = 1;           // Wall thickness around a single cell. Spacing between cells is twice this amount.
holder_height = 8;  // 
slot_height = 2;    // Height of all slots
col_slot_width = 5; // Width of slots between rows
row_slot_width = 8; // Width of slots along rows

rect_style = 1;     // 1 for rectangular shape pack, 0 for rhombus
mirrored = 0;       // 1 for mirrored model, 0 for normal. Useful for printing matching top/bottom pieces
num_rows = 2;       
num_cols = 4;

$fn = 50;       // Number of facets for circular parts.  
extra = 0.1;    // enlarge hexes by this to make them overlap

// END OF CONFIGURATION



hex_w = cell_dia + 2*wall;
hex_pt = (hex_w/2 + extra) / cos(30);


if (mirrored)
    mirror_pack();
else
    regular_pack();


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
                            single_hex();
                    }                
                }
                else
                {
                    translate([0.5 * hex_w,1.5*(hex_pt-extra)*row,0])
                    for(col = [0:num_cols-1])
                    {
                        translate([hex_w*col,0,0])
                            single_hex();
                    }
                }
            }
            else if (rect_style == 0)
            {
                translate([row*(0.5 * hex_w),1.5*(hex_pt-extra)*row,0])
                for(col = [0:num_cols-1])
                {
                    translate([hex_w*col,0,0])
                        single_hex();
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
                            single_hex();
                    }                
                }
                else
                {
                    translate([-0.5 * hex_w,1.5*(hex_pt-extra)*row,0])
                    for(col = [0:num_cols-1])
                    {
                        translate([hex_w*col,0,0])
                            single_hex();
                    }
                }
            }
            else if (rect_style == 0)
            {
                translate([-row*(0.5 * hex_w),1.5*(hex_pt-extra)*row,0])
                for(col = [0:num_cols-1])
                {
                    translate([hex_w*col,0,0])
                        single_hex();
                }

            }
        }
    }      
}


module single_hex()
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
        translate([0,0,-holder_height])
            cylinder(h=2*(holder_height-slot_height),d=cell_dia);
        
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

