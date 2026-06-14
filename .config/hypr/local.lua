-- ══════════════════════════════════════════════════════════════
--                    LOCAL / PRIVATE CONFIG
--                   github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════
-- This file is for machine-specific or personal overrides.
-- Safe to customize without touching the main config files.

-- ──────────────────────────────────────────────────────────────
-- Example: Game-specific rules
-- ──────────────────────────────────────────────────────────────
hl.window_rule({ match = { class = "dota.*|reverse.*|underlords" }, content = "game" })
hl.window_rule({ match = { class = "steam_app_359870|ffx.*" }, fullscreen = true })
hl.window_rule({ match = { class = "Arcane.App" }, float = true, center = true })
-- hl.window_rule({ match = { class = "reverse.*" }, fullscreen = true })
-- hl.window_rule({ match = { class = "reverse.*" }, workspace = 4 })

-- ──────────────────────────────────────────────────────────────
-- Example: Personal workspace preferences
-- ──────────────────────────────────────────────────────────────
-- hl.window_rule({ match = { class = "personal-app" }, workspace = 5 })

-- ──────────────────────────────────────────────────────────────
-- Example: Monitor-specific settings
-- ──────────────────────────────────────────────────────────────
-- hl.monitor({ output = "DP-1", mode = "2560x1440@144", position = "0x0", scale = 1 })
-- hl.workspace_rule({ workspace = 1, monitor = "DP-1" })

-- ──────────────────────────────────────────────────────────────
-- Example: Override app paths with actual installations
-- ──────────────────────────────────────────────────────────────
-- (Override variables in keybinds.lua or redefine binds here)
-- e.g. if Zen Browser is installed at a custom path, rebind mod+B:
-- local HOME = os.getenv("HOME")
-- hl.bind("SUPER + B", hl.dsp.exec_cmd(HOME .. "/.local/opt/zen/zen-bin"))
