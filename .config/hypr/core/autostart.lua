-- ══════════════════════════════════════════════════════════════
--                           AUTOSTART
--                  github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- Session env lives in ~/.config/uwsm/env*

hl.on("hyprland.start", function()
  hl.exec_cmd("kbuildsycoca6 --noincremental || dunstify -u critical 'Failed to rebuild KService cache'")
  hl.exec_cmd("uwsm-app -t service -- kitty")
  hl.exec_cmd("uwsm-app -t service -s b -- ianny || dunstify -a warning 'Failed to start ianny service'")
  -- hl.exec_cmd("uwsm-app -t service -s b -- hyprsnow")
end)

hl.env("GDK_WAYLAND_DISABLE", "ext_background_effect_manager_v1")
