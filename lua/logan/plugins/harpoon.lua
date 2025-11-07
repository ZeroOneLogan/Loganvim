return {
  {
    'ThePrimeagen/harpoon',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local mark = require 'harpoon.mark'
      local ui = require 'harpoon.ui'

      require('harpoon').setup {
        menu = { width = math.floor(vim.o.columns * 0.3) },
        global_settings = {
          save_on_toggle = true,
          save_on_change = true,
          enter_on_sendcmd = true,
          excluded_filetypes = { 'alpha', 'neo-tree' },
        },
      }

      vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = 'Harpoon: Add file' })
      vim.keymap.set('n', '<leader>hh', ui.toggle_quick_menu, { desc = 'Harpoon: Toggle menu' })
      vim.keymap.set('n', '<leader>hx', mark.rm_file, { desc = 'Harpoon: Remove file' })
      vim.keymap.set('n', '<leader>hn', ui.nav_next, { desc = 'Harpoon: Next file' })
      vim.keymap.set('n', '<leader>hp', ui.nav_prev, { desc = 'Harpoon: Prev file' })

      for i = 1, 4 do
        vim.keymap.set('n', string.format('<leader>h%d', i), function()
          ui.nav_file(i)
        end, { desc = string.format('Harpoon: Goto slot %d', i) })
      end
    end,
  },
}
