-- mini.lua --
-- Collection of Essential Mini.nvim Modules
-- Carefully selected for maximum utility

return {
  'echasnovski/mini.nvim',
  version = false,
  event = 'VeryLazy',
  config = function()
    --  ╭──────────────────────────────────────────────────────────╮
    --  │                    mini.ai                               │
    --  │               Better Around/Inside textobjects           │
    --  ╰──────────────────────────────────────────────────────────╯

    require('mini.ai').setup({
      n_lines = 500,
      custom_textobjects = {
        -- Code block
        o = require('mini.ai').gen_spec.treesitter({
          a = { '@block.outer', '@conditional.outer', '@loop.outer' },
          i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }, {}),
        -- Function
        f = require('mini.ai').gen_spec.treesitter({
          a = '@function.outer',
          i = '@function.inner',
        }, {}),
        -- Class
        c = require('mini.ai').gen_spec.treesitter({
          a = '@class.outer',
          i = '@class.inner',
        }, {}),
        -- Comment
        u = require('mini.ai').gen_spec.treesitter({
          a = '@comment.outer',
          i = '@comment.inner',
        }, {}),
        -- HTML tag
        t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().googletag.cmd.push(function() { googletag.display('div-gpt-ad-1470689393084-0'); });*</googletag.cmd.push(function() { googletag.display('div-gpt-ad-1470689393084-0'); });' },
        -- Digit sequences
        d = { '%f[%d]%d+' },
        -- Word with case
        e = {
          { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
          '^().*googletag.cmd.push(function() { googletag.display('div-gpt-ad-1470689393084-0'); });',
        },
        -- Entire buffer
        g = function()
          local from = { line = 1, col = 1 }
          local to = {
            line = vim.fn.line('$'),
            col = math.max(vim.fn.getline('$'):len(), 1),
          }
          return { from = from, to = to }
        end,
      },
    })

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                    mini.surround                         │
    --  │            Add/delete/replace surroundings               │
    --  ╰──────────────────────────────────────────────────────────╯

    require('mini.surround').setup({
      mappings = {
        add = 'gsa',            -- Add surrounding in Normal and Visual modes
        delete = 'gsd',         -- Delete surrounding
        find = 'gsf',           -- Find surrounding (to the right)
        find_left = 'gsF',      -- Find surrounding (to the left)
        highlight = 'gsh',      -- Highlight surrounding
        replace = 'gsr',        -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
        suffix_last = 'l',      -- Suffix to search with "prev" method
        suffix_next = 'n',      -- Suffix to search with "next" method
      },
    })

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                    mini.pairs                            │
    --  │                 Auto-close brackets                      │
    --  ╰──────────────────────────────────────────────────────────╯

    -- Note: Using nvim-autopairs instead for more features
    -- Uncomment if you prefer mini.pairs:
    -- require('mini.pairs').setup({})

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                  mini.splitjoin                          │
    --  │          Toggle between single/multi-line                │
    --  ╰──────────────────────────────────────────────────────────╯

    require('mini.splitjoin').setup({
      mappings = {
        toggle = 'gS', -- Changed from 'gs' to avoid conflict with flash
      },
    })

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                  mini.trailspace                         │
    --  │           Highlight/trim trailing whitespace             │
    --  ╰──────────────────────────────────────────────────────────╯

    require('mini.trailspace').setup()

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('loganvim-trailspace', { clear = true }),
      callback = function()
        local excluded = { 'markdown', 'gitcommit', 'diff' }
        if vim.tbl_contains(excluded, vim.bo.filetype) then
          return
        end
        if vim.bo.modifiable and not vim.bo.readonly then
          require('mini.trailspace').trim()
        end
      end,
    })

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                    mini.bufremove                        │
    --  │               Better buffer deletion                     │
    --  ╰──────────────────────────────────────────────────────────╯

    require('mini.bufremove').setup({})

    vim.keymap.set('n', '<leader>bd', function()
      local bd = require('mini.bufremove').delete
      if vim.bo.modified then
        local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
        if choice == 1 then
          vim.cmd.write()
          bd(0)
        elseif choice == 2 then
          bd(0, true)
        end
      else
        bd(0)
      end
    end, { desc = 'Delete buffer' })

    vim.keymap.set('n', '<leader>bD', function()
      require('mini.bufremove').delete(0, true)
    end, { desc = 'Force delete buffer' })

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                    mini.icons                            │
    --  │                   Icon provider                          │
    --  ╰──────────────────────────────────────────────────────────╯

    require('mini.icons').setup({
      style = vim.g.have_nerd_font and 'glyph' or 'ascii',
    })

    -- Mock nvim-web-devicons for compatibility
    MiniIcons.mock_nvim_web_devicons()

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                   mini.indentscope                       │
    --  │              Visualize current scope                     │
    --  ╰──────────────────────────────────────────────────────────╯

    require('mini.indentscope').setup({
      symbol = '│',
      options = { try_as_border = true },
      draw = {
        delay = 100,
        animation = require('mini.indentscope').gen_animation.none(),
      },
    })

    -- Disable for certain filetypes
    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'alpha',
        'dashboard',
        'fzf',
        'help',
        'lazy',
        'lazyterm',
        'mason',
        'neo-tree',
        'notify',
        'toggleterm',
        'Trouble',
        'trouble',
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                   mini.bracketed                         │
    --  │              Go forward/backward with [ ]                │
    --  ╰──────────────────────────────────────────────────────────╯

    require('mini.bracketed').setup({
      -- Disable some that conflict with our keymaps
      buffer = { suffix = 'b', options = {} },
      comment = { suffix = 'c', options = {} },
      conflict = { suffix = 'x', options = {} },
      diagnostic = { suffix = '', options = {} }, -- We use our own
      file = { suffix = 'f', options = {} },
      indent = { suffix = 'i', options = {} },
      jump = { suffix = 'j', options = {} },
      location = { suffix = 'l', options = {} },
      oldfile = { suffix = 'o', options = {} },
      quickfix = { suffix = 'q', options = {} },
      treesitter = { suffix = 't', options = {} },
      undo = { suffix = 'u', options = {} },
      window = { suffix = 'w', options = {} },
      yank = { suffix = 'y', options = {} },
    })

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                    mini.cursorword                       │
    --  │           Highlight word under cursor                    │
    --  ╰──────────────────────────────────────────────────────────╯

    require('mini.cursorword').setup({
      delay = 100,
    })

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                    mini.move                             │
    --  │           Move lines/selections with Alt                 │
    --  ╰──────────────────────────────────────────────────────────╯

    require('mini.move').setup({
      mappings = {
        -- Visual mode
        left = '<M-h>',
        right = '<M-l>',
        down = '<M-j>',
        up = '<M-k>',
        -- Normal mode
        line_left = '<M-h>',
        line_right = '<M-l>',
        line_down = '<M-j>',
        line_up = '<M-k>',
      },
    })

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                   mini.hipatterns                        │
    --  │            Highlight patterns (TODO, etc.)               │
    --  ╰──────────────────────────────────────────────────────────╯

    local hipatterns = require('mini.hipatterns')
    hipatterns.setup({
      highlighters = {
        -- Highlight hex colors
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
