-- ══════════════════════════════════════════════════════════════
--                    HYPRLAND CONFIG (LUA)
--                 github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════
-- Requires Hyprland >= 0.55. Each require() runs in its own scope,
-- so an error in one file won't stop the rest from loading.
--
-- core/    helpers, theme tokens, system, autostart
-- look/    style, animations, runtime modes (zen, vibrance)
-- binds/   keybinds split by area
-- rules/   window + layer rules
-- local    machine-specific overrides, always last
--
-- Named window rules run top to bottom and the last match wins,
-- so keep rules.* -> look.modes -> local in this order.

-- ──────────────────────────────────────────────────────────────
-- CORE
-- ──────────────────────────────────────────────────────────────
require("core.system") -- Monitors, input, gestures, render, permissions
require("core.autostart") -- Autostart programs

-- ──────────────────────────────────────────────────────────────
-- LOOK AND FEEL
-- ──────────────────────────────────────────────────────────────
require("look.style") -- Borders, blur, shadows, rounding
require("look.animations") -- Curves and animation rows

-- ──────────────────────────────────────────────────────────────
-- KEYBINDS
-- ──────────────────────────────────────────────────────────────
require("binds.apps") -- Launchers and rofi menus
require("binds.desktop") -- Windows, focus, workspaces, mouse
require("binds.system") -- Media, screenshots, wallpaper, session

-- ──────────────────────────────────────────────────────────────
-- RULES
-- ──────────────────────────────────────────────────────────────
require("rules.apps") -- Window rules for apps
require("rules.games") -- Games, Steam, Proton
require("rules.layers") -- Waybar, rofi, notifications

-- ──────────────────────────────────────────────────────────────
-- MODES & OVERRIDES
-- ──────────────────────────────────────────────────────────────
require("look.modes") -- Zen mode, vibrance toggle
require("local") -- Local / private overrides
