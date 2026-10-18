-- ══════════════════════════════════════════════════════════════
--                         RUNTIME MODES
--                 github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- SUPER + Z          zen mode (flat tiles, no gaps, random waybar preset)
-- SUPER + SHIFT + V  vibrance shader on/off
-- Both toggles flip a flag file (see U.flag in core/util.lua) and reload the
-- config, so they survive reloads and restarts.
-- Loaded after rules.* so the zen rule wins over the named ones.

local U = require("core.util")
local mod = "SUPER"

local function notify(text)
  hl.notification.create({ text = text, timeout = 2500, icon = "ok", color = "#0099BB" })
end

-- ──────────────────────────────────────────────────────────────
-- ZEN MODE
-- ──────────────────────────────────────────────────────────────
-- Entering zen picks a random waybar preset from ZEN_PRESETS,
-- leaving zen picks one from NORMAL_PRESETS (trim either list to taste).
local WAYMOD = os.getenv("HOME") .. "/.local/bin/waymod"
local WAYBAR_COLOR = "azure"

local ZEN_PRESETS = { "top", "top-modern", "top-roman", "top-rule", "stylish", "bottom" }
local NORMAL_PRESETS = { "top", "top-modern", "top-roman", "top-rule", "stylish", "bottom", "float", "dock", "slant", "side" }

math.randomseed(os.time())

local function random_waybar(presets)
  hl.exec_cmd(string.format("bash '%s' %s %s", WAYMOD, presets[math.random(#presets)], WAYBAR_COLOR))
end

local zen_on = U.flag("zen")

-- Applied on every (re)load while zen is on: no gaps, flat tiles
if zen_on then
  hl.config({ general = { gaps_in = 1, gaps_out = 0 } })
  hl.window_rule({ match = { float = false }, border_size = 0, rounding = 0, no_shadow = true })
end

hl.bind(mod .. " + Z", function()
  zen_on = not zen_on
  U.set_flag("zen", zen_on)
  random_waybar(zen_on and ZEN_PRESETS or NORMAL_PRESETS)
  notify("Zen: " .. (zen_on and "ON" or "OFF"))
  hl.exec_cmd("hyprctl reload")
end)

-- ──────────────────────────────────────────────────────────────
-- VIBRANCE
-- ──────────────────────────────────────────────────────────────
-- Any screen shader disables direct scanout, so turn it off for lowest-latency games.
-- look/style.lua sets the shader, or leaves it out while the flag is set.
local vibrance_on = not U.flag("vibrance-off")

hl.bind(mod .. " + SHIFT + V", function()
  vibrance_on = not vibrance_on
  U.set_flag("vibrance-off", not vibrance_on)
  notify("Vibrance: " .. (vibrance_on and "ON" or "OFF"))
  hl.exec_cmd("hyprctl reload")
end)
