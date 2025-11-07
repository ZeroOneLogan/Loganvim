return {
  {
    'folke/persistence.nvim',
    lazy = false,
    opts = {
      options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals' },
      pre_save = function()
        -- close neo-tree to avoid weird restore layouts
        pcall(vim.cmd, 'Neotree close')
      end,
    },
    keys = {
      {
        '<leader>qs',
        function()
          require('persistence').load()
        end,
        desc = 'Session: restore last',
      },
      {
        '<leader>ql',
        function()
          require('persistence').load { last = true }
        end,
        desc = 'Session: restore previous',
      },
      {
        '<leader>qd',
        function()
          require('persistence').stop()
          vim.notify('Session persistence disabled for this tab', vim.log.levels.INFO)
        end,
        desc = 'Session: stop',
      },
    },
  },
}
