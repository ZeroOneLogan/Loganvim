return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'windwp/nvim-ts-autotag',
    },
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'json',
        'javascript',
        'typescript',
        'tsx',
        'yaml',
        'css',
        'prisma',
        'svelte',
        'graphql',
        'dockerfile',
        'gitignore',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'vim',
        'vimdoc',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      autotag = { enable = true, enable_close_on_slash = true },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
            ['acm'] = '@comment.outer',
          },
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = 'V',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = { ['<leader>ta'] = '@parameter.inner' },
          swap_previous = { ['<leader>tA'] = '@parameter.inner' },
        },
        lsp_interop = {
          enable = true,
          peek_definition_code = {
            ['gp'] = '@function.outer',
            ['gP'] = '@class.outer',
          },
        },
      },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = true,
      max_lines = 3,
      multiline_threshold = 5,
      trim_scope = 'outer',
      mode = 'cursor',
      separator = '-',
    },
    keys = {
      {
        '<leader>tc',
        function()
          require('treesitter-context').toggle()
        end,
        desc = 'TS Context: Toggle',
      },
      {
        '<leader>tp',
        function()
          require('treesitter-context').go_to_context()
        end,
        desc = 'TS Context: Go to parent',
      },
    },
    config = function(_, opts)
      require('treesitter-context').setup(opts)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
