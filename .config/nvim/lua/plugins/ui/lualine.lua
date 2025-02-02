return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local lualine = require 'lualine'
    local lazy_status = require 'lazy.status' -- to configure lazy to pending updates count

    local colors = {
      blue = '#1FA0F0',
      green = '#38CF38',
      violet = '#FF61EF',
      yellow = '#FF9E64',
      red = '#FF3A3A',
      grey = '#232323',
      fg = '#c3ccdc',
      bg = '#000000',
      inactive_bg = '#0D0D0D',
    }

    local azure_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.grey, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.grey, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.grey, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.grey, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.grey, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        -- a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = 'bold' },
        -- b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        -- c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    local get_active_lsp = function()
      local msg = 'none'
      local buf_ft = vim.api.nvim_get_option_value('filetype', {})
      local clients = vim.lsp.get_clients { bufnr = 0 }
      if next(clients) == nil then
        return msg
      end

      for _, client in ipairs(clients) do
        ---@diagnostic disable-next-line: undefined-field
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          return client.name
        end
      end
      return msg
    end

    -- configure lualine with modified theme
    lualine.setup {
      options = {
        theme = azure_theme,
        component_separators = '',
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          {
            'mode',
            icon = '',
          },
        },
        lualine_b = {
          {
            'filename',
            icon = ' ',
            path = 1, -- set to relative path
            shorting_target = 100, -- leave 100 spaces in the windows
            symbols = {
              readonly = '[🔒]',
            },
          },
        },
        lualine_c = {
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            -- symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            update_in_insert = true,
          },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = '#00AF1F' },
          },
          {
            'fileformat',
            color = { fg = '#ABABAB' },
          },
          {
            'encoding',
            color = { fg = '#ABABAB' },
          },
          {
            'filetype',
            icon_only = true,
          },
        },
        lualine_y = {
          {
            get_active_lsp,
            icon = ' ',
          },
          -- {
          --   'location',
          -- },
        },
        lualine_z = {
          {
            'progress',
            icon = ' ',
          },
        },
      },
    }
  end,
}

-- vim: ts=2 sts=2 sw=2 et
