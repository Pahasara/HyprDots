return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Set header
    dashboard.section.header.val = {
      '                                        ',
      '        _   __                _         shinzo™',
      '       / | / /__  ____ _   __(_)___ ___ ',
      '      /  |/ / _ \\/ __ \\ | / / / __ `__ \\',
      '     / /|  /  __/ /_/ / |/ / / / / / / /',
      '    /_/ |_/\\___/\\____/|___/_/_/ /_/ /_/ ',
      '                                            ',
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button('e', '  New File', '<cmd>ene<CR>'),
      dashboard.button('Spc e e', '  File Explorer', '<cmd>NvimTreeToggle<CR>'),
      dashboard.button('Spc f f', '󰱼  Find Files', '<cmd>Telescope find_files<CR>'),
      dashboard.button('Spc f g', '  Live Grep', '<cmd>Telescope live_grep<CR>'),
      dashboard.button('Spc w w', '  Restore Session', '<cmd>SessionRestore<CR>'),
      dashboard.button('q', '  Quit NVIM', '<cmd>qa<CR>'),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]
  end,
}

-- vim: ts=2 sts=2 sw=2 et
