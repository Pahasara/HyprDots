return {
  'mfussenegger/nvim-dap',

  config = function()
    local dap = require 'dap'
    local keymap = vim.keymap -- for conciseness

    -- set highlight colors
    vim.api.nvim_set_hl(0, 'red', { fg = '#DB1D00' })
    vim.api.nvim_set_hl(0, 'yellow', { fg = '#D8B838' })
    vim.api.nvim_set_hl(0, 'green', { fg = '#38C038' })

    -- set custom icons
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'red', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'green', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '●', texthl = 'red', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '●', texthl = 'yellow', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '●', texthl = 'yellow', linehl = '', numhl = '' })

    -- set keybinds
    keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
    keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
    keymap.set('n', '<F12>', dap.step_out, { desc = 'Debug: Step Out' })
    keymap.set('n', '<F9>', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    keymap.set('n', 'B', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
