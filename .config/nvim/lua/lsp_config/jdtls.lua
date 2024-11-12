return {
  cmd = {
    --
    'java', -- Or the absolute path '/path/to/java21_or_newer/bin/java'
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    --
    '-jar',
    '/home/shinzo/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
    '-configuration',
    '/home/shinzo/.local/share/nvim/mason/packages/jdtls/config_linux',
    '-data',
    '/home/shinzo/.local/share/nvim/java',
  },
  settings = {
    java = {
      signatureHelp = { enabled = true },
      import = { enabled = true },
      rename = { enabled = true },
    },
  },
  init_options = {
    bundles = {},
  },
}

-- vim: ts=2 sts=2 sw=2 et
