return {
  root_markers = { 'hyprland.lua', 'hyprland.conf', '.git' },
  cmd = { 'hyprls' },
  filetypes = { 'hyprland', 'hyprlang' },
  single_file_support = true,
  settings = {
    hyprls = {
      preferIgnoreFile = false,
      ignore = { 'hyprlock.conf', 'hypridle.conf' },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
