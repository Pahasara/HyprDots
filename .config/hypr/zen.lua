-- ══════════════════════════════════════════════════════════════
--                        ZEN MODE CONFIG
--                   github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════
-- Uncomment `require("zen")` in hyprland.lua to activate,
-- or toggle it at runtime via your $ZEN_MODE script.


hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 0,
    },
})

-- Remove borders and shadows from tiled windows
hl.window_rule({ match = { float = false }, border_size = 0 })
hl.window_rule({ match = { float = false }, rounding    = 0 })
hl.window_rule({ match = { float = false }, no_shadow   = true })

-- Steam tiled windows also get flat look
hl.window_rule({ match = { float = false, class = "steam" }, rounding = 0 })
