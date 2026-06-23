shader_type canvas_item;

uniform float channel_offset : hint_range(0.0, 0.02) = 0.003;
uniform int r_levels : hint_range(2, 32) = 8;
uniform int g_levels : hint_range(2, 32) = 8;
uniform int b_levels : hint_range(2, 32) = 8;
uniform float dither_strength : hint_range(0.0, 2.0) = 1.0;

float bayer_dither(vec2 screen_pos) {
    const float matrix[16] = float[16](
        0.0,  8.0,  2.0, 10.0,
       12.0,  4.0, 14.0,  6.0,
        3.0, 11.0,  1.0,  9.0,
       15.0,  7.0, 13.0,  5.0
    );
    int x = int(mod(screen_pos.x, 4.0));
    int y = int(mod(screen_pos.y, 4.0));
    return (matrix[y * 4 + x] / 16.0) - 0.5;
}

float quantize_channel(float value, int levels, float dither) {
    float step = 1.0 / float(levels - 1);
    float dithered = value + dither * step;
    return clamp(round(dithered / step) * step, 0.0, 1.0);
}

void fragment() {
    float r = texture(TEXTURE, UV + vec2(channel_offset, 0.0)).r;
    float g = texture(TEXTURE, UV).g;
    float b = texture(TEXTURE, UV - vec2(channel_offset, 0.0)).b;
    float a = texture(TEXTURE, UV).a;

    float dither = bayer_dither(FRAGCOORD.xy) * dither_strength;

    r = quantize_channel(r, r_levels, dither);
    g = quantize_channel(g, g_levels, dither);
    b = quantize_channel(b, b_levels, dither);

    COLOR = vec4(r, g, b, a);
}