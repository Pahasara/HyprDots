-- ══════════════════════════════════════════════════════════════
--                         LOOK AND FEEL
--                  github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- Colors and sizes come from core/theme.lua

local T = require("core.theme")
local U = require("core.util")

-- ──────────────────────────────────────────────────────────────
-- GENERAL, DECORATION & BLUR
-- ──────────────────────────────────────────────────────────────
hl.config({
  general = {
    gaps_in = T.gaps_in,
    gaps_out = T.gaps_out,
    border_size = T.border,
    layout = "dwindle",
    allow_tearing = false,
    col = {
      active_border = T.border_active,
      inactive_border = T.border_inactive,
    },
  },

  decoration = {
    rounding = T.rounding,
    rounding_power = 8,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    screen_shader = (not U.flag("vibrance-off")) and T.shader or nil, -- toggled in look/modes.lua

    shadow = {
      enabled = true,
      range = 100,
      render_power = 4,
      offset = { 1, 2 },
      scale = 1.00,
      color = T.shadow_active,
      color_inactive = T.shadow_inactive,
    },

    blur = {
      enabled = true,
      -- variant = T.blur_variant,
      size = 4,
      passes = 3,
      brightness = 0.8172,
      contrast = 1.0,
      vibrancy = 0.1696,
      vibrancy_darkness = 0.2,
      ignore_opacity = true,
      xray = false,
      special = true,
    },

    -- glow = { enabled = true, range = 10, color = T.rgba(T.cyan, "22") },
  },

  dwindle = { preserve_split = true },
})
