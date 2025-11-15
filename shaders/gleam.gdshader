shader_type canvas_item;

uniform vec4 silver_color_start : source_color = vec4(0.9, 0.9, 0.9, 1.0);
uniform vec4 silver_color_end   : source_color = vec4(0.65, 0.65, 0.65, 1.0);

uniform float metallic_contrast : hint_range(0.5, 5.0) = 2.0;

// Gleam settings
uniform float gleam_speed : hint_range(0.0, 3.0) = 1.0;
uniform float gleam_width : hint_range(0.05, 0.5) = 0.15;
uniform float gleam_intensity : hint_range(0.0, 2.0) = 1.4;

// How often the gleam happens (lower = more often)
uniform float gleam_interval : hint_range(0.5, 10.0) = 4.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    if (tex.a < 0.01) {
        COLOR = vec4(0.0);
    }

    // ---- SILVER METAL BASE COLOR ----
    // Fake metallic shading using UV.x
    float shade = pow(abs(UV.x - 0.5) * 2.0, metallic_contrast);
    vec4 silver = mix(silver_color_start, silver_color_end, shade);

    // ---- OCCASIONAL GLEAM / SHIMMER ----
    // Gleam triggers every "gleam_interval" seconds
    float t = mod(TIME * gleam_speed, gleam_interval);

    // Only gleam when t < 1.0 (short burst)
    float gleam_pos = t; // 0 → 1 during gleam phase

    // Make gleam a narrow diagonal band moving across UV
    float gleam = smoothstep(gleam_pos - gleam_width, gleam_pos, UV.x)
                * smoothstep(gleam_pos + gleam_width, gleam_pos, UV.x);

    // Gleam fades out outside of the active phase
    float active = step(t, 1.0); // 1 during gleam, 0 otherwise

    gleam *= active * gleam_intensity;

    vec4 final_col = silver + vec4(gleam);

    // Keep original alpha from font texture
    final_col.a = tex.a;

    COLOR = final_col;
}