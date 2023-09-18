#version 150

uniform sampler2D DiffuseSampler;
uniform sampler2D DiffuseDepthSampler;
uniform sampler2D ControlSampler;
uniform vec2 OutSize;

in vec2 texCoord;
in vec2 oneTexel;

out vec4 fragColor;


void main() {
    vec4 prev_color  = texture(DiffuseSampler, texCoord);
    vec4 overlay;
	fragColor = prev_color;

//    // Channel #1
//    vec4 control_color = texelFetch(ControlSampler, ivec2(0, 1), 0);
//    switch(int(control_color.b * 255.)) {
//        case 1:
//            //fragColor.b += 0.5;
//            break;
//    }

//    // Channel #2
//    control_color = texelFetch(ControlSampler, ivec2(0, 2), 0);
//    switch(int(control_color.b * 255.)) {
//        case 1:
//            //fragColor.g += 0.5;
//            break;
//    }

//    // Overlay the Overlay on top of other pixels, by default overlay has nothing.
//    // Import an overlay sampler to set it.
//    if(overlay.a > 0.0) {
//        fragColor.rgb = mix(fragColor.rgb, overlay.rgb, overlay.a).rgb;
//    }
}
