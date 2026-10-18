-- ══════════════════════════════════════════════════════════════
--                KEYBINDS / WINDOWS & WORKSPACES
--                  github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

local mod = "SUPER"

-- ──────────────────────────────────────────────────────────────
-- WINDOW ACTIONS
-- ──────────────────────────────────────────────────────────────
-- stylua: ignore start
hl.bind(mod .. " + Q",         hl.dsp.window.close())
hl.bind(mod .. " + F",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + C", hl.dsp.window.center())
hl.bind(mod .. " + SHIFT + D", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + F12",       hl.dsp.window.pin())
-- stylua: ignore end

-- ──────────────────────────────────────────────────────────────
-- FOCUS & MOVEMENT
-- ──────────────────────────────────────────────────────────────
-- Vim keys.
local dirs = { H = "left", L = "right", K = "up", J = "down" }
for key, dir in pairs(dirs) do
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = dir }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
end

-- ──────────────────────────────────────────────────────────────
-- RESIZING
-- ──────────────────────────────────────────────────────────────
-- Hold to repeat.
local resize = { L = { 20, 0 }, H = { -20, 0 }, K = { 0, -20 }, J = { 0, 20 } }
for key, d in pairs(resize) do
  hl.bind(mod .. " + CONTROL + " .. key, hl.dsp.window.resize({ x = d[1], y = d[2], relative = true }), { repeating = true })
end

-- ──────────────────────────────────────────────────────────────
-- WORKSPACES
-- ──────────────────────────────────────────────────────────────
-- Key 0 maps to workspace 10.
for i = 1, 10 do
  local key = i % 10
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

-- ──────────────────────────────────────────────────────────────
-- SPECIAL WORKSPACE
-- ──────────────────────────────────────────────────────────────
hl.bind(mod .. " + M", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.window.move({ workspace = "special:magic" }))

-- ──────────────────────────────────────────────────────────────
-- MOUSE
-- ──────────────────────────────────────────────────────────────
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
