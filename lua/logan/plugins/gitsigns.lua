-- gitsigns.lua --
-- Git integration for buffers
-- Signs, blame, and hunk navigation

return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
  opts = {
    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Signs                             │
    --  ╰──────────────────────────────────────────────────────────╯

    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    signs_staged = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
    },
    signs_staged_enable = true,

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Preview                           │
    --  ╰──────────────────────────────────────────────────────────╯

    preview_config = {
      border = 'rounded',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                         Blame                            │
    --  ╰──────────────────────────────────────────────────────────╯

    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 300,
      ignore_whitespace = false,
      virt_text_priority = 100,
    },
    current_line_blame_formatter = '  <author>, <author_time:%R> • <summary>',

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Settings                           │
    --  ╰──────────────────────────────────────────────────────────╯

    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      follow_files = true,
    },
    auto_attach = true,
    attach_to_untracked = true,
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Keymaps                            │
    --  ╰──────────────────────────────────────────────────────────╯

    on_attach = function(bufnr)
      local gs = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end, { desc = 'Next git change' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end, { desc = 'Previous git change' })

      -- Actions
      map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
      map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })

      map('v', '<leader>hs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Stage hunk' })

      map('v', '<leader>hr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Reset hunk' })

      map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
      map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
      map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
      map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
      map('n', '<leader>hP', gs.preview_hunk_inline, { desc = 'Preview hunk inline' })

      map('n', '<leader>hb', function()
        gs.blame_line({ full = true })
      end, { desc = 'Blame line' })

      map('n', '<leader>hB', function()
        gs.blame()
      end, { desc = 'Blame buffer' })

      map('n', '<leader>hd', gs.diffthis, { desc = 'Diff this' })

      map('n', '<leader>hD', function()
        gs.diffthis('~')
      end, { desc = 'Diff this ~' })

      -- Toggles
      map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle git blame line' })
      map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle git deleted' })
      map('n', '<leader>tw', gs.toggle_word_diff, { desc = 'Toggle git word diff' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
