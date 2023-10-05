shader_type canvas_item;

uniform float r: hint_range(0.0, 2.0, 0.01);
uniform vec3 transition_color: source_color;

void fragment() {
	vec2 st = UV - vec2(.5);
	float d = dot(st, st) * 4.;
	vec3 color = vec3(.0);
	float alpha = 1.;
	if (r < 0.02) {
		color = transition_color;
	} else {
		color = vec3(smoothstep(r - .01, r+.01, d)) * transition_color;
		alpha = step(r, d);
	};
	
	COLOR = vec4(color, alpha);
}
