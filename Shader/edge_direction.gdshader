// Godot 4.4.1, Forward+ ou Mobile
shader_type spatial;
render_mode unshaded, depth_draw_never, depth_test_disabled, cull_disabled;

uniform sampler2D screen_texture : source_color, hint_screen_texture, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, filter_nearest;
uniform sampler2D normal_rough_texture : hint_roughness_normal, filter_nearest;

uniform float pixel_size = 0.01; // Controla o tamanho dos pixels
uniform vec3 normal_edge_bias = vec3(1.0, 1.0, 1.0);
uniform float depth_threshold_low = 11.0;
uniform float depth_threshold_high = 11.0;
uniform float normal_threshold_low = 0.0;
uniform float normal_threshold_high = 0.02;
uniform float brighter_line = 5.0;
uniform float darker_line = 15.0; // Reduzido para preservar sombras
uniform float neg_sharpen = 5.0;
uniform float neg_threshold_low = 0.5;
uniform float neg_threshold_high = 0.5;

float GetLinearDepth(vec2 suv, sampler2D dephtexture, mat4 invProjectionMat) {
    float depth = texture(dephtexture, suv).x;
    vec3 dnc = vec3(suv * 2.0 - 1.0, depth);
    vec4 view = invProjectionMat * vec4(dnc, 1.0);
    view.xyz /= view.w;
    return -view.z;
}

vec3 GetNormal(vec2 suv) {
    vec3 normal = texture(normal_rough_texture, suv).rgb;
    return normal * 2.0 - 1.0;
}

float NormalEdgeIndicator(vec3 bias, vec3 base_normal, vec3 new_normal, float depth_diff) {
    float normal_diff = dot(base_normal - new_normal, bias);
    float normal_indicator = clamp(smoothstep(-0.01, 0.01, normal_diff), 0.0, 1.0);
    float depth_indicator = clamp(sign(depth_diff * 0.25 + 0.0025), 0.0, 1.0);
    return (1.0 - dot(base_normal, new_normal)) * depth_indicator * normal_indicator;
}

void vertex() {
    POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
    vec2 tSize = 1.0 / VIEWPORT_SIZE.xy;
    vec2 uv = floor(SCREEN_UV / pixel_size) * pixel_size; // Pixelizar UVs

    vec2 uv_offsets[4] = vec2[](
        vec2(-tSize.x, 0.0),
        vec2(tSize.x, 0.0),
        vec2(0.0, -tSize.y),
        vec2(0.0, tSize.y)
    );

    float center_depth = GetLinearDepth(uv, depth_texture, INV_PROJECTION_MATRIX);
    vec3 center_normal = GetNormal(uv);

    float depth_diff = 0.0;
    float neg_depth_diff = 0.5;
    float normal_diff = 0.0;

    for (int i = 0; i < uv_offsets.length(); i++) {
        vec2 offset_uv = uv + uv_offsets[i];
        float offset_depth = GetLinearDepth(offset_uv, depth_texture, INV_PROJECTION_MATRIX);
        vec3 neighbor_normal = GetNormal(offset_uv);

        depth_diff += clamp(offset_depth - center_depth, 0.0, 1.0);
        neg_depth_diff += clamp(center_depth - offset_depth, 0.0, 1.0);
        float offset_depth_diff = offset_depth - center_depth;
        normal_diff += NormalEdgeIndicator(normal_edge_bias, center_normal, neighbor_normal, offset_depth_diff);
    }

    float depth_edge = smoothstep(depth_threshold_low, depth_threshold_high, depth_diff);
    float neg_depth_edge = smoothstep(neg_threshold_low, neg_threshold_high, neg_depth_diff);
    neg_depth_edge *= neg_sharpen;
    neg_depth_edge = clamp(neg_depth_edge, 0.0, 1.0);

    float normal_edge = smoothstep(normal_threshold_low, normal_threshold_high, normal_diff);
    normal_edge -= neg_depth_edge;
    normal_edge = clamp(normal_edge, 0.0, 1.0);

    float inner_lines = clamp(normal_edge - depth_edge, 0.0, 1.0);

    vec3 albedo = texture(screen_texture, uv).rgb;
    albedo += inner_lines * brighter_line;
    albedo -= albedo * depth_edge * darker_line;

    ALBEDO = albedo;
}