-- ══════════════════════════════════════════════════════════════
--                  WINDOW RULES / GAMES & STEAM
--                  github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- Content type is assigned first so later rules can match on it.

local U = require("core.util")
local rule = U.rule

-- ──────────────────────────────────────────────────────────────
-- GAME DETECTION
-- ──────────────────────────────────────────────────────────────
-- Marks games with content = "game" and routes them to workspace 4.
rule("game-by-class", { class = "(dota2|steam_app.*)" }, { content = "game" })
rule("game-by-proton-tag", { xdg_tag = "proton-game.*" }, { content = "game" })
rule("game-content-ws", { content = "game" }, { workspace = 4 })

-- ──────────────────────────────────────────────────────────────
-- LAUNCHERS & MOD TOOLS
-- ──────────────────────────────────────────────────────────────
-- These must never go fullscreen.
local TOOLISH = ".*([Ll]auncher|[Oo]ptions|[Ss]etup|[Ww]orking|[Mm]od|[Oo]rganizer|[Ii]install).*"
for _, prop in ipairs({ "title", "class" }) do
  rule("game-tool-" .. prop, { content = "game", [prop] = TOOLISH }, { fullscreen_state = "0 0", rounding = 2 })
end

-- ──────────────────────────────────────────────────────────────
-- FAUGUS LAUNCHER
-- ──────────────────────────────────────────────────────────────
rule("faugus-ws", { class = ".*faugus-launcher", title = "Faugus" }, { workspace = 4 })
rule("faugus-float", { class = ".*faugus-launcher" }, { float = true })
rule("faugus-main", { class = ".*faugus-launcher", title = "Faugus" }, { size = U.frac(0.70, 0.72) })
rule("faugus-update-box", { class = "faugus-launcher", title = "Faugus" }, { stay_focused = true })

-- ──────────────────────────────────────────────────────────────
-- STEAM CLIENT
-- ──────────────────────────────────────────────────────────────
rule("steam-main", { class = "steam", title = "Steam" }, { workspace = 4 })
rule("steam-dialogs", { class = "steam", title = "negative:Steam" }, { float = true })
rule("steam-signin", { class = "steam", title = "Sign.*" }, { center = true })
rule("steam-float-flat", { class = "steam", float = true }, { rounding = 1 })
rule("steam-no-focus-steal", { class = "steam" }, { suppress_event = "activatefocus" })
