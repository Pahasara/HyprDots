-- ══════════════════════════════════════════════════════════════
--                          LAYER RULES
--                  github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- Waybar, rofi, notifications, screenshot overlay.

hl.layer_rule({
  name = "glass-layers",
  match = { namespace = "waybar|rofi|notifications" },
  blur = true,
  ignore_alpha = 0.1,
})

hl.layer_rule({
  name = "rofi",
  match = { namespace = "rofi" },
  dim_around = true,
})

hl.layer_rule({
  name = "no-anim-selection",
  match = { namespace = "selection" },
  no_anim = true,
})
