return { -- maximizes and restores the current window
  'szw/vim-maximizer',
  keys = {
    { '<leader>sm', '<cmd>MaximizerToggle<CR>', desc = 'Maximize/minimize a split' },
  },
}
