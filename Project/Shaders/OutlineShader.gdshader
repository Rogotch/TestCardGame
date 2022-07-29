shader_type canvas_item;

//const float PI = 3.1415926;
uniform sampler2D mask_texture;
uniform sampler2D noize_img;
uniform float AlfaMult = 1.0;
uniform vec2  XYMult   = vec2(1.0,1.0);
uniform float speed = 1.0;
uniform vec4 border_color: hint_color = vec4(1.0,1.0,1.0, 1.0);

//void vertex() {
//    loc_vertex = VERTEX;
//}

//vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
//    float sine = sin(rotation);
//    float cosine = cos(rotation);
//
//    uv -= pivot;
//    uv.x = uv.x * cosine - uv.y * sine;
//    uv.x *= Modifier.x;
//    uv.y = uv.x * sine + uv.y * cosine;
//    uv.y *= Modifier.y;
//    uv += pivot;
//
//    return uv;
//}

void fragment() {
//	vec2 offset = vec2(0.5, 0.5);
//	float rotation = TIME * 0.5;
//	rotateUV(UV, Offset, Rotation * PI/(4.0))
	vec2 uv1 = vec2(UV.x * XYMult.x + TIME * speed, UV.y * XYMult.y + TIME * speed);
//	vec2 uv1 = rotateUV(UV, offset, rotation * PI/(4.0));

	float noize_r = texture(noize_img, uv1).r;
	float noize_g = texture(noize_img, uv1).g;
	float noize_b = texture(noize_img, uv1).b;
	
	float testNum = 0.5;
	
	float newAlfa = noize_r * noize_g * noize_b;
	
//    colour.a *= texture(mask_texture, UV).a;
	
//    COLOR = colour;
	COLOR = border_color;
	COLOR.a = texture(mask_texture, UV).a * newAlfa * AlfaMult * border_color.a;
	
}