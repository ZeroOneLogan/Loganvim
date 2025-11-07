-- noice --
return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
  opts = {
    lsp = {
      progress = { enabled = false },
      signature = { enabled = true },
      hover = { enabled = true },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        -- (drop cmp override since you're on blink.cmp)
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = false,
    },

    views = {
      notify = { merge = true, replace = true, timeout = 2500 },
      cmdline_popup = { border = { style = 'rounded' }, win_options = { winblend = 0 } },
      popupmenu = { border = { style = 'rounded' }, win_options = { winblend = 0 } },
      mini = { timeout = 800 },
    },

    routes = {
      { filter = { event = 'msg_show', kind = '', find = 'written' }, opts = { skip = true } },
      { filter = { event = 'msg_show', kind = '', find = 'bytes' }, opts = { skip = true } },
      { filter = { event = 'msg_show', kind = '', find = 'lines' }, opts = { skip = true } },
      { filter = { event = 'msg_show', kind = '', find = 'yanked' }, opts = { skip = true } },
      { filter = { event = 'msg_show', kind = 'search_count' }, opts = { skip = true } },
      { filter = { event = 'msg_show', kind = 'echomsg', find = 'E486: Pattern not found' }, opts = { skip = true } },
      -- route really long messages to split (helpful for LSP walls of text)
      { filter = { event = 'msg_show', min_height = 10 }, view = 'split' },
    },

    throttle = 20,
    notify = { enabled = true },
  },
}
