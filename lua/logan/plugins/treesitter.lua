-- treesitter.lua --
-- Complete Treesitter Configuration for LoganVim
-- Optimized for syntax, navigation, and code understanding

return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                Main Treesitter Config                    │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile', 'VeryLazy' },
    lazy = vim.fn.argc(-1) == 0, -- Load early when opening a file from CLI
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      { 'windwp/nvim-ts-autotag', opts = {} },
    },
    init = function(plugin)
      -- Perf: add treesitter queries to rtp before loading plugins
      require('lazy.core.loader').add_to_rtp(plugin)
      require('nvim-treesitter.query_predicates')
    end,
    keys = {
      { '<C-space>', desc = 'Increment selection' },
      { '<bs>', desc = 'Decrement selection', mode = 'x' },
    },
    opts = {
      ensure_installed = {
        -- Core
        'vim',
        'vimdoc',
        'lua',
        'luadoc',
        'luap',
        'query',
        'regex',

        -- Shell
        'bash',
        'fish',

        -- Web
        'html',
        'css',
        'scss',
        'javascript',
        'typescript',
        'tsx',
        'vue',
        'svelte',
        'astro',

        -- Data
        'json',
        'json5',
        'jsonc',
        'yaml',
        'toml',
        'xml',

        -- Documentation
        'markdown',
        'markdown_inline',
        'rst',
        'mermaid',

        -- Programming
        'python',
        'rust',
        'go',
        'gomod',
        'gosum',
        'gowork',
        'c',
        'cpp',
        'java',
        'kotlin',

        -- Config
        'dockerfile',
        'make',
        'cmake',
        'ninja',

        -- Database
        'sql',
        'prisma',
        'graphql',

        -- Git
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'diff',

        -- Other
        'comment',
        'jsdoc',
        'http',
        'printf',
      },

      auto_install = true,
      sync_install = false,

      highlight = {
        enable = true,
        disable = function(lang, buf)
          -- Disable for large files
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
          return false
        end,
        additional_vim_regex_highlighting = { 'ruby', 'org' },
      },

      indent = {
        enable = true,
        disable = { 'ruby', 'yaml' },
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = { query = '@function.outer', desc = 'Select outer function' },
            ['if'] = { query = '@function.inner', desc = 'Select inner function' },
            ['ac'] = { query = '@class.outer', desc = 'Select outer class' },
            ['ic'] = { query = '@class.inner', desc = 'Select inner class' },
            ['aa'] = { query = '@parameter.outer', desc = 'Select outer parameter' },
            ['ia'] = { query = '@parameter.inner', desc = 'Select inner parameter' },
            ['al'] = { query = '@loop.outer', desc = 'Select outer loop' },
            ['il'] = { query = '@loop.inner', desc = 'Select inner loop' },
            ['ai'] = { query = '@conditional.outer', desc = 'Select outer conditional' },
            ['ii'] = { query = '@conditional.inner', desc = 'Select inner conditional' },
            ['ab'] = { query = '@block.outer', desc = 'Select outer block' },
            ['ib'] = { query = '@block.inner', desc = 'Select inner block' },
            ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
          },
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = 'V',
          },
          include_surrounding_whitespace = true,
        },

        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = { query = '@function.outer', desc = 'Next function start' },
            [']c'] = { query = '@class.outer', desc = 'Next class start' },
            [']a'] = { query = '@parameter.inner', desc = 'Next parameter' },
            [']l'] = { query = '@loop.outer', desc = 'Next loop start' },
            [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
            [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
          },
          goto_next_end = {
            [']F'] = { query = '@function.outer', desc = 'Next function end' },
            [']C'] = { query = '@class.outer', desc = 'Next class end' },
          },
          goto_previous_start = {
            ['[f'] = { query = '@function.outer', desc = 'Previous function start' },
            ['[c'] = { query = '@class.outer', desc = 'Previous class start' },
            ['[a'] = { query = '@parameter.inner', desc = 'Previous parameter' },
            ['[l'] = { query = '@loop.outer', desc = 'Previous loop start' },
            ['[s'] = { query = '@scope', query_group = 'locals', desc = 'Previous scope' },
            ['[z'] = { query = '@fold', query_group = 'folds', desc = 'Previous fold' },
          },
          goto_previous_end = {
            ['[F'] = { query = '@function.outer', desc = 'Previous function end' },
            ['[C'] = { query = '@class.outer', desc = 'Previous class end' },
          },
        },

        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = { query = '@parameter.inner', desc = 'Swap next parameter' },
          },
          swap_previous = {
            ['<leader>A'] = { query = '@parameter.inner', desc = 'Swap previous parameter' },
          },
        },

        lsp_interop = {
          enable = true,
          border = 'rounded',
          floating_preview_opts = {},
          peek_definition_code = {
            ['<leader>pf'] = { query = '@function.outer', desc = 'Peek function definition' },
            ['<leader>pc'] = { query = '@class.outer', desc = 'Peek class definition' },
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      -- Setup folding
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                Treesitter Context                        │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = {
      enable = true,
      max_lines = 3,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = 'outer',
      mode = 'cursor',
      separator = nil,
      zindex = 20,
    },
    keys = {
      {
        '<leader>tc',
        function()
          require('treesitter-context').toggle()
        end,
        desc = 'Toggle TS Context',
      },
      {
        '<leader>tp',
        function()
          require('treesitter-context').go_to_context(vim.v.count1)
        end,
        desc = 'Go to context',
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │              Treesitter Textsubjects                     │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'RRethy/nvim-treesitter-textsubjects',
    event = 'VeryLazy',
    config = function()
      require('nvim-treesitter.configs').setup({
        textsubjects = {
          enable = true,
          prev_selection = ',',
          keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = { 'textsubjects-container-inner', desc = 'Select inside containers' },
          },
        },
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
