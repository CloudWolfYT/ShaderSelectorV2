#version 150
in vec4 Position;

uniform vec2 InSize;
uniform vec2 OutSize;
uniform vec2 ScreenSize;

uniform sampler2D ControlSampler;

out vec2 texCoord;

float time() {
    vec3 control_time = texelFetch(ControlSampler, ivec2(0, 0), 0).rgb;
    return control_time.x + 255. * control_time.y + 65025. * control_time.z;
}

void main(){
    // REQUIRED Blit Copy Statement
    float x = -1.0; 
    float y = -1.0;
    if (Position.x > 0.001){
        x = 1.0;
    }
    if (Position.y > 0.001){
        y = 1.0;
    }
    gl_Position = vec4(x, y, 0.2, 1.0);
    //////////////////////////////////////


    // Shake Effect refactored from: https://www.shadertoy.com/view/tdSyWz
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = Position.xy/OutSize.xy;

    float t = time();
    vec4 control_color = texelFetch(ControlSampler, ivec2(0, 2), 0);
    vec2 freq = vec2(control_color.b * 255.,control_color.b * 255.); // Channel #2 Controls Shake Freq
    control_color = texelFetch(ControlSampler, ivec2(0, 1), 0);
    vec2 magnitude = vec2(control_color.b * 255. / 5000.,control_color.b * 255. / 5000.); // Channel #1 Controls Shake Magnitude

    // Zoom in to prevent black bars
    uv -= 0.5;
    uv *= 1.0 - 2.0 * magnitude.x;
    uv += 0.5;

    if(control_color.b * 255. > 0) {
        uv.x += sin(t * freq.x) * magnitude.x;
        uv.y += cos(t * freq.y) * magnitude.y;
    }

//    switch(int(control_color.b * 255.)) {
//        case 1:
//            gl_Position.x += sin(control_time.r * uniA.x + uniB.x) * uniScale.x;
//            gl_Position.y += cos(control_time.r * uniA.y + uniB.y) * uniScale.y;
//            break;
//    }

    texCoord = uv.xy; // Load edited coords
}