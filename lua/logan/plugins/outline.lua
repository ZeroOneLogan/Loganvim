return {
  {
    'hedyhli/outline.nvim',
    cmd = { 'Outline', 'OutlineOpen' },
    keys = {
      { '<leader>o', '<cmd>Outline<CR>', desc = 'Symbol outline' },
    },
    opts = {
      outline_window = {
        position = 'right',
        width = 40,
        auto_jump = true,
      },
      preview_window = {
        auto_preview = true,
        width = 60,
      },
      guides = {
        mid_item = '├╴',
        last_item = '└╴',
        nested_top = '│ ',
        whitespace = '  ',
      },
    },
  },
}
