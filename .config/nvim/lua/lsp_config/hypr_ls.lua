return {
  root_markers = { 'hyprland.lua', 'hyprland.conf', '.git' },
  cmd = { 'hyprls' },
  -- hyprls only understands hyprlang (.conf). Lua configs ('hyprland' ft) go to lua_ls.
  filetypes = { 'hyprlang' },
  single_file_support = true,
  settings = {
    hyprls = {
      preferIgnoreFile = false,
      ignore = { 'hyprlock.conf', 'hypridle.conf' },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
