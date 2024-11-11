return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  version = '*',
  opts = {
    options = {
      mode = 'tabs',
      seperator_style = 'slant',
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local s = ' '
        for e, n in pairs(diagnostics_dict) do
          -- local sym = e == 'error' and ' ' or (e == 'warning' and ' ' or ' ')
          local sym = e == 'error' and ' ' or (e == 'warning' and ' ' or ' ')
          s = s .. sym .. n .. ' '
        end
        return s
      end,
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
