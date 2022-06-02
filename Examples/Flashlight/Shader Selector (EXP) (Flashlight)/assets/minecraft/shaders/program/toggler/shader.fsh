#version 150

uniform sampler2D DiffuseSampler;
uniform sampler2D DiffuseDepthSampler;
uniform sampler2D ControlSampler;
uniform sampler2D FlashlightSampler;

uniform vec4 ColorModulate;

uniform mat4 ProjMat;
uniform vec2 InSize;
uniform vec2 OutSize;
uniform vec2 ScreenSize;
uniform float _FOV;

in vec2 texCoord;
out vec4 fragColor;

float near = 0.1; 
float far  = 1000.0;
float LinearizeDepth(float depth) 
{
    float z = depth * 2.0 - 1.0;
    return (near * far) / (far + near - z * (far - near));    
}

// Flashlight Variables
const float exposure = 2.;
const float AOE = 8.;

void main() {
    vec4 prev_color  = texture(DiffuseSampler, texCoord);
    vec4 overlay;
	fragColor = prev_color;

    // Channel #1
    vec4 control_color = texelFetch(ControlSampler, ivec2(0, 1), 0);
    switch(int(control_color.b * 255.)) {
        case 1:
            float depth = LinearizeDepth(texture(DiffuseDepthSampler, texCoord).r);
            float distance = length(vec3(1., (2.*texCoord - 1.) * vec2(OutSize.x/OutSize.y,1.) * tan(radians(_FOV / 2.))) * depth);

            vec2 uv = texCoord;
            float d = sqrt(pow((uv.x - 0.5),2.0) + pow((uv.y - 0.5),2.0));
            d = exp(-(d * AOE)) * exposure / (distance*0.15);
            fragColor = vec4(fragColor.rgb*clamp(1.0 + d,0.1,10.0),1.0);
            break;
    }

    // Channel #2
    float battery = 0.0;
    control_color = texelFetch(ControlSampler, ivec2(0, 2), 0);
    switch(int(control_color.b * 255.)) {
        case 1:
            battery = 1.0;
            break;
        case 2:
            battery = 2.0;
            break;
        case 3:
            battery = 3.0;
            break;
        case 4:
            battery = 4.0;
            break;
    }

    // Overlay Coordinates Based on Battery Level
    overlay = texture(FlashlightSampler, vec2(texCoord.x, battery/5.0+(1.0-texCoord.y)/5.0 ));

    // Overlay the Overlay on top of other pixels, by default overlay has nothing.
    // Import an overlay sampler to set it.
    if(overlay.a > 0.0) {
        fragColor.rgb = mix(fragColor.rgb, overlay.rgb, overlay.a).rgb;
    }
}
