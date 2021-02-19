#version 120

#include "distort.glsl"

varying vec2 TexCoords;
varying vec4 Color;

void main(){
    gl_Position    = ftransform();
    gl_Position.xy = DistortPosition(gl_Position.xy);
    TexCoords = gl_MultiTexCoord0.st;
    Color = gl_Color;
}