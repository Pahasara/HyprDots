return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    'windwp/nvim-ts-autotag',
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require 'nvim-treesitter.configs'

    -- configure treesitter (following nvim-treesitter recommended options)
    treesitter.setup {
      ensure_installed = {
        'bash', 'c', 'c_sharp', 'cmake', 'cpp', 'css', 'html', 'java', 'javascript', 'lua', 'make', 'markdown', 'python', 'toml', 'typescript', 'tsx',
      },
      sync_install = false,
      auto_install = true,

      highlight = {
        enable = true,
        disable = { 'markdown' }, -- keep markdown disabled if it caused issues
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
        disable = { 'c', 'cpp' },
      },

      autotag = {
        enable = true,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
    }
    -- Map custom filetypes to existing parsers (hyprland configs are Lua)
    pcall(function()
      if vim.treesitter and vim.treesitter.language then
        vim.treesitter.language.register('lua', { 'hyprland' })
      end
    end)
  end,
}

-- vim: ts=2 sts=2 sw=2 et
