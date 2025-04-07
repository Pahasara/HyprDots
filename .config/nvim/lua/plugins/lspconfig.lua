return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    { 'antosha417/nvim-lsp-file-operations', config = true },
    { 'folke/neodev.nvim', opts = {} },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require 'lspconfig'

    -- import mason_lspconfig plugin
    local mason_lspconfig = require 'mason-lspconfig'

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
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

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
    vim.diagnostic.config {
      signs = {
        text = { '▶ ', '▶ ', '▶ ', '▶ ' }, -- E, W, H, I
      },
    }

    mason_lspconfig.setup_handlers {
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup {
          capabilities = capabilities,
        }
      end,
      --
      -- NOTE: lua_ls
      ['lua_ls'] = function()
        local config = require 'lsp_config.lua_ls'
        lspconfig['lua_ls'].setup(config)
      end,
      --
      -- NOTE: clangd
      ['clangd'] = function()
        local config = require 'lsp_config.clangd'
        lspconfig['clangd'].setup(config)
      end,
      --
      -- NOTE: jdtls
      ['jdtls'] = function()
        local config = require 'lsp_config.jdtls'
        lspconfig['jdtls'].setup(config)
      end,
    }
  end,
}

-- vim: ts=2 sts=2 sw=2 et
