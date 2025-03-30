return {
  -- { -- NOTE: oxocarbon
  --   {
  --     'nyoom-engineering/oxocarbon.nvim',
  --     lazy = false,
  --     priority = 1000,
  --     -- Add in any other configuration;
  --     --   event = foo,
  --     config = function()
  --       vim.opt.background = 'dark' -- set this to dark or light
  --       vim.cmd 'colorscheme oxocarbon'
  --     end,
  --   },
  -- },
  --
  -- { -- NOTE: ayu-dark
  --   'Shatur/neovim-ayu',
  --   priority = 1000,
  --   -- Add in any other configuration;
  --   --   event = foo,
  --   config = function()
  --     vim.cmd 'colorscheme ayu-dark'
  --   end,
  -- },
  --
  -- { -- NOTE: aura-theme
  --   {
  --     'baliestri/aura-theme',
  --     lazy = false,
  --     priority = 1000,
  --     config = function(plugin)
  --       vim.opt.rtp:append(plugin.dir .. '/packages/neovim')
  --       vim.cmd [[colorscheme aura-dark]]
  --     end,
  --   },
  -- },
  --
  { -- NOTE: tokyonight (modified)
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      local bg = '#020202' -- #080808
      local bg_dark = '#121212' -- #121212
      local bg_highlight = '#292E44'
      local bg_search = '#3DDBD9'
      local bg_visual = '#324867'
      local fg = '#D5D5D5'
      local fg_dark = '#EFEFEF'
      local fg_gutter = '#424242'
      local border = '#161616'

      require('tokyonight').setup {
        style = 'night',
        on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = bg_dark
          colors.bg_float = bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = bg_dark
          colors.bg_statusline = bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
        end,
      }

      vim.cmd 'colorscheme tokyonight'

      vim.cmd 'hi CursorLineNr guifg=#BCBCBF'
      vim.cmd 'hi LineNrAbove guifg=#888899'
      vim.cmd 'hi LineNrBelow guifg=#888899'
      vim.cmd 'hi Search guibg=#194B68'

      vim.api.nvim_set_hl(0, 'Comment', { fg = '#768696' })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
