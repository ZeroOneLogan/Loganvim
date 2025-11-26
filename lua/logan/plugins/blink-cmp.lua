-- blink-cmp.lua --
-- Ultimate Autocompletion for Neovim 0.11.5
-- Fast, feature-rich, and beautifully designed

return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                    Copilot Client                        │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
        gitcommit = true,
        gitrebase = false,
        ['.'] = false,
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                    Blink Completion                      │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    version = '1.*',
    dependencies = {
      'fang2hou/blink-copilot',
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
              -- Add custom snippets path
              require('luasnip.loaders.from_vscode').lazy_load({
                paths = { vim.fn.stdpath('config') .. '/snippets' },
              })
            end,
          },
        },
        opts = {
          history = true,
          delete_check_events = 'TextChanged',
        },
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      --  ╭────────────────────────────────────────────────────────╮
      --  │                      Keymaps                           │
      --  ╰────────────────────────────────────────────────────────╯

      keymap = {
        preset = 'default',

        -- Tab for snippets and sidekick
        ['<Tab>'] = {
          'snippet_forward',
          function()
            local ok, sidekick = pcall(require, 'sidekick')
            if ok then return sidekick.nes_jump_or_apply() end
          end,
          'fallback',
        },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

        -- Accept with Enter
        ['<CR>'] = { 'accept', 'fallback' },

        -- Navigate completions
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },

        -- Scroll docs
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        -- Toggle completion
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
      },

      --  ╭────────────────────────────────────────────────────────╮
      --  │                     Appearance                         │
      --  ╰────────────────────────────────────────────────────────╯

      appearance = {
        nerd_font_variant = 'normal',
        kind_icons = {
          Text = '󰉿',
          Method = '󰊕',
          Function = '󰊕',
          Constructor = '󰒓',
          Field = '󰜢',
          Variable = '󰀫',
          Class = '󰠱',
          Interface = '',
          Module = '󰏗',
          Property = '󰜢',
          Unit = '',
          Value = '󰎠',
          Enum = '',
          Keyword = '󰌋',
          Snippet = '',
          Color = '󰏘',
          File = '󰈙',
          Reference = '',
          Folder = '󰉋',
          EnumMember = '',
          Constant = '󰏿',
          Struct = '󰆼',
          Event = '',
          Operator = '󰆕',
          TypeParameter = '󰅲',
          Copilot = '',
        },
      },

      --  ╭────────────────────────────────────────────────────────╮
      --  │                     Completion                         │
      --  ╰────────────────────────────────────────────────────────╯

      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          update_delay_ms = 50,
          treesitter_highlighting = true,
          window = {
            min_width = 10,
            max_width = 80,
            max_height = 20,
            border = 'rounded',
            winblend = 0,
            winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc',
          },
        },
        list = {
          max_items = 200,
          selection = {
            preselect = function(ctx)
              return ctx.mode ~= 'cmdline'
            end,
            auto_insert = function(ctx)
              return ctx.mode == 'cmdline'
            end,
          },
        },
        menu = {
          enabled = true,
          min_width = 15,
          max_height = 10,
          border = 'rounded',
          winblend = 0,
          winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
          scrolloff = 2,
          scrollbar = true,
          draw = {
            align_to = 'label',
            padding = 1,
            gap = 1,
            treesitter = { 'lsp' },
            columns = {
              { 'kind_icon' },
              { 'label', 'label_description', gap = 1 },
              { 'source_name' },
            },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
              source_name = {
                width = { max = 30 },
                text = function(ctx)
                  return '[' .. ctx.source_name .. ']'
                end,
                highlight = 'BlinkCmpSource',
              },
            },
          },
        },
        ghost_text = {
          enabled = false, -- Disabled since we use Copilot
        },
      },

      --  ╭────────────────────────────────────────────────────────╮
      --  │                       Sources                          │
      --  ╰────────────────────────────────────────────────────────╯

      sources = {
        default = { 'copilot', 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        per_filetype = {
          lua = { 'copilot', 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 100,
            async = true,
            opts = {
              max_completions = 3,
              max_attempts = 4,
            },
          },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 90,
          },
          lsp = {
            name = 'LSP',
            module = 'blink.cmp.sources.lsp',
            fallbacks = { 'buffer' },
            score_offset = 80,
            transform_items = function(_, items)
              -- Filter out text completions from LSP
              return vim.tbl_filter(function(item)
                return item.kind ~= require('blink.cmp.types').CompletionItemKind.Text
              end, items)
            end,
          },
          path = {
            name = 'Path',
            module = 'blink.cmp.sources.path',
            score_offset = 70,
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
            },
          },
          buffer = {
            name = 'Buffer',
            module = 'blink.cmp.sources.buffer',
            score_offset = 50,
            opts = {
              -- Get words from all visible buffers
              get_bufnrs = function()
                return vim.tbl_filter(function(buf)
                  return vim.bo[buf].buftype == ''
                end, vim.api.nvim_list_bufs())
              end,
            },
          },
          snippets = {
            name = 'Snippets',
            module = 'blink.cmp.sources.snippets',
            score_offset = 60,
            opts = {
              friendly_snippets = true,
              search_paths = { vim.fn.stdpath('config') .. '/snippets' },
            },
          },
        },
      },

      --  ╭────────────────────────────────────────────────────────╮
      --  │                      Snippets                          │
      --  ╰────────────────────────────────────────────────────────╯

      snippets = {
        preset = 'luasnip',
      },

      --  ╭────────────────────────────────────────────────────────╮
      --  │                       Fuzzy                            │
      --  ╰────────────────────────────────────────────────────────╯

      fuzzy = {
        implementation = 'prefer_rust_with_warning',
        use_typo_resistance = true,
        use_frecency = true,
        use_proximity = true,
        sorts = { 'score', 'kind', 'label' },
      },

      --  ╭────────────────────────────────────────────────────────╮
      --  │                     Command Line                       │
      --  ╰────────────────────────────────────────────────────────╯

      cmdline = {
        enabled = true,
        completion = {
          menu = {
            auto_show = true,
          },
        },
        keymap = {
          ['<Tab>'] = { 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
          ['<CR>'] = { 'accept', 'fallback' },
          ['<C-e>'] = { 'cancel', 'fallback' },
        },
      },

      --  ╭────────────────────────────────────────────────────────╮
      --  │                      Signature                         │
      --  ╰────────────────────────────────────────────────────────╯

      signature = {
        enabled = true,
        window = {
          border = 'rounded',
          winblend = 0,
          winhighlight = 'Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder',
          treesitter_highlighting = true,
        },
      },
    },

    config = function(_, opts)
      -- Setup mini.icons for completion icons
      local ok, mini_icons = pcall(require, 'mini.icons')
      if ok then
        mini_icons.setup()
      end

      require('blink.cmp').setup(opts)
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
