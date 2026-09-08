#version 300 es
precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
layout(location = 0) out vec4 fragColor;

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    // Warm eye care night filter: soft blue attenuation
    pixColor.b *= 0.78;
    pixColor.g *= 0.94;
    fragColor = pixColor;
}
