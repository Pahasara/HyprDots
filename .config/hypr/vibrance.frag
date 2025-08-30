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
const float VIB_VIBRANCE = 0.15;

// Precomputed vibrance coefficients for performance
const vec3 VIB_coeffVibrance = VIB_RGB_BALANCE * -VIB_VIBRANCE;

void main() {
    // Sample the original pixel color from screen texture
    vec4 pixColor = texture(tex, v_texcoord);
    
    // Extract RGB components for processing
    vec3 color = pixColor.rgb;
    
    // ===== LUMINANCE CALCULATION =====
    // Two options for luminance calculation:
    // Option 1: Equal weight (simple average)
    // vec3 VIB_coefLuma = vec3(0.333333, 0.333334, 0.333333);
    
    // Option 2: Perceptual luminance (Rec. 709 standard)
    // Weights based on human eye sensitivity to different colors
    vec3 VIB_coefLuma = vec3(0.212656, 0.715158, 0.072186);
    
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
