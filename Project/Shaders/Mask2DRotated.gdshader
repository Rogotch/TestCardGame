shader_type canvas_item;

uniform float PI = 3.1415926;
uniform sampler2D mask_texture;
uniform sampler2D mask_top_texture;
uniform vec2 Offset;
uniform float Rotation;
uniform vec2 Modifier = vec2(1.0, 1.0);

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);

    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.x *= Modifier.x;
    uv.y = uv.x * sine + uv.y * cosine;
    uv.y *= Modifier.y;
    uv += pivot;

    return uv;
}

void fragment() {
    vec4 colour = texture(TEXTURE, UV);
    colour.a *= texture(mask_texture, rotateUV(UV, Offset, Rotation * PI/(4.0))).a;

    colour.a *= texture(mask_top_texture, UV).a;
	
    COLOR = colour;
}
