-- ══════════════════════════════════════════════════════════════
--                      WINDOW RULES / APPS
--                  github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- All rules are named. Named rules run top to bottom, last match wins,
-- so the order is intentional: route, float, center, tile, focus, sizes, per-app.

local U = require("core.util")
local rule, any, frac = U.rule, U.any, U.frac

-- ──────────────────────────────────────────────────────────────
-- WORKSPACE ROUTING
-- ──────────────────────────────────────────────────────────────
local route = {
  { 2, { "firefox", "[Bb]rowser" } },
  { 3, { "mpv", "vlc", "gimp", "VSCode", "libreoffice", "kdenlive", "Foliate", "rider" } },
  { 4, { "dota2", "heroic", "Faugus", "spotify", "zoom", "Postman", "Obsidian" } },
  { 10, { "discord", "signal", "GitHub", "telegram", "qbittorrent" } },
}
for _, r in ipairs(route) do
  rule("route-ws" .. r[1], { class = any(r[2]) }, { workspace = r[1] })
end

-- ──────────────────────────────────────────────────────────────
-- FLOATING WINDOWS
-- ──────────────────────────────────────────────────────────────
rule("float-kitty-ws1", { class = "kitty", workspace = 1 }, { float = true })

rule("float-by-title", { title = ".*(DvNET|float|About|Picture-in-Picture|Open (File|Folder|Document)|Choose Files).*" }, { float = true })

-- stylua: ignore start
rule("float-by-class", { class = any({
  "DvNET", "zen", "firefox", "mpv", "vlc", "imv", "java", "discord", "Lollypop",
  "Proton", "nwg-look", "qt[56]ct", "zathura", "qbittorrent", "easyeffects",
  "MissionCenter", "Zoom Workplace", "xdg-desktop-portal-gtk", "waypaper",
}) }, { float = true })
-- stylua: ignore end

rule("float-kde-gnome", { class = any({ "gnome", "kde", "keditfiletype" }), title = "negative:.*(Kdenlive|okular).*" }, { float = true })

-- ──────────────────────────────────────────────────────────────
-- CENTERING
-- ──────────────────────────────────────────────────────────────
rule("center-common", { class = any({ "mpv", "java", "qt[56]ct", "zathura", "gnome", "kde" }) }, { center = true })

-- ──────────────────────────────────────────────────────────────
-- TILING EXCEPTIONS
-- ──────────────────────────────────────────────────────────────
-- Main windows of apps that otherwise float.
-- Browsers float by class (popups, dialogs); the main window tiles by title.
rule("tile-main-windows", { title = "(Mozilla Firefox|qBittorrent).*" }, { tile = true })
rule("tile-kompare", { class = "kompare.*", title = "Kompare" }, { tile = true })
rule("tile-kde-editors", { class = any({ "kid3", "kdenlive" }), title = "negative:.*(Project|Open|Find|Configure|About).*" }, { tile = true })
rule("float-kompare-dialogs", { class = "kompare.*", title = ".*(About|Select|Compare).*" }, { float = true })

-- ──────────────────────────────────────────────────────────────
-- FOCUS & IDLE
-- ──────────────────────────────────────────────────────────────
rule("system-dialogs", { class = any({ "hyprland-dialog", "hyprland-donate-screen" }) }, { stay_focused = true, pin = true })
rule("stay-focused-about", { title = "About.*" }, { stay_focused = true })
rule("kde-polkit", { class = "org.kde.polkit-kde-authentication-agent-1" }, { stay_focused = true })

rule("idle-inhibit-fullscreen", { class = ".*" }, { idle_inhibit = "fullscreen" })
rule("idle-inhibit-music", { class = ".*Lollypop" }, { idle_inhibit = "focus" })
rule("suppress-maximize", { class = ".*" }, { suppress_event = "maximize" })
rule("browser-focus-on-activate", { class = any({ "zen", "firefox" }) }, { focus_on_activate = true })

-- ──────────────────────────────────────────────────────────────
-- VISUAL TWEAKS
-- ──────────────────────────────────────────────────────────────
rule("no-blur-xwayland", { xwayland = true }, { no_blur = true })
rule("borderless-imv", { class = "imv" }, { border_size = 0 })
rule("pin-missioncenter", { class = ".*MissionCenter" }, { pin = true })

-- ──────────────────────────────────────────────────────────────
-- SIZING
-- ──────────────────────────────────────────────────────────────
-- Each row is { name, match, width, height, extra effects? }.
local sizes = {
-- stylua: ignore start
  { "discord",   { class = any({ "discord" }) },                            0.72, 0.83 },
  { "mid-apps",  { class = any({ "Lollypop", "okular", "MissionCenter" }) }, 0.64, 0.75 },
  { "kde-gnome", { class = any({ "gnome", "kde" }), title = "negative:.*(Dolphin|About).*" }, 0.64, 0.75 },
  { "terminal",  { title = "kitty" },                                       0.48, 0.56 },
  { "imv",       { class = "imv" },                                         0.65, 0.65 },
  { "zathura",   { class = ".*zathura" },                                   0.72, 0.72 },
  { "easyeffects", { class = ".*easyeffects" },                             0.78, 0.85 },
  { "pip",       { title = "Picture-in-Picture" },                          0.55, 0.55 },
  { "theme-tools", { class = any({ "qt[65]ct", "nwg-look" }) },             0.55, 0.65 },
  { "portal",    { class = "xdg-desktop-portal-gtk" },                      0.54, 0.68, { center = true } },
  { "save-as",   { title = "Save As.*" },                                   0.54, 0.68, { center = true } },
}
-- stylua: ignore end
for _, s in ipairs(sizes) do
  local fx = s[5] or {}
  fx.size = frac(s[3], s[4])
  rule("size-" .. s[1], s[2], fx)
end

-- ══════════════════════════════════════════════════════════════
--                         PER-APP RULES
-- ══════════════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────────────
-- DOLPHIN
-- ──────────────────────────────────────────────────────────────
rule("dolphin-float", { class = ".*dolphin.*" }, { float = true })
rule("dolphin-center", { class = ".*dolphin.*", title = "negative:.*Properties.*" }, { center = true })
rule("dolphin-home", { class = ".*dolphin.*", title = "Home.*" }, { workspace = 4, size = frac(0.7, 0.8) })
rule("dolphin-progress", { class = ".*dolphin.*", title = ".*(Copy|Moving|Compress|Extract).*" }, { move = frac(0.005, 0.05) })
rule("dolphin-confirm", { class = "org.kde.dolphin", title = ".*(File|Delete).*" }, { stay_focused = true })

-- ──────────────────────────────────────────────────────────────
-- QBITTORRENT
-- ──────────────────────────────────────────────────────────────
rule("qbittorrent-dialogs", { class = ".*qBittorrent.*", title = "negative:qBittorrent.*" }, { center = true, stay_focused = true })

-- ──────────────────────────────────────────────────────────────
-- PROTONVPN
-- ──────────────────────────────────────────────────────────────
rule("protonvpn", { class = "protonvpn.*" }, { float = true, center = true })
rule("protonvpn-status", { class = "protonvpn.*", title = "Active connection.*" }, { size = frac(0.30, 0.17) })
rule("protonvpn-main", { class = "protonvpn.*", title = "Proton VPN" }, { move = frac(0.778, 0.035) })

-- ──────────────────────────────────────────────────────────────
-- GIMP
-- ──────────────────────────────────────────────────────────────
rule("gimp-export", { class = "file-png", title = "Export.*" }, { float = true })
rule("gimp-quit", { class = "gimp", title = "Quit.*" }, { stay_focused = true })

-- ──────────────────────────────────────────────────────────────
-- JETBRAINS
-- ──────────────────────────────────────────────────────────────
rule("jetbrains-splash", { class = "jetbrains.*", title = "splash" }, { float = true, center = true })
rule("jetbrains-welcome", { class = "jetbrains.*", title = "Welcome.*" }, { float = true, center = true, size = frac(0.42, 0.40) })
rule("jetbrains-floating", { class = "jetbrains.*", float = true }, { rounding = 7, border_color = "rgba(56585B99)" })
rule("jetbrains-confirm", { class = "jetbrains.*", title = "Confirm.*" }, { stay_focused = true })

-- ──────────────────────────────────────────────────────────────
-- UTILITIES
-- ──────────────────────────────────────────────────────────────
rule("timecanvas", { class = "TimeCanvas" }, { float = true, center = true })
rule("kcolorchooser", { class = ".*kcolorchooser.*" }, { move = frac(0.51, -0.11) })
rule("waypaper", { class = "waypaper" }, { opacity = 0.9, size = frac(0.505, 0.58), move = frac(0.49, 0.41) })
rule("hyprland-run", { class = "hyprland-run" }, { float = true, move = "20 monitor_h-120" })

-- XWayland ghost windows: stop them stealing focus while dragging
rule("fix-xwayland-drags", { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }, { no_focus = true })
