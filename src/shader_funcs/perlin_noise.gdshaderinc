#include "res://shader_funcs/hash.gdshaderinc"

//creates random vector based on coords
vec3 create_vector(vec3 vec) {
	//using length to get single number; still is somewhat random due to hash
    float coords_hash = length(hash(vec));
	
	//generate random values
	float theta = coords_hash * 2.0 * PI;
	float x = cos(theta);
	float y = sin(theta);
	float z = fract(coords_hash * 43758.5453123) * 2.0 - 1.0;
	float r = sqrt(max(0.0, 1.0 - z * z));
	
    //create and return vector based on hashed coords
    vec3 vector = vec3(x * r, y * r, z);
    return normalize(vector);
}

float quantic_smoothstep(float x) {
	return x * x * x * ( x * (x * 6.0 - 15.0) + 10.0);
}

float perlin_3D(vec3 coords) {
	//get corners
    float x = floor(coords.x);
    float y = floor(coords.y);
	float z = floor(coords.z);
	
    //normalize corners to be between 0 and 1
    float x_relative = coords.x - x;
    float y_relative = coords.y - y;
	float z_relative = coords.z - z;
	
    //calculate the corner values 
    vec3 front_bottom_left = vec3(x, y, z);
    vec3 front_bottom_right = vec3(x - 1.0, y, z);
    vec3 front_top_left = vec3(x, y - 1.0, z);
    vec3 front_top_right = vec3(x - 1.0, y - 1.0, z);
	vec3 back_bottom_left = vec3(x, y, z - 1.0);
    vec3 back_bottom_right = vec3(x - 1.0, y, z - 1.0);
    vec3 back_top_left = vec3(x, y - 1.0, z - 1.0);
    vec3 back_top_right = vec3(x - 1.0, y - 1.0, z - 1.0);
	
    //convert corners into gradient vectors
    vec3 vector_front_bottom_left = create_vector(front_bottom_left);
    vec3 vector_front_bottom_right = create_vector(front_bottom_right);
    vec3 vector_front_top_left = create_vector(front_top_left);
    vec3 vector_front_top_right = create_vector(front_top_right);
	vec3 vector_back_bottom_left = create_vector(back_bottom_left);
    vec3 vector_back_bottom_right = create_vector(back_bottom_right);
    vec3 vector_back_top_left = create_vector(back_top_left);
    vec3 vector_back_top_right = create_vector(back_top_right);
	
    //get displacement values
    vec3 delta_front_bottom_left = vec3(x_relative, y_relative, z_relative);
    vec3 delta_front_bottom_right = vec3(x_relative - 1.0, y_relative, z_relative);
    vec3 delta_front_top_left = vec3(x_relative, y_relative - 1.0, z_relative);
    vec3 delta_front_top_right = vec3(x_relative - 1.0, y_relative - 1.0, z_relative);
	vec3 delta_back_bottom_left = vec3(x_relative, y_relative, z_relative - 1.0);
    vec3 delta_back_bottom_right = vec3(x_relative - 1.0, y_relative, z_relative - 1.0);
    vec3 delta_back_top_left = vec3(x_relative, y_relative - 1.0, z_relative - 1.0);
    vec3 delta_back_top_right = vec3(x_relative - 1.0, y_relative - 1.0, z_relative - 1.0);
	
    //get dot products
    float dot_front_bottom_left = dot(delta_front_bottom_left, vector_front_bottom_left);
    float dot_front_bottom_right = dot(delta_front_bottom_right, vector_front_bottom_right);
    float dot_front_top_left = dot(delta_front_top_left, vector_front_top_left);
    float dot_front_top_right = dot(delta_front_top_right, vector_front_top_right);
	float dot_back_bottom_left = dot(delta_back_bottom_left, vector_back_bottom_left);
    float dot_back_bottom_right = dot(delta_back_bottom_right, vector_back_bottom_right);
    float dot_back_top_left = dot(delta_back_top_left, vector_back_top_left);
    float dot_back_top_right = dot(delta_back_top_right, vector_back_top_right);
	
    //get weights for top and bottom
    float weight_x = quantic_smoothstep(x_relative);
    float weight_y = quantic_smoothstep(y_relative);
	float weight_z = quantic_smoothstep(z_relative);
	
    //interpolate between front distances
    float front_top = mix(dot_front_top_left, dot_front_top_right, weight_x);
    float front_bottom = mix(dot_front_bottom_left, dot_front_bottom_right, weight_x);
	float front = mix (front_top, front_bottom , weight_y);
	
	//interpolate between back distances
	float back_top = mix(dot_back_top_left, dot_back_top_right, weight_x);
    float back_bottom = mix(dot_back_bottom_left, dot_back_bottom_right, weight_x);
	float back = mix (back_top, back_bottom , weight_y);
	
    //interpolate over z to get final answer
    float middle = mix(front, back, weight_z);
    //convert from range [-1, 1] to [0, 1]
    float newValue = ((middle - (-1.0)) / (1.0 - (-1.0))) * (1.0 - 0.0) + 0.0;
    return newValue;
}