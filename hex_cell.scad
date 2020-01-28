// https://github.com/Addy771/Hex-Cell-Holder
// This script generates models of cell holders and caps for 
// building battery packs using cylindrical cells. 
// Original concept by ES user "SpinningMagnets"
// More info can be found here:
// https://endless-sphere.com/forums/viewtopic.php?f=3&t=90058
//
// This file was created by Addy and is released as public domain
// Contributors
// Albert Phan - Added boxes and optimizations


///////////////////////////////////////////////////////////////////////////////////////////////////////////
// BASIC CONFIGURATION
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


cell_dia = 18.4;    // Cell diameter default = 18.4 for 18650s **PRINT OUT TEST FIT PIECE STL FIRST**
cell_height = 65;	// Cell height default = 65 for 18650s
wall = 1.2;         // Wall thickness around a single cell. Make as a multiple of the nozzle diameter. Spacing between cells is twice this amount. default = 1.2

num_rows = 2;       
num_cols = 3;

holder_height = 15; // Total height of cell holder default = 15
slot_height = 3.5;  // Height of all slots default = 3.5 mm is a good size for 14 awg solid in slots


col_slot_width = 4; // Width of slots between rows default = 6
row_slot_width = 8; // Width of slots along rows default = 6

pack_style = "rect";	// "rect" for rectangular pack, "para" for parallelogram, "tria" for triangle shaped pack (number of rows define the amount of rows at the bottom of the triangle. Columns get ignored)

wire_style = "strip";		// "strip" to make space to run nickel strips between cells.
						// "bus" to make space for bus wires between rows

box_style = "both";		// "bolt" for bolting the box pack together
						// "ziptie" for using zipties to fasten the box together. (ziptie heads will stick out), 
						// "both" uses bolts for the 4 corners and zipties inbetween. Useful for mounting the pack to something with zipties but while still using bolts to hold it together

part_type = "normal";   // "normal","mirrored", or "both". "assembled" is used for debugging.  You'll want a mirrored piece if the tops and bottom are different ( ie. When there are even rows in rectangular style or any # of rows in parallelogram. The Console will tell you if you need a mirrored piece).

part = "holder";   		// "holder" to generate cell holders, 
						// "cap" to generate pack end caps, 
						// "box lid" to generate box lid
						// "box bottom" for box bottom
						// "wire clamp" for strain relief clamp
						
						// Note: There are no boxes for parallelogram packs.

box_lip = true;			// Adds a lip to the box pieces. default = true.

cap_wall = 1.2;				// Cap wall thickness (default = 1.2 recommend to make a multiple of nozzle dia)
cap_clearance = 0.2;		// Clearance between holder and caps default = 0.2

box_wall = 2.0;				// Box wall thickness (default = 2.0 recommend to make at least 4 * multiple of nozzle dia)
box_clearance = 0.2;		// Clearance between holder and box default = 0.2


// Box clearances for wires 
bms_clearance = 8; 			// Vertical space for the battery management system (bms) on top of holders, set to 0 for no extra space
box_bottom_clearance = 0;	// Vertical space for wires on bottom of box
box_wire_side_clearance = 3; // Horizontal space from right side (side with wire hole opening) to the box wall for wires
box_nonwire_side_clearance = 0; // Horizontal space from left side (opposite of wire hole) to the box wall for wires

wire_diameter = 2;			// Diameter of 1 power wire used in the strain relief clamps default = 5 for 10 awg stranded silicon wire
wire_clamp_bolt_dia = 3;	// Bolt dia used for clamping wire default = 3 for M3 bolt
clamp_factor = 0.7;			// Factor of wire diameter to be clamped. Higher number is less clamping force (default=0.7 max=1.0)
bolt_dia = 3;				// Actual dia of bolt default = 3 for M3 bolt
bolt_head_dia = 6;			// Actual dia of bolt head default = 6 for M3 socket head bolt
bolt_head_thickness = 3;	// Thickness (height) of bolt head default = 3 for M3 Socket head
ziptie_width = 8;
ziptie_thickness = 2.5;


///////////////////////////////////////////////////////////////////////////////////
// ADVANCED CONFIGURATION for users that need to customize everything
//////////////////////////////////////////////////////////////////////////////////

opening_dia = cell_dia;   		// Circular opening to expose cell default = 12
separation = 1.5;   			// Separation between cell top and wire slots (aka tab thickness) default = 1.5
wire_hole_width = 15;		// Width of wire hole default = 15
wire_hole_length = 10;		// Length of the wireclamp that sticks out default = 10
wire_top_wall = 4;			// Thickness of top wire wall default = 4mm
clamp_plate_height = 4;		// default = 4
bolt_dia_clearance = 1;		// Amount of extra diameter for bolt holes default = 1
cell_tab_width = 5;			// Width of tab that keeps the cell in the holder default = 5
cell_tab_length = 3;		// Approx Length of tab that keeps the cell in the holder default = 3
box_lip_height = box_wall * 0.75;	// Height of lip default = box_wall * 0.75



//////////////////////////////////////////////////////
// Don't forget to do a test fit print
//////////////////////////////////////////////////////

// END OF CONFIGURATION
////////////////////////////////////////////////////////////////////////

// TODO: 
// [x] fix and optimize para cap
// [x] fix lid support for bottom using bms clearance instead of box_bottom_clearance
// [x] add box_lip_height between box and lid
//		[x] add box_lip_height parameter to rectcap negative to do it
// [x] add side clearance
// [x] fix wire hole for different box wire clearances
// [x] fix wire_hole_length for large values
// [x] add wire strain relief clamp
// [x] add clamp to part_type
// [x] add abilty to remove faulty cells easily
// [x] add default values in comments for config vars
// [x] cleanup old code that uses hex()
// [x] fix bus cuts with new hole style 
// [x] work on strength of tab holders (make thicker)
// [x] echo for length, height, and width of box
// [x] #5 Fix lid_support issues with even rows
// [x] #3 Fix wire hole support generating too much over the box.
// [x] Change instances of box_clearance used in the x direction to box_clearance_x because box_clearance is only true in the y direction, for box_clearance in x, you must use the x component of box_clearance ( * cos(30))
// [x] #4 Fix zipties and bolt holes generate in same hole for cols 2 or less
// [x] #6 Fix box_clearance value changes lip height
// [x] Add option to have no lip for box for printing with thin box walls

///////////////////////////////////////////////////////////////////////////
// NON-Configurable helper variables
///////////////////////////////////////////////////////////////////////////
$fn = 50;       // Number of facets for circular parts. 
hextra = 0.0001; // enlarge hexes by this to make them overlap
extra = 1;    	// for proper differences()
spacing = 4;    // Spacing between top and bottom pieces
box_lid_height = (holder_height)-(holder_height-slot_height)/2+(box_clearance+box_wall) + bms_clearance;	// box lid to middle of holder
box_bottom_height = get_mock_pack_height() + 2 * (box_wall + box_clearance) + bms_clearance + box_bottom_clearance - box_lid_height;
hex_w = (cell_dia + 2*wall);		// Width of one hex cell
hex_pt = (hex_w/2) / cos(30); 	// Half the distance of point to point of a hex aka radius
cell_radius = cell_dia/2;
box_clearance_x = box_clearance * cos(30);	// Used whenever we are translating in the x direction from the hexes
box_wall_x = box_wall * cos(30);			// Used whenever we are translating in the x direction from the hexes 

wire_clamp_support = hex_pt + box_clearance + box_wall - wire_hole_width/2 ;		// Place for strain relief clamp to screw into
wire_clamp_nib_dia = 5;

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
	else if (part == "box lid" || part == "box bottom")
	{
		regular_box_bottom();
		translate([0,-(hex_pt * 2 + 2 * (box_wall + box_clearance) + spacing), 0])
		mirror([0,0,1])
			rotate([180,0,0])
				regular_box_lid();
	}
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
	translate([0,0,box_bottom_height + box_lid_height - 2 * (box_wall + box_clearance) - box_bottom_clearance])
		mirror([0,0,1])
		{
			color("green", alpha = 0.7)
			regular_box_lid();
			color("orange", alpha = 0.7)
					translate([(get_hex_length(num_cols + 1) + box_wire_side_clearance + box_wall + box_clearance + wire_hole_length/2),0,box_lid_height-box_wall-box_clearance])
						mirror([0,0,1])
							wire_clamp();
		}
			
	
		color("lightgreen", alpha = 0.7)
			translate([0,0,-box_bottom_clearance])
				regular_box_bottom();

	translate([(get_hex_length(num_rows+2)+ 2*(box_wall + box_clearance) + box_nonwire_side_clearance + box_wire_side_clearance)*2,get_hex_length_pt(num_cols+2) + 2*(box_wall + box_clearance),0])
	{
		mock_pack();	// for debugging for now  - 2 * (box_wall + box_clearance) - bms_clearance
		translate([0,0,get_mock_pack_height() + bms_clearance])
			mirror([0,0,1])
			{
				color("green", alpha = 0.7)
				regular_box_lid();
				color("orange", alpha = 0.7)
					translate([(get_hex_length(num_cols + 1) + box_wire_side_clearance + box_wall + box_clearance + wire_hole_length/2),0,box_lid_height-box_wall-box_clearance])
						mirror([0,0,1])
							wire_clamp();
			}
	
		
	}

	translate([(get_hex_length(num_rows+2)+ 2*(box_wall + box_clearance) + box_nonwire_side_clearance + box_wire_side_clearance)*4,(get_hex_length_pt(num_cols+2) + 2*(box_wall + box_clearance)) * 3,0])
		{
			mock_pack();	// for debugging for now
			color("lightgreen", alpha = 0.7)
				translate([0,0,-(box_bottom_clearance)])
					regular_box_bottom();

		}

				

}
else if(part_type == "mock pack")
{
	mock_pack();
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
		translate([0,get_hex_length_pt(num_cols),0])
		mirror([0,0,1])
			rotate([180,0,0])
				regular_box_lid();
	}
	else if (part == "box bottom")
	{
		regular_box_bottom();
	}
	else if (part == "wire clamp")
		wire_clamp();

}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// echos and info
echo(pack_height_holder = get_mock_pack_height());
echo(box_lid_height = box_lid_height);
echo(box_bottom_height = box_bottom_height);
echo(box_total_length = get_box_total_length());
echo(box_total_width = get_box_total_width());

echo(total_width_holder = get_hex_length_pt(num_rows)+hex_pt*2);
if (pack_style == "rect")
{
    // Rectangular style
    echo(total_length_holder=get_holder_rect_length());
	if((num_rows % 2) == 0) // Even?
		
    echo("\n******************************************************* \n Top and bottom are different. Don't forget to do a mirrored holder\n*******************************************************");
}
else if(pack_style == "para")
{
	// Parallelogram style
    echo(total_length_holder=hex_w*(num_cols+0.5*(num_rows-1)));
	echo("\n******************************************************* \n Top and bottom are different. Don't forget to do a mirrored holder\n*******************************************************");
}
else if(pack_style == "tria")
{
	// Triangle style
    echo(total_length_holder=hex_w*(num_cols+0.5*(num_rows-1))); // No idea if this is correct
	echo("\n******************************************************* \n Top and bottom are not different. But don't forget to print twice ;)\n*******************************************************");
}

if (part_type == "mirrored" && (part == "box lid" || part == "box bottom"))
	echo("\n******************************************************* \n Please choose Normal for box lid or box bottom as there aren't mirrored versions of them.\n*******************************************************");
	 
if (pack_style == "para" && (part == "box lid" || part == "box bottom"))
	echo("\n******************************************************* \n There are currently no boxes for parallelogram style\n*******************************************************");

if (pack_style == "tria" && (part == "box lid" || part == "box bottom" || part == "cap"))
	echo("\n******************************************************* \n There are currently no boxes and caps for triangle style\n*******************************************************");



//////////////////////////////////////////////////////////////////////////////////////////////////////////////

// This module generates a cap for a para style holder
module para_cap(cap_wall = cap_wall, cap_clearance = cap_clearance,cap_height = holder_height,positive_x = 0, negative_x = 0, positive_y = 0, negative_y = 0)
{
	difference()
	{
		// Positive Hull	
		para_cap_positive(cap_wall,cap_clearance,cap_height,positive_x,negative_x,positive_y,negative_y);
		// Negative Hull
		para_cap_negative(cap_wall,cap_clearance,cap_height,positive_x,negative_x,positive_y,negative_y);
	}
}

// Generates a positive of the paracap which is to be cut out with the negative
module para_cap_positive(cap_wall,cap_clearance,cap_height = holder_height,positive_x = 0, negative_x = 0, positive_y = 0, negative_y = 0)
{
	translate([0,0,-(cap_wall + cap_clearance)])
		hull()
		{
			// Generate 4 hexes in each corner and hull them together
			// [0,0] Bottom left
			translate([-negative_x,-negative_y,0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
			// [1,0] Bottom right
			translate([get_hex_length(num_cols)+ positive_x,-(negative_y),0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
			// [0,1] Top left
			translate([get_hex_length(num_rows/2 +0.5)-(negative_x),get_hex_length_pt(num_rows) + positive_y,0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
			//  [1,1] Top right
			translate([get_hex_length(num_cols + num_rows/2-0.5) + positive_x,get_hex_length_pt(num_rows) + positive_y,0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
		}
}

// Generates negative of the paracap to be cut out in a difference()
module para_cap_negative(cap_wall,cap_clearance,cap_height = holder_height,positive_x = 0, negative_x = 0, positive_y = 0, negative_y = 0)
{
		hull()
		{
			// Generate 4 hexes in each corner and hull them together
			// [0,0] Bottom left
			translate([-negative_x,-negative_y,0])
				hex(cap_height,hex_pt + cap_clearance);
			// [1,0] Bottom right
			translate([get_hex_length(num_cols)+ positive_x,-(negative_y),0])
				hex(cap_height,hex_pt + cap_clearance);
			// [0,1] Top left
			translate([get_hex_length(num_rows/2 +0.5)-(negative_x),get_hex_length_pt(num_rows) + positive_y,0])
				hex(cap_height,hex_pt  + cap_clearance);
			//  [1,1] Top right
			translate([get_hex_length(num_cols + num_rows/2-0.5) + positive_x,get_hex_length_pt(num_rows) + positive_y,0])
				hex(cap_height,hex_pt + cap_clearance);

		}
}


module rect_cap(cap_wall = cap_wall, cap_clearance = cap_clearance,cap_height = holder_height,positive_x = 0, negative_x = 0, positive_y = 0, negative_y = 0)
{
	difference()
	{
		// Positive Hull	
		rect_cap_positive(cap_wall,cap_clearance,cap_height,positive_x,negative_x,positive_y,negative_y);
		// Negative Hull
		rect_cap_negative(cap_wall,cap_clearance,cap_height,positive_x,negative_x,positive_y,negative_y);
		
	}
} 

// Generates the rectangular cap positive piece used in rect_cap and box. Default height is holder height
// height includes wall thickness and clearance
// Z Origin is -(cap_wall + cap_clearance)
// Positive_x = amount of clearance between the positive x box wall and the holder.
// Negative_x = amount of clearance between the negative x box wall and the holder.
// Same goes for y

module rect_cap_positive(cap_wall,cap_clearance,cap_height = holder_height,positive_x = 0, negative_x = 0, positive_y = 0, negative_y = 0)
{
	translate([0,0,-(cap_wall + cap_clearance)])
		hull()
		{
			// Generate 4 hexes in each corner and hull them together
			// [0,0] Bottom left
			translate([-negative_x,-negative_y,0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
			// [1,0] Bottom right
			translate([get_hex_length(num_cols + 0.5)+ positive_x,-(negative_y),0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
			// [0,1] Top left
			translate([-(negative_x),get_hex_length_pt(num_rows) + positive_y,0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
			//  [1,1] Top right
			translate([get_hex_length(num_cols + 0.5) + positive_x,get_hex_length_pt(num_rows) + positive_y,0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
		}
}

// Generates the rect_cap negative piece (as a positive to be cut out using difference) used in rect_cap and box. This is basically the same as rect_cap_positive but the hexes are smaller by cap_wall and
// z origin = 0
// TODO: With rect_cap_negative now very similiar to rect_cap_positive, is it really required anymore?
module rect_cap_negative(cap_wall,cap_clearance,cap_height = holder_height,positive_x = 0, negative_x = 0, positive_y = 0, negative_y = 0)
{
		hull()
		{

			// Generate 4 hexes in each corner and hull them together
			// [0,0] Bottom left
			translate([-negative_x,-negative_y,0])
				hex(cap_height,hex_pt + cap_clearance);
			// [1,0] Bottom right
			translate([get_hex_length(num_cols + 0.5)+ positive_x,-(negative_y),0])
				hex(cap_height,hex_pt + cap_clearance);
			// [0,1] Top left
			translate([-(negative_x),get_hex_length_pt(num_rows) + positive_y,0])
				hex(cap_height,hex_pt  + cap_clearance);
			//  [1,1] Top right
			translate([get_hex_length(num_cols + 0.5) + positive_x,get_hex_length_pt(num_rows) + positive_y,0])
				hex(cap_height,hex_pt + cap_clearance);
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
						rect_cap_positive(box_wall,box_clearance,box_lid_height,box_wire_side_clearance, box_nonwire_side_clearance);
						// Lip Positive ( lip is added to box_lid and subtracted from box_bottom)
						if(box_lip)
						{
							translate([0,0,box_lid_height - box_wall/2])
								rect_cap_positive(box_wall/2,box_clearance,box_lip_height,box_wire_side_clearance,box_nonwire_side_clearance);
						}

						
						// Wire support hole
						translate([(num_cols * hex_w + box_wire_side_clearance + box_clearance_x + box_wall_x) - (box_wall_x + box_clearance_x + hex_w/2 + extra),-(wire_hole_width + 2 * (wire_clamp_support)) /2,-(box_wall + box_clearance)])
							cube([wire_hole_length + box_wall_x + box_clearance_x + hex_w/2 + extra,wire_hole_width + 2 * (wire_clamp_support),box_lid_height]);
						
					}
					// Negatives
					rect_cap_negative(box_wall,box_clearance,box_lid_height*2,box_wire_side_clearance,box_nonwire_side_clearance);
					// Wire hole cutout
					translate([(num_cols)*hex_w+box_clearance_x + box_wall_x +box_wire_side_clearance,0,wire_top_wall - box_wall + box_lid_height/2])
						cube([(wire_hole_length + box_wall_x + box_clearance_x + hex_w/2) * 2 + box_wall *3,wire_hole_width,box_lid_height], center = true);
					// Strain relief bolt cutouts
					translate([(num_cols)*hex_w+box_clearance_x + box_wall_x + box_wire_side_clearance + wire_hole_length/2,(wire_hole_width + wire_clamp_support)/2,0])
						cylinder(d = wire_clamp_bolt_dia * 0.9, h=wire_top_wall + box_lid_height);
					translate([(num_cols)*hex_w+box_clearance_x + box_wall_x + box_wire_side_clearance + wire_hole_length/2,-(wire_hole_width + wire_clamp_support)/2,0])
						cylinder(d = wire_clamp_bolt_dia * 0.9, h=wire_top_wall + box_lid_height);
				}
				// Lid supports
				if(box_lip)
					both_lid_supports(box_lid_height + box_lip_height, bms_clearance);
				else
					both_lid_supports(box_lid_height, bms_clearance);
				
				
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
				rect_cap(box_wall,box_clearance,box_bottom_height,box_wire_side_clearance,box_nonwire_side_clearance);
				both_lid_supports(box_bottom_height,box_bottom_clearance);
			}

			// Other cutouts of entire box bottom
			// Lip cutout
			if(box_lip)
			{
				translate([0,0,box_bottom_height-(box_wall+box_clearance)-box_lip_height])
					rect_cap_negative(box_wall,box_clearance + box_wall/2,box_lid_height,box_wire_side_clearance,box_nonwire_side_clearance);
			}
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
	if(pack_style == "rect")
	{
		for(x = get_hex_center_points_rect(num_rows,num_cols))
		 {
			// Iterate through each hex center and place a cell
			translate([x[0],x[1],slot_height + separation])
				color("CornflowerBlue")mock_cell();

		 }
	}
	else if(pack_style == "para")
	{
		for(x = get_hex_center_points_para(num_rows,num_cols))
		 {
			// Iterate through each hex center and place a cell
			translate([x[0],x[1],slot_height + separation])
				color("CornflowerBlue")mock_cell();
		 }
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
                else if (pack_style == "tria") 
                {
                    translate([row*(0.5 * hex_w),1.5*(hex_pt)*row,0])
					for(col = [0:row])
					{
						translate([hex_w*(-col),0,0])
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
			union()
			{
				// Hex block
				hex(holder_height, hex_pt + hextra);
			}
			
					
			// Top opening    
			translate([0,0,-1])
				cylinder(h=holder_height+2,d=opening_dia);
			  
			// Cell space    
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
		cell_tabs();

	}
}


module bus_hex()
{
	mirror([0,0,1])
	{
		difference()
		{
			// Hex block
			hex(holder_height, hex_pt + hextra);
					
			// Top opening    
			translate([0,0,-1])
				cylinder(h=holder_height+2,d=opening_dia);
			  
			// Cell space    
			cylinder(h=2 *(holder_height-slot_height-separation) ,d=cell_dia, center=true);
		
				
			// 1st column slot
			rotate([0,0,60])
				translate([0,0,holder_height])    
					cube([hex_w+1,col_slot_width,2*slot_height], center=true);    
				
			// 2nd column slot    
			rotate([0,0,-60])
				translate([0,0,holder_height])    
					cube([hex_w+1,col_slot_width,2*slot_height], center=true);
					
			// Row slot A
			translate([0,(hex_pt*cos(60) + hex_pt)/2,holder_height]) 
				cube([hex_w + extra,row_slot_width,2*slot_height], center=true);  
			  
			// Row slot B    
			translate([0,-(hex_pt*cos(60) + hex_pt)/2,holder_height]) 
				cube([hex_w + extra,row_slot_width,2*slot_height], center=true);
		}
		cell_tabs();
	}	
}
module cell_tabs()
{
	// Tabs
		if(wire_style == "strip")
		{
			for(a = [1,3,5])
			{
				difference()
				{
					intersection()
					{
						translate([ cell_radius*sin(a*60),cell_radius*cos(a*60),holder_height-(separation/2 + slot_height)])
						rotate([0,0,a*30])cube([cell_tab_length * 2 + wall, cell_tab_width, separation],center=true);
						hex(holder_height, hex_pt + hextra);
					}
					
					// Difference with strip cutouts
					union()
					{
						// 1st column slot
						rotate([0,0,60])
							translate([0,0,holder_height/2])    
								cube([hex_w+1,col_slot_width,holder_height*2], center=true);    
							
						// 2nd column slot
						rotate([0,0,-60])
							translate([0,0,holder_height/2])    
								cube([hex_w+1,col_slot_width,holder_height*2], center=true);
					   
						// Row slot 
						translate([0,0,holder_height/2]) 
							cube([hex_w+1,row_slot_width,holder_height*2], center=true);   
					}
					

				}
			}
		}
		else if(wire_style == "bus")
		{
			for(a = [1,3])
			{

					intersection()
					{
						translate([cell_radius*sin(a*90),cell_radius*cos(a*90),holder_height-(separation/2 + slot_height)])
						rotate([0,0,a*180])cube([cell_tab_length * 2 + wall, cell_tab_width, separation],center=true);
						hex(holder_height, hex_pt + hextra);
					}

			}
		}
}
// Generates support for the box for bolts and zipties. spacer parameter addes a spacer incase there is extra space on the boxes for wires.
module both_lid_supports(lid_support_height = box_lid_height, spacer = 0)
{
	intersection()
	{
		union()
		{
				
			// Generate +y side of supports
			lid_support(lid_support_height,spacer);

			// Generate -y side of supports
			// if even, translate over half a hex
			if(num_rows % 2 == 0)
				translate([get_hex_length(num_cols + 0.5),get_hex_length_pt(num_rows),0])
					rotate([0,0,180])
						lid_support(lid_support_height,spacer);
			else	
				translate([0,get_hex_length_pt(num_rows),0])
					mirror([0,1,0])
							lid_support(lid_support_height,spacer);

		}
		// Remove all pieces outside of the box
		rect_cap_positive(box_wall/2,box_clearance,lid_support_height + extra,box_wire_side_clearance,box_nonwire_side_clearance);
	}
	


	
}

// Generates the support to hold the holders in the box lid and bottom.
// spacer sets height for bms clearance
// mirrored is used for the -y lid_support which will have different sizes due to different side clearances
module lid_support(lid_support_height = box_lid_height,spacer = 0)
{
	for(col = [1:num_cols])
	{
		// iterate on one side
		// add support in the shape of a hex inbetween cols
		difference()
		{
			union()
			{
				translate([get_hex_length(col+0.5),-get_hex_length_pt(2)-box_clearance,-(box_wall + box_clearance)])
				hex(lid_support_height);
				if(spacer)
				{
					translate([get_hex_length(col)+hex_w/2,-row_slot_width/2 -hex_pt/2,spacer/2])
						cube([hex_w/2,hex_pt,spacer],center = true);
				}
				
			}
			// Cutouts
			translate([get_hex_length(col+0.5),-hex_pt*2 - (box_wall + box_clearance) + box_wall/2,-box_wall - lid_support_height/2 -extra])
			{
				cube([hex_pt*2 + extra,hex_pt*2,lid_support_height*5],center = true);
			}
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

			// Don't generate ziptie holes for both style when 2 columns or less
			if(num_cols > 2)
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

// Part which clamps down the wires for strain relief
// Z origin is top of the mounting plate
module wire_clamp()
{
	translate([0,0,-clamp_plate_height/2])
	{
		difference()
		{
			union()
			{
				clamp_height = box_lid_height - wire_top_wall - box_clearance - wire_diameter * clamp_factor;
				cube([wire_hole_length,wire_hole_width + 2 * wire_clamp_support,clamp_plate_height],center = true);
				// To top of plate
				translate([0,0,wire_top_wall/2])
				{
					translate([0,0,(clamp_height - wire_clamp_nib_dia/2)/2]) 
						cube([wire_hole_length,wire_hole_width - extra, clamp_height - wire_clamp_nib_dia/2], true);
					translate([0,(wire_hole_width - extra)/2,(clamp_height) - wire_clamp_nib_dia/2])
						rotate([90,0,0])
							cylinder(d = wire_clamp_nib_dia, h = wire_hole_width - extra);
				}
				
			}
			// Bolt hole cutout
			translate([0,(wire_hole_width + wire_clamp_support)/2,-wire_top_wall])
				cylinder(d = wire_clamp_bolt_dia + bolt_dia_clearance, h = wire_top_wall * 2);
			translate([0,-(wire_hole_width + wire_clamp_support)/2,-wire_top_wall])
				cylinder(d = wire_clamp_bolt_dia + bolt_dia_clearance, h = wire_top_wall * 2);
		}
		
		
	}

}

// Generates a hex of cap_height tall and hex_pt radius by default.
module hex(cap_height = holder_height,hex_pt = hex_pt)
{
		linear_extrude(height=cap_height, convexity = 10)
			polygon([ for (a=[0:5])[hex_pt*sin(a*60),hex_pt*cos(a*60)]]);	

}

// returns total box width
function get_box_total_width()
= 2 * (box_clearance + box_wall) + get_holder_width();

// returns holder width
function get_holder_width()
= get_hex_length_pt(num_rows) + hex_pt * 2;



// returns length of the longest part of box (from side of lid to wireclamp) 
// Reminder: Rect box only.
function get_box_total_length()
= 2 * (box_clearance + box_wall) + get_holder_rect_length() + box_wire_side_clearance + box_nonwire_side_clearance + wire_hole_length;

// returns length of rect holders
function get_holder_rect_length()
= hex_w*(num_cols+0.5);

 

// returns height of the mock pack
function get_mock_pack_height() 
= 2 * (slot_height + separation) + cell_height;
// returns the length of the center of one hex cell on a row to number to hexes passed to function
function get_hex_length(num_cell)
= (num_cell-1) * hex_w;

// returns the length of the center of vertical(columns) hex cells to number to hexes passed to function
function get_hex_length_pt(num_cell)
= (num_cell-1) * hex_pt*1.5;

// returns a list of the hex cell centers of a given num of rows and columns for para packs.
function get_hex_center_points_para(num_rows, num_cols)
=  [
		// Iterate through num of rows and cols
		for(row = [0:num_rows-1],col = [0:num_cols-1]) 
		[	// X component of list member
			row*(0.5 * hex_w) + hex_w * col
			,	
			// Y component of list member
			row * 1.5 * (hex_pt)
		]
	];	// Closing function bracket

// returns a list of the hex cell centers of a given num of rows and columns for rect packs.
function get_hex_center_points_rect(num_rows, num_cols)
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
