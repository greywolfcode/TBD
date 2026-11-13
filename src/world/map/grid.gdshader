shader_type spatial;

uniform vec3 grid_colour : source_color = vec3(0.0);
uniform float cell_size = 0.05;
uniform float line_thickness : hint_range(0.0, 1.0) = 0.01;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {	
	vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	//shift grid to be centred at (0,0)
	vec2 grid_pos = mod(world_pos.xz + cell_size, cell_size) / cell_size - 0.5;
	
	grid_pos = abs(grid_pos) * 2.0;
	
	//only apply colour when on one of the axis
	float is_line = 1.0 - min(step(line_thickness, grid_pos.x), step(line_thickness, grid_pos.y));

	//blend colour with original colour to not cover whole surface in line colour
	ALBEDO = grid_colour;
	ALPHA = is_line;
}