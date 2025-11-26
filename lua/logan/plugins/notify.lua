-- notify.lua --
-- Beautiful notifications for Neovim
-- Replaces the default vim.notify

return {
  'rcarriga/nvim-notify',
  lazy = false, -- Load early for notifications
  priority = 100,
  keys = {
    {
      '<leader>nd',
      function()
        require('notify').dismiss({ silent = true, pending = true })
      end,
      desc = 'Dismiss all notifications',
    },
  },
  opts = {
    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Animation                          │
    --  ╰──────────────────────────────────────────────────────────╯

    stages = 'fade_in_slide_out',
    timeout = 3000,
    fps = 60,

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Render                            │
    --  ╰──────────────────────────────────────────────────────────╯

    render = 'wrapped-compact',
    max_width = function()
      return math.floor(vim.o.columns * 0.4)
    end,
    max_height = function()
      return math.floor(vim.o.lines * 0.3)
    end,
    minimum_width = 40,

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Position                           │
    --  ╰──────────────────────────────────────────────────────────╯

    top_down = false,
    level = vim.log.levels.INFO,

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Icons                             │
    --  ╰──────────────────────────────────────────────────────────╯

    icons = {
      ERROR = '',
      WARN = '',
      INFO = '',
      DEBUG = '',
      TRACE = '✎',
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Background                         │
    --  ╰──────────────────────────────────────────────────────────╯

    background_colour = '#000000',

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Callbacks                          │
    --  ╰──────────────────────────────────────────────────────────╯

    on_open = function(win)
      vim.api.nvim_win_set_config(win, { zindex = 100 })
    end,
    on_close = function() end,
  },
  config = function(_, opts)
    local notify = require('notify')
    notify.setup(opts)

    -- Set as default notify handler
    vim.notify = notify

    -- Create telescope extension picker
    local ok, telescope = pcall(require, 'telescope')
    if ok then
      telescope.load_extension('notify')
    end
  end,
}

-- vim: ts=2 sts=2 sw=2 et
