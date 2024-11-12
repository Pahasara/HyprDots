return {
  -- cmd = {...},
  -- filetypes = { ...},
  -- capabilities = {},
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
  -- single_file_support = true,
}

-- vim: ts=2 sts=2 sw=2 et
