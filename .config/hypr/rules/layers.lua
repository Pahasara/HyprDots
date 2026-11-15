-- ══════════════════════════════════════════════════════════════
--                          LAYER RULES
--                  github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- Waybar, rofi, notifications, screenshot overlay.

local M = {}

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

-- ──────────────────────────────────────────────────────────────
-- SLIDE DIRECTION
-- ──────────────────────────────────────────────────────────────
-- Plain "slide" no longer picks the nearest edge, so force a side.

hl.layer_rule({ name = "slide-waybar", match = { namespace = "waybar" }, animation = "slide top" })
hl.layer_rule({ name = "slide-notifications", match = { namespace = "notifications" }, animation = "slide right" })

-- Every rofi menu shares one namespace, so each gets its own rule.
-- Each row is { style, open speed, close speed }; only the opened menu's rule stays enabled.
-- stylua: ignore start
local rofi_anim = {
  launcher  = { "popin 60%",   6.5, 8 },
  power     = { "slide right", 1.5, 1.5 },
  wifi      = { "slide right", 6.5, 8 },
  clipboard = { "slide right", 6.5, 8 },
  calc      = { "popin 60%",   6.5, 8 },
  emoji     = { "slide right", 6.5, 8 },
}
-- stylua: ignore end

local rofi_rules = {}
for name, a in pairs(rofi_anim) do
  rofi_rules[name] = hl.layer_rule({
    name = "rofi-" .. name,
    match = { namespace = "rofi" },
    animation = a[1],
  })
end

function M.rofi_mode(mode)
  for name, rule in pairs(rofi_rules) do
    rule:set_enabled(name == mode)
  end
  local a = rofi_anim[mode]
  hl.animation({ leaf = "layersIn", enabled = true, speed = a[2], bezier = "snap", style = "slide" })
  hl.animation({ leaf = "layersOut", enabled = true, speed = a[3], bezier = "snap", style = "slide" })
end

M.rofi_mode("launcher")

return M
