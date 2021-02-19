#version 120

varying vec2 TexCoords;

const bool colortex0MipmapEnabled = true;

const float centerDepthSmoothHalfLife = 100.0f;

uniform float far, near, centerDepthSmooth, viewWidth, viewHeight;
uniform sampler2D colortex0, depthtex0;

/*
A  - Aperture diameter
f  - Focal length
S1 - Focal distance
S2 - Fragment distance
All units should be the same, preferably in meters/blocks
*/
float ComputeCircleOfConfusion(in float A, in float f, in float S1, in float S2){
    return A * (abs(S2-S1) / S2) * (f / (S1 - f));
}

float ComputeCircleOfConfusion(in float center, in float dist) {
    return min(ComputeCircleOfConfusion(0.024f, 0.5f, center, dist), 0.02f);
}

float LinearizeDepth(in float depth){
    return (2.0f * near * far) / (far + near - (2.0f * depth - 1.0f) * (far - near)); 
}

float GetMipLevel(void){
    float FragmentDistance = LinearizeDepth(texture2D(depthtex0, TexCoords).r) * far + near;
    float CenterDistance   = LinearizeDepth(centerDepthSmooth) * far + near;
    float CoC = ComputeCircleOfConfusion(CenterDistance, FragmentDistance);
    /*
    CoC is in percent image size
    We need to convert mip level to image size and solve for mip level
    Mip level is denoted as M
    Largest image resolution (max(viewWidth, viewHeight)) is denoted as R
    CoC is denoted as just CoC
    We first get mip level to pixel size:
    exp2(M)
    But we care about percent image size, so we divide by image resolution
    exp2(M)/R
    We then set up an equality and solve for M
    CoC = exp2(M)/R
    R*CoC=exp2(M)
    log2(R*CoC) = M
    */
    float Resolution = max(viewWidth, viewHeight);
    float MipLevel = log2(Resolution * CoC);
    return MipLevel;
}

void main(){
    gl_FragColor = texture2DLod(colortex0, TexCoords, GetMipLevel());
}
