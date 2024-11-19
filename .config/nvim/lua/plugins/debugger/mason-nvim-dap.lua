return {
  'jay-babu/mason-nvim-dap.nvim',
  event = 'VeryLazy',
  dependencies = {
    'williamboman/mason.nvim',
    'mfussenegger/nvim-dap',
  },
  opts = {
    handlers = {},
    ensure_installed = {
      -- 'codelldb', -- c++ debugger
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
