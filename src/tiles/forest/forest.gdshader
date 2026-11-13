shader_type spatial;

#include "res://shader_funcs/perlin_noise.gdshaderinc"

uniform vec3 colour_one : source_color = vec3(0.18039, 0.43529, 0.25098);
uniform vec3 colour_two : source_color = vec3(0.03921, 0.09803, 0.05490);
uniform float noise_scale: hint_range(0.0, 100.0) = 40.0;

varying vec2 coords;

void vertex() {
	coords = VERTEX.xz * noise_scale;
}

void fragment() {
	float noise_val = perlin_2D(coords);
	
	ALBEDO = mix(colour_one, colour_two, noise_val);
}