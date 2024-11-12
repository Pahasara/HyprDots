local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Helper function to dynamically import all Lua files and directories within a given directory
local function import_all_plugins(directory)
  local imports = {}
  for _, file in ipairs(vim.fn.glob(directory .. '/**/*.lua', true, true)) do
    -- Convert the path into a Lua module format
    local module_name = file:match('nvim/lua/(.*).lua$'):gsub('/', '.')
    table.insert(imports, { import = module_name })
  end
  return imports
end

require('lazy').setup(
  vim.list_extend({}, import_all_plugins(vim.fn.stdpath 'config' .. '/lua/plugins')), -- Automatically import everything under plugins
  {
    checker = {
      enabled = true,
      notify = false,
    },
    change_detection = {
      notify = false,
    },
  }
)

-- vim: ts=2 sts=2 sw=2 et
