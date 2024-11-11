return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- ur configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}

-- vim: ts=2 sts=2 sw=2 et
