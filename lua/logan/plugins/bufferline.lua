return {
  'akinsho/bufferline.nvim',
  version = '*',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    {
      ']b',
      function()
        require('bufferline').cycle(1)
      end,
      desc = 'Buffer: next',
    },
    {
      '[b',
      function()
        require('bufferline').cycle(-1)
      end,
      desc = 'Buffer: previous',
    },
    {
      '<leader>bp',
      function()
        require('bufferline').pick()
      end,
      desc = 'Buffer: pick',
    },
    {
      '<leader>b<',
      function()
        require('bufferline').move(-1)
      end,
      desc = 'Buffer: move left',
    },
    {
      '<leader>b>',
      function()
        require('bufferline').move(1)
      end,
      desc = 'Buffer: move right',
    },
  },
  opts = function()
    local bufferline = require 'bufferline'
    return {
      options = {
        mode = 'buffers',
        style_preset = bufferline.style_preset.minimal,
        show_close_icon = false,
        show_buffer_close_icons = false,
        always_show_bufferline = false,
        indicator = { icon = '▎', style = 'icon' },
        separator_style = { '', '' },
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(_, _, diag)
          local symbols = { error = ' ', warning = ' ', info = ' ' }
          local ret = (diag.error and symbols.error .. diag.error .. ' ' or '') .. (diag.warning and symbols.warning .. diag.warning or '')
          return ret ~= '' and ret or ''
        end,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            highlight = 'Directory',
            separator = true,
          },
        },
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
        custom_areas = {
          right = function()
            local ok, lazy = pcall(require, 'lazy.status')
            if ok and lazy.has_updates() then
              return { { text = ' ﮮ ' .. lazy.updates(), fg = '#f38ba8' } }
            end
            return {}
          end,
        },
      },
    }
  end,
}
