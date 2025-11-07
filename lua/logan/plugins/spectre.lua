return {
  {
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      open_cmd = 'vnew',
      live_update = true,
      highlight = {
        ui = 'String',
        search = 'DiffChange',
        replace = 'DiffDelete',
      },
    },
    keys = {
      {
        '<leader>rr',
        function()
          require('spectre').open()
        end,
        desc = 'Spectre: project replace',
      },
      {
        '<leader>rw',
        function()
          require('spectre').open_visual { select_word = true }
        end,
        desc = 'Spectre: replace word',
      },
      {
        '<leader>rf',
        function()
          require('spectre').open_file_search()
        end,
        desc = 'Spectre: replace in file',
      },
    },
  },
}
