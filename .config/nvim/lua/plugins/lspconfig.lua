return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    { 'antosha417/nvim-lsp-file-operations', config = true },
    { 'folke/neodev.nvim', opts = {} },
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },

  config = function()
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'
    local keymap = vim.keymap

    -- Setup capabilities with completion support
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- LSP Attach autocmd - runs when LSP attaches to a buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(event)
        local opts = { buffer = event.buf, silent = true }

        -- Buffer local mappings
        keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', vim.tbl_extend('keep', opts, { desc = 'Show LSP References' }))
        keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('keep', opts, { desc = 'Goto Declaration' }))
        keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', vim.tbl_extend('keep', opts, { desc = 'Show LSP Definitions' }))
        keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', vim.tbl_extend('keep', opts, { desc = 'Show LSP Implementations' }))
        keymap.set('n', 'gs', '<cmd>Telescope lsp_type_definitions<CR>', vim.tbl_extend('keep', opts, { desc = 'Show LSP Type Definitions' }))
        keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('keep', opts, { desc = 'Show Documentation for what is under cursor' }))
        keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('keep', opts, { desc = 'See available code actions' }))
        keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('keep', opts, { desc = 'Smart Rename' }))
        keymap.set('n', '<leader>lr', ':lsp restart<CR>', { desc = 'Restart LSP' })
        keymap.set('n', '<leader>li', ':LspInfo<CR>', { desc = 'View LSP Info' })
        keymap.set('n', '<leader>lf', vim.lsp.buf.format, vim.tbl_extend('keep', opts, { desc = 'Format document' }))
      end,
    })

    -- Diagnostic configuration
    vim.diagnostic.config {
      signs = {
        text = { '▶ ', '▶ ', '▶ ', '▶ ' }, -- E, W, H, I
      },
      underline = true,
      virtual_text = {
        prefix = '■ ',
      },
      update_in_insert = true,
    }

    -- Configure Lua LSP
    local lua_config = require 'lsp_config.lua_ls'
    vim.lsp.config('lua_ls', vim.tbl_deep_extend('force', {
      capabilities = capabilities,
    }, lua_config or {}))

    -- Configure Clang LSP
    local clangd_config = require 'lsp_config.clangd'
    vim.lsp.config('clangd', vim.tbl_deep_extend('force', {
      capabilities = capabilities,
    }, clangd_config or {}))

    -- Configure Python LSP
    local py_config = require 'lsp_config.basedpyright'
    vim.lsp.config('basedpyright', vim.tbl_deep_extend('force', {
      capabilities = capabilities,
    }, py_config or {}))

    -- Configure Java LSP
    local jdtls_config = require 'lsp_config.jdtls'
    vim.lsp.config('jdtls', vim.tbl_deep_extend('force', {
      capabilities = capabilities,
    }, jdtls_config or {}))

    -- Configure Hyprland LSP
    local hypr_ls_config = require 'lsp_config.hypr_ls'
    vim.lsp.config('hyprls', vim.tbl_deep_extend('force', {
      capabilities = capabilities,
    }, hypr_ls_config or {}))

    -- Global capabilities for all servers
    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    -- Enable configured LSP servers
    vim.lsp.enable { 'lua_ls', 'clangd', 'basedpyright', 'jdtls', 'hyprls' }
  end,
}
-- vim: ts=2 sts=2 sw=2 et
