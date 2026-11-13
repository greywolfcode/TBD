shader_type spatial;

#include "res://shader_funcs/perlin_noise.gdshaderinc"

uniform vec3 base_colour : source_color = vec3(0.85098, 0.76862, 0.52549);
uniform vec3 spot_colour : source_color = vec3(0.60000, 0.49411, 0.18823);
uniform sampler2D depth_texture : hint_depth_texture;

void fragment() {
	//get global coords for pixel
	//from https://docs.godotengine.org/en/stable/tutorials/shaders/advanced_postprocessing.html#example-shader
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec4 world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	vec3 world_position = world.xyz / world.w;
	
	//use coords to get noise value
	float noise_val = perlin_3D(world_position);
	
	ALBEDO = mix(base_colour, spot_colour, noise_val);
}
