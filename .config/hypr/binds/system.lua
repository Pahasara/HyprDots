-- ══════════════════════════════════════════════════════════════
--                   KEYBINDS / MEDIA & SYSTEM
--                  github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- Zen and vibrance toggles live in look/modes.lua

local U = require("core.util")
local mod = "SUPER"

local HOME = os.getenv("HOME")
local BIN = os.getenv("XDG_BIN_HOME") or (HOME .. "/.local/bin")
local PICS = os.getenv("XDG_PICTURES_DIR") or (HOME .. "/Pictures")
local CFG = os.getenv("XDG_CONFIG_HOME") or (HOME .. "/.config")

-- ──────────────────────────────────────────────────────────────
-- BRIGHTNESS & VOLUME
-- ──────────────────────────────────────────────────────────────
-- stylua: ignore start
hl.bind("XF86MonBrightnessUp",   U.exec(BIN .. "/brightness up"),   { repeating = true })
hl.bind("XF86MonBrightnessDown", U.exec(BIN .. "/brightness down"), { repeating = true })
hl.bind("XF86AudioMicMute",      U.exec(BIN .. "/volume mic"))
hl.bind("XF86AudioMute",         U.exec(BIN .. "/volume mute"), { locked = true })
hl.bind("XF86AudioRaiseVolume",  U.exec(BIN .. "/volume up"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  U.exec(BIN .. "/volume down"), { locked = true, repeating = true })

-- ──────────────────────────────────────────────────────────────
-- PLAYER CONTROLS
-- ──────────────────────────────────────────────────────────────
hl.bind(mod .. " + MINUS",                U.exec("playerctl position 10-"),     { repeating = true })
hl.bind(mod .. " + EQUAL",                U.exec("playerctl position 10+"),     { repeating = true })
hl.bind(mod .. " + BRACKETLEFT",          U.exec("playerctl volume 0.020-"),    { repeating = true })
hl.bind(mod .. " + BRACKETRIGHT",         U.exec("playerctl volume 0.020+"),    { repeating = true })
hl.bind(mod .. " + SHIFT + BRACKETLEFT",  U.exec(BIN .. "/player previous_track"))
hl.bind(mod .. " + SHIFT + BRACKETRIGHT", U.exec(BIN .. "/player next_track"))
hl.bind(mod .. " + SHIFT + BACKSLASH",    U.exec(BIN .. "/player toggle_play"), { locked = true })

-- ──────────────────────────────────────────────────────────────
-- SCREENSHOTS
-- ──────────────────────────────────────────────────────────────
local SHOT = BIN .. "/grimblast"
hl.bind("Print",         U.exec(SHOT .. " save screen"),          { locked = true })
hl.bind("SHIFT + Print", U.exec(SHOT .. " --cursor save screen"), { locked = true })
hl.bind("ALT + Print",   U.exec(SHOT .. " save area"))
-- stylua: ignore end

-- ──────────────────────────────────────────────────────────────
-- WALLPAPER
-- ──────────────────────────────────────────────────────────────
local RANDOM_WALL = BIN .. "/random-wall"
hl.bind(mod .. " + COMMA", U.exec(RANDOM_WALL))
hl.bind(
  mod .. " + SHIFT + COMMA",
  U.exec("systemctl --user enable --now wallpaper-rotate.timer && dunstify -i configure 'Wallpaper Rotator' 'Rotation Enabled'")
)
hl.bind(
  mod .. " + SHIFT + PERIOD",
  U.exec("systemctl --user disable --now wallpaper-rotate.timer && dunstify -i configure-red 'Wallpaper Rotator' 'Rotation Disabled'")
)

-- SUPER+CTRL+1..9,0 -> random wallpaper from that folder
local walls = { "Anime", "Old-G", "MOBA", "DOTA", "Green", "Cute", "League", "DC", "Tech", "Other" }
for i, cat in ipairs(walls) do
  hl.bind(mod .. " + CTRL + " .. (i % 10), U.exec(string.format("%s %s/Wallpapers/%s", RANDOM_WALL, PICS, cat)))
end

-- ──────────────────────────────────────────────────────────────
-- SYSTEM / SESSION
-- ──────────────────────────────────────────────────────────────
hl.bind(mod .. " + SHIFT + W", U.exec("killall -SIGUSR1 waybar"))
hl.bind(mod .. " + SHIFT + B", U.uwsm(CFG .. "/waybar/waybar.sh"))
hl.bind(mod .. " + SHIFT + ESCAPE", U.exec("uwsm stop"))
