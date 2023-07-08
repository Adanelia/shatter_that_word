shader_type canvas_item;

void fragment()
{
	vec3 color = texture(SCREEN_TEXTURE, SCREEN_UV).xyz * 0.16;
	color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.15;
	color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.15;
	color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(2.0 * SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.12;
	color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(2.0 * -SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.12;
	color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(3.0 * SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.09;
	color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(3.0 * -SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.09;
	color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(4.0 * SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.05;
	color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(4.0 * -SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.05;
	
	COLOR.xyz = color;
}
