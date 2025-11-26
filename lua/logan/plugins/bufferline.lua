-- bufferline.lua --
-- Beautiful buffer/tab line for LoganVim
-- Feature-rich with elegant design

return {
  'akinsho/bufferline.nvim',
  version = '*',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>bp', '<cmd>BufferLineTogglePin<CR>', desc = 'Toggle pin' },
    { '<leader>bP', '<cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete non-pinned buffers' },
    { '<leader>bo', '<cmd>BufferLineCloseOthers<CR>', desc = 'Close other buffers' },
    { '<leader>br', '<cmd>BufferLineCloseRight<CR>', desc = 'Close buffers to the right' },
    { '<leader>bl', '<cmd>BufferLineCloseLeft<CR>', desc = 'Close buffers to the left' },
    { '<S-h>', '<cmd>BufferLineCyclePrev<CR>', desc = 'Previous buffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
    { '[b', '<cmd>BufferLineCyclePrev<CR>', desc = 'Previous buffer' },
    { ']b', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
    { '[B', '<cmd>BufferLineMovePrev<CR>', desc = 'Move buffer left' },
    { ']B', '<cmd>BufferLineMoveNext<CR>', desc = 'Move buffer right' },
    { '<leader>b1', '<cmd>BufferLineGoToBuffer 1<CR>', desc = 'Go to buffer 1' },
    { '<leader>b2', '<cmd>BufferLineGoToBuffer 2<CR>', desc = 'Go to buffer 2' },
    { '<leader>b3', '<cmd>BufferLineGoToBuffer 3<CR>', desc = 'Go to buffer 3' },
    { '<leader>b4', '<cmd>BufferLineGoToBuffer 4<CR>', desc = 'Go to buffer 4' },
    { '<leader>b5', '<cmd>BufferLineGoToBuffer 5<CR>', desc = 'Go to buffer 5' },
    { '<leader>b6', '<cmd>BufferLineGoToBuffer 6<CR>', desc = 'Go to buffer 6' },
    { '<leader>b7', '<cmd>BufferLineGoToBuffer 7<CR>', desc = 'Go to buffer 7' },
    { '<leader>b8', '<cmd>BufferLineGoToBuffer 8<CR>', desc = 'Go to buffer 8' },
    { '<leader>b9', '<cmd>BufferLineGoToBuffer 9<CR>', desc = 'Go to buffer 9' },
    { '<leader>b$', '<cmd>BufferLineGoToBuffer -1<CR>', desc = 'Go to last buffer' },
  },
  opts = {
    options = {
      mode = 'buffers',
      themable = true,
      numbers = function(opts)
        return string.format('%s', opts.ordinal)
      end,
      close_command = function(n)
        require('mini.bufremove').delete(n, false)
      end,
      right_mouse_command = function(n)
        require('mini.bufremove').delete(n, false)
      end,
      left_mouse_command = 'buffer %d',
      middle_mouse_command = nil,
      indicator = {
        icon = '▎',
        style = 'icon',
      },
      buffer_close_icon = '󰅖',
      modified_icon = '●',
      close_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',
      max_name_length = 30,
      max_prefix_length = 15,
      truncate_names = true,
      tab_size = 21,
      diagnostics = 'nvim_lsp',
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(_, _, diag)
        local icons = { error = ' ', warning = ' ', hint = '󰌵 ', info = ' ' }
        local ret = (diag.error and icons.error .. diag.error .. ' ' or '')
          .. (diag.warning and icons.warning .. diag.warning .. ' ' or '')
          .. (diag.hint and icons.hint .. diag.hint .. ' ' or '')
          .. (diag.info and icons.info .. diag.info or '')
        return vim.trim(ret)
      end,
      custom_filter = function(buf_number)
        -- Filter out filetypes you don't want to see
        local ft = vim.bo[buf_number].filetype
        if ft == 'qf' then
          return false
        end
        return true
      end,
      offsets = {
        {
          filetype = 'neo-tree',
          text = ' File Explorer',
          text_align = 'center',
          separator = true,
          highlight = 'Directory',
        },
        {
          filetype = 'Outline',
          text = ' Symbols',
          text_align = 'center',
          separator = true,
          highlight = 'Directory',
        },
      },
      color_icons = true,
      get_element_icon = function(element)
        local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
        return icon, hl
      end,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      show_duplicate_prefix = true,
      persist_buffer_sort = true,
      move_wraps_at_ends = false,
      separator_style = 'thin',
      enforce_regular_tabs = false,
      always_show_bufferline = false,
      hover = {
        enabled = true,
        delay = 200,
        reveal = { 'close' },
      },
      sort_by = 'insert_after_current',
      groups = {
        options = {
          toggle_hidden_on_enter = true,
        },
        items = {
          {
            name = 'Tests',
            highlight = { underline = true, sp = 'blue' },
            priority = 2,
            icon = '',
            matcher = function(buf)
              return buf.name:match('%_test') or buf.name:match('%_spec') or buf.name:match('test_')
            end,
          },
          {
            name = 'Docs',
            highlight = { undercurl = true, sp = 'green' },
            icon = '',
            matcher = function(buf)
              return buf.name:match('%.md') or buf.name:match('%.txt')
            end,
          },
        },
      },
    },
    highlights = {
      fill = {
        bg = { attribute = 'bg', highlight = 'TabLineFill' },
      },
      background = {
        bg = { attribute = 'bg', highlight = 'TabLine' },
      },
      buffer_visible = {
        bg = { attribute = 'bg', highlight = 'TabLine' },
      },
      buffer_selected = {
        bold = true,
        italic = false,
      },
      separator = {
        fg = { attribute = 'bg', highlight = 'TabLineFill' },
        bg = { attribute = 'bg', highlight = 'TabLine' },
      },
      separator_selected = {
        fg = { attribute = 'bg', highlight = 'TabLineFill' },
      },
      separator_visible = {
        fg = { attribute = 'bg', highlight = 'TabLineFill' },
        bg = { attribute = 'bg', highlight = 'TabLine' },
      },
      indicator_selected = {
        fg = { attribute = 'fg', highlight = 'Function' },
      },
    },
  },
  config = function(_, opts)
    require('bufferline').setup(opts)

    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
