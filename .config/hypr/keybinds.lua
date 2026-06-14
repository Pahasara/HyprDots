-- ══════════════════════════════════════════════════════════════
--                        KEYBINDINGS
--                   github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────────────
-- Paths & Environment
-- ──────────────────────────────────────────────────────────────
local HOME = os.getenv("HOME")
local BIN = os.getenv("XDG_BIN_HOME") or (HOME .. "/.local/bin")
local PICS = os.getenv("XDG_PICTURES_DIR") or (HOME .. "/Pictures")
local CFG = os.getenv("XDG_CONFIG_HOME") or (HOME .. "/.config")

local WALL_DIR = PICS .. "/Wallpapers"
local ROFI_PRE = CFG .. "/rofi/presets"

-- ──────────────────────────────────────────────────────────────
-- Helper Functions
-- ──────────────────────────────────────────────────────────────
local function exec(cmd)
  return hl.dsp.exec_cmd(cmd)
end
local function uwsm(app)
  return exec("uwsm-app -t service -- " .. app)
end

-- Toggles a process (kills if running, starts if not)
local function toggle(proc, cmd)
  return exec(string.format("pkill %s || %s", proc, cmd or proc))
end

-- ──────────────────────────────────────────────────────────────
-- Core Components & Utilities
-- ──────────────────────────────────────────────────────────────
local LAUNCHER = "rofi -show drun -run-command 'uwsm-app -- {cmd}'"
local POWER_MENU = string.format("rofi -show powermenu -modi powermenu:%s/rofi-powermenu -config %s/powermenu.rasi", BIN, ROFI_PRE)
local CALC = string.format("rofi -show calc -modi calc -no-show-match -no-sort -config %s/calculator.rasi | wl-copy", ROFI_PRE)
local CLIP = string.format("cliphist list | rofi -dmenu -display-columns 2 -config %s/clipboard.rasi | cliphist decode | wl-copy", ROFI_PRE)
local CLIP_DEL = string.format("cliphist list | rofi -dmenu -display-columns 2 -config %s/clipboard.rasi | cliphist delete", ROFI_PRE)
local EMOJI = string.format("rofi -modi emoji -show emoji -config %s/emoji.rasi", ROFI_PRE)

local SCREENSHOT = BIN .. "/grimblast"
local RANDOM_WALL = BIN .. "/random-wall"

-- ──────────────────────────────────────────────────────────────
-- Modifier & Core Binds
-- ──────────────────────────────────────────────────────────────
local mod = "SUPER"

-- Menus & Tools
hl.bind(mod .. " + X", toggle("rofi", POWER_MENU))
hl.bind(mod .. " + W", toggle("rofi", BIN .. "/rofi-wifi"))
hl.bind(mod .. " + C", toggle("rofi", CLIP))
hl.bind(mod .. " + V", toggle("rofi", CALC))
hl.bind(mod .. " + I", toggle("rofi", EMOJI))
hl.bind(mod .. " + SPACE", toggle("rofi", LAUNCHER))

hl.bind(mod .. " + P", toggle("hyprpicker", "hyprpicker -a"))
hl.bind(mod .. " + SHIFT + P", toggle("kcolorchooser"))
hl.bind(mod .. " + SHIFT + X", exec("loginctl lock-session"))
hl.bind(mod .. " + SHIFT + R", exec(CLIP_DEL))

-- Notifications
hl.bind(mod .. " + N", exec("dunstctl history-pop"))
hl.bind(mod .. " + SHIFT + N", exec("dunstctl close-all"))

-- ──────────────────────────────────────────────────────────────
-- Application Launchers
-- ──────────────────────────────────────────────────────────────
hl.bind(mod .. " + RETURN", uwsm("kitty"))
hl.bind(mod .. " + B", uwsm("firefox"))
hl.bind(mod .. " + E", uwsm("dolphin"))
hl.bind(mod .. " + SHIFT + E", uwsm("foliate"))
hl.bind(mod .. " + D", uwsm("rider"))
hl.bind(mod .. " + O", uwsm("obsidian"))
hl.bind(mod .. " + SHIFT + O", exec("obs"))
hl.bind(mod .. " + S", uwsm("steam"))
hl.bind(mod .. " + T", uwsm("qbittorrent"))
hl.bind(mod .. " + G", uwsm("github-desktop"))
hl.bind(mod .. " + SHIFT + G", uwsm("obs"))
hl.bind(mod .. " + SHIFT + I", uwsm("gimp"))
hl.bind(mod .. " + A", uwsm("lutris"))
hl.bind(mod .. " + SLASH", uwsm("code"))
hl.bind(mod .. " + SEMICOLON", uwsm("signal-desktop"))
hl.bind(mod .. " + APOSTROPHE", uwsm("discord"))
hl.bind(mod .. " + U", uwsm("libreoffice --writer"))
hl.bind(mod .. " + SHIFT + U", uwsm("postman"))
hl.bind(mod .. " + Y", uwsm("okular"))
hl.bind(mod .. " + BACKSPACE", uwsm("timecanvas"))
hl.bind(mod .. " + SHIFT + BACKSPACE", uwsm("protonplus"))
hl.bind(mod .. " + SHIFT + SPACE", uwsm("protonvpn-app"))
hl.bind(mod .. " + GRAVE", toggle("missioncenter", "uwsm-app -t service -- missioncenter"))

-- ──────────────────────────────────────────────────────────────
-- Window Management
-- ──────────────────────────────────────────────────────────────
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + C", hl.dsp.window.center())
hl.bind(mod .. " + SHIFT + D", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + F12", hl.dsp.window.pin())

-- Focus & Movement
local dirs = { h = "left", l = "right", k = "up", j = "down" }
for key, dir in pairs(dirs) do
  hl.bind(mod .. " + " .. key:upper(), hl.dsp.focus({ direction = dir }))
  hl.bind(mod .. " + SHIFT + " .. key:upper(), hl.dsp.window.move({ direction = dir }))
end

-- Resizing
hl.bind(mod .. " + CONTROL + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CONTROL + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CONTROL + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mod .. " + CONTROL + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

-- ──────────────────────────────────────────────────────────────
-- Workspaces
-- ──────────────────────────────────────────────────────────────
for i = 1, 9 do
  hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
hl.bind(mod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

-- Magic (Special) Workspace
hl.bind(mod .. " + M", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.window.move({ workspace = "special:magic" }))

-- ──────────────────────────────────────────────────────────────
-- Media & Hardware
-- ──────────────────────────────────────────────────────────────
hl.bind("XF86MonBrightnessUp", exec(BIN .. "/brightness up"), { repeating = true })
hl.bind("XF86MonBrightnessDown", exec(BIN .. "/brightness down"), { repeating = true })
hl.bind("XF86AudioMicMute", exec(BIN .. "/volume mic"))
hl.bind("XF86AudioMute", exec(BIN .. "/volume mute"), { locked = true })
hl.bind("XF86AudioRaiseVolume", exec(BIN .. "/volume up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", exec(BIN .. "/volume down"), { locked = true, repeating = true })

-- Player Controls
hl.bind(mod .. " + MINUS", exec("playerctl position 10-"), { repeating = true })
hl.bind(mod .. " + EQUAL", exec("playerctl position 10+"), { repeating = true })
hl.bind(mod .. " + BRACKETLEFT", exec("playerctl volume 0.020-"), { repeating = true })
hl.bind(mod .. " + BRACKETRIGHT", exec("playerctl volume 0.020+"), { repeating = true })
hl.bind(mod .. " + SHIFT + BRACKETLEFT", exec(BIN .. "/player previous_track"))
hl.bind(mod .. " + SHIFT + BRACKETRIGHT", exec(BIN .. "/player next_track"))
hl.bind(mod .. " + BACKSLASH", uwsm("lollypop"))
hl.bind(mod .. " + SHIFT + BACKSLASH", exec(BIN .. "/player toggle_play"), { locked = true })

-- Screenshots
hl.bind("Print", exec(SCREENSHOT .. " save screen"), { locked = true })
hl.bind("SHIFT + Print", exec(SCREENSHOT .. " --cursor save screen"), { locked = true })
hl.bind("ALT + Print", exec(SCREENSHOT .. " save area"))

-- ──────────────────────────────────────────────────────────────
-- Custom Toggles & Wallpaper
-- ──────────────────────────────────────────────────────────────
hl.bind(mod .. " + Z", exec(BIN .. "/zen-mode"))
hl.bind(mod .. " + SHIFT + V", exec(BIN .. "/vibrance-toggle"))
hl.bind(mod .. " + COMMA", exec(RANDOM_WALL))
hl.bind(mod .. " + PERIOD", toggle("waypaper", "uwsm-app -t service -- waypaper"))

-- Wallpapers by Category
local wall_cats = {
  [1] = "Anime",
  [2] = "Old-G",
  [3] = "MOBA",
  [4] = "DOTA",
  [5] = "Green",
  [6] = "Cute",
  [7] = "League",
  [8] = "DC",
  [9] = "Tech",
  [0] = "Other",
}
for num, cat in pairs(wall_cats) do
  hl.bind(mod .. " + CTRL + " .. num, exec(string.format("%s %s/%s", RANDOM_WALL, WALL_DIR, cat)))
end

-- System / Session
hl.bind(mod .. " + SHIFT + W", exec("killall -SIGUSR1 waybar"))
hl.bind(mod .. " + SHIFT + B", uwsm(CFG .. "/waybar/waybar.sh"))
hl.bind(mod .. " + SHIFT + ESCAPE", exec("uwsm stop"))

-- Mouse Binds
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
