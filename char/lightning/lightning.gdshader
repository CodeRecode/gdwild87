shader_type spatial;

uniform float scroll_speed = 3.0;
uniform float noise_scale = 4.0;
uniform vec4 glow_color : source_color = vec4(0.5, 0.8, 1.0, 1.0);
uniform sampler2D noise_texture;

void fragment() {
    float t = TIME * scroll_speed;
    float n = texture(noise_texture, vec2(UV.x * noise_scale, UV.y * noise_scale + t)).r;
    float intensity = smoothstep(0.4, 1.0, n);
    ALBEDO = glow_color.rgb * intensity;
    EMISSION = glow_color.rgb * intensity * 3.0;
}
