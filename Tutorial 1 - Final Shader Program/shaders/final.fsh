#version 120

varying vec2 TexCoords;

uniform sampler2D colortex0;

void main() {
   vec3 Color = texture2D(colortex0, TexCoords).rgb;
   Color = vec3(dot(Color, vec3(0.333f)));
   gl_FragColor = vec4(Color, 1.0f);
}