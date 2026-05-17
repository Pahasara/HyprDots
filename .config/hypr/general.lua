-- ══════════════════════════════════════════════════════════════
--                   GENERAL / LOOK AND FEEL
--                 github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────────────
-- MONITORS
-- ──────────────────────────────────────────────────────────────
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = "1" })
hl.monitor({ output = "", mode = "preferred", position = "0x0", scale = "1", mirror = "eDP-1" }) -- Mirrored display / projector

-- ──────────────────────────────────────────────────────────────
-- SECURITY
-- ──────────────────────────────────────────────────────────────
hl.config({
  ecosystem = {
    enforce_permissions = true,
  },
})

-- ──────────────────────────────────────────────────────────────
-- LOOK AND FEEL
-- ──────────────────────────────────────────────────────────────
hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 25,
    border_size = 2,
    layout = "dwindle",
    allow_tearing = false,

    col = {
      active_border = "rgba(00BBFFAA)",
      inactive_border = "rgba(00AADD44)",
    },
  },

  decoration = {
    rounding = 12,
    rounding_power = 4,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    screen_shader = "vibrance.frag", -- Enhances color vibrancy

    shadow = {
      enabled = true,
      range = 150,
      render_power = 4,
      offset = { 0, 12 },
      color = "rgba(1a1a1aaf)",
      color_inactive = "rgba(1a1a1a88)",
      scale = 0.98,
    },

    blur = {
      enabled = true,
      size = 4,
      passes = 3,
      contrast = 1.0,
      brightness = 0.8172,
      vibrancy = 0.1696,
      vibrancy_darkness = 0.2,
      ignore_opacity = true,
      special = true,
    },
  },
})

-- ──────────────────────────────────────────────────────────────
-- ANIMATIONS
-- ──────────────────────────────────────────────────────────────
hl.config({ animations = { enabled = true } })

-- Curves
hl.curve("md3_standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
hl.curve("md3_decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("md3_accel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.02 } } })

hl.curve("spring_snappy", { type = "spring", mass = 1, stiffness = 80, dampening = 16 })
hl.curve("weighted_decel", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1 } } })
hl.curve("snap_curve", { type = "bezier", points = { { 0.1, 1 }, { 0, 1 } } })

hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.0 }, { 0.1, 1.0 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.1, 1.0 }, { 0.1, 1.0 } } })

-- Window animations
hl.animation({ leaf = "windows", enabled = true, speed = 4, spring = "spring_snappy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "md3_decel", style = "popin 70%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "md3_accel", style = "popin 70%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "overshot" })

-- Fade animations
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "md3_standard" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3.0, bezier = "md3_decel" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2.0, bezier = "md3_accel" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 3.0, bezier = "md3_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.0, bezier = "md3_accel" })

-- Layers
hl.animation({ leaf = "layers", enabled = true, speed = 6.5, bezier = "md3_standard", style = "fade" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 6.5, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 8.0, bezier = "winOut", style = "slide" })

-- Workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 5.0, bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 7.0, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 7.0, bezier = "winOut", style = "slide" })

-- Special workspace
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4.0, bezier = "md3_decel", style = "slide" })

-- ──────────────────────────────────────────────────────────────
-- WINDOW MANAGEMENT
-- ──────────────────────────────────────────────────────────────
hl.config({
  dwindle = {
    preserve_split = true,
  },

  master = {
    new_on_top = true,
  },
})

-- ──────────────────────────────────────────────────────────────
-- RENDER
-- ──────────────────────────────────────────────────────────────
hl.config({
  render = {
    direct_scanout = 0,
    cm_enabled = true,
    cm_sdr_eotf = "srgb",
    non_shader_cm = 1,
    new_render_scheduling = true, -- Experimental triple buffering
  },
})

-- ──────────────────────────────────────────────────────────────
-- MISC SETTINGS
-- ──────────────────────────────────────────────────────────────
hl.config({
  misc = {
    force_default_wallpaper = 2,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
  },

  xwayland = {
    force_zero_scaling = true,
  },
})

-- ──────────────────────────────────────────────────────────────
-- INPUT
-- ──────────────────────────────────────────────────────────────
hl.config({
  input = {
    kb_layout = "us",
    follow_mouse = 1,
    sensitivity = 0.5, -- Range: -1.0 to 1.0
    mouse_refocus = false,
    accel_profile = "adaptive",

    touchpad = {
      natural_scroll = true,
    },
  },
})

-- Touchpad gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", mods = "ALT", action = "close" })
hl.gesture({ fingers = 3, direction = "up", scale = 1.5, action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "down", scale = 1.5, action = "float" })
