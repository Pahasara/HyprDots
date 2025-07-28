if vim.g.vscode then
  -- VSCode extension
  require 'core.keymaps'
  require 'core.options'
  require 'core.autocmds'
else
  -- ordinary Neovim
  require 'core'
end
