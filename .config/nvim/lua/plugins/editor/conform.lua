return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local conform = require 'conform'

    conform.setup {
      formatters_by_ft = {
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        css = { 'prettier' },
        html = { 'prettier' },
        javascript = { 'prettier' },
        lua = { 'stylua' },
        xml = { 'xmlformatter' },
        -- markdown = { "prettier" },
        python = { 'isort', 'black' },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>pp', function()
      conform.format {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      }
    end, { desc = 'Format file or range (in visual mode)' })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
