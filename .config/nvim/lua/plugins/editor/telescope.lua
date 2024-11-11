return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-tree/nvim-web-devicons',
    'folke/todo-comments.nvim',
  },
  config = function()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'

    -- Define a function to set ignore patterns based on file type presence
    local function get_ignore_patterns()
      local ignore_patterns = {}
      local cwd = vim.fn.getcwd()

      -- Check for Java specific files in the current working directory
      if vim.fn.glob(cwd .. '/*.java') ~= '' or vim.fn.glob(cwd .. '/pom.xml') ~= '' then
        -- Java project, ignore .class files
        vim.list_extend(ignore_patterns, {
          '%.class$',
          '%.lst$',
        })
      end
      return ignore_patterns
    end

    telescope.setup {
      defaults = {
        path_display = { 'smart' },
        file_ignore_patterns = get_ignore_patterns(), -- dynamically set ignore patterns
        mappings = {
          i = {
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    }

    telescope.load_extension 'fzf'

    -- Set keymaps
    local keymap = vim.keymap
    keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Fuzzy find files in cwd' })
    keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', { desc = 'Fuzzy find recent files' })
    keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep in opened files' })
    keymap.set('n', '<leader>fc', '<cmd>Telescope grep_string<cr>', { desc = 'Find string under cursor in cwd' })
    keymap.set('n', '<leader>ft', '<cmd>TodoTelescope<cr>', { desc = 'Find todos' })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
