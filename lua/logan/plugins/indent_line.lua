return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '▏',
        highlight = 'IblIndent',
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        highlight = 'IblScope',
      },
      whitespace = {
        remove_blankline_trail = true,
      },
    },
  },
}
