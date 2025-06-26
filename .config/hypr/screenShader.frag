#version 100
precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

vec3 adjustSaturation(vec3 color, float saturation) {
    float luma = dot(color, vec3(0.299, 0.587, 0.114));
    return mix(vec3(luma), color, saturation);
}

vec3 adjustContrast(vec3 color, float contrast) {
    return ((color - 0.5) * contrast) + 0.5;
}

vec3 adjustBrightness(vec3 color, float brightness) {
    return color + vec3(brightness);
}

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);

    // Saturation boost — higher = more vivid (1.0 = unchanged)
    pixColor.rgb = adjustSaturation(pixColor.rgb, 1.20);

    // Contrast tweak — higher = punchier, <1 = flatter
    pixColor.rgb = adjustContrast(pixColor.rgb, 1.05);

    // Brightness boost — small value like 0.01–0.05 is enough
    pixColor.rgb = adjustBrightness(pixColor.rgb, 0.03);

    gl_FragColor = pixColor;
}
