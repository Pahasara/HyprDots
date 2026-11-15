-- ══════════════════════════════════════════════════════════════
--                    KEYBINDS / APPS & MENUS
--                  github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- One row per app: add or remove freely.

local U = require("core.util")
local mod = "SUPER"

local HOME = os.getenv("HOME")
local BIN = os.getenv("XDG_BIN_HOME") or (HOME .. "/.local/bin")
local CFG = os.getenv("XDG_CONFIG_HOME") or (HOME .. "/.config")
local ROFI = CFG .. "/rofi/presets"

-- ──────────────────────────────────────────────────────────────
-- ROFI MENUS
-- ──────────────────────────────────────────────────────────────
-- Press again to close.
-- Each row is { key, animation mode (see rules/layers.lua), command }.
local L = require("rules.layers") -- rofi_mode() lives here

local menus = {
  { "X", "power", string.format("rofi -show powermenu -modi powermenu:%s/rofi-powermenu -config %s/powermenu.rasi", BIN, ROFI) },
  { "W", "wifi", BIN .. "/rofi-wifi" },
  { "C", "clipboard", string.format("cliphist list | rofi -dmenu -display-columns 2 -config %s/clipboard.rasi | cliphist decode | wl-copy", ROFI) },
  { "V", "calc", BIN .. "/rofi-calc" },
  { "I", "emoji", string.format("rofi -modi emoji -show emoji -config %s/emoji.rasi", ROFI) },
  { "SPACE", "launcher", "rofi -show drun -run-command 'uwsm-app -- {cmd}'" },
}

-- run whatever U.toggle() returned, whether it's a plain function or a dispatcher object
local function run(action)
  if type(action) == "function" then
    action() -- already callable
  else
    hl.dispatch(action) -- dispatcher object
  end
end

for _, m in ipairs(menus) do
  local action = U.toggle("rofi", m[3]) -- your existing toggle helper, unchanged
  hl.bind(mod .. " + " .. m[1], function()
    L.rofi_mode(m[2]) -- pick this menu's slide direction first
    run(action) -- then open/close it exactly as before
  end)
end

-- ──────────────────────────────────────────────────────────────
-- QUICK TOOLS
-- ──────────────────────────────────────────────────────────────
hl.bind(mod .. " + P", U.toggle("hyprpicker", "hyprpicker -a"))
hl.bind(mod .. " + SHIFT + P", U.toggle("kcolorchooser"))
hl.bind(mod .. " + SHIFT + X", U.exec("loginctl lock-session"))
hl.bind(mod .. " + N", U.exec("dunstctl history-pop"))
hl.bind(mod .. " + SHIFT + N", U.exec("dunstctl close-all"))

-- ──────────────────────────────────────────────────────────────
-- APPLICATION LAUNCHERS
-- ──────────────────────────────────────────────────────────────
-- Each row is { key, command }, started in a uwsm service scope.
local STEAM = "env STEAM_RUNTIME=0 /usr/bin/steam -compat-force-slr off"
local MUSIC = "env GTK_THEME='Glassy-Originals-Gtk-Black-Dark:dark' lollypop"
local PLAYER = "mpv --player-operation-mode=pseudo-gui"

-- stylua: ignore start
local launch = {
  { "RETURN",            "kitty" },
  { "SLASH",             "code" },
  { "BACKSLASH",         MUSIC },
  { "A",                 PLAYER },
  { "B",                 "firefox" },
  { "D",                 "rider" },
  { "E",                 "dolphin" },
  { "G",                 "faugus-launcher" },
  { "SHIFT + G",         "github-desktop" },
  { "SHIFT + I",         "gimp" },
  { "O",                 "obsidian" },
  { "SHIFT + O",         "obs" },
  { "S",                 STEAM },
  { "T",                 "qbittorrent" },
  { "U",                 "foliate" },
  { "SHIFT + U",         "libreoffice --writer" },
  { "Y",                 "okular" },
  { "SHIFT + Y",         "postman" },
  { "SHIFT + SPACE",     "protonvpn-app" },
  { "SHIFT + BACKSPACE", "protonplus" },
  { "APOSTROPHE",        "discord" },
  { "SEMICOLON",         "signal-desktop" },
}
-- stylua: ignore end

for _, l in ipairs(launch) do
  hl.bind(mod .. " + " .. l[1], U.uwsm(l[2]))
end

-- ──────────────────────────────────────────────────────────────
-- TOGGLE APPS
-- ──────────────────────────────────────────────────────────────
-- Press again to quit.
hl.bind(mod .. " + BACKSPACE", U.toggle("timecanvas", U.uwsm_cmd("timecanvas")))
hl.bind(mod .. " + GRAVE", U.toggle("missioncenter", U.uwsm_cmd("missioncenter")))
hl.bind(mod .. " + PERIOD", U.toggle("waypaper", U.uwsm_cmd("waypaper")))
