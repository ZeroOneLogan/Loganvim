return {
  {
    'SmiteshP/nvim-navic',
    lazy = true,
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = {
      depth_limit = 5,
      highlight = true,
      separator = '  ',
      safe_output = true,
    },
  },
}
