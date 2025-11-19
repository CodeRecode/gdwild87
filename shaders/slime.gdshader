shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(0., 0.2, 0.);
	//ALPHA = .95;
	ROUGHNESS = .4;
	RIM = 0.5;
	BACKLIGHT = vec3(1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
