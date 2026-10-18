-- ══════════════════════════════════════════════════════════════
--                            HELPERS
--                  github.com/pahasara/HyprDots
-- ══════════════════════════════════════════════════════════════

-- Small functions shared by binds and rules.

local U = {}

-- Command string that runs an app inside a uwsm service scope.
function U.uwsm_cmd(app)
  return "uwsm-app -t service -- " .. app
end

-- Dispatchers (for hl.bind)
function U.exec(cmd)
  return hl.dsp.exec_cmd(cmd)
end
function U.uwsm(app)
  return hl.dsp.exec_cmd(U.uwsm_cmd(app))
end

-- Kill the process if it's running, otherwise start it.
function U.toggle(proc, cmd)
  return hl.dsp.exec_cmd(string.format("pkill %s || %s", proc, cmd or proc))
end

-- { "a", "b" } -> ".*(a|b).*"   (class/title "contains any of")
function U.any(list)
  return ".*(" .. table.concat(list, "|") .. ").*"
end

-- Window size / position as fractions of the monitor.
function U.frac(w, h)
  return { "monitor_w*" .. w, "monitor_h*" .. h }
end

-- Named window rule: name first, so rule order stays explicit and every
-- rule can later be toggled with the handle it returns.
function U.rule(name, match, fx)
  fx.name, fx.match = name, match
  return hl.window_rule(fx)
end

-- Persistent on/off flags: an empty file in the cache dir means "on".
-- They survive config reloads and restarts (used by look/modes.lua).
local STATE = (os.getenv("XDG_CACHE_HOME") or (os.getenv("HOME") .. "/.cache")) .. "/hypr-modes"

function U.flag(name)
  local f = io.open(STATE .. "/" .. name, "r")
  if f then
    f:close()
    return true
  end
  return false
end

function U.set_flag(name, on)
  local path = STATE .. "/" .. name
  if on then
    os.execute("mkdir -p '" .. STATE .. "'")
    local f = io.open(path, "w")
    if f then
      f:close()
    end
  else
    os.remove(path)
  end
end

return U
