-- colorthemes.lua --
-- Colorscheme Collection for LoganVim
-- Curated selection of beautiful themes

return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                     Tokyo Night                          │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    lazy = false,
    priority = 1000,
    opts = {
      style = 'night',
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = 'dark',
        floats = 'dark',
      },
      sidebars = { 'qf', 'help', 'terminal', 'neo-tree', 'Outline' },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
      on_highlights = function(hl, c)
        hl.CursorLineNr = { fg = c.orange, bold = true }
        hl.FloatBorder = { fg = c.blue, bg = c.bg_float }
        hl.FloatTitle = { fg = c.magenta, bg = c.bg_float, bold = true }
      end,
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                      Catppuccin                          │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
    opts = {
      flavour = 'mocha',
      background = {
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = 'dark',
        percentage = 0.15,
      },
      styles = {
        comments = { 'italic' },
        conditionals = { 'italic' },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      integrations = {
        alpha = true,
        cmp = true,
        blink_cmp = true,
        flash = true,
        gitsigns = true,
        harpoon = true,
        indent_blankline = { enabled = true, scope_color = 'lavender', colored_indent_levels = false },
        lsp_trouble = true,
        mason = true,
        mini = { enabled = true, indentscope_color = 'lavender' },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
          },
          underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            warnings = { 'underline' },
            information = { 'underline' },
          },
          inlay_hints = { background = true },
        },
        neogit = true,
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        nvim_surround = true,
        semantic_tokens = true,
        telescope = { enabled = true },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                      Kanagawa                            │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
    lazy = true,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function(colors)
        return {
          FloatBorder = { bg = colors.palette.sumiInk0 },
          NormalFloat = { bg = colors.palette.sumiInk0 },
          FloatTitle = { bg = colors.palette.sumiInk0, bold = true },
        }
      end,
      theme = 'wave',
      background = {
        dark = 'wave',
        light = 'lotus',
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                      Rose Pine                           │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = true,
    opts = {
      variant = 'auto',
      dark_variant = 'main',
      dim_inactive_windows = false,
      extend_background_behind_borders = true,
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
      groups = {
        border = 'muted',
        link = 'iris',
        panel = 'surface',
        error = 'love',
        hint = 'iris',
        info = 'foam',
        warn = 'gold',
        git_add = 'foam',
        git_change = 'rose',
        git_delete = 'love',
        git_dirty = 'rose',
        git_ignore = 'muted',
        git_merge = 'iris',
        git_rename = 'pine',
        git_stage = 'iris',
        git_text = 'rose',
        git_untracked = 'subtle',
        headings = {
          h1 = 'iris',
          h2 = 'foam',
          h3 = 'rose',
          h4 = 'gold',
          h5 = 'pine',
          h6 = 'foam',
        },
      },
      highlight_groups = {
        TelescopeBorder = { fg = 'highlight_high', bg = 'none' },
        TelescopeNormal = { bg = 'none' },
        TelescopePromptNormal = { bg = 'base' },
        TelescopeResultsNormal = { fg = 'subtle', bg = 'none' },
        TelescopeSelection = { fg = 'text', bg = 'base' },
        TelescopeSelectionCaret = { fg = 'rose', bg = 'rose' },
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                      Nightfox                            │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'EdenEast/nightfox.nvim',
    name = 'nightfox',
    lazy = true,
    opts = {
      options = {
        compile_path = vim.fn.stdpath('cache') .. '/nightfox',
        compile_file_suffix = '_compiled',
        transparent = false,
        terminal_colors = true,
        dim_inactive = false,
        module_default = true,
        styles = {
          comments = 'italic',
          keywords = 'bold',
          types = 'italic,bold',
        },
      },
      palettes = {},
      specs = {},
      groups = {},
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                        VSCode                            │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'Mofiqul/vscode.nvim',
    name = 'vscode',
    lazy = true,
    opts = {
      style = 'dark',
      transparent = false,
      italic_comments = true,
      disable_nvimtree_bg = true,
      color_overrides = {},
      group_overrides = {},
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                       Dracula                            │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'Mofiqul/dracula.nvim',
    name = 'dracula',
    lazy = true,
    opts = {
      show_end_of_buffer = false,
      transparent_bg = false,
      lualine_bg_color = nil,
      italic_comment = true,
      overrides = {},
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                    GitHub Theme                          │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = true,
    priority = 1000,
    config = function()
      require('github-theme').setup({
        options = {
          compile_path = vim.fn.stdpath('cache') .. '/github-theme',
          compile_file_suffix = '_compiled',
          hide_end_of_buffer = true,
          hide_nc_statusline = true,
          transparent = false,
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,
          styles = {
            comments = 'italic',
            keywords = 'bold',
            types = 'italic,bold',
            conditionals = 'NONE',
            constants = 'NONE',
            functions = 'NONE',
            numbers = 'NONE',
            operators = 'NONE',
            strings = 'NONE',
            variables = 'NONE',
          },
          inverse = {
            match_paren = false,
            visual = false,
            search = false,
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      })
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                       OneDark                            │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'olimorris/onedarkpro.nvim',
    name = 'onedarkpro',
    lazy = true,
    priority = 1000,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                        Nord                              │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'shaunsingh/nord.nvim',
    name = 'nord',
    lazy = true,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                       Sequoia                            │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'forest-nvim/sequoia.nvim',
    name = 'sequoia',
    lazy = true,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                      Night Owl                           │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'oxfist/night-owl.nvim',
    name = 'night-owl',
    lazy = true,
    opts = {},
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                      Colorizer                           │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      filetypes = {
        '*',
        '!lazy',
        '!mason',
        '!TelescopePrompt',
      },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = false,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = 'background',
        tailwind = 'both',
        sass = { enable = true, parsers = { 'css' } },
        virtualtext = '■',
        always_update = false,
      },
      buftypes = {},
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
