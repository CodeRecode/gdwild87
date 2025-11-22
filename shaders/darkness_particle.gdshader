shader_type spatial;
render_mode unshaded, depth_test_disabled;

uniform sampler2D particle_tex;

void fragment() {
	vec4 tex = texture(particle_tex, UV);
	ALBEDO *= COLOR.rgb;
	ALPHA = tex.a * COLOR.a;
}
