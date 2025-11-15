shader_type canvas_item;

uniform float speed : hint_range(0.0, 5.0) = 0.2;
uniform float cloud_scale : hint_range(0.5, 10.0) = 1.5;

uniform vec4 cloud_color : source_color = vec4(0.2, 0.8, 0.2, 1.0);
uniform vec4 bg_color    : source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform float cloud_alpha : hint_range(0.0, 1.0) = 0.7; // max cloud opacity
uniform float cutoff : hint_range(0.0, 1.0) = 0.2;      // how much empty space to allow

// Basic hash-based noise
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(23.43, 45.17))) * 12345.678);
}

float noise(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f*f*(3.0 - 2.0*f);

    return mix(a, b, u.x) +
           (c - a)*u.y*(1.0 - u.x) +
           (d - b)*u.x*u.y;
}

void fragment() {
    vec2 uv = UV * cloud_scale;

    // animation
    uv.x += TIME * speed;

    // layered noise for soft clouds
    float n = 0.0;
    n += noise(uv * 1.0);
    n += noise(uv * 2.0) * 0.5;
    n += noise(uv * 4.0) * 0.25;
    n /= 1.75;

    // Fade out clouds below the cutoff threshold
    float alpha_factor = smoothstep(cutoff, 1.0, n);

    // Final alpha = noise-based * max alpha
    float final_alpha = alpha_factor * cloud_alpha;

    // Blend with background
    vec4 col = mix(bg_color, cloud_color, n);

    col.a = final_alpha;

    COLOR = col;
}