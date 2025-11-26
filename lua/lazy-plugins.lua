-- lazy-plugins.lua --
--[[
  ╭──────────────────────────────────────────────────────────╮
  │              LoganVim Plugin Configuration               │
  │            Organized for Performance & Power              │
  ╰──────────────────────────────────────────────────────────╯
--]]

require('lazy').setup({
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                    Core Utilities                        │
  --  ╰──────────────────────────────────────────────────────────╯

  -- Detect tabstop and shiftwidth automatically
  { 'NMAC427/guess-indent.nvim', event = 'BufReadPre', opts = {} },

  -- Library dependencies
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'MunifTanjim/nui.nvim', lazy = true },
  { 'nvim-tree/nvim-web-devicons', lazy = true, enabled = vim.g.have_nerd_font },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                    Plugin Modules                        │
  --  ╰──────────────────────────────────────────────────────────╯

  -- Colorschemes & Theme
  require('logan.plugins.colorthemes'),

  -- UI Components
  require('logan.plugins.alpha'),
  require('logan.plugins.bufferline'),
  require('logan.plugins.lualine'),
  require('logan.plugins.noice'),
  require('logan.plugins.notify'),
  require('logan.plugins.indent_line'),
  require('logan.plugins.rainbow-delimiters'),
  require('logan.plugins.dressing'),

  -- Navigation & Search
  require('logan.plugins.telescope'),
  require('logan.plugins.neo-tree'),
  require('logan.plugins.flash'),
  require('logan.plugins.harpoon'),
  require('logan.plugins.outline'),

  -- Editor Features
  require('logan.plugins.which-key'),
  require('logan.plugins.mini'),
  require('logan.plugins.autopairs'),
  require('logan.plugins.comment'),
  require('logan.plugins.todo-comments'),
  require('logan.plugins.ufo'),
  require('logan.plugins.spectre'),
  require('logan.plugins.smart-splits'),
  require('logan.plugins.persistence'),

  -- LSP & Completion
  require('logan.plugins.lspconfig'),
  require('logan.plugins.blink-cmp'),
  require('logan.plugins.conform'),
  require('logan.plugins.lint'),
  require('logan.plugins.navic'),

  -- Treesitter
  require('logan.plugins.treesitter'),

  -- Diagnostics & Testing
  require('logan.plugins.diagnostics'),
  require('logan.plugins.trouble'),
  require('logan.plugins.neotest'),

  -- Git
  require('logan.plugins.gitsigns'),
  require('logan.plugins.neogit'),

  -- Debugging
  require('logan.plugins.debug'),

  -- AI Assistance
  require('logan.plugins.sidekick'),
  require('logan.plugins.copilot-chat'),

  -- Task Running
  require('logan.plugins.overseer'),
  require('logan.plugins.cmake-tools'),

  -- Utilities
  require('logan.plugins.snacks'),
}, {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                    Lazy.nvim Config                      │
  --  ╰──────────────────────────────────────────────────────────╯

  defaults = {
    lazy = true,  -- Enable lazy-loading by default
    version = false,  -- Try installing latest stable versions
  },

  install = {
    missing = true,
    colorscheme = { 'tokyonight', 'habamax' },
  },

  checker = {
    enabled = true,
    notify = false,
    frequency = 86400,  -- Check once per day
  },

  change_detection = {
    enabled = true,
    notify = false,
  },

  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
        'rplugin',
        'editorconfig',
        'spellfile',
      },
    },
  },

  ui = {
    size = { width = 0.8, height = 0.8 },
    border = 'rounded',
    title = ' 󰒲 LoganVim Plugins ',
    title_pos = 'center',
    icons = vim.g.have_nerd_font and {
      cmd = ' ',
      config = ' ',
      event = ' ',
      ft = ' ',
      init = ' ',
      import = ' ',
      keys = ' ',
      lazy = '󰒲 ',
      loaded = '●',
      not_loaded = '○',
      plugin = ' ',
      runtime = ' ',
      require = '󰢱 ',
      source = ' ',
      start = ' ',
      task = ' ',
      list = { '●', '➜', '★', '‒' },
    } or {
      cmd = '⌘ ',
      config = '🛠 ',
      event = '📅 ',
      ft = '📂 ',
      init = '⚙ ',
      import = ' ',
      keys = '🗝 ',
      lazy = '💤 ',
      loaded = '●',
      not_loaded = '○',
      plugin = '🔌 ',
      runtime = '💻 ',
      require = '🌙 ',
      source = '📄 ',
      start = '🚀 ',
      task = '📌 ',
    },
  },

  readme = {
    enabled = true,
    root = vim.fn.stdpath('state') .. '/lazy/readme',
    files = { 'README.md', 'lua/**/README.md' },
    skip_if_doc_exists = true,
  },
})

-- vim: ts=2 sts=2 sw=2 et
