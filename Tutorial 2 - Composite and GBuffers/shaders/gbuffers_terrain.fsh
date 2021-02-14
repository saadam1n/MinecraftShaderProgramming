#version 120

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;

// The texture atlas
uniform sampler2D texture;

void main(){
    // Sample from texture atlas and account for biome color + ambien occlusion
    vec4 albedo = texture2D(texture, TexCoords) * Color;
    /* DRAWBUFFERS:01 */
    // Write the values to the color textures
    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(Normal * 0.5f + 0.5f, 1.0f);
}