-- ══════════════════════════════════════════════════════════════
--                           ANIMATIONS
--                  github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- speed is in deciseconds (4 = 400ms). Edit a row to retune.

hl.config({ animations = { enabled = true } })

-- ──────────────────────────────────────────────────────────────
-- CURVES
-- ──────────────────────────────────────────────────────────────
-- stylua: ignore start
local curves = {
  decel    = { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } },    -- soft landing
  accel    = { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } },    -- quick exit
  standard = { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } },
  overshot = { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.02 } } }, -- tiny overshoot
  snap     = { type = "bezier", points = { { 0.1, 1 }, { 0.1, 1 } } },       -- hard decel
}
for name, c in pairs(curves) do hl.curve(name, c) end

-- ──────────────────────────────────────────────────────────────
-- ANIMATIONS
-- ──────────────────────────────────────────────────────────────
-- Each row is { leaf, speed, curve, style? }.

local rows = {
  -- windows
  { "windowsIn",       3,   "decel",    "popin 70%" },
  { "windowsOut",      4,   "accel",    "popin 70%" },
  { "windowsMove",     4,   "overshot" },
  -- fades
  { "fade",            2.5, "standard" },
  { "fadeIn",          3,   "decel" },
  { "fadeOut",         2,   "accel" },
  { "fadeLayersIn",    3,   "decel" },
  { "fadeLayersOut",   2,   "accel" },
  -- layers (waybar, rofi, notifications)
  { "layers",          6.5, "standard", "fade" },
  { "layersIn",        6.5, "snap",     "slide" },
  { "layersOut",       8,   "snap",     "slide" },
  -- workspaces
  { "workspaces",      5,   "decel",    "slide" },
  { "workspacesIn",    7,   "snap",     "slide" },
  { "workspacesOut",   7,   "snap",     "slide" },
  { "specialWorkspace", 4,  "decel",    "slide" },
}
-- stylua: ignore end

for _, r in ipairs(rows) do
  hl.animation({ leaf = r[1], enabled = true, speed = r[2], bezier = r[3], style = r[4] })
end
