-- NOTE: [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
--
-- HACK: Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', {
    clear = true,
  }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_user_command('LspInfo', function()
  local clients = vim.lsp.get_clients { bufnr = 0 }

  if vim.tbl_isempty(clients) then
    vim.notify('No LSP clients attached to the current buffer', vim.log.levels.INFO, { title = 'LSP Info' })
    return
  end

  local lines = {
    '╔════════════════════════════════════════╗',
    '║        Attached LSP Clients            ║',
    '╚════════════════════════════════════════╝',
    '',
  }

  for i, client in ipairs(clients) do
    table.insert(lines, string.format('Client %d: %s', i, client.name))
    table.insert(lines, string.format('  ID: %d', client.id))
    table.insert(lines, string.format('  Root: %s', client.config.root_dir or 'unknown'))
    if client.config.cmd then
      table.insert(lines, string.format('  Command: %s', table.concat(client.config.cmd, ' ')))
    end
    table.insert(lines, '')
  end

  -- Create floating window
  local width = 50
  local height = math.min(#lines + 2, vim.o.lines - 4)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    border = 'rounded',
    title = ' LSP Info ',
    title_pos = 'center',
  })

  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  vim.keymap.set('n', 'q', ':q<CR>', { buffer = buf, noremap = true, silent = true })
end, { desc = 'Show LSP info' })

vim.filetype.add {
  pattern = {
    [vim.pesc(vim.fn.expand '~/.config/hypr/') .. '.*%.lua'] = 'lua',
    [vim.pesc(vim.fn.expand '~/.config/hypr/') .. '.*%.conf'] = 'hyprland',
  },
  filename = {
    ['hyprland.conf'] = 'hyprland',
  },
}

vim.api.nvim_create_autocmd('BufReadPre', {
  desc = 'Detect Hyprland config filetype',
  group = vim.api.nvim_create_augroup('HyprlandFiletype', { clear = true }),
  callback = function(event)
    local filename = vim.fn.fnamemodify(event.file, ':t')
    local file_path = vim.fs.normalize(event.file)
    local hypr_dir = vim.fs.normalize(vim.fn.expand '~/.config/hypr/')
    local extension = vim.fn.fnamemodify(event.file, ':e')

    if vim.startswith(file_path, hypr_dir) then
      if extension == 'lua' then
        vim.bo[event.buf].filetype = 'lua'
      elseif extension == 'conf' or filename == 'hyprland.conf' then
        vim.bo[event.buf].filetype = 'hyprland'
      end
    end
  end,
})

-- vim: ts=2 sts=2 sw=2 et
