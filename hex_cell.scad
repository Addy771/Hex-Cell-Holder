// HEX CELL CAPS V1.5
// This script generates models of cell holders and caps for 
// building battery packs using cylindrical cells. 
// Original concept by ES user "SpinningMagnets"
// More info can be found here:
// https://endless-sphere.com/forums/viewtopic.php?f=3&t=90058
//
// This file was created by Addy and is released as public domain
// Contributors
// Albert Phan


// TODO: 
// - add flat border option
// - fix caps
// - add option for space for a bms and spacers
// - have nicer cylindrical wire hole

// CONFIGURATION
////////////////////////////////////////////////////////////////////////////////////

opening_dia = 12;   // Circular opening to expose cell 
cell_dia = 18.6;    // Cell diameter
cell_height = 65;	// Cell height - only used when showing a mock pack
wall = 0.8;         // Wall thickness around a single cell. Spacing between cells is twice this amount.

num_rows = 2;       
num_cols = 4;

holder_height = 15; // Total height of cell holder
separation = 1;   	// Separation between cell top and tab slots
slot_height = 3.5;  // Height of all slots (3.5 mm is a good size for 14 awg solid in slots) more space may be needed for putting in a box
col_slot_width = 6; // Width of slots between rows
row_slot_width = 6; // Width of slots along rows

pack_style = "rect";    // "rect" for rectangular pack, "para" for parallelogram
wire_style = "bus";    // "strip" to make space to run nickel strips between cells. "bus" to make space for bus wires between rows
box_style = "both";		// "bolt" for bolting the box pack together, "ziptie" for using zipties to fasten the box together. (ziptie heads will stick out), "both" uses bolts for the 4 corners and zipties inbetween. Useful for mounting the pack to something with zipties but while still using bolts to hold it together
part_type = "assembled";    // "normal","mirrored", or "both". "assembled" is used for debugging  You'll want a mirrored piece if the tops and bottom are different ( ie. When there are even rows in rectangular style or any # of rows in parallelogram)
part = "cap";   // "holder" to generate cell holders, "cap" to generate pack end caps, "box lid" to generate boxes for the holders to fit in

cap_wall = 1.2;
cap_clearance = 0.8;

box_wall = 2.0;
box_lid_height = 15;

box_clearance = 0.4;
wire_hole_width = 15;
wire_hole_height = 8;	// Keep smaller than box_lid_height
wire_hole_length = 5;
wire_wall = 3;
wire_clearance = 0; 	// Remove if not needed. Space for wires between holder and box (vertically)

bolt_dia = 3;
bolt_dia_clearance = 1;
bolt_head_dia = 6;
bolt_head_thickness = 2;	// Keep smaller than box_lid_height

ziptie_width = 4;
ziptie_thickness = 2;
ziptie_head_width = 7;
ziptie_head_length = 7;
ziptie_head_thickness = 5;



//////////////////////////////////////////////////////
// Don't forget to do a test fit print
//////////////////////////////////////////////////////

// END OF CONFIGURATION
////////////////////////////////////////////////////////////////////////
$fn = 50;       // Number of facets for circular parts. 
hextra = 0.0001; // enlarge hexes by this to make them overlap
extra = 1;    	// for proper differences
spacing = 4;    // Spacing between top and bottom pieces
box_bottom_height = get_mock_pack_height() + 2 * (box_wall + box_clearance) - box_lid_height;
height_18650 = 65;

hex_w = cell_dia + 2*wall;	// Width of one hex cell
hex_pt = (hex_w/2) / cos(30); // Half the distance of point to point of a hex aka radius


if (part_type == "mirrored")
{
    if (part == "cap")
    {    
        mirror([1,0,0])
            regular_cap();
    }
    else if (part == "holder")    
    {
        mirror([1,0,0])
            regular_pack();
    }
}
else if(part_type == "both")
{
    if (part == "cap")
	{
        regular_cap();
	}
    else if (part == "holder")
        regular_pack();
    
    if(num_rows % 2 == 1)   // If odd pack move pack over to nest properly
    {

        mirror([1,0,0])
		{
            if (part == "cap")
                translate([-hex_w*(num_cols - 0.5), 1.5*(hex_pt)*(num_rows+1) + spacing,0])
                    regular_cap();
            else if (part == "holder")
                translate([-hex_w*(num_cols - 0.5), 1.5*(hex_pt)*num_rows + spacing,0])
                    regular_pack();
		}
    }
    else
    {
        
        mirror([1,0,0])
            if (part == "cap")
                translate([-hex_w*(num_cols - 0.5),1.5*(hex_pt)*(num_rows+1) + spacing,0])
                    regular_cap();
			
            else if (part == "holder")
                translate([-hex_w*(num_cols - 1),1.5*(hex_pt)*num_rows + spacing,0])
                    regular_pack();
    }
}
else if(part_type == "assembled")
{
	
	mock_pack();	// for debugging for now
	translate([0,0,box_bottom_height + box_lid_height - 2 * (box_wall + box_clearance)])
		mirror([0,0,1])
			color("green", alpha = 0.7)
			regular_box_lid();
	
		color("lightgreen", alpha = 0.7)
		regular_box_bottom();

}
else	// if Normal
{
    if (part == "cap")  
	{
        regular_cap();
	}
    
    else if (part == "holder")
        regular_pack();
	else if (part == "box lid")
	{
		regular_box_lid();
	}
		

}


// echos and info
echo(total_width=1.5*(hex_pt)*(num_rows-1)+hex_pt*2);

if (pack_style == "rect")
{
    // Rectangular style
    echo(total_length=hex_w*(num_cols+0.5));
	if((num_rows % 2) == 0) // Even?
		
    echo("\n******************************************************* \n Top and bottom are different. Don't forget to do a mirrored part\n*******************************************************");
}
else if(pack_style == "para")
{
	// Parallelogram style
    echo(total_length=hex_w*(num_cols+0.5*(num_rows-1)));
	echo("\n******************************************************* \n Top and bottom are different. Don't forget to do a mirrored part\n*******************************************************");
}

// para cap needs to be fixed. It's thin on one side.
module para_cap()
{
    translate([-cap_clearance,-cap_clearance,-holder_height/2])
        difference()
        {
            
            translate([-cap_clearance/2,-cap_clearance/2,-(cap_wall)])
                minkowski()
                {

                    linear_extrude(height=extra + cap_wall, center=false, convexity=10)
                        polygon([
                            [0,0],
                            [hex_w*(num_rows-1)*0.5,1.5*(hex_pt)*(num_rows-1)],
                            [hex_w*(num_rows-1)*0.5+hex_w*(num_cols-1),1.5*(hex_pt)*(num_rows-1)],
                            [hex_w*(num_cols-1),0]]
                        );
                    
                    hex_pt2 = (hex_w/2 + extra + cap_clearance + cap_wall) / cos(30);
                    linear_extrude(height=holder_height, center=true, convexity=10)
                        polygon([ for (a=[0:5])[hex_pt2*sin(a*60),hex_pt2*cos(a*60)]]); 
                }    
            
            minkowski()
            {
                linear_extrude(height=extra*2, center=false, convexity=10)
                    polygon([
                        [0,0],
                        [hex_w*(num_rows-1)*0.5,1.5*(hex_pt)*(num_rows-1)],
                        [hex_w*(num_rows-1)*0.5+hex_w*(num_cols-1),1.5*(hex_pt)*(num_rows-1)],
                        [hex_w*(num_cols-1),0]]
                    );
                hex_pt2 = (hex_w/2 + extra + cap_clearance) / cos(30);
                linear_extrude(height=holder_height, center=true, convexity=10)
                    polygon([ for (a=[0:5])[hex_pt2*sin(a*60),hex_pt2*cos(a*60)]]); 
            }
                
        }
}


module rect_cap(cap_wall, cap_clearance,cap_height = holder_height)
{
	difference()
	{
		// Positive Hull	
		rect_cap_positive(cap_wall,cap_clearance,cap_height);
		// Negative Hull
		rect_cap_negative(cap_wall,cap_clearance,cap_height);
		
	}
} 

// Generates the rectangular cap positive piece used in rect_cap and box. Default height is holder height
module rect_cap_positive(cap_wall,cap_clearance,cap_height = holder_height)
{
	translate([-(cap_wall + cap_clearance),-(cap_wall + cap_clearance),-(cap_wall + cap_clearance)])
			
		hull()
		{
			for (x = [0,1], y = [0,1])
			{
				translate([x * (get_hex_length(num_cols + 0.5) + 2*(cap_wall + cap_clearance)),y *( get_hex_length_pt(num_rows) + 2*(cap_wall + cap_clearance)),0])
				linear_extrude(height=cap_height, convexity = 10)
					polygon([ for (a=[0:5])[hex_pt*sin(a*60),hex_pt*cos(a*60)]]); 
				
			}
		}
}

// Generates the rect_cap negative piece (as a positive to be cut out using difference) used in rect_cap and box
module rect_cap_negative(cap_wall,cap_clearance,cap_height = holder_height)
{
	translate([-cap_clearance,-cap_clearance,0])
		hull()
		{
			for (x = [0,1], y = [0,1])
			{
				translate([x * ((get_hex_length(num_cols + 0.5)+ 2 * cap_clearance)),y * (get_hex_length_pt(num_rows)+ 2 * cap_clearance),0])
				linear_extrude(height=cap_height + extra, convexity = 10)
					polygon([ for (a=[0:5])[hex_pt*sin(a*60),hex_pt*cos(a*60)]]); 
				
			}
		}
}
module regular_cap()
{
    if (pack_style == "rect")
        rect_cap();
    else if (pack_style == "para")
        para_cap();
}

module regular_box_lid()
{
	/* To do: 
	just one hole in corner
	[]add support for wire hole
	[]add zip ties to secure the two halves 
		support for zipties inbetween hex in shape of hex
		cutout ziptie area for flushness of ziptie
	
	[]add clearance for wires top and bottom
	[x]add helper functions to get pack sizes 
	[x]optimize using hull()
	[]check on the regular caps again
	
	
	*/
	
	
	if (pack_style == "rect")
	{
		difference()
		{

		
			union()
			{
				
				difference()
				{
					union()
					{
						// Positive
						rect_cap_positive(box_wall,box_clearance,box_lid_height);
						// Wire support hole
						translate([(num_cols)*hex_w + box_clearance + box_wall * 1.5 - wire_hole_length*8/2,0,box_lid_height-box_wall-box_clearance - (box_lid_height)/2 ])
							cube([wire_hole_length*10,wire_hole_width + wire_wall *2,box_lid_height], center = true);
						
					}
					// Negatives
					translate([-box_clearance,-box_clearance,0])
					{
						rect_cap_negative(box_wall,box_clearance,box_lid_height);
					}
					// Wire hole cutout
					translate([(num_cols)*hex_w+box_clearance+box_wall *1.5,0,box_lid_height-box_wall-box_clearance - wire_hole_height/2 + extra])
						cube([wire_hole_length *11 + box_wall *3,wire_hole_width,wire_hole_height], center = true);
				}
				// Lid supports
				both_lid_supports();
				
			}
			// Other cutouts of entire box lid
			pick_hole_style(lid = true);
		}
		
	}
	
    else if (pack_style == "para")
    // para box;
	;
	
}

module regular_box_bottom()
{
	if(pack_style == "rect")
	{
		difference()
		{
			union()
			{
				rect_cap(box_wall,box_clearance,box_bottom_height);
				both_lid_supports(box_bottom_height);
			}

			// Other cutouts of entire box bottom
			pick_hole_style();
		}
	}
	else if (pack_style == "para")
    // para box;
	;
}

// Creates a mock pack for debugging
// Origin is the bottom of the center of the first hex cell
module mock_pack()
{
	
	color("blue") render(1)regular_pack();
	// add 18650s
	for(x = get_hex_center_points_rect(num_rows,num_cols))
		 {
			// Iterate through each hex center and place a cell
			// find out proper z height for translate  holder_height-slot_height-separation?
			translate([x[0],x[1],slot_height + separation])
				color("CornflowerBlue")mock_cell();

		 }
	color("blue")
		translate([0,0,slot_height + separation + cell_height + slot_height + separation])
			mirror([0,0,1])
				render(1)regular_pack();
}

// Creates a mock cell. Origin is bottom of 1st hex cell holder.
module mock_cell()
{
	cylinder(d = cell_dia, h = cell_height);
}

module regular_pack()
{
	translate([0,0,holder_height])
		union()
		{
			for(row = [0:num_rows-1])
			{
				
				if (pack_style == "rect")
				{
					if ((row % 2) == 0)
					{            
						translate([0,1.5*(hex_pt)*row,0])
						for(col = [0:num_cols-1])
						{
							translate([hex_w*col,0,0])
								pick_hex();
						}                
					}
					else
					{
						translate([0.5 * hex_w,1.5*(hex_pt)*row,0])
						for(col = [0:num_cols-1])
						{
							translate([hex_w*col,0,0])
								pick_hex();
						}
					}
				}
				else if (pack_style == "para")
				{
					translate([row*(0.5 * hex_w),1.5*(hex_pt)*row,0])
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
    if (wire_style == "strip")
        strip_hex();
    else if (wire_style == "bus")
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
				polygon([ for (a=[0:5])[(hex_pt + hextra)*sin(a*60),(hex_pt + hextra)*cos(a*60)]]); 
					
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
				polygon([ for (a=[0:5])[(hex_pt + hextra)*sin(a*60),(hex_pt + hextra)*cos(a*60)]]); 
					
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

module both_lid_supports(lid_support_height = box_lid_height)
{
	lid_support(lid_support_height);

	// if even, translate over half a hex
	if(num_rows % 2 == 0)
		translate([get_hex_length(num_cols +0.5),get_hex_length_pt(num_rows),0])
			rotate([0,0,180])
				lid_support(lid_support_height);
	else	
		translate([0,get_hex_length_pt(num_rows),0])
			mirror([0,1,0])
					lid_support(lid_support_height);
}

module lid_support(lid_support_height = box_lid_height)
{
	// Ziptie supports
	difference()
	{
		for(col = [1:num_cols])
		{
			// iterate on one side
			// add support in the shape of a hex inbetween cols
			difference()
			{
				translate([-hex_w/2 + col * hex_w,-hex_pt*1.5 - box_clearance/2,-(box_wall + box_clearance)])
					linear_extrude(height=lid_support_height, center=false, convexity=10)
						polygon([ for (a=[0:5])[hex_pt*sin(a*60),hex_pt*cos(a*60)]]);
				
				translate([-hex_w/2 + col * hex_w + box_clearance,-hex_pt*2 - box_wall + extra,-box_wall - lid_support_height/2 -extra])
				{
					cube([hex_pt*2 + extra,hex_pt*2,lid_support_height*5],center = true);
				}
			}


		}
		// Cutout for last support piece
		translate([get_hex_length(num_cols+1) + box_clearance + box_wall,-hex_pt*1.5 - 0.5 *(box_wall + box_clearance),-(box_wall + box_clearance) - lid_support_height])
		{
			linear_extrude(height=lid_support_height*3, center=false, convexity=10)
					polygon([ for (a=[0:5])[hex_pt*sin(a*60),hex_pt*cos(a*60)]]);
		}
		

		
	}
}

// Picks the correct hole style based on configuration
module pick_hole_style(lid = false)
{
		// Other cutouts of entire box lid
		if (box_style == "ziptie")
		{
			both_ziptie_holes();
		}
		else if (box_style == "bolt")
		{
			// if holes are for lid, make them bolt size, otherwise for the bottom, use the tap size and no bolt head
			if(lid)
				both_bolt_holes(bolt_dia + bolt_dia_clearance, bolt_head_dia + bolt_dia_clearance,[1:num_cols]);
			else
			{
				both_bolt_holes(bolt_dia * 0.9, bolt_dia * 0.9,[1:num_cols]);

			}
				
		}
		else if (box_style == "both")
		{
			if(lid)
				both_bolt_holes(bolt_dia + bolt_dia_clearance, bolt_head_dia + bolt_dia_clearance,[1,num_cols]);
			else
				both_bolt_holes(bolt_dia * 0.9,bolt_dia * 0.9,[1,num_cols]);

			both_ziptie_holes(ziptie_width, ziptie_thickness,[2:num_cols-1]);
		}
}
module both_ziptie_holes(ziptie_width = ziptie_width,ziptie_thickness = ziptie_thickness,range = [1:num_cols])
{
	ziptie_holes(ziptie_width,ziptie_thickness,range);
	
	// if even, translate over half a hex
	if(num_rows % 2 == 0)
		translate([get_hex_length(num_cols +0.5),get_hex_length_pt(num_rows),0])
			rotate([0,0,180])
				ziptie_holes(ziptie_width,ziptie_thickness,range);
	else	
		translate([0,get_hex_length_pt(num_rows),0])
			mirror([0,1,0])
					ziptie_holes(ziptie_width,ziptie_thickness,range);

}
// Holes for ziptie
module ziptie_holes(ziptie_width = ziptie_width,ziptie_thickness = ziptie_thickness, range = [1:num_cols])
{
	for(col = range)
	{
			// Cutout ziptie holes
			translate([-hex_w/2 + col * hex_w,-hex_pt + 0.5 *(box_wall + box_clearance),box_bottom_height/2-box_wall-box_clearance])
			{
				cube([ziptie_width,ziptie_thickness,box_bottom_height*2],center = true);
			// Cutout for ziptie head (cuts through lid however, should think of a better solution maybe bolts instead?)
			// translate([0,ziptie_head_thickness/2-ziptie_thickness/2,-(box_lid_height/2-box_wall-box_clearance)- (box_wall + box_clearance) + ziptie_head_length/2 - extra/2])
			// 	cube([ziptie_head_width,ziptie_head_thickness,ziptie_head_length + extra],center = true);
			}	
	}
}

module both_bolt_holes(bolt_dia,bolt_head_dia, range = [1:num_cols])
{
	bolt_holes(bolt_dia,bolt_head_dia, range);
	// if even, translate over half a hex
	if(num_rows % 2 == 0)
		translate([get_hex_length(num_cols +0.5),get_hex_length_pt(num_rows),0])
			rotate([0,0,180])
				bolt_holes(bolt_dia,bolt_head_dia, range);
	else	
		translate([0,get_hex_length_pt(num_rows),0])
			mirror([0,1,0])
					bolt_holes(bolt_dia,bolt_head_dia, range);
}
// Creates a positive model of the bolt holes and the bolt heads
module bolt_holes(bolt_dia,bolt_head_dia, range = [1:num_cols])
{
	for(col = range)
	{
			// Cutout bolt holes
			translate([-hex_w/2 + col * hex_w,-hex_pt + 0.5 *(box_wall + box_clearance),box_lid_height/2-box_wall-box_clearance])
			{
				cylinder(d = bolt_dia, h = box_bottom_height*2,center = true);
			translate([0,0,-(box_lid_height/2-box_wall-box_clearance)- (box_wall + box_clearance) - extra])
				cylinder(d = bolt_head_dia, h = bolt_head_thickness + extra);
			}	
	}
}

// returns height of the mock pack
function get_mock_pack_height() 
= 2 * (slot_height + separation) + cell_height;
// returns the length of the center of one hex cell on a row to number to hexes passed to function
function get_hex_length(num_cell)
= (num_cell-1) * hex_w;

// returns the length of the center of vertical(columns) hex cells to number to hexes passed to function
function get_hex_length_pt(num_cell)
= (num_cell-1) * hex_pt*1.5;

// returns a list of the hex cell centers.
function get_hex_center_points_rect(num_rows, num_cols)
//= [[(num_rows == 1) ? 1 : 2,2],[2,4]]; // vector of points test 
=  [
	// Iterate through num of rows and cols
	for(row = [0:num_rows-1],col = [0:num_cols-1]) 
	[	// X component of list member
		row % 2 == 0 ? // if even
		hex_w * col :
		//else	
		0.5 * hex_w + hex_w * col
		,	
		// Y component of list member
		 row * 1.5 * (hex_pt)
		 ]
	];	// Closing function bracket
