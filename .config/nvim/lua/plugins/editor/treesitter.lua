return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false, -- main branch does not support lazy-loading
  build = ':TSUpdate',
  dependencies = { 'windwp/nvim-ts-autotag' },
  config = function()
    local ts = require 'nvim-treesitter'
    ts.setup {} -- only option is install_dir; defaults are fine

    -- Parsers to install up front (async, no-op if already installed)
    ts.install {
      'bash',
      'c',
      'c_sharp',
      'cmake',
      'cpp',
      'css',
      'html',
      'java',
      'javascript',
      'json',
      'lua',
      'make',
      'markdown',
      'markdown_inline',
      'python',
      'regex',
      'toml',
      'typescript',
      'tsx',
      'xml',
      'yaml',
    }

    -- hyprland ft uses the lua parser (register BEFORE the FileType autocmd)
    vim.treesitter.language.register('lua', { 'hyprland' })

    local no_highlight = {} -- markdown must be highlighted for render-markdown
    local no_indent = { c = true, cpp = true }

    local function attach(buf, ft, lang)
      if not pcall(vim.treesitter.language.add, lang) then
        return false
      end
      if not no_highlight[ft] then
        pcall(vim.treesitter.start, buf, lang)
      end
      if not no_indent[ft] then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
      return true
    end

    -- Replaces highlight.enable / indent.enable / auto_install
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('UserTreesitter', { clear = true }),
      callback = function(ev)
        local ft = ev.match
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return
        end
        if attach(ev.buf, ft, lang) then
          return
        end
        -- parser missing: install it, then attach (replacement for auto_install)
        if vim.list_contains(ts.get_available(), lang) then
          ts.install(lang):await(function()
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(ev.buf) then
                attach(ev.buf, ft, lang)
              end
            end)
          end)
        end
      end,
    })

    -- autotag is no longer a treesitter module; set it up directly
    require('nvim-ts-autotag').setup()

    -- incremental_selection was removed from the plugin; use Neovim's built-in
    -- treesitter selection (an / in in visual mode, see :h v_an)
    vim.keymap.set('n', '<C-space>', 'van', { remap = true, desc = 'Select node' })
    vim.keymap.set('x', '<C-space>', 'an', { remap = true, desc = 'Expand selection' })
    vim.keymap.set('x', '<bs>', 'in', { remap = true, desc = 'Shrink selection' })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
