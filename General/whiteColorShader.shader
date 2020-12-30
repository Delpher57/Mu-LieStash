shader_type canvas_item;

uniform bool active = true;

void fragment() {
	vec4 previusColor = texture(TEXTURE, UV);
	vec4 whiteColor = vec4(1.0,1.0,1.0, previusColor.a);
	vec4 NewColor = previusColor;
	if (active == true) {
		NewColor = whiteColor;
	}
	COLOR = NewColor;
}