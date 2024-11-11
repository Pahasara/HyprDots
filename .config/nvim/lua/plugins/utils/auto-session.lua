return { -- automated session manager
  'rmagatti/auto-session',
  config = function()
    local auto_session = require 'auto-session'

    auto_session.setup {
      auto_restore_enabled = false,
      auto_session_supress_dirs = { '~/', '~/Downloads', '~/Documents', '~/Desktop/' },
    }

    vim.keymap.set('n', '<leader>ww', '<cmd>SessionRestore<CR>', { desc = 'Restore session for cwd' }) -- restore last workspace session for current directory
    vim.keymap.set('n', '<leader>ws', '<cmd>SessionSave<CR>', { desc = 'Save session for auto session root dir' }) -- save workspace session for current working directory
  end,
}

-- vim: ts=2 sts=2 sw=2 et
