shader_type spatial;

uniform vec3 rock_colour : source_color = vec3(0.53333, 0.54901, 0.55294);
uniform vec3 snow_colour : source_color = vec3(1.00000, 1.00000, 1.00000);
uniform float snow_height = 0.005;

varying float height;

void vertex() {
	height = VERTEX.y;
}

void fragment() {
	if (height < snow_height)
	{
		ALBEDO = rock_colour;
	}
	else
	{
		ALBEDO = snow_colour;
	}
}
