local schemes = {
  { 'folke/tokyonight.nvim', name = 'tokyonight', lazy = false, priority = 1000 },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  { 'webhooked/oscura.nvim', name = 'oscura', enabled = false, lazy = true, opts = {} },
  { 'Mofiqul/vscode.nvim', name = 'vscode', lazy = true, opts = {} },
  { 'slugbyte/lackluster.nvim', name = 'lackluster', enabled = false, lazy = true, opts = {} },
  { 'projekt0n/github-nvim-theme', name = 'github-theme', lazy = true },
  { 'forest-nvim/sequoia.nvim', name = 'sequoia', lazy = true },
  { 'shaunsingh/nord.nvim', name = 'nord', lazy = true },
  { 'EdenEast/nightfox.nvim', name = 'nightfox', lazy = true },
  { 'p00f/alabaster.nvim', name = 'alabaster', enabled = false, lazy = true },
  {
    'armannikoyan/rusty',
    name = 'rusty',
    enabled = false,
    lazy = true,
    opts = { transparent = true, italic_comments = true, underline_current_line = true },
  },
  { 'oxfist/night-owl.nvim', name = 'night-owl', lazy = true, opts = {} },
  { 'rebelot/kanagawa.nvim', name = 'kanagawa', lazy = true, opts = {} },
  { 'olimorris/onedarkpro.nvim', name = 'onedarkpro', lazy = true },
  { 'sainnhe/everforest', name = 'everforest', enabled = false, lazy = true },
  { 'rose-pine/neovim', name = 'rose-pine', lazy = true },
  { 'Mofiqul/dracula.nvim', name = 'dracula', lazy = true, opts = {} },
}

schemes[#schemes + 1] = {
  -- color html colors
  'NvChad/nvim-colorizer.lua',
  event = 'VeryLazy',
  opts = {
    filetypes = { 'html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte', 'astro' },
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      names = true,
      RRGGBBAA = true,
      AARRGGBB = false,
      rgb_fn = false,
      hsl_fn = false,
      css = false,
      css_fn = false,
      mode = 'background',
      tailwind = false,
      sass = { enable = false, parsers = { 'css' } },
      virtualtext = '■',
      always_update = false,
    },
    buftypes = {},
  },
}

return schemes
