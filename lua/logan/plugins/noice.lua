-- noice.lua --
-- Better UI for messages, cmdline, and popups
-- Modern and clean notification system

return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  keys = {
    {
      '<S-Enter>',
      function()
        require('noice').redirect(vim.fn.getcmdline())
      end,
      mode = 'c',
      desc = 'Redirect cmdline',
    },
    {
      '<leader>nl',
      function()
        require('noice').cmd('last')
      end,
      desc = 'Noice last message',
    },
    {
      '<leader>na',
      function()
        require('noice').cmd('all')
      end,
      desc = 'Noice all',
    },
    {
      '<leader>nc',
      function()
        require('noice').cmd('dismiss')
      end,
      desc = 'Dismiss all',
    },
    {
      '<leader>nt',
      function()
        require('noice').cmd('pick')
      end,
      desc = 'Noice picker (Telescope)',
    },
    {
      '<C-f>',
      function()
        if not require('noice.lsp').scroll(4) then
          return '<C-f>'
        end
      end,
      silent = true,
      expr = true,
      desc = 'Scroll forward',
      mode = { 'i', 'n', 's' },
    },
    {
      '<C-b>',
      function()
        if not require('noice.lsp').scroll(-4) then
          return '<C-b>'
        end
      end,
      silent = true,
      expr = true,
      desc = 'Scroll backward',
      mode = { 'i', 'n', 's' },
    },
  },
  opts = {
    --  ╭──────────────────────────────────────────────────────────╮
    --  │                      Command Line                        │
    --  ╰──────────────────────────────────────────────────────────╯

    cmdline = {
      enabled = true,
      view = 'cmdline_popup',
      opts = {},
      format = {
        cmdline = { pattern = '^:', icon = '', lang = 'vim' },
        search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
        search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
        filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
        lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '', lang = 'lua' },
        help = { pattern = '^:%s*he?l?p?%s+', icon = '󰋖' },
        input = { view = 'cmdline_input', icon = '󰥻 ' },
      },
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Messages                           │
    --  ╰──────────────────────────────────────────────────────────╯

    messages = {
      enabled = true,
      view = 'notify',
      view_error = 'notify',
      view_warn = 'notify',
      view_history = 'messages',
      view_search = 'virtualtext',
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                      Popupmenu                           │
    --  ╰──────────────────────────────────────────────────────────╯

    popupmenu = {
      enabled = true,
      backend = 'nui',
      kind_icons = {},
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Redirect                          │
    --  ╰──────────────────────────────────────────────────────────╯

    redirect = {
      view = 'popup',
      filter = { event = 'msg_show' },
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       LSP                                │
    --  ╰──────────────────────────────────────────────────────────╯

    lsp = {
      progress = {
        enabled = true,
        format = 'lsp_progress',
        format_done = 'lsp_progress_done',
        throttle = 1000 / 30,
        view = 'mini',
      },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = false, -- We use blink.cmp
      },
      hover = {
        enabled = true,
        silent = false,
        view = nil,
        opts = {},
      },
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true,
          luasnip = true,
          throttle = 50,
        },
        view = nil,
        opts = {},
      },
      message = {
        enabled = true,
        view = 'notify',
        opts = {},
      },
      documentation = {
        view = 'hover',
        opts = {
          lang = 'markdown',
          replace = true,
          render = 'plain',
          format = { '{message}' },
          win_options = { concealcursor = 'n', conceallevel = 3 },
        },
      },
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Presets                            │
    --  ╰──────────────────────────────────────────────────────────╯

    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Views                             │
    --  ╰──────────────────────────────────────────────────────────╯

    views = {
      cmdline_popup = {
        position = {
          row = 5,
          col = '50%',
        },
        size = {
          width = 60,
          height = 'auto',
        },
        border = {
          style = 'rounded',
          padding = { 0, 1 },
        },
        filter_options = {},
        win_options = {
          winhighlight = {
            Normal = 'NoiceCmdlinePopup',
            FloatBorder = 'NoiceCmdlinePopupBorder',
          },
        },
      },
      popupmenu = {
        relative = 'editor',
        position = {
          row = 8,
          col = '50%',
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = 'rounded',
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = 'NoicePopupmenu',
            FloatBorder = 'NoicePopupmenuBorder',
          },
        },
      },
      mini = {
        timeout = 2500,
        win_options = {
          winblend = 0,
        },
      },
      hover = {
        border = {
          style = 'rounded',
          padding = { 0, 1 },
        },
        win_options = {
          winblend = 0,
          winhighlight = {
            Normal = 'NormalFloat',
            FloatBorder = 'FloatBorder',
          },
        },
      },
      notify = {
        merge = true,
        replace = true,
        timeout = 3000,
      },
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Routes                            │
    --  ╰──────────────────────────────────────────────────────────╯

    routes = {
      -- Hide "written" messages
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'written',
        },
        opts = { skip = true },
      },
      -- Hide search count messages
      {
        filter = {
          event = 'msg_show',
          kind = 'search_count',
        },
        opts = { skip = true },
      },
      -- Hide "No information available"
      {
        filter = {
          event = 'notify',
          find = 'No information available',
        },
        opts = { skip = true },
      },
      -- Hide "buffer" messages
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'buffer',
        },
        opts = { skip = true },
      },
      -- Hide "lines" messages
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'lines',
        },
        opts = { skip = true },
      },
      -- Hide "yanked" messages
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'yanked',
        },
        opts = { skip = true },
      },
      -- Route long messages to split
      {
        filter = {
          event = 'msg_show',
          min_height = 10,
        },
        view = 'split',
      },
      -- Route warnings to mini
      {
        filter = {
          event = 'msg_show',
          kind = 'wmsg',
        },
        view = 'mini',
      },
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Throttle                           │
    --  ╰──────────────────────────────────────────────────────────╯

    throttle = 1000 / 30,
  },
}

-- vim: ts=2 sts=2 sw=2 et
