return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    -- import mason
    local mason = require 'mason'

    -- import mason-lspconfig
    local mason_lspconfig = require 'mason-lspconfig'

    -- import mason-tool-installer
    local mason_tool_installer = require 'mason-tool-installer'

    -- enable mason and configure icons
    mason.setup {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    }

    mason_lspconfig.setup {
      -- list of servers for mason to install
      ensure_installed = {
        'bashls',
        'clangd',
        'csharp_ls',
        'cssls',
        'html',
        'jdtls',
        'lua_ls',
        'basedpyright',
      },
    }

    mason_tool_installer.setup {
      ensure_installed = {
        -- list of formatters for mason to install
        'clang-format', -- c/c++ formatter
        -- "prettier",  -- css/html formatter
        'black', -- python formatter
        'isort', -- python formatter
        'stylua', -- lua formatter

        -- list of linters for mason to install
        -- 'cpplint', -- c++ linter
        -- 'pylint', -- python linter

        -- list of debuggers for mason to install
        -- 'codelldb', -- c++ debugger
      },
    }
  end,
}

-- vim: ts=2 sts=2 sw=2 et
