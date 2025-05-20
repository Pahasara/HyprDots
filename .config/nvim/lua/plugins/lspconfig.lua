return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    { 'antosha417/nvim-lsp-file-operations', config = true },
    { 'folke/neodev.nvim', opts = {} },
  },

  config = function()
    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function()
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', { desc = 'Show LSP References' })
        keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
        keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', { desc = 'Show LSP Definitions' })
        keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', { desc = 'Show LSP Implementations' })
        keymap.set('n', 'gs', '<cmd>Telescope lsp_type_definitions<CR>', { desc = 'Show LSP Type Definitions' })
        keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show Documentation for what is under cursor' })
        keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'See available code actions' })
        keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Smart Rename' })
        keymap.set('n', '<leader>lr', ':LspRestart<CR>', { desc = 'Restart LSP' })
        keymap.set('n', '<leader>li', ':LspInfo<CR>', { desc = 'View LSP Info' })
      end,
    })

    -- Change the Diagnostic symbols in the sign column (gutter)
    vim.diagnostic.config {
      signs = {
        text = { '▶ ', '▶ ', '▶ ', '▶ ' }, -- E, W, H, I
      },
    }

    -- Manually configured serverss
    --
    -- NOTE: lua_ls
    local lua_ls_config = require 'lsp_config.lua_ls'
    vim.lsp.config('lua_ls', { settings = { lua_ls_config } })

    -- NOTE: clangd
    local clangd_config = require 'lsp_config.clangd'
    vim.lsp.config('clangd', { settings = { clangd_config } })

    -- NOTE: jdtls
    local jdtls_config = require 'lsp_config.jdtls'
    vim.lsp.config('jdtls', { settings = { jdtls_config } })
  end,
}
-- vim: ts=2 sts=2 sw=2 et
