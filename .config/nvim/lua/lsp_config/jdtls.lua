return {
  cmd = {
    vim.fn.expand '$HOME/.local/share/nvim/mason/bin/jdtls',
    ('--jvm-arg=-javaagent:%s'):format(vim.fn.expand '$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar'),
  },
  settings = {
    java = {
      format = {
        enabled = true,
        -- settings = {
        --   url = '$HOME/.config/intellij-java-google-style.xml',
        --   profile = 'GoogleStyle',
        -- },
      },

      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' }, -- Use fernflower to decompile library code
      saveActions = {
        organizeImports = true,
      },

      -- Specify any options for organizing imports
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },

      -- How code generation should act
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
    },
    init_options = {
      bundles = {},
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
