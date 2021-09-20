float random2d(vec2 n) 
{
	return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453123);
}

#pragma glslify: export(random2d)