-- ══════════════════════════════════════════════════════════════
--              WINDOW RULES, LAYER RULES & PERMISSIONS
--                   github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────────────
-- PERMISSIONS
-- ──────────────────────────────────────────────────────────────
hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/hyprpicker", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/hyprlock", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/lib/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })

-- ──────────────────────────────────────────────────────────────
-- LAYER RULES
-- ──────────────────────────────────────────────────────────────
hl.layer_rule({ name = "overlay-blur", match = { namespace = "waybar|rofi|notifications" }, blur = true, ignore_alpha = 0.1 })
hl.layer_rule({ name = "rofi-dim", match = { namespace = "rofi" }, dim_around = true })
hl.layer_rule({ name = "screen-select-no-anim", match = { namespace = "selection" }, no_anim = true })

-- ══════════════════════════════════════════════════════════════
--                       WINDOW RULES
-- ══════════════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────────────
-- WORKSPACE ROUTING
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "ws-browsing",
  match = { class = ".*(zen|firefox|[Bb]rowser).*" },
  workspace = 2,
})

hl.window_rule({
  name = "ws-media-productivity",
  match = { class = ".*(mpv|vlc|gimp|code|libreoffice|kdenlive|Foliate|rider).*" },
  workspace = 3,
})

hl.window_rule({
  name = "ws-gaming-entertainment",
  match = { class = ".*(steam|steam_app|cs2|dota2|Lutris|spotify|Minecraft).*" },
  workspace = 4,
})

hl.window_rule({
  name = "ws-proton-games",
  match = { xdg_tag = "proton-game" },
  workspace = 4,
})

hl.window_rule({
  name = "ws-productivity",
  match = { class = ".*(zoom|VirtualBox|Postman|dolphin|obsidian|java).*" },
  workspace = 4,
})

hl.window_rule({
  name = "ws-social",
  match = { class = ".*(vesktop|discord|signal|GitHub|telegram|qbittorrent).*" },
  workspace = 10,
})

-- ──────────────────────────────────────────────────────────────
-- FLOATING WINDOWS
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "float-term-ws1",
  match = { class = "kitty", workspace = 1 },
  float = true,
})

hl.window_rule({
  name = "float-by-title",
  match = { title = ".*(Okular|About|Picture-in-Picture|Open (File|Folder|Document)|Choose Files).*" },
  float = true,
})

hl.window_rule({
  name = "float-media-apps",
  match = { class = ".*(zen|firefox|mpv|vlc|imv|java|discord|Lutris|Lollypop|pupgui2).*" },
  float = true,
})

hl.window_rule({
  name = "float-config-apps",
  match = { class = ".*(nwg-look|qt[56]ct|zathura|qbittorrent|easyeffects|MissionCenter).*" },
  float = true,
})

hl.window_rule({
  name = "float-desktop-utils",
  match = {
    class = ".*(gnome|kde|keditfiletype).*",
    title = "negative:.*(Kdenlive|okular).*",
  },
  float = true,
})

hl.window_rule({
  name = "float-system-apps",
  match = { class = "(Zoom Workplace|xdg-desktop-portal-gtk|VirtualBox|waypaper).*" },
  float = true,
})

-- ──────────────────────────────────────────────────────────────
-- CENTERING & TILING
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "center-apps",
  match = {
    class = ".*(kitty|MissionCenter|pupgui2|Lollypop|Lutris|mpv|java|discord|imv|nomacs|easyeffects|nwg-look|qt[56]ct|zathura|gnome|kde).*",
  },
  center = true,
})

hl.window_rule({
  name = "tile-browsers",
  match = { title = "(Zen Browser|Mozilla Firefox|qBittorrent).*" },
  tile = true,
})

hl.window_rule({
  name = "tile-kompare",
  match = { class = "kompare.*", title = "Kompare" },
  tile = true,
})

-- ──────────────────────────────────────────────────────────────
-- FOCUS & IDLE
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "stay-focused-pinned",
  match = { class = ".*(hyprland-dialog|hyprland-donate-screen).*" },
  stay_focused = true,
  pin = true,
})

hl.window_rule({
  name = "stay-focused-about",
  match = { title = "About.*" },
  stay_focused = true,
})

hl.window_rule({
  name = "idle-inhibit-fullscreen",
  match = { class = ".*" },
  idle_inhibit = "fullscreen",
})

hl.window_rule({
  name = "idle-inhibit-music",
  match = { class = ".*Lollypop.*" },
  idle_inhibit = "focus",
})

-- ──────────────────────────────────────────────────────────────
-- MISC
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "no-blur-xwayland",
  match = { xwayland = true },
  no_blur = true,
})

hl.window_rule({
  name = "borderless-imv",
  match = { class = "imv" },
  border_size = 0,
})

hl.window_rule({
  name = "pin-missioncenter",
  match = { class = ".*MissionCenter.*" },
  pin = true,
})

hl.window_rule({
  name = "suppress-maximize",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- ──────────────────────────────────────────────────────────────
-- SIZING
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "size-large",
  match = { class = ".*(discord|vesktop).*" },
  size = { "monitor_w*0.72", "monitor_h*0.83" },
})

hl.window_rule({
  name = "size-mid",
  match = { class = ".*(Lutris|Lollypop|okular|MissionCenter).*" },
  size = { "monitor_w*0.64", "monitor_h*0.75" },
})

hl.window_rule({
  name = "size-mid-desktop",
  match = {
    class = ".*(gnome|kde).*",
    title = "negative:.*(Dolphin|About).*",
  },
  size = { "monitor_w*0.64", "monitor_h*0.75" },
})

hl.window_rule({
  name = "size-terminal",
  match = { title = ".*(kitty|ProtonUp-Qt -).*" },
  size = { "monitor_w*0.48", "monitor_h*0.56" },
})

hl.window_rule({
  name = "size-image-viewers",
  match = { class = ".*(imv|nomacs).*" },
  size = { "monitor_w*0.65", "monitor_h*0.65" },
})

hl.window_rule({
  name = "size-pdf",
  match = { class = ".*zathura.*" },
  size = { "monitor_w*0.72", "monitor_h*0.72" },
})

hl.window_rule({
  name = "size-audio",
  match = { class = ".*easyeffects.*" },
  size = { "monitor_w*0.78", "monitor_h*0.85" },
})

hl.window_rule({
  name = "size-pip",
  match = { title = "Picture-in-Picture" },
  size = { "monitor_w*0.55", "monitor_h*0.55" },
})

hl.window_rule({
  name = "size-theme",
  match = { class = ".*(qt[65]ct|nwg-look).*" },
  size = { "monitor_w*0.55", "monitor_h*0.65" },
})

-- ──────────────────────────────────────────────────────────────
-- KDE
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "kde-polkit",
  match = { class = "org.kde.polkit-kde-authentication-agent-1" },
  stay_focused = true,
})

hl.window_rule({
  name = "kompare-dialogs",
  match = { class = "kompare.*", title = ".*(About|Select|Compare).*" },
  float = true,
})

hl.window_rule({
  name = "kde-tile",
  match = {
    class = ".*(kid3|kdenlive).*",
    title = "negative:.*(Project|Open|Find|Configure|About).*",
  },
  tile = true,
})

-- ──────────────────────────────────────────────────────────────
-- DIALOGS
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "xdg-portal",
  match = { class = "xdg-desktop-portal-gtk" },
  center = true,
  size = { "monitor_w*0.54", "monitor_h*0.68" },
})

hl.window_rule({
  name = "save-dialogs",
  match = { title = "Save As.*" },
  center = true,
  size = { "monitor_w*0.54", "monitor_h*0.68" },
})

-- ──────────────────────────────────────────────────────────────
-- BROWSERS
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "browser-focus",
  match = { class = ".*(zen|firefox).*" },
  focus_on_activate = true,
})

hl.window_rule({
  name = "browser-focus-main",
  match = {
    class = ".*(zen|firefox).*",
    title = "negative:.*(Zen Browser|Mozilla Firefox).*",
  },
  stay_focused = false,
})

-- ──────────────────────────────────────────────────────────────
-- UTILITIES
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "kcolorchooser",
  match = { class = ".*kcolorchooser.*" },
  move = { "monitor_w*0.51", "monitor_h*-0.11" },
})

hl.window_rule({
  name = "timecanvas",
  match = { class = "TimeCanvas" },
  float = true,
  center = true,
})

hl.window_rule({
  name = "waypaper",
  match = { class = "waypaper" },
  opacity = 0.9,
  size = { "monitor_w*0.505", "monitor_h*0.58" },
  move = { "monitor_w*0.49", "monitor_h*0.41" },
})

-- ──────────────────────────────────────────────────────────────
-- qBITTORRENT
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "qbittorrent-dialogs",
  match = {
    class = ".*qBittorrent.*",
    title = "negative:qBittorrent.*",
  },
  center = true,
  stay_focused = true,
})

-- ──────────────────────────────────────────────────────────────
-- PROTONVPN
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "protonvpn-main",
  match = { class = "protonvpn.*" },
  float = true,
  center = true,
})

hl.window_rule({
  name = "protonvpn-notification",
  match = { class = "protonvpn.*", title = "Active connection.*" },
  size = { "monitor_w*0.30", "monitor_h*0.17" },
})

hl.window_rule({
  name = "protonvpn-window",
  match = { class = "protonvpn.*", title = "Proton VPN" },
  move = { "monitor_w*0.778", "monitor_h*0.035" },
})

-- ──────────────────────────────────────────────────────────────
-- VIRTUALBOX
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "virtualbox-vm",
  match = { class = "VirtualBox Machine" },
  fullscreen = true,
})

hl.window_rule({
  name = "virtualbox-settings",
  match = { class = "VirtualBox", title = "Settings.*" },
  center = true,
})

-- ──────────────────────────────────────────────────────────────
-- GIMP
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "gimp-export",
  match = { class = "file-png", title = "Export.*" },
  float = true,
})

hl.window_rule({
  name = "gimp-quit",
  match = { class = "gimp", title = "Quit.*" },
  stay_focused = true,
})

-- ──────────────────────────────────────────────────────────────
-- DOLPHIN
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "dolphin-float",
  match = { class = ".*dolphin.*" },
  float = true,
})

hl.window_rule({
  name = "dolphin-center",
  match = {
    class = ".*dolphin.*",
    title = "negative:.*Properties.*",
  },
  center = true,
})

hl.window_rule({
  name = "dolphin-home",
  match = { class = ".*dolphin.*", title = "Home.*" },
  size = { "monitor_w*0.7", "monitor_h*0.8" },
})

hl.window_rule({
  name = "dolphin-operations",
  match = {
    class = ".*dolphin.*",
    title = ".*(Copy|Moving|Compress|Extract).*",
  },
  move = { "monitor_w*0.005", "monitor_h*0.05" },
})

hl.window_rule({
  name = "dolphin-confirmations",
  match = {
    class = "org.kde.dolphin",
    title = ".*(File|Delete).*",
  },
  stay_focused = true,
})

-- ──────────────────────────────────────────────────────────────
-- STEAM
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "steam-games",
  match = { class = ".*(steam_app|cs2|dota2).*" },
  content = "game",
})

hl.window_rule({
  name = "steam-fullscreen",
  match = {
    content = 3,
    title = "negative:.*(Launcher|Options|Setup|Working).*",
  },
  fullscreen = true,
})

hl.window_rule({
  name = "steam-dialogs",
  match = { class = "steam", title = "negative:Steam" },
  float = true,
})

hl.window_rule({
  name = "steam-signin",
  match = { class = "steam", title = "Sign.*" },
  center = true,
})

hl.window_rule({
  name = "steam-rounding",
  match = { float = true, class = "steam" },
  rounding = 1,
})

hl.window_rule({
  name = "steam-no-focus-events",
  match = { class = "steam" },
  suppress_event = "activatefocus",
})

-- ──────────────────────────────────────────────────────────────
-- JETBRAINS
-- ──────────────────────────────────────────────────────────────
hl.window_rule({
  name = "jetbrains-welcome",
  match = { class = "jetbrains.*", title = "Welcome.*" },
  float = true,
  center = true,
  size = { "monitor_w*0.42", "monitor_h*0.40" },
})

hl.window_rule({
  name = "jetbrains-float-style",
  match = { float = true, class = "jetbrains.*" },
  rounding = 7,
  border_color = "rgba(56585B99)",
})

hl.window_rule({
  name = "jetbrains-confirmations",
  match = { class = "jetbrains.*", title = "Confirm.*" },
  stay_focused = true,
})

-- ──────────────────────────────────────────────────────────────
-- MISC
-- ──────────────────────────────────────────────────────────────
-- Fix some dragging issues with XWayland
hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

hl.window_rule({
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move = "20 monitor_h-120",
  float = true,
})
