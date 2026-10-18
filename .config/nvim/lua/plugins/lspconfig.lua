return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    { 'antosha417/nvim-lsp-file-operations', config = true },
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
        keymap.set('n', '<leader>lr', '<cmd>lsp restart<CR>', { desc = 'Restart LSP' })
        keymap.set('n', '<leader>li', '<cmd>checkhealth vim.lsp<CR>', { desc = 'View LSP Info' })
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

    -- Global capabilities for all servers (also covers mason auto-enabled ones)
    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    local function setup(name, module)
      local ok, cfg = pcall(require, module)
      vim.lsp.config(name, ok and cfg or {})
    end

    setup('lua_ls', 'lsp_config.lua_ls')
    setup('clangd', 'lsp_config.clangd')
    setup('basedpyright', 'lsp_config.basedpyright')
    setup('jdtls', 'lsp_config.jdtls')
    setup('hyprls', 'lsp_config.hypr_ls')

    -- hyprls is not installed via mason, so enable explicitly.
    -- Other servers installed via mason are auto-enabled by mason-lspconfig.
    vim.lsp.enable { 'lua_ls', 'clangd', 'basedpyright', 'jdtls', 'hyprls' }
  end,
}
-- vim: ts=2 sts=2 sw=2 et
