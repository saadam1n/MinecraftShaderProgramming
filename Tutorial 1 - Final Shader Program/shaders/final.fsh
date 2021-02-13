#version 120

varying vec2 TexCoords;

uniform sampler2D gcolor;

void main() {
   vec3 Color = texture2D(gcolor, TexCoords).rgb;
   Color = vec3(dot(Color, vec3(0.333f)));
   gl_FragColor = vec4(Color, 1.0f);
}