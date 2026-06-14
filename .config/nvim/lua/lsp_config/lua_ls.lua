return {
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  single_file_support = true,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim', 'hl' },
        disable = { 'missing-fields' },
      },
      workspace = {
        library = vim.list_extend(vim.api.nvim_get_runtime_file('', true), { '/usr/share/hypr/stubs' }),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      completion = {
        callSnippet = 'Replace',
        displayContext = 5,
        keywordSnippet = 'Disable',
      },
      hint = {
        enable = true,
        paramType = true,
        paramName = 'All',
        setType = true,
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
