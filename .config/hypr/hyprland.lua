-- ══════════════════════════════════════════════════════════════
--                    HYPRLAND CONFIG (Lua)
--              Migrated from hyprlang → Hyprland v0.55
--                   github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════
--
-- Files are loaded in separate scopes; errors in one won't
-- stop the rest from loading. See: https://wiki.hypr.land/Configuring/Start/

require("general") -- Look & feel, monitors, animations, input
require("execs") -- Variables, env, autostart
require("keybinds") -- Keybindings
require("rules") -- Window rules, layer rules, permissions
require("local") -- Local / private overrides
-- require("zen")    -- Zen mode (uncomment to enable)
