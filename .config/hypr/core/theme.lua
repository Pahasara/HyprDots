-- ══════════════════════════════════════════════════════════════
--                          THEME TOKENS
--                  github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- Change the whole look from this one file.

local T = {}

function T.rgba(hex, alpha)
  return string.format("rgba(%s%s)", hex, alpha)
end
-- stylua: ignore start

-- ──────────────────────────────────────────────────────────────
-- PALETTE
-- ──────────────────────────────────────────────────────────────
-- Cyan to azure on active borders, steel-blue inactive, blue-black shadows.
T.cyan  = "33C7FF"
T.azure = "3D7BFF"
T.steel = "6E8CB8"
T.ink   = "030A18"

-- ──────────────────────────────────────────────────────────────
-- GEOMETRY
-- ──────────────────────────────────────────────────────────────
T.gaps_in  = 5
T.gaps_out = 25
T.border   = 2
T.rounding = 18

-- ──────────────────────────────────────────────────────────────
-- BORDERS
-- ──────────────────────────────────────────────────────────────
T.border_active   = { colors = { T.rgba(T.cyan, "EE"), T.rgba(T.azure, "EE") }, angle = 45 }
T.border_inactive = T.rgba(T.steel, "55")

-- ──────────────────────────────────────────────────────────────
-- SHADOWS
-- ──────────────────────────────────────────────────────────────
T.shadow_active   = T.rgba(T.ink, "BB")
T.shadow_inactive = T.rgba(T.ink, "66")

-- ──────────────────────────────────────────────────────────────
-- EFFECTS
-- ──────────────────────────────────────────────────────────────
T.shader       = "vibrance.frag"  -- screen shader (toggle: SUPER+SHIFT+V)
T.blur_variant = "kawase"
-- stylua: ignore end

return T
