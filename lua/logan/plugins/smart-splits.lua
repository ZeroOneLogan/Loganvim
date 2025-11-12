return {
  {
    'mrjones2014/smart-splits.nvim',
    event = 'VeryLazy',
    opts = {
      ignored_filetypes = { 'alpha', 'neo-tree' },
      ignored_buftypes = { 'nofile', 'prompt' },
      default_amount = 3,
      at_edge = 'stop',
      multiplexer_integration = 'tmux',
      resize_mode = {
        silent = true,
        hooks = {
          on_leave = function()
            vim.notify_once('Resize mode exited', vim.log.levels.INFO)
          end,
        },
      },
    },
    keys = {
      {
        '<leader>wr',
        function()
          require('smart-splits').start_resize_mode()
        end,
        desc = 'Resize windows',
      },
    },
    config = function(_, opts)
      local smart_splits = require 'smart-splits'
      smart_splits.setup(opts)

      -- Resize with Alt + hjkl
      vim.keymap.set('n', '<A-h>', smart_splits.resize_left, { desc = 'Resize split left' })
      vim.keymap.set('n', '<A-l>', smart_splits.resize_right, { desc = 'Resize split right' })
      vim.keymap.set('n', '<A-j>', smart_splits.resize_down, { desc = 'Resize split down' })
      vim.keymap.set('n', '<A-k>', smart_splits.resize_up, { desc = 'Resize split up' })

      -- Swap buffers between windows
      vim.keymap.set('n', '<leader>wh', smart_splits.swap_buf_left, { desc = 'Swap buffer left' })
      vim.keymap.set('n', '<leader>wl', smart_splits.swap_buf_right, { desc = 'Swap buffer right' })
      vim.keymap.set('n', '<leader>wj', smart_splits.swap_buf_down, { desc = 'Swap buffer down' })
      vim.keymap.set('n', '<leader>wk', smart_splits.swap_buf_up, { desc = 'Swap buffer up' })
    end,
  },
}
