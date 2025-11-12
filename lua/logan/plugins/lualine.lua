return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local lualine = require 'lualine'
    local lazy_status = require 'lazy.status'
    local navic_ok, navic = pcall(require, 'nvim-navic')
    local noice_ok, noice = pcall(require, 'noice')
    local sidekick_status_ok, sidekick_status = pcall(require, 'sidekick.status')
    local devicons = require 'nvim-web-devicons'

    local function navic_component()
      if navic_ok and navic.is_available() then
        return navic.get_location()
      end
      return ''
    end

    local function macro_recording()
      local reg = vim.fn.reg_recording()
      if reg == '' then
        return ''
      end
      return ' @' .. reg
    end

    local function format_filetype()
      local ft = vim.bo.filetype ~= '' and vim.bo.filetype or 'plain'
      local icon = devicons.get_icon_by_filetype(ft, { default = true })
      return string.format('%s %s', icon or '', ft)
    end

    local function hl_color(name)
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
      if not ok then
        local legacy_ok, legacy = pcall(vim.api.nvim_get_hl_by_name, name, true)
        if not legacy_ok then
          return nil
        end
        hl = legacy
      end
      local fg = hl.fg or hl.foreground
      if not fg then
        return nil
      end
      return { fg = string.format('#%06x', fg) }
    end

    local function sidekick_lsp_status()
      if not sidekick_status_ok then
        return ''
      end
      local status = sidekick_status.get()
      if not status then
        return ''
      end
      local message = status.message
      if message and #message > 32 then
        message = message:sub(1, 29) .. '…'
      end
      if status.busy and message and message ~= '' then
        return ' ' .. message
      end
      if status.kind ~= 'Normal' and message and message ~= '' then
        return ' ' .. message
      end
      return ''
    end

    local function sidekick_has_status()
      return sidekick_status_ok and sidekick_status.get() ~= nil
    end

    local function sidekick_lsp_color()
      if not sidekick_status_ok then
        return nil
      end
      local status = sidekick_status.get()
      if not status then
        return nil
      end
      local group = status.kind == 'Error' and 'DiagnosticError' or status.busy and 'DiagnosticWarn' or 'Special'
      return hl_color(group)
    end

    local function sidekick_cli_component()
      if not sidekick_status_ok then
        return ''
      end
      local sessions = sidekick_status.cli()
      local count = #sessions
      if count == 0 then
        return ''
      end
      if count == 1 then
        return ' ' .. sessions[1].tool
      end
      return ' ' .. count
    end

    local function sidekick_has_cli_sessions()
      return sidekick_status_ok and #sidekick_status.cli() > 0
    end

    lualine.setup {
      options = {
        theme = 'auto',
        globalstatus = true,
        disabled_filetypes = { 'alpha' },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(str)
              return ' ' .. str:sub(1, 1)
            end,
          },
        },
        lualine_b = {
          { 'branch', icon = '' },
          { 'diff', symbols = { added = ' ', modified = ' ', removed = ' ' } },
          {
            'diagnostics',
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
          },
        },
        lualine_c = {
          { 'filename', path = 1, newfile_status = true, symbols = { modified = ' ', readonly = ' ', unnamed = '' } },
          {
            navic_component,
            cond = function()
              return navic_ok and navic.is_available()
            end,
            color = { fg = '#a6e3a1' },
          },
          { macro_recording },
          {
            sidekick_lsp_status,
            cond = sidekick_has_status,
            color = sidekick_lsp_color,
          },
        },
        lualine_x = {
          {
            function()
              if noice_ok then
                return noice.api.status.mode.get()
              end
            end,
            cond = function()
              return noice_ok and noice.api.status.mode.has()
            end,
            color = { fg = '#89b4fa' },
          },
          {
            sidekick_cli_component,
            cond = sidekick_has_cli_sessions,
            color = function()
              return hl_color 'Special'
            end,
          },
          { lazy_status.updates, cond = lazy_status.has_updates, color = { fg = '#ff9e63' } },
          {
            function()
              local ok, shiftwidth = pcall(vim.api.nvim_buf_get_option, 0, 'shiftwidth')
              if not ok then
                return ''
              end
              local expand = vim.bo.expandtab and '␠' or '⇥'
              local width = shiftwidth > 0 and shiftwidth or vim.bo.tabstop
              return string.format('%s %d', expand, width)
            end,
            cond = function()
              return vim.bo.filetype ~= ''
            end,
          },
          { format_filetype },
        },
        lualine_y = {
          { 'progress' },
        },
        lualine_z = {
          { 'location', icon = '' },
          {
            function()
              return os.date '%I:%M %p'
            end,
            icon = '󰥔',
          },
        },
      },
      extensions = { 'neo-tree', 'lazy', 'quickfix', 'trouble', 'fugitive' },
    }

    vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
      callback = function()
        vim.schedule(function()
          lualine.refresh()
        end)
      end,
    })
  end,
}
