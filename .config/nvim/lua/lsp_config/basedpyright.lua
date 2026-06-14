return {
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', '.git' },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'standard',
        diagnosticMode = 'openFilesOnly',
        autoImportCompletions = true,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        reportMissingTypeStubs = false,
        reportUnknownArgumentType = false,
        reportUnknownMemberType = false,
        reportUnknownVariableType = false,
        reportUnknownParameterType = false,
      },
    },
    python = {
      pythonPath = vim.fn.exepath 'python3' or vim.fn.exepath 'python',
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
