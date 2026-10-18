return { -- automated session manager
  'rmagatti/auto-session',
  config = function()
    local auto_session = require 'auto-session'

    auto_session.setup {
      auto_restore = false,
      suppressed_dirs = { '~/', '~/Downloads', '~/Documents', '~/Desktop/' },
    }

    vim.keymap.set('n', '<leader>ww', '<cmd>AutoSession restore<CR>', { desc = 'Restore session for cwd' })
    vim.keymap.set('n', '<leader>ws', '<cmd>AutoSession save<CR>', { desc = 'Save session for auto session root dir' })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
