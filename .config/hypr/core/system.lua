-- ══════════════════════════════════════════════════════════════
--                             SYSTEM
--                  github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- Monitors, input, gestures, render, permissions.

-- ──────────────────────────────────────────────────────────────
-- MONITORS
-- ──────────────────────────────────────────────────────────────
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1, vrr = 0 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, mirror = "eDP-1" }) -- projector / external

-- ──────────────────────────────────────────────────────────────
-- INPUT
-- ──────────────────────────────────────────────────────────────
hl.config({
  input = {
    kb_layout = "us",
    follow_mouse = 1,
    mouse_refocus = false,
    sensitivity = 0.8, -- -1.0 .. 1.0
    accel_profile = "adaptive",
    touchpad = { natural_scroll = true },
  },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", mods = "ALT", action = "close" })
hl.gesture({ fingers = 3, direction = "up", scale = 1.5, action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "down", scale = 1.5, action = "float" })

-- ──────────────────────────────────────────────────────────────
-- RENDER & MISC
-- ──────────────────────────────────────────────────────────────
hl.config({
  render = {
    direct_scanout = 0,
    cm_enabled = true,
    cm_sdr_eotf = "default",
    non_shader_cm = 2,
    new_render_scheduling = true, -- experimental triple buffering
  },
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
  },
  xwayland = { force_zero_scaling = true },
})

-- ──────────────────────────────────────────────────────────────
-- PERMISSIONS
-- ──────────────────────────────────────────────────────────────
-- Needs a Hyprland restart to apply changes.
hl.config({ ecosystem = { enforce_permissions = true } })

hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/hyprpicker", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/hyprlock", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
