return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'basic',
        diagnosticMode = 'openFilesOnly',

        reportMissingTypeStubs = false,
        reportUnknownArgumentType = false,
        reportUnknownMemberType = false,
        reportUnknownVariableType = false,

        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        autoImportCompletions = true,
      },
    },
  },
}
