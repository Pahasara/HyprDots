#version 320 es
// Enhanced Vibrance Screen Shader for Hyprland
// OpenGL ES 3.2 optimized with modern GLSL features
// Influenced by SweetFX vibrance implementation


precision highp float;

// Input texture coordinate from vertex shader
in vec2 v_texcoord;

// Screen texture sampler
layout(binding = 0) uniform sampler2D tex;

// Output fragment color
layout(location = 0) out vec4 fragColor;

// ===== VIBRANCE CONFIGURATION =====
// Color channel balance (R, G, B) - adjust individual channel sensitivity
const vec3 VIB_RGB_BALANCE = vec3(1.0, 1.0, 1.0);

// Vibrance intensity (0.0 = no effect, higher = more vibrant)
const float VIB_VIBRANCE = 0.20;

// Precomputed vibrance coefficients for performance
const vec3 VIB_coeffVibrance = VIB_RGB_BALANCE * -VIB_VIBRANCE;

// ===== SHADOW LIFT CONFIGURATION =====
// Brightens near-black detail without touching mids or highlights.
// Pure black stays black, so letterbox bars stay black.
// Shadow lift strength (0.0 = off, 1.0 = full effect)
const float SHADOW_LIFT = 0.30;

// Shadow curve (below 1.0 brightens darks, lower = stronger)
const float SHADOW_GAMMA = 0.70;

// Brightness level (0.0 - 1.0) of the brightest channel above which the lift fades out
const float SHADOW_RANGE = 0.50;

// Pulls lifted shadows toward neutral gray (0.0 = keep hue, 1.0 = fully gray in deep shadows)
// Raise it if dark areas still look too blue
const float SHADOW_DESAT = 0.45;

// Perceptual luminance weights (Rec. 709)
const vec3 VIB_coefLuma = vec3(0.212656, 0.715158, 0.072186);

void main() {
    // Sample the original pixel color from screen texture
    vec4 pixColor = texture(tex, v_texcoord);
    
    // Extract RGB components for processing
    vec3 color = pixColor.rgb;

    // ===== SHADOW LIFT =====
    // The curve is applied to luminance only and the color is scaled by the same
    // amount, so the hue of dark areas is preserved (no color cast from the lift)
    float shadow_luma = dot(VIB_coefLuma, color);

    // Weight is 1.0 when every channel is dark and fades to 0.0 once the brightest
    // channel reaches SHADOW_RANGE (so saturated colors like pure blue are untouched)
    float shadow_peak = max(color.r, max(color.g, color.b));
    float shadow_weight = 1.0 - smoothstep(0.0, SHADOW_RANGE, shadow_peak);

    // A gamma below 1.0 raises dark values; 0 stays 0
    float lifted_luma = pow(shadow_luma, SHADOW_GAMMA);
    float shadow_gain = mix(1.0, lifted_luma / max(shadow_luma, 0.0001), shadow_weight * SHADOW_LIFT);

    // Never push a channel past white (keeps saturated dark colors from clipping)
    shadow_gain = min(shadow_gain, 1.0 / max(max(color.r, max(color.g, color.b)), 0.0001));
    color *= shadow_gain;

    // Pull deep shadows toward neutral so blue-black themes and panel tint don't get emphasized
    color = mix(vec3(dot(VIB_coefLuma, color)), color, 1.0 - shadow_weight * SHADOW_DESAT);

    // ===== LUMINANCE CALCULATION =====
    // Two options for luminance calculation:
    // Option 1: Equal weight (simple average)
    // vec3 VIB_coefLuma = vec3(0.333333, 0.333334, 0.333333);
    
    // Option 2: Perceptual luminance (Rec. 709 standard, VIB_coefLuma above)
    // Weights based on human eye sensitivity to different colors
    
    // Calculate perceptual brightness of the pixel
    float luma = dot(VIB_coefLuma, color);
    
    // ===== SATURATION ANALYSIS =====
    // Find the most and least saturated color channels
    float max_color = max(color.r, max(color.g, color.b));
    float min_color = min(color.r, min(color.g, color.b));
    
    // Calculate current color saturation (difference between max and min channels)
    float color_saturation = max_color - min_color;
    
    // ===== VIBRANCE ENHANCEMENT =====
    // Create per-channel vibrance multipliers based on current saturation
    // This creates a non-linear response that enhances less saturated colors more
    vec3 p_col = vec3(sign(VIB_coeffVibrance) * color_saturation - 1.0) * VIB_coeffVibrance + 1.0;
    
    // Apply vibrance by mixing between luminance and original color
    // Higher saturation pixels get less enhancement (preserves skin tones)
    pixColor.r = mix(luma, color.r, p_col.r);
    pixColor.g = mix(luma, color.g, p_col.g);
    pixColor.b = mix(luma, color.b, p_col.b);
    
    // Output the enhanced color (alpha channel unchanged)
    fragColor = pixColor;
}
