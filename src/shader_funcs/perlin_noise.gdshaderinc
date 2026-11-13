#include "res://shader_funcs/hash.gdshaderinc"

//creates random vector based on coords
vec3 create_vector_3D(vec3 vec) {
	//using length to get single number; still is somewhat random due to hash
    float coords_hash = length(hash_3D(vec));
	
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

vec2 create_vector_2D(vec2 vec) {
	//using length to get single number; still is somewhat random due to hash
    float coords_hash = length(hash_2D(vec));
	
	//generate random values
	float theta = coords_hash * 2.0 * PI;
	float x = cos(theta);
	float y = sin(theta);
	float z = fract(coords_hash * 43758.5453123) * 2.0 - 1.0;
	float r = sqrt(max(0.0, 1.0 - z * z));
	
    //create and return vector based on hashed coords
    vec2 vector = vec2(x * r, y * r);
    return normalize(vector);
}

float quintic_smoothstep(float x) {
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
    vec3 front_bottom_right = vec3(x + 1.0, y, z);
    vec3 front_top_left = vec3(x, y + 1.0, z);
    vec3 front_top_right = vec3(x + 1.0, y + 1.0, z);
	vec3 back_bottom_left = vec3(x, y, z + 1.0);
    vec3 back_bottom_right = vec3(x + 1.0, y, z + 1.0);
    vec3 back_top_left = vec3(x, y + 1.0, z + 1.0);
    vec3 back_top_right = vec3(x + 1.0, y + 1.0, z + 1.0);
	
    //convert corners into gradient vectors
    vec3 vector_front_bottom_left = create_vector_3D(front_bottom_left);
    vec3 vector_front_bottom_right = create_vector_3D(front_bottom_right);
    vec3 vector_front_top_left = create_vector_3D(front_top_left);
    vec3 vector_front_top_right = create_vector_3D(front_top_right);
	vec3 vector_back_bottom_left = create_vector_3D(back_bottom_left);
    vec3 vector_back_bottom_right = create_vector_3D(back_bottom_right);
    vec3 vector_back_top_left = create_vector_3D(back_top_left);
    vec3 vector_back_top_right = create_vector_3D(back_top_right);
	
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
    float weight_x = quintic_smoothstep(x_relative);
    float weight_y = quintic_smoothstep(y_relative);
	float weight_z = quintic_smoothstep(z_relative);
	
    //interpolate between front distances
    float front_top = mix(dot_front_top_left, dot_front_top_right, weight_x);
    float front_bottom = mix(dot_front_bottom_left, dot_front_bottom_right, weight_x);
	float front = mix (front_bottom, front_top, weight_y);
	
	//interpolate between back distances
	float back_top = mix(dot_back_top_left, dot_back_top_right, weight_x);
    float back_bottom = mix(dot_back_bottom_left, dot_back_bottom_right, weight_x);
	float back = mix (back_bottom, back_top, weight_y);
	
    //interpolate over z to get final answer
    float middle = mix(front, back, weight_z);
    //convert from range [-1, 1] to [0, 1]
    float newValue = ((middle - (-1.0)) / (1.0 - (-1.0))) * (1.0 - 0.0) + 0.0;
    return newValue;
}

float perlin_2D(vec2 coords) {
	//get corners
    float x = floor(coords.x);
    float y = floor(coords.y);
	
    //normalize corners to be between 0 and 1
    float x_relative = coords.x - x;
    float y_relative = coords.y - y;
	
    //calculate the corner values 
    vec2 bottom_left = vec2(x, y);
    vec2 bottom_right = vec2(x + 1.0, y);
    vec2 top_left = vec2(x, y + 1.0);
    vec2 top_right = vec2(x + 1.0, y + 1.0);
	
    //convert corners into gradient vectors
    vec2 vector_bottom_left = create_vector_2D(bottom_left);
    vec2 vector_bottom_right = create_vector_2D(bottom_right);
    vec2 vector_top_left = create_vector_2D(top_left);
    vec2 vector_top_right = create_vector_2D(top_right);
	
    //get displacement values
    vec2 delta_bottom_left = vec2(x_relative, y_relative);
    vec2 delta_bottom_right = vec2(x_relative - 1.0, y_relative);
    vec2 delta_top_left = vec2(x_relative, y_relative - 1.0);
    vec2 delta_top_right = vec2(x_relative - 1.0, y_relative - 1.0);
	
    //get dot products
    float dot_bottom_left = dot(delta_bottom_left, vector_bottom_left);
    float dot_bottom_right = dot(delta_bottom_right, vector_bottom_right);
    float dot_top_left = dot(delta_top_left, vector_top_left);
    float dot_top_right = dot(delta_top_right, vector_top_right);
	
    //get weights for top and bottom
    float weight_x = quintic_smoothstep(x_relative);
    float weight_y = quintic_smoothstep(y_relative);
	
    //interpolate between x distances
    float top = mix(dot_top_left, dot_top_right, weight_x);
    float bottom = mix(dot_bottom_left, dot_bottom_right, weight_x);
	
    //interpolate over y to get final answer
	float middle = mix (bottom, top, weight_y);
	
    //convert from range [-1, 1] to [0, 1]
    float newValue = ((middle - (-1.0)) / (1.0 - (-1.0))) * (1.0 - 0.0) + 0.0;
    return newValue;
}