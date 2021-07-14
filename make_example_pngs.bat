set "color=--imgsize=720,720 --colorscheme DeepOcean --projection ortho"
set "rows=-D num_rows=4 -D num_cols=8"
openscad -o Photos/1.png -D "part_type =\"normal\"" -D "part=\"holder\""  -D num_rows=2 -D num_cols=2 %color% hex_cell.scad
openscad -o Photos/2.png -D "part_type =\"normal\"" -D "part=\"holder\""  -D num_rows=2 -D num_cols=4 %color% hex_cell.scad
openscad -o Photos/3.png -D "part_type =\"normal\"" -D "part=\"holder\""  -D num_rows=3 -D num_cols=4 %color% hex_cell.scad
openscad -o Photos/4.png -D "part_type =\"normal\"" -D "part=\"holder\""  %rows% %color% hex_cell.scad
openscad -o Photos/5.png -D "part_type =\"normal\"" -D "part=\"holder\"" -D "pack_style=\"para\"" %rows% %color% hex_cell.scad
openscad -o Photos/6.png -D "part_type =\"normal\"" -D "part=\"cap\""  %rows% %color% hex_cell.scad
openscad -o Photos/7.png -D "part_type =\"normal\"" -D "part=\"cap\"" -D "pack_style=\"para\"" %rows% %color% hex_cell.scad
openscad -o Photos/8.png -D "part_type =\"both\"" -D "part=\"box bottom\"" -D "pack_style= \"rect\"" %rows% %color% hex_cell.scad
openscad -o Photos/9.png -D "part_type =\"both\"" -D "part=\"box bottom\"" -D "pack_style= \"para\"" %rows% %color% hex_cell.scad
openscad -o Photos/10.png -D "part_type =\"normal\"" -D "part=\"insulator\""  %rows% %color% hex_cell.scad
openscad -o Photos/rect_holder.png -D "part_type =\"normal\"" -D "part=\"holder\"" -D "pack_style=\"rect\"" %rows% %color% hex_cell.scad
openscad -o Photos/para_holder.png -D "part_type =\"normal\"" -D "part=\"holder\"" -D "pack_style=\"para\"" %rows% %color% hex_cell.scad
openscad -o Photos/holder_with_insulator.png -D "part_type =\"normal\"" -D "part=\"flipped holder png\"" -D "pack_style=\"rect\"" -D insulator_as_support=true %rows% %color% hex_cell.scad
openscad -o Photos/holder_with_stacking_pins.png -D "part_type =\"normal\"" -D "part=\"flipped holder png\"" -D "pack_style=\"rect\"" -D stacking_pins=true %rows% %color% hex_cell.scad
openscad -o Photos/holder_with_stacking_bolt.png -D "part_type =\"normal\"" -D "part=\"flipped holder png\"" -D "pack_style=\"rect\"" -D stacking_bolts=true %rows% %color% hex_cell.scad
openscad -o Photos/rect_box_and_lid.png -D "part_type =\"both\"" -D "part=\"box bottom\"" -D "pack_style= \"rect\"" %rows% %color% hex_cell.scad
openscad -o Photos/para_box_and_lid.png -D "part_type =\"both\"" -D "part=\"box bottom\"" -D "pack_style= \"para\"" %rows% %color% hex_cell.scad