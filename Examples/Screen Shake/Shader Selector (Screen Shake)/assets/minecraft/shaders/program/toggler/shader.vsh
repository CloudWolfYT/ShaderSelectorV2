#version 150
in vec4 Position;

uniform vec2 InSize;
uniform vec2 OutSize;
uniform vec2 ScreenSize;

uniform sampler2D ControlSampler;

out vec2 texCoord;

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
    vec2 freq = vec2(100.,100.);
    vec2 magnitude = vec2(0.01,0.01);

    vec2 uv = Position.xy/OutSize.xy;
    vec4 control_time  = texelFetch(ControlSampler, ivec2(0, 0), 0);

    // Channel #1
    vec4 control_color = texelFetch(ControlSampler, ivec2(0, 1), 0);
    switch(int(control_color.b * 255.)) {
        case 1:
            uv -= 0.5;
            uv *= 1.0 - 2.0 * magnitude.x;
            uv += 0.5;

            uv.x += sin(control_time.r * freq.x) * magnitude.x;
            uv.y += cos(control_time.r * freq.y) * magnitude.y;
        break;
    }

    texCoord = uv.xy; // Load edited coords
}