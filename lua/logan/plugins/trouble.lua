-- trouble.lua --
-- Better diagnostics and quickfix list experience

return {
  'folke/trouble.nvim',
  cmd = { 'Trouble' },
  keys = {
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<CR>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<CR>',
      desc = 'Buffer diagnostics (Trouble)',
    },
    {
      '<leader>cs',
      '<cmd>Trouble symbols toggle focus=false<CR>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>cl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<CR>',
      desc = 'LSP Definitions / References (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<CR>',
      desc = 'Location list (Trouble)',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist toggle<CR>',
      desc = 'Quickfix list (Trouble)',
    },
    {
      '<leader>xt',
      '<cmd>Trouble todo toggle<CR>',
      desc = 'Todos (Trouble)',
    },
    {
      '[t',
      function()
        if require('trouble').is_open() then
          require('trouble').prev({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Previous Trouble/Quickfix item',
    },
    {
      ']t',
      function()
        if require('trouble').is_open() then
          require('trouble').next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Next Trouble/Quickfix item',
    },
  },
  opts = {
    modes = {
      preview_float = {
        mode = 'diagnostics',
        preview = {
          type = 'float',
          relative = 'editor',
          border = 'rounded',
          title = 'Preview',
          title_pos = 'center',
          position = { 0, -2 },
          size = { width = 0.3, height = 0.3 },
          zindex = 200,
        },
      },
      cascade = {
        mode = 'diagnostics',
        filter = function(items)
          local severity = vim.diagnostic.severity.HINT
          for _, item in ipairs(items) do
            severity = math.min(severity, item.severity)
          end
          return vim.tbl_filter(function(item)
            return item.severity == severity
          end, items)
        end,
      },
    },
    icons = {
      indent = {
        top = '│ ',
        middle = '├╴',
        last = '└╴',
        fold_open = ' ',
        fold_closed = ' ',
        ws = '  ',
      },
      folder_closed = ' ',
      folder_open = ' ',
      kinds = {
        Array = ' ',
        Boolean = '󰨙 ',
        Class = ' ',
        Constant = '󰏿 ',
        Constructor = ' ',
        Enum = ' ',
        EnumMember = ' ',
        Event = ' ',
        Field = ' ',
        File = ' ',
        Function = '󰊕 ',
        Interface = ' ',
        Key = ' ',
        Method = '󰊕 ',
        Module = ' ',
        Namespace = '󰦮 ',
        Null = ' ',
        Number = '󰎠 ',
        Object = ' ',
        Operator = ' ',
        Package = ' ',
        Property = ' ',
        String = ' ',
        Struct = '󰆼 ',
        TypeParameter = ' ',
        Variable = '󰀫 ',
      },
    },
  },
}
