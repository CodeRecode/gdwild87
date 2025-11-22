shader_type spatial;
render_mode unshaded;

uniform sampler2D tex;

void fragment() {
	vec4 tex_color = texture(tex, UV + vec2(fract(TIME), 0));
	ALBEDO = vec3(0.1, .4, 0.1) - tex_color.rgb * 1.;
}
