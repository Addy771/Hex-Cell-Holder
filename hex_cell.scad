// https://github.com/Addy771/Hex-Cell-Holder
// This script generates models of cell holders and caps for
// building battery packs using cylindrical cells.
// Original concept by ES user "SpinningMagnets"
// More info can be found here:
// https://endless-sphere.com/forums/viewtopic.php?f=3&t=90058
//
// This file was created by Addy and is released as public domain
// Contributors
// Albert Phan - Added boxes, stacking, and optimizations


///////////////////////////////////////////////////////////////////////////////////////////////////////////
// BASIC CONFIGURATION
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


cell_dia = 18.4;    // Cell diameter default = 18.4 for 18650s **PRINT OUT TEST FIT PIECE STL FIRST**
cell_height = 65;	// Cell height default = 65 for 18650s
wall = 1.2;       // Wall thickness around a single cell. Make as a multiple of the nozzle diameter. Spacing between cells is twice this amount. default = 1.2
					// If using bought injection molded hexes and printing out the boxes, take the distance between the centers of 2 cells and divide by two for the wall thickness (((((pitch - diameter)/2). Add space for the protuding interlocking tabs in the cap or box clearances.

num_rows = 4;
num_cols = 8;

holder_height = 10; // Height of cell holder default = 10 (not including slot_height)
slot_height = 3;  // Height of all slots default = 3 mm (set to 0 for no slots but that allows you to print without support)

col_slot_width = 8; // Width of slots between rows default = 8
row_slot_width = 8; // Width of slots along rows default = 8


pack_style = "rect";	// "rect" for rectangular pack, "para" for parallelogram, "tria" for triangle shaped pack (number of rows define the amount of rows at the bottom of the triangle. Columns get ignored)

wire_style = "strip";	// "strip" to make space to run nickel strips between cells. Default usage
						// "bus" to make space for bus wires between rows

box_style = "both";		// "bolt" for bolting the box pack together
						// "ziptie" for using zipties to fasten the box together. (ziptie heads will stick out),
						// "both" default: uses bolts for the 4 corners and zipties inbetween. Useful for mounting the pack to something with zipties but while still using bolts to hold it together 

part_type = "normal";   // "normal","mirrored", or "both". "assembled" is used for debugging.  You'll want a mirrored piece if the tops and bottom are different ( ie. When there are even rows in rectangular style or any number of rows in parallelogram. The Console will tell you if you need a mirrored piece).

part = "holder";   		// "holder" to generate cell holders,
						// "cap" to generate pack end caps,
						// "box lid" to generate box lid
						// "box bottom" for box bottom
						// "wire clamp" for strain relief clamp
						// "insulator" for insulator piece to fit over the nickel strips
						// "vertical box section" for vertical battery stacking boxes (print 1 section for every additional stacked pack) 

box_lip = true;			// Adds a lip to the box pieces. default = true.
wire_clamp_add = true; 	// Adds a wire exit hole out the side of the box lid.
insulator_as_support = true;	// Print the insulator as a part of the holder support material.

cap_wall = 1.2;				// Cap wall thickness (default = 1.2 recommend to make a multiple of nozzle dia)
cap_clearance = 0.2;		// Clearance between holder and caps default = 0.2

box_wall = 2;				// Box wall thickness (default = 2.0 recommend to make at least 4 * multiple of nozzle dia)
box_clearance = 0.2;		// Clearance between holder and box default = 0.2


// Box clearances for wires
bms_clearance = 10; 			// Vertical space for the battery management system (bms) on top of holders, set to 0 for no extra space
box_bottom_clearance = 0;	// Vertical space for wires on bottom of box
box_wire_side_clearance = 3; // Horizontal space from right side (side with wire hole opening) to the box wall for wires
box_nonwire_side_clearance = 0; // Horizontal space from left side (opposite of wire hole) to the box wall for wires

support_z_gap = 0.3;		// Insulator gap to holder. default 0.3
insulator_tolerance = 1.5;	// How much smaller to make the width of the insulator default 1.5
insulator_thickness = (slot_height-support_z_gap);	// Thickness of insulator

wire_diameter = 5;			// Diameter of 1 power wire used in the strain relief clamps default = 5 for 10 awg stranded silicon wire
wire_clamp_bolt_dia = 3;	// Bolt dia used for clamping wire default = 3 for M3 bolt
clamp_factor = 0.7;			// Factor of wire diameter to be clamped. Higher number is less clamping force (default=0.7 max=1.0)
bolt_dia = 3;				// Actual dia of bolt default = 3 for M3 bolt
bolt_head_dia = 6;			// Actual dia of bolt head default = 6 for M3 socket head bolt
bolt_head_thickness = 3;	// Thickness (height) of bolt head default = 3 for M3 Socket head
ziptie_width = 8;
ziptie_thickness = 2.5;

////////////////////////////////////////////////////////////////////////////////////
// EXPERIMENTAL Vertical Holder Stacking
// Use at own risk - Stacking holders vertically requires more thought into electrical short prevention.
// For best use, col and row slots sizes should be the same so the pin is centered
// Rectangular packs only
// Using stacking pins or bolts require you to cut holes out for the kapton tape/fishpaper for the insulation.
// If you don't use stacking pins or bolts, you can print out insulators (use part = insulator) and add kapton/fishpaper without cutting holes in it on top.
// The fishpaper is a last line of protection to prevent shorts in case the plastic insulation melts due to a malfunction.
///////////////////////////////////////////////////////////////////////////////////

stacking_pins = false;	// Adds pins and holes for stacking holders vertically. Make sure col and row slots are the same width. You'll have to think about how to insulate the strips properly. Maybe precut kapton/fishpaper? 
stacking_pin_dia = 3;	// Default 3 mm. Smaller than 3 not recommended.
stacking_pin_alt_style = false; // Alternate style of pins that are longer and go into the holder deeper. (Used when the triangle islands are too small for a hole)
stacking_bolts = false;	// Adds holes through the holders to bolt them (if not using box to bolt them together). 
						// !!!!!!MAKE SURE BOLTS DO NOT SHORT NICKEL STRIPS!!!!
						// Don't use with stacking pins. You'll need mirrored pieces.
stacking_bolt_dia = 4.5;	// Bolt dia. Make slightly bigger for bolt fit. Watch out for too large bolts that cut too much out of the holder.
num_pack_stacks = 1;	// How many additional packs you will stack vertically. Affects part = vertical box section. (set to 1 if you just want to print single sections and glue them together. 1 section for every additional pack stack)



///////////////////////////////////////////////////////////////////////////////////
// ADVANCED CONFIGURATION for users that need to customize everything
//////////////////////////////////////////////////////////////////////////////////

cell_top_overlap = 3; // How big the opening overlaps the cell default = 3
opening_dia = cell_dia-cell_top_overlap*2;   		// Circular opening to expose cell
separation = 1;   			// Separation between cell top and wire slots (aka tab thickness) default = 1
wire_hole_width = 15;		// Width of wire hole default = 15
wire_hole_length = 10;		// Length of the wireclamp that sticks out default = 10
wire_top_wall = 4;			// Thickness of top wire wall default = 4mm
clamp_plate_height = 4;		// default = 4
bolt_dia_clearance = 1;		// Amount of extra diameter for bolt holes default = 1
box_lip_height = box_wall * 0.75;	// Height of lip default = box_wall * 0.75
box_lip_width = box_wall * 0.5;		// Width of lip default = box_wall * 0.5
stacking_pins_tolerance = 0.5;	// How much larger for the stacking pin hole compared to it's pin diameter
spacer_overhang = box_clearance + 3; 		// Amount of spacer overhang to hold the holders default = 3

flip_holders = false;	// Mostly used for taking pngs



// cell_tab_width = 5;			// Width of tab that keeps the cell in the holder default = 5
// cell_tab_length = 3;		// Approx Length of tab that keeps the cell in the holder default = 3

//////////////////////////////////////////////////////
// Don't forget to do a test fit print
//////////////////////////////////////////////////////

// END OF CONFIGURATION
////////////////////////////////////////////////////////////////////////

// TODO:
// [x] Vertical Stacking Pins
// [x] Vertical Stacking Bolts
// [x] Add insulators
//	[x] rect support
//	[x] other styles support
// [x] Fixed boxes spacers
// [x] Add vertical stacking boxes
// [x] Add insulator to bat file
// [] Add some more echo helper messages for mirrored pieces wrt to stacking pins/bolt
// [x] Add insulation to "both" part types
// [x] Don't do mirrored versions for Both parts unless needed. 
// [x] Double check box_lip_height usage versus box_wall/2 in some cases with the lid and bottom lips


///////////////////////////////////////////////////////////////////////////
// NON-Configurable helper variables
///////////////////////////////////////////////////////////////////////////
$fn = 50;       // Number of facets for circular parts.
hextra = 0.0001; // enlarge hexes by this to make them overlap
extra = 1;    	// for proper differences()
spacing = 4;    // Spacing between top and bottom pieces
box_total_height = get_mock_pack_height() + 2 * (box_wall + box_clearance) + bms_clearance + box_bottom_clearance;
box_lid_height = (holder_height + slot_height)/2 + (box_clearance + box_wall) + bms_clearance;	// box lid to middle of holder
box_bottom_height = box_total_height - box_lid_height;
vertical_box_section_height = get_mock_pack_height();
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
			mirror([0,1,0])
				cap(cap_wall,cap_clearance);
		}
		else if (part == "holder")
		{
			mirror([0,1,0])
				rotate([0,180,0])
					holders();
		}
	}
	else if(part_type == "both")
	{
		if (part == "cap")
		{
			cap(cap_wall,cap_clearance);
			mirror([0,1,0])
				translate([0,2*hex_pt + 2 * (cap_wall + cap_clearance) + spacing,0])
					cap(cap_wall,cap_clearance);
		}
		else if (part == "holder")
		{
			
			//rotate([0, 180, 0]) //flips around all the holders
			{
				// First holder
				holders();
				// Second holder
				if(pack_style == "para")
				{
					mirror([0,1,0])
						translate([hex_w*0.5,1.5*hex_pt + spacing,0])
							holders();
				}
				else if(pack_style == "rect")
				{
					if(num_rows % 2 == 1)   // If odd pack move pack over to nest properly
					{
						if(stacking_bolts)
						{
							mirror([1,0,0])	// mirrored for bolt stacking holes
								rotate([0,0,180])
									translate([-(hex_w*0.5), (1.5*(hex_pt) + spacing),0])
									holders();
									
						}
						else	// not mirrored for anything but bolt stacking holes
						{
								translate([-(hex_w*0.5), -(1.5*(hex_pt) * num_rows+ spacing),0])
									holders();
						}
					}
					else	// if even pack
					{
						mirror([0,1,0])	// mirrored for bolt stacking holes
							translate([hex_w*0.5,1.5*hex_pt + spacing,0])
								holders();
					}
				}
			}
		}
		else if (part == "box lid" || part == "box bottom")
		{
			box_bottom();
			translate([0,-(hex_pt * 2 + 2 * (box_wall + box_clearance) + spacing), 0])
			mirror([0,0,1])
				rotate([180,0,0])
					box_lid();
		}
		
	}
	else if(part_type == "assembled")
	{
		// TESTING difference section analysis
		difference()
		{
			union()
			{
				mock_pack();	// for debugging for now


				if(part == "vertical box section")
				{
					// iterate through packs
					for(i = [1:num_pack_stacks])
					{
						translate([0,0,get_mock_pack_height()*i])
						{
							mock_pack();
							// vertical section box
							color("darkgreen", alpha =0.8)
								translate([0,0,box_bottom_height -(box_clearance+box_wall)-get_mock_pack_height()])
									vertical_box_section();

							if(i == num_pack_stacks)
							{
								// lid
								translate([0,0,box_bottom_height + box_lid_height - 2 * (box_wall + box_clearance) - box_bottom_clearance])
									mirror([0,0,1])
									{
										color("green", alpha = 0.7)
										box_lid();
										if(wire_clamp_add)
										{
											color("orange", alpha = 0.7)
												translate([(get_hex_center_x_length(num_cols + 1) + box_wire_side_clearance + box_wall + box_clearance + wire_hole_length/2),0,box_lid_height-box_wall-box_clearance])
													mirror([0,0,1])
														wire_clamp();
										}
										
									}
							}
						}
							
					}
					
				}
				else
				{
					//normal non stacking assembly
					// lid
					translate([0,0,box_bottom_height-(box_wall +box_clearance)*2+box_lid_height])
						mirror([0,0,1])
						{
							color("green", alpha = 0.7)
							box_lid();
							if(wire_clamp_add)
							{
								color("orange", alpha = 0.7)
									translate([(get_hex_center_x_length(num_cols + 1) + box_wire_side_clearance + box_wall + box_clearance + wire_hole_length/2),0,box_lid_height-box_wall-box_clearance])
										mirror([0,0,1])
											wire_clamp();
							}
							
						}
				}
				// bottom
				color("lightgreen", alpha = 0.7)
					translate([0,0,0])
						box_bottom();
			}

			// // sectional analysis testing cutout
			// translate([0,50,50])
			// 	cube([150,100,2000], center = true);
		}

		// Additional assembled packs
		// translate([(get_hex_center_x_length(num_rows+2)+ 2*(box_wall + box_clearance) + box_nonwire_side_clearance + box_wire_side_clearance)*2,get_hex_center_y_length(num_cols+2) + 2*(box_wall + box_clearance),0])
		// {
		// 	mock_pack();	// for debugging for now  - 2 * (box_wall + box_clearance) - bms_clearance
		// 	translate([0,0,get_mock_pack_height() + bms_clearance])
		// 		mirror([0,0,1])
		// 		{
		// 			color("green", alpha = 0.7)
		// 			box_lid();
		// 			if(wire_clamp_add)
		// 			{
		// 				color("orange", alpha = 0.7)
		// 					translate([(get_hex_center_x_length(num_cols + 1) + box_wire_side_clearance + box_wall + box_clearance + wire_hole_length/2),0,box_lid_height-box_wall-box_clearance])
		// 						mirror([0,0,1])
		// 							wire_clamp();
		// 			}
					
		// 		}


		// }

		// translate([(get_hex_center_x_length(num_rows+2)+ 2*(box_wall + box_clearance) + box_nonwire_side_clearance + box_wire_side_clearance)*4,(get_hex_center_y_length(num_cols+2) + 2*(box_wall + box_clearance)) * 3,0])
		// 	{
		// 		mock_pack();	// for debugging for now
		// 		color("lightgreen", alpha = 0.7)
		// 			translate([0,0,-(box_bottom_clearance)])
		// 				box_bottom();

		// 	}



	}
	else if(part_type == "mock pack")
	{
		mock_pack();
	}
	else	// if Normal
	{
		if (part == "cap")
		{
			cap(cap_wall,cap_clearance);
		}
		else if (part == "holder")
			rotate([0,0,0])
			{
				holders();
			}
				
			
		else if (part == "box lid")
		{
			translate([0,get_hex_center_y_length(num_cols),0])
			mirror([0,0,1])	
				rotate([180,0,0])
					box_lid();
		}
		else if (part == "box bottom")
		{
			box_bottom();
		}
		else if (part == "wire clamp")
			wire_clamp();
		else if(part == "insulator")
		{
			holder_insulators();
		}
		else if(part == "vertical box section")
		{
			vertical_box_section(num_pack_stacks);
		}
		else if(part == "flipped holder png")
		{
			rotate([0,180,0])
				holders();
		}
		else if(part == "testing")
		{
		translate([0,0,0])
		{
			box_lid();
		}
		// Testing
		translate([0,-get_hex_center_y_length(num_rows+2) - (box_wall + box_clearance)*2,0])
			box_bottom();
		translate([0,-get_hex_center_y_length(num_rows+2)*2 - (box_wall + box_clearance)*4,0])
			vertical_box_section();
		}
	}





/////////////////////////////////////////////////////////////////////////////////////////////////////////
// echos and info
echo(hex_cell_center_to_center_distance = get_hex_center_x_length(2));
echo(pack_height_holder = get_mock_pack_height());
echo(box_lid_height = box_lid_height);
echo(box_bottom_height = box_bottom_height);
echo(box_total_height = box_total_height);
echo(box_total_length = get_box_total_length());
echo(box_total_width = get_box_total_width());
echo(vertical_box_section_height = vertical_box_section_height * (num_pack_stacks) + box_lip_height);
echo(box_total_height_with_vertical_stacking = box_bottom_height + box_lid_height + vertical_box_section_height * num_pack_stacks - box_lip_height);

echo(total_width_holder = get_hex_center_y_length(num_rows)+hex_pt*2);
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
    echo(total_length_holder=hex_w*(num_rows-1));
	echo("\n******************************************************* \n Top and bottom are not different. But don't forget to print twice ;)\n*******************************************************");
}

if (part_type == "mirrored" && (part == "box lid" || part == "box bottom"))
	echo("\n******************************************************* \n Please choose Normal for box lid or box bottom as there aren't mirrored versions of them.\n*******************************************************");

if (pack_style == "tria" && (part == "box lid" || part == "box bottom" || part == "cap"))
	echo("\n******************************************************* \n There are currently no boxes and caps for triangle style\n*******************************************************");



//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module cap(cap_wall,cap_clearance,cap_height = holder_height+slot_height,positive_x = 0, negative_x = 0, positive_y = 0, negative_y = 0)
{
	difference()
	{
	// Positive Hull
	cap_positive(cap_wall,cap_clearance,cap_height,positive_x,negative_x,positive_y,negative_y);
	// Negative Hull
	cap_negative(cap_wall,cap_clearance,cap_height,positive_x,negative_x,positive_y,negative_y);
	}
}

// Generates the rectangular cap positive piece used in caps and boxes. Default height is holder height
// height includes wall thickness and clearance
// Z Origin is -(cap_wall + cap_clearance)
// Positive_x = amount of clearance between the positive x box wall and the holder.
// Negative_x = amount of clearance between the negative x box wall and the holder.
// Same goes for y
module cap_positive(cap_wall,cap_clearance,cap_height = holder_height,positive_x = 0, negative_x = 0, positive_y = 0, negative_y = 0)
{
	if(pack_style=="rect")
	{
		translate([0,0,-(cap_wall + cap_clearance)])
		hull()
		{
			// Generate 4 hexes in each corner and hull them together
			// [0,0] Bottom left
			translate([-negative_x,-negative_y,0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
			// [1,0] Bottom right
			translate([get_hex_center_x_length(num_cols + 0.5)+ positive_x,-(negative_y),0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
			// [0,1] Top left
			translate([-(negative_x),get_hex_center_y_length(num_rows) + positive_y,0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
			//  [1,1] Top right
			translate([get_hex_center_x_length(num_cols + 0.5) + positive_x,get_hex_center_y_length(num_rows) + positive_y,0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
		}
	}
	else if(pack_style=="para")
	{
		translate([0,0,-(cap_wall + cap_clearance)])
		hull()
		{
			// Generate 4 hexes in each corner and hull them together
			// [0,0] Bottom left
			translate([-negative_x,-negative_y,0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
			// [1,0] Bottom right
			translate([get_hex_center_x_length(num_cols)+ positive_x,-(negative_y),0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
			// [0,1] Top left
			translate([get_hex_center_x_length(num_rows/2 +0.5)-(negative_x),get_hex_center_y_length(num_rows) + positive_y,0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
			//  [1,1] Top right
			translate([get_hex_center_x_length(num_cols + num_rows/2-0.5) + positive_x,get_hex_center_y_length(num_rows) + positive_y,0])
				hex(cap_height,hex_pt + cap_wall + cap_clearance);
		}
	}
}


// Generates the cap negative piece (as a positive to be cut out using difference) used in cap and box. This is basically the same as cap_positive but the hexes are smaller by cap_wall and
// z origin = -cap_clearance
module cap_negative(cap_wall,cap_clearance,cap_height = holder_height,positive_x = 0, negative_x = 0, positive_y = 0, negative_y = 0)
{
	translate([0,0,-cap_clearance])
	{
		if(pack_style=="rect")
		{
			hull()
			{
				// Generate 4 hexes in each corner and hull them together
				// [0,0] Bottom left
				translate([-negative_x,-negative_y,0])
					hex(cap_height,hex_pt + cap_clearance);
				// [1,0] Bottom right
				translate([get_hex_center_x_length(num_cols + 0.5)+ positive_x,-(negative_y),0])
					hex(cap_height,hex_pt + cap_clearance);
				// [0,1] Top left
				translate([-(negative_x),get_hex_center_y_length(num_rows) + positive_y,0])
					hex(cap_height,hex_pt  + cap_clearance);
				//  [1,1] Top right
				translate([get_hex_center_x_length(num_cols + 0.5) + positive_x,get_hex_center_y_length(num_rows) + positive_y,0])
					hex(cap_height,hex_pt + cap_clearance);
			}
		}
		else if(pack_style=="para")
		{
			hull()
			{
				// Generate 4 hexes in each corner and hull them together
				// [0,0] Bottom left
				translate([-negative_x,-negative_y,0])
					hex(cap_height,hex_pt + cap_clearance);
				// [1,0] Bottom right
				translate([get_hex_center_x_length(num_cols)+ positive_x,-(negative_y),0])
					hex(cap_height,hex_pt + cap_clearance);
				// [0,1] Top left
				translate([get_hex_center_x_length(num_rows/2 +0.5)-(negative_x),get_hex_center_y_length(num_rows) + positive_y,0])
					hex(cap_height,hex_pt  + cap_clearance);
				//  [1,1] Top right
				translate([get_hex_center_x_length(num_cols + num_rows/2-0.5) + positive_x,get_hex_center_y_length(num_rows) + positive_y,0])
					hex(cap_height,hex_pt + cap_clearance);
			}
		}
	}
}

module box_lid()
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
					cap_positive(box_wall,box_clearance,box_lid_height,box_wire_side_clearance, box_nonwire_side_clearance);
					// Lip Positive ( lip is added to box_lid and subtracted from box_bottom)
					if(box_lip)
					{
						translate([0,0,box_lid_height-box_lip_width])
							cap_positive(box_lip_width,box_clearance,box_lip_height,box_wire_side_clearance,box_nonwire_side_clearance);
					}
					// Wire support hole
					if(wire_clamp_add)
					{
						translate([(num_cols * hex_w + box_wire_side_clearance + box_clearance_x + box_wall_x) - (box_wall_x + box_clearance_x + num_cols/2 * hex_w/2 + extra),-(wire_hole_width + 2 * (wire_clamp_support)) /2,-(box_wall + box_clearance)])
						cube([wire_hole_length + box_wall_x + box_clearance_x + num_cols/2 * hex_w/2 + extra,wire_hole_width + 2 * (wire_clamp_support),box_lid_height]);
					}
					
				}
				// Negatives
				cap_negative(box_wall,box_clearance,box_lid_height*2,box_wire_side_clearance,box_nonwire_side_clearance);
				if(wire_clamp_add)
				{
					// Wire hole cutout
					translate([(num_cols)*hex_w+box_clearance_x + box_wall_x +box_wire_side_clearance,0,wire_top_wall - box_wall + box_lid_height/2])
					cube([(wire_hole_length + box_wall_x + box_clearance_x + num_cols/2 * hex_w/2) * 2 + box_wall *3,wire_hole_width,box_lid_height], center = true);
					// Strain relief bolt cutouts
					translate([(num_cols)*hex_w+box_clearance_x + box_wall_x + box_wire_side_clearance + wire_hole_length/2,(wire_hole_width + wire_clamp_support)/2,0])
						cylinder(d = wire_clamp_bolt_dia * 0.9, h=wire_top_wall + box_lid_height);
					translate([(num_cols)*hex_w+box_clearance_x + box_wall_x + box_wire_side_clearance + wire_hole_length/2,-(wire_hole_width + wire_clamp_support)/2,0])
						cylinder(d = wire_clamp_bolt_dia * 0.9, h=wire_top_wall + box_lid_height);
				}
				
				
			}
			// Lid supports
			if(box_lip)
				both_box_holder_supports(box_lid_height + box_lip_height, bms_clearance);
			else
				both_box_holder_supports(box_lid_height, bms_clearance);
		}
		// Other cutouts of entire box lid
		generate_box_lid_holes(lid = true);
	}
}

module box_bottom()
{
	difference()
	{
		union()
		{
			cap(box_wall,box_clearance,box_bottom_height,box_wire_side_clearance,box_nonwire_side_clearance);
			both_box_holder_supports(box_bottom_height,box_bottom_clearance);
		}

		// Other cutouts of entire box bottom
		// Lip cutout
		if(box_lip)
		{
			translate([0,0,box_bottom_height-box_lip_width-box_lip_height])
			{
				cap_negative(box_wall,box_clearance + box_lip_width,box_lid_height,box_wire_side_clearance,box_nonwire_side_clearance);	// z origin -(box_clearance + box_lip_width)
			}
				
		}
		generate_box_lid_holes();
	}
}

// Creates a mock pack for debugging
// Origin is the bottom of the center of the first hex cell
module mock_pack()
{

	color("blue") holders();
	// add 18650s
	if(pack_style == "rect")
	{
		for(hex_list = get_hex_center_points_rect(num_rows,num_cols))
		 {
			// Iterate through each hex center and place a cell
			translate([hex_list.x,hex_list.y,slot_height + separation])
				color("CornflowerBlue")mock_cell();

		 }
	}
	else if(pack_style == "para")
	{
		for(hex_list = get_hex_center_points_para(num_rows,num_cols))
		 {
			// Iterate through each hex center and place a cell
			translate([hex_list.x,hex_list.y,slot_height + separation])
				color("CornflowerBlue")mock_cell();
		 }
	}

	color("blue")
		translate([0,0,slot_height + separation + cell_height + slot_height + separation])
			mirror([0,0,1])
				holders();
}

// Creates a mock cell. Origin is bottom of 1st hex cell holder.
module mock_cell()
{
	cylinder(d = cell_dia, h = cell_height);
}

// Generates the holders
module holders()
{
	if(insulator_as_support)
	{
		translate([0,0,-holder_height+slot_height])
			holder_insulators();
	}

	translate([0, 0, holder_height])
	{
		difference()
		{
			union()
			{
				if(pack_style == "rect")
				{
					for(hex_list = get_hex_center_points_rect(num_rows,num_cols))
					{
					// Iterate through each hex center and place a hex cell
					translate([hex_list.x,hex_list.y,0])
						pick_hex();
					}
				}
				else if(pack_style == "para")
				{
					for(hex_list = get_hex_center_points_para(num_rows,num_cols))
					{
					// Iterate through each hex center and place a hex cell
					translate([hex_list.x,hex_list.y,0])
						pick_hex();
					}
				}
				else if(pack_style == "tria")
				{
					for(hex_list = get_hex_center_points_tria(num_rows,num_cols))
					{
					// Iterate through each hex center and place a hex cell
					translate([hex_list.x,hex_list.y,0])
						pick_hex();
					}
				}
				// Other unions
				// Stacking Pins here
				if(stacking_pins)
				{
					for(hex_list = get_pin_list_rect(num_rows,num_cols))
					{
						// add pins
						if(stacking_pin_alt_style)
						{
							translate([hex_list.x,hex_list.y,-(holder_height + slot_height)])
							{
								
								// increase triangle island height by one slot height
								linear_extrude(height = slot_height)
								{
									polygon(points=[
										// generate points
										for(a = [30,150,270])[(hex_pt-(0.5*col_slot_width)/cos(60))*cos(a),(hex_pt-(0.5*col_slot_width)/cos(60))*sin(a)],
										
									]);
								}
								// add pin
								translate([0,0,-slot_height*0.5])
									cylinder(d = stacking_pin_dia, h = slot_height);
							}
						}
						else
						{
						translate([hex_list.x,hex_list.y,-(holder_height + slot_height*0.5)])
							cylinder(d = stacking_pin_dia, h = slot_height);
						}
					}
				}
			}
			// Cutouts
			
			// Stacking Pins
			if(stacking_pins)
			{
				// do pin holes
				for(hex_list = get_pin_holes_list_rect(num_rows,num_cols))
				{
					if(stacking_pin_alt_style)
					{	
						// delete triangle
						translate([hex_list.x,hex_list.y,-(holder_height + extra)])
						linear_extrude(height = slot_height + extra)
						{
							polygon(points=[
								// generate points
								for(a = [90,210,330])[hex_pt*cos(a),hex_pt*sin(a)]
							]);
						}

					}
					// add hole
					translate([hex_list.x,hex_list.y,-holder_height-extra])
						cylinder(d = stacking_pin_dia + stacking_pins_tolerance, h = slot_height *2 + extra);

				}
			}

			// Stacking Bolts
			if(stacking_bolts)
			{
				for(hex_list = get_pin_holes_list_rect(num_rows,num_cols))
				{
					// delete triangle
					translate([hex_list.x,hex_list.y,-(holder_height + extra)])
					linear_extrude(height = slot_height + extra)
					{
						polygon(points=[
							// generate points
							for(a = [90,210,330])[hex_pt*cos(a),hex_pt*sin(a)]
						]);
					}
					// add hole
					translate([hex_list.x,hex_list.y,-(holder_height + extra)])
						cylinder(d = stacking_bolt_dia, h = holder_height*2);
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
				translate([0,0,holder_height + slot_height])
					cube([hex_w+1,col_slot_width,4*slot_height], center=true);

			// 2nd column slot
			rotate([0,0,-60])
				translate([0,0,holder_height + slot_height])
					cube([hex_w+1,col_slot_width,4*slot_height], center=true);

			// Row slot
			translate([0,0,holder_height + slot_height])
				cube([hex_w+1,row_slot_width,4*slot_height], center=true);

		}
		//cell_tabs();	// older style of cell tabs. Not used anymore
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
		//cell_tabs(); // older style of cell tabs. Not used anymore
	}
}

// 3 tabs in the holder that keep the cell in. Not used anymore.
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

// Generates a insulator to fit inside the nickel strip channels, also doubles as a spacer
// TODO: support para too
// Add cut outs for stacking bolts

module holder_insulators()
{
	// TESTING
	// mirror([0,0,1])
	// translate([0,0,-holder_height])
	// holders();

	// Use difference code from hex cells
	// intersection it with hexes
	if(pack_style == "rect")
	{
		single_insulator(get_hex_center_points_rect(num_rows,num_cols));
	}
	else if(pack_style == "para")
	{
		single_insulator(get_hex_center_points_para(num_rows,num_cols));
	}
	else if(pack_style == "tria")
	{
		single_insulator(get_hex_center_points_tria(num_rows,num_cols));
	}

	

}

module single_insulator(hex_list)
{
	difference()
	{
		// sorry
		for(hex_list = hex_list)
		{
		// Iterate through each hex center and place a hex cell
		translate([hex_list.x,hex_list.y,0])
			{	
				intersection()
				{
					union()
					{
						// Hex block
						hex(holder_height-slot_height + insulator_thickness, hex_pt + hextra);
					}

					union()
					{
						if(wire_style == "strip")
						{
							// 1st column slot
							rotate([0,0,60])
								translate([0,0,holder_height + slot_height])
									cube([hex_w+1,col_slot_width-insulator_tolerance,4*slot_height], center=true);

							// 2nd column slot
							rotate([0,0,-60])
								translate([0,0,holder_height + slot_height])
									cube([hex_w+1,col_slot_width-insulator_tolerance,4*slot_height], center=true);

							// Row slot
							translate([0,0,holder_height + slot_height])
								cube([hex_w+1,row_slot_width-insulator_tolerance,4*slot_height], center=true);
						}
						else if(wire_style == "bus")
						{
							// 1st column slot
							rotate([0,0,60])
								translate([0,0,holder_height])
									cube([hex_w+1,col_slot_width-insulator_tolerance,2*slot_height], center=true);

							// 2nd column slot
							rotate([0,0,-60])
								translate([0,0,holder_height])
									cube([hex_w+1,col_slot_width-insulator_tolerance,2*slot_height], center=true);

							// Row slot A
							translate([0,(hex_pt*cos(60) + hex_pt)/2,holder_height])
								cube([hex_w + extra,row_slot_width-insulator_tolerance,2*slot_height], center=true);

							// Row slot B
							translate([0,-(hex_pt*cos(60) + hex_pt)/2,holder_height])
								cube([hex_w + extra,row_slot_width-insulator_tolerance,2*slot_height], center=true);

							// Cell opening
							translate([0,0,holder_height-slot_height])
								cylinder(h=slot_height,d=opening_dia-insulator_tolerance);
						}
						
					}
					

				}
			}	
		}

		// cut out stacking bolt holes
		if(stacking_bolts)
		{
			for(bolt_holes_list = concat(get_pin_holes_list_rect(num_rows,num_cols), get_pin_list_rect(num_rows,num_cols)))
			{
				// add hole
				translate([bolt_holes_list.x,bolt_holes_list.y,0])
					cylinder(d = stacking_bolt_dia, h = holder_height*2);
			}
		}
	}
}


// Generates a box section designed for one addition vertical pack stack. Can make sections larger if printer is able to print higher
module vertical_box_section(num_stacks = 1)
{
	// Create a box section with lips (if enabled) on both sides
	difference()
	{
		union()
		{
			
			// main box 
			difference()
			{
				union()
				{
					translate([0,0,0])
						cap_positive(box_wall,box_clearance,vertical_box_section_height*num_stacks,box_wire_side_clearance,box_nonwire_side_clearance);
					// lip addition on bottom
					if(box_lip)
					{
						translate([0,0,-(box_lip_width + box_lip_height)])
							cap_positive(box_lip_width,box_clearance,box_lip_height,box_wire_side_clearance,box_nonwire_side_clearance);
					}
				}
				

				// hollow out
				translate([0,0,-vertical_box_section_height*num_stacks])
					cap_negative(box_wall,box_clearance,vertical_box_section_height*num_stacks*100,box_wire_side_clearance,box_nonwire_side_clearance);
			}

			if(box_lip)
			{
				translate([0,0,-box_lip_height])
					both_box_holder_supports(vertical_box_section_height*num_stacks,0);
			}
			else
			{
				translate([0,0,0])
					both_box_holder_supports(vertical_box_section_height*num_stacks,0);
			}
			
			
			
			
			//%cylinder(d=50,h = vertical_box_section_height*num_stacks); // helper cylinder
		}

		// Other cutouts of entire box bottom
		// Lip cutout
		if(box_lip)
		{	
			// top lip cut
			translate([0,0,vertical_box_section_height*num_stacks])
				cap_negative(box_wall,box_clearance + box_lip_width,box_lid_height,box_wire_side_clearance,box_nonwire_side_clearance);
		}
		generate_box_lid_holes(make_bolt_head_holes = false);
	}
}

// Generates support for the box for bolts and zipties. spacer parameter addes a spacer incase there is extra space on the boxes for wires.
module both_box_holder_supports(lid_support_height = box_lid_height, spacer = 0)
{
	intersection()
	{
		union()
		{

			// Generate +y side of supports
			box_holder_support(lid_support_height,spacer);

			// Generate -y side of supports
			// if even, translate over half a hex
			if(num_rows % 2 == 0)
			{
				if(pack_style == "rect")
				{	
				translate([get_hex_center_x_length(num_cols + 0.5),get_hex_center_y_length(num_rows),0])
					rotate([0,0,180])
						box_holder_support(lid_support_height,spacer);
				}
				else if(pack_style == "para")
				{
				translate([get_hex_center_x_length(num_cols+num_rows/2 - 0.5),get_hex_center_y_length(num_rows),0])
					rotate([0,0,180])
						box_holder_support(lid_support_height,spacer);
				}
			}
				
			else	// if odd
			{
				if(pack_style =="rect")
				{
					translate([0,get_hex_center_y_length(num_rows),0])
						mirror([0,1,0])
								box_holder_support(lid_support_height,spacer);
				}
				else if(pack_style == "para")
				{
					translate([get_hex_center_x_length(num_rows/2+0.5),get_hex_center_y_length(num_rows),0])
						mirror([0,1,0])
								box_holder_support(lid_support_height,spacer);
				}
			}
		}
		translate([0,0,-(box_wall/2 + extra)])
			cap_positive(box_wall/2,box_clearance,lid_support_height*2 ,box_wire_side_clearance,box_nonwire_side_clearance);
	}




}

// Generates the support to hold the holders in the box lid and bottom.
// spacer sets height for bms clearance or bottom_clearance
// mirrored is used for the -y box_holder_support which will have different sizes due to different side clearances
module box_holder_support(lid_support_height = box_lid_height,spacer = 0)
{
	difference()
	{
		for(col = [1:num_cols])
		{
			// iterate on one side
			// add support in the shape of a hex inbetween cols
			union()
			{
				translate([get_hex_center_x_length(col+0.5),-get_hex_center_y_length(2)-box_clearance,-(box_wall+box_clearance)])
					hex(lid_support_height);
				if(spacer)
				{
					translate([get_hex_center_x_length(col)+hex_w/2,-(get_hex_center_y_length(2) + box_clearance - spacer_overhang),-box_clearance-box_wall])
					{
						intersection()
						{
							translate([0,0,0])
								cube([hex_w/2,hex_pt * 2 + spacer_overhang,(spacer+box_wall)*3],center = true);
							hex(spacer+box_wall);
						}
						
					}
						
				}
			}
		}
		// Cutouts

		// TESTING: flatten the lid support tips for injection molded holders with tabs
		// translate([get_hex_center_x_length(0.5),-(hex_pt- cos(60) * hex_pt + box_clearance),0])
		// 	cube([1000,5,100]);
	}
	
}

module generate_box_lid_holes(lid = false,make_bolt_head_holes = true)
{
	list = get_holes_list(num_rows,num_cols);
	// create holes
	for(range = list)
	{
		if(box_style == "bolt")
		{
			// Bolt hole
			translate([range.x,range.y,box_lid_height/2-box_wall-box_clearance])
			{
				generate_bolt_hole(lid,make_bolt_head_holes);
			}
		}
		else if(box_style == "ziptie")
		{
			// Ziptie holes
			translate([range.x,range.y,box_bottom_height/2-box_wall-box_clearance])
			{
				generate_ziptie_hole();
			}
		}
			
	}
	if(box_style == "both")
	{
		// these indexes set where the bolt holes should go for rect and para styles
		last = len(list)-1;

		row_end = (pack_style == "rect")
			? num_cols - 1
			: num_cols - 2; // if para style

		row_start = (pack_style == "rect")
		? num_cols
		: num_cols -1; // if para style

		// Bolt holes on ends, zipties in middle
		for(i = [list[0],list[row_end],list[row_start],list[last]])
		{
			translate([i.x,i.y,box_lid_height/2-box_wall-box_clearance])
			{
				generate_bolt_hole(lid,make_bolt_head_holes);
			}
		}
		// iterate on list but not the bolt holes
		
		for(index = [0:len(list)-1])
		{
			// if not where the bolt holes are
			if (!(index == 0 || index == row_end || index == row_start || index == last ))
			{
				// Do zipties
				// Ziptie holes
				translate([list[index].x,list[index].y,box_bottom_height/2-box_wall-box_clearance])
				{
					generate_ziptie_hole();
				}
			}
		}	
	}
}

module generate_bolt_hole(lid = false,make_bolt_head_holes = true)
{
	if(lid)
		cylinder(d = bolt_dia, h = box_bottom_height*100,center = true); // Bolt size
	else
		cylinder(d = bolt_dia*0.9, h = box_bottom_height*100,center = true);	// Tap size
	translate([0,0,-(box_lid_height/2-box_wall-box_clearance)- (box_wall + box_clearance) - extra])
		{
		// Bolt Head Hole
		if(make_bolt_head_holes)
			cylinder(d = bolt_head_dia, h = bolt_head_thickness + extra);
		}
}

module generate_ziptie_hole()
{
	cube([ziptie_width,ziptie_thickness,box_bottom_height*100],center = true);
}


// returns a list of all the positions of the holes for box and lid
function get_holes_list(num_rows,num_cols)
= 	[
		// Iterate through rows/cols
		for(row = [0,num_rows],col = [1:pack_style == "rect" ? num_cols: num_cols-1])
		[	// X Component of list member
			row == 0 // if bottom row
			? get_hex_center_x_length(pack_style == "rect" ? col + 0.5: col + 0.5 + row/2)
			: row % 2 == 0 
				? get_hex_center_x_length(pack_style == "rect" ? col: col + row/2)	// if top row even
				: get_hex_center_x_length(pack_style == "rect" ? col + 0.5: col + row/2) // else top row odd
			,
			// Y component of list member
			row == 0 // if bottom row
			? -hex_pt + cos(60) * hex_pt - box_clearance - (cos(60) * hex_pt + box_wall)/2 // Messy but spaces the hole half way between the lid support tip and box wall
			: get_hex_center_y_length(num_rows) + hex_pt - cos(60) * hex_pt + box_clearance + (cos(60) * hex_pt + box_wall)/2 // else top row
			
		]

	];






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
= get_hex_center_y_length(num_rows) + hex_pt * 2;



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
function get_hex_center_x_length(num_cell)
= (num_cell-1) * hex_w;

// returns the length of the center of vertical(columns) hex cells to number to hexes passed to function
function get_hex_center_y_length(num_cell)
= (num_cell-1) * hex_pt*1.5;

// returns a list of the hex cell centers of a given num of rows and columns for para packs.
function get_hex_center_points_para(num_rows, num_cols)
=  	[
		for(row = [0:num_rows-1],col = [0:num_cols-1])
		[	// X component of list member
			row*(0.5 * hex_w) + hex_w * col
			,
			// Y component of list member
			row * 1.5 * (hex_pt)
		]
	];

// returns a list of the hex cell centers of a given num of rows and columns for rect packs.
function get_hex_center_points_rect(num_rows, num_cols)
= 	[
		// Iterate through num of rows and cols
		for(row = [0:num_rows-1],col = [0:num_cols-1])
		[	// X component of list member
			row % 2 == 0 ? // if even
				hex_w * col
			://else
				0.5 * hex_w + hex_w * col
			,
			// Y component of list member
			row * 1.5 * (hex_pt)
		]
	];	// Closing function bracket

// returns a list of the hex cell centers of a given num of rows and columns for rect packs.
function get_hex_center_points_tria(num_rows, num_cols)
= 	[
		// Iterate through num of rows and cols
		for(row = [0:num_rows-1],col = [0:row])
		[	// X component of list member
			row*(0.5 * hex_w) + hex_w*(-col)
			,
			// Y component of list member
			row * 1.5 * (hex_pt)
		]
	];	// Closing function bracket

// code from tria for
// else if(pack_style == "tria")
// 	{
		
// 		for(row = [0:num_rows-1])
// 					{
// 						translate([row*(0.5 * hex_w),1.5*(hex_pt)*row,0])
// 						for(col = [0:row])
// 						{
// 							translate([hex_w*(-col),0,0])
// 								pick_hex();
// 						}
// 					}
// 	}

// returns a list of all the positions of the pin holes for stacking pins
function get_pin_holes_list_rect(num_rows,num_cols)
= 	[
		// Iterate through rows/cols and ignore last row and last column
		for(row = [0:num_rows-2],col = [0:num_cols-2])
		[	// X Component of list member
			row % 2 == 0? // if even
			hex_w * col + hex_pt*cos(30)
			: // else odd
			0.5 * hex_w +hex_w * col + hex_pt*cos(30)
			,
			// Y component of list member
			row * 1.5 * hex_pt  + hex_pt*sin(30)
		]

	];

// returns a list of all the positions of the pins for stacking pins
function get_pin_list_rect(num_rows,num_cols)
= 	[
		// Iterate through rows/cols and ignore last row and last column
		for(row = [0:num_rows-2],col = [1:num_cols-1])
		[	// X Component of list member
			row % 2 == 0? // if even
			hex_w * col + hex_pt*cos(90)
			: // else odd
			col == num_cols - 1? // if also last column then just put pin in first column hex (this nicely works out)
			0.5 * hex_w
			: // else
			0.5 * hex_w +hex_w * col + hex_pt*cos(90)
			,
			// Y component of list member
			row * 1.5 * hex_pt  + hex_pt*sin(90)
		]

	];
