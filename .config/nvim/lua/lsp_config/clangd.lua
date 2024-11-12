return {
  cmd = { 'clangd', '--background-index', '--clang-tidy', '--cross-file-rename' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  capabilities = {
    offsetEncoding = { 'utf-8', 'utf-16' },
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
  },
  single_file_support = true,
  flags = {
    debounce_text_changes = 150,
  },

  -- Additional options for clangd
  init_options = {
    fallbackFlags = { '-Wall', '-Wextra', '-Wshadow' },
  },
}

-- vim: ts=2 sts=2 sw=2 et
