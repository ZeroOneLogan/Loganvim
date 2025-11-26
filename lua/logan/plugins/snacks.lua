-- snacks.lua --
-- Snacks.nvim: Collection of small QOL improvements
-- Utilities for modern Neovim experience

local term = (vim.env.TERM or ''):lower()
local term_program = (vim.env.TERM_PROGRAM or ''):lower()
local has_kitty = term:find('kitty') ~= nil
local has_ghostty = term_program == 'ghostty'

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    --  ╭──────────────────────────────────────────────────────────╮
    --  │                      Big File                            │
    --  ╰──────────────────────────────────────────────────────────╯

    bigfile = {
      enabled = true,
      notify = true,
      size = 1.5 * 1024 * 1024, -- 1.5MB
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                      Notifier                            │
    --  ╰──────────────────────────────────────────────────────────╯

    notifier = {
      enabled = true,
      timeout = 3000,
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.6 },
      margin = { top = 0, right = 1, bottom = 0 },
      padding = true,
      sort = { 'level', 'added' },
      icons = {
        error = ' ',
        warn = ' ',
        info = ' ',
        debug = ' ',
        trace = ' ',
      },
      style = 'fancy',
      top_down = false,
      date_format = '%R',
      more_format = ' ↓ %d lines ',
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                      Quickfile                           │
    --  ╰──────────────────────────────────────────────────────────╯

    quickfile = {
      enabled = true,
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                      Statuscolumn                        │
    --  ╰──────────────────────────────────────────────────────────╯

    statuscolumn = {
      enabled = true,
      left = { 'mark', 'sign' },
      right = { 'fold', 'git' },
      folds = {
        open = false,
        git_hl = false,
      },
      git = {
        patterns = { 'GitSign' },
      },
      refresh = 50,
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Words                             │
    --  ╰──────────────────────────────────────────────────────────╯

    words = {
      enabled = true,
      debounce = 200,
      notify_jump = false,
      notify_end = true,
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                      Git Browse                          │
    --  ╰──────────────────────────────────────────────────────────╯

    gitbrowse = {
      enabled = true,
      notify = true,
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Terminal                           │
    --  ╰──────────────────────────────────────────────────────────╯

    terminal = {
      enabled = true,
      win = {
        style = 'terminal',
        border = 'rounded',
      },
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Input                             │
    --  ╰──────────────────────────────────────────────────────────╯

    input = {
      enabled = true,
      icon = ' ',
      icon_pos = 'left',
      prompt_pos = 'title',
      win = {
        style = 'input',
        border = 'rounded',
        relative = 'cursor',
        row = -3,
        col = 0,
      },
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Indent                            │
    --  ╰──────────────────────────────────────────────────────────╯

    indent = {
      enabled = true,
      indent = {
        char = '│',
        only_scope = false,
        only_current = false,
      },
      scope = {
        enabled = true,
        char = '│',
        underline = false,
        only_current = false,
      },
      animate = {
        enabled = false,
      },
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                         Dim                              │
    --  ╰──────────────────────────────────────────────────────────╯

    dim = {
      enabled = true,
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Scroll                            │
    --  ╰──────────────────────────────────────────────────────────╯

    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 250 },
        easing = 'linear',
      },
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Image                              │
    --  ╰──────────────────────────────────────────────────────────╯

    image = {
      enabled = has_kitty or has_ghostty,
      backend = 'kitty',
      tmux = vim.env.TMUX ~= nil,
      integrations = {
        markdown = { enabled = true },
      },
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                     Zen Mode                             │
    --  ╰──────────────────────────────────────────────────────────╯

    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = false,
        diagnostics = false,
        inlay_hints = false,
      },
      show = {
        statusline = false,
        tabline = false,
      },
      win = {
        style = 'zen',
        width = 120,
      },
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                      Dashboard                           │
    --  ╰──────────────────────────────────────────────────────────╯

    dashboard = {
      enabled = false, -- We use alpha.nvim
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Picker                             │
    --  ╰──────────────────────────────────────────────────────────╯

    picker = {
      enabled = false, -- We use telescope
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                      Explorer                            │
    --  ╰──────────────────────────────────────────────────────────╯

    explorer = {
      enabled = false, -- We use neo-tree
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Styles                            │
    --  ╰──────────────────────────────────────────────────────────╯

    styles = {
      notification = {
        border = 'rounded',
        wo = { wrap = true },
      },
    },
  },

  keys = {
    --  ╭────────────────────────────────────────────────────────╮
    --  │                    Notifications                       │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader>nh',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification history',
    },
    {
      '<leader>nd',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss notifications',
    },

    --  ╭────────────────────────────────────────────────────────╮
    --  │                      Git Browse                        │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader>go',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Open in browser',
      mode = { 'n', 'v' },
    },

    --  ╭────────────────────────────────────────────────────────╮
    --  │                      Terminal                          │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader>tt',
      function()
        Snacks.terminal()
      end,
      desc = 'Toggle terminal',
    },
    {
      '<C-\\>',
      function()
        Snacks.terminal()
      end,
      desc = 'Toggle terminal',
      mode = { 'n', 't' },
    },

    --  ╭────────────────────────────────────────────────────────╮
    --  │                        Words                           │
    --  ╰────────────────────────────────────────────────────────╯

    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Previous reference',
      mode = { 'n', 't' },
    },

    --  ╭────────────────────────────────────────────────────────╮
    --  │                       Zen Mode                         │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader>uz',
      function()
        Snacks.zen()
      end,
      desc = 'Toggle Zen mode',
    },
    {
      '<leader>uZ',
      function()
        Snacks.zen.zoom()
      end,
      desc = 'Toggle Zoom',
    },

    --  ╭────────────────────────────────────────────────────────╮
    --  │                     Scratch                            │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle scratch buffer',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select scratch buffer',
    },

    --  ╭────────────────────────────────────────────────────────╮
    --  │                      Buffer                            │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader>bx',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete buffer',
    },
    {
      '<leader>bX',
      function()
        Snacks.bufdelete.other()
      end,
      desc = 'Delete other buffers',
    },
  },

  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Global toggle mappings
        _G.Snacks = require('snacks')

        -- Setup debug print
        Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
        Snacks.toggle.diagnostics():map('<leader>ud')
        Snacks.toggle.line_number():map('<leader>ul')
        Snacks.toggle.treesitter():map('<leader>uT')
        Snacks.toggle.inlay_hints():map('<leader>uh')
        Snacks.toggle.dim():map('<leader>uD')
      end,
    })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
