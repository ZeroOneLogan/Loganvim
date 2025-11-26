-- lualine.lua --
-- Beautiful and Informative Statusline for LoganVim
-- Feature-rich with elegant design

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'folke/noice.nvim',
  },
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = ' '
    else
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    local lazy_ok, lazy_status = pcall(require, 'lazy.status')
    local noice_ok, noice = pcall(require, 'noice')
    local navic_ok, navic = pcall(require, 'nvim-navic')

    --  ╭────────────────────────────────────────────────────────╮
    --  │                    Helper Functions                    │
    --  ╰────────────────────────────────────────────────────────╯

    local function navic_component()
      if navic_ok and navic.is_available() then
        return navic.get_location()
      end
      return ''
    end

    local function macro_recording()
      local reg = vim.fn.reg_recording()
      if reg == '' then return '' end
      return '󰑋 @' .. reg
    end

    local function search_count()
      if vim.v.hlsearch == 0 then return '' end
      local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
      if not ok or result.total == 0 then return '' end
      return string.format(' %d/%d', result.current, result.total)
    end

    local function lsp_clients()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then return '' end

      local names = {}
      for _, client in ipairs(clients) do
        if client.name ~= 'copilot' then
          table.insert(names, client.name)
        end
      end
      if #names == 0 then return '' end
      return '󰒍 ' .. table.concat(names, ', ')
    end

    local function python_venv()
      if vim.bo.filetype ~= 'python' then return '' end
      local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_DEFAULT_ENV
      if not venv then return '' end
      return '󰌠 ' .. vim.fn.fnamemodify(venv, ':t')
    end

    local function indent_info()
      local shiftwidth = vim.bo.shiftwidth
      local icon = vim.bo.expandtab and '󱁐' or '󰌒'
      return icon .. ' ' .. shiftwidth
    end

    --  ╭────────────────────────────────────────────────────────╮
    --  │                       Colors                           │
    --  ╰────────────────────────────────────────────────────────╯

    local colors = {
      blue = '#7aa2f7',
      cyan = '#7dcfff',
      green = '#9ece6a',
      magenta = '#bb9af7',
      orange = '#ff9e64',
      pink = '#f7768e',
      purple = '#9d7cd8',
      red = '#f7768e',
      yellow = '#e0af68',
      gray = '#565f89',
      fg = '#c0caf5',
    }

    return {
      options = {
        theme = 'auto',
        globalstatus = true,
        disabled_filetypes = {
          statusline = { 'dashboard', 'alpha' },
          winbar = {},
        },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },

      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(str)
              local mode_map = {
                ['NORMAL'] = ' ',
                ['INSERT'] = ' ',
                ['VISUAL'] = '󰈈 ',
                ['V-LINE'] = '󰈈 ',
                ['V-BLOCK'] = '󰈈 ',
                ['REPLACE'] = ' ',
                ['COMMAND'] = ' ',
                ['TERMINAL'] = ' ',
              }
              return mode_map[str] or str:sub(1, 1)
            end,
          },
        },

        lualine_b = {
          {
            'branch',
            icon = '',
            color = { fg = colors.magenta },
          },
          {
            'diff',
            symbols = { added = ' ', modified = ' ', removed = ' ' },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },

        lualine_c = {
          {
            'filename',
            path = 1,
            symbols = {
              modified = ' 󰏫',
              readonly = ' 󰌾',
              unnamed = '',
              newfile = ' 󰎔',
            },
          },
          {
            navic_component,
            cond = function()
              return navic_ok and navic.is_available()
            end,
            color = { fg = colors.gray },
          },
          {
            macro_recording,
            color = { fg = colors.red, gui = 'bold' },
          },
          {
            search_count,
            color = { fg = colors.yellow },
          },
        },

        lualine_x = {
          -- Noice mode (recording, etc.)
          {
            function()
              return noice.api.status.mode.get()
            end,
            cond = function()
              return noice_ok and noice.api.status.mode.has()
            end,
            color = { fg = colors.cyan },
          },
          -- Lazy updates
          {
            function()
              return '󰚰 ' .. lazy_status.updates()
            end,
            cond = function()
              return lazy_ok and lazy_status.has_updates()
            end,
            color = { fg = colors.orange },
          },
          -- Python venv
          { python_venv, color = { fg = colors.green } },
          -- Diagnostics
          {
            'diagnostics',
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = '󰌵 ',
            },
          },
        },

        lualine_y = {
          { lsp_clients, color = { fg = colors.cyan } },
          { indent_info, color = { fg = colors.gray } },
          {
            'filetype',
            icon_only = true,
            padding = { left = 1, right = 0 },
          },
          { 'encoding', fmt = string.upper, color = { fg = colors.gray } },
        },

        lualine_z = {
          {
            'progress',
            fmt = function()
              return '%P/%L'
            end,
          },
          {
            'location',
            fmt = function()
              local line = vim.fn.line('.')
              local col = vim.fn.virtcol('.')
              return string.format('%3d:%-2d', line, col)
            end,
          },
          {
            function()
              return os.date('󰥔 %H:%M')
            end,
          },
        },
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            'filename',
            path = 1,
            symbols = { modified = ' 󰏫', readonly = ' 󰌾' },
          },
        },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },

      extensions = {
        'neo-tree',
        'lazy',
        'quickfix',
        'trouble',
        'toggleterm',
        'man',
        'mason',
      },
    }
  end,
  config = function(_, opts)
    require('lualine').setup(opts)

    -- Refresh lualine when recording macros
    vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
      callback = function()
        vim.schedule(function()
          require('lualine').refresh()
        end)
      end,
    })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
