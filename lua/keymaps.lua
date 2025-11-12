-- keymaps.lua --

local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic helpers
map('n', '<leader>xq', vim.diagnostic.setloclist, { desc = 'Diagnostics quickfix list' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })
map('n', ']e', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Next error' })
map('n', '[e', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Prev error' })

-- Quick saves / quits
map({ 'n', 'i', 'v', 'x' }, '<C-s>', '<Esc><cmd>w<CR>', { desc = 'Save file', silent = true })
map('n', '<leader>wq', '<cmd>wall | qa<CR>', { desc = 'Save all & quit' })

-- Buffer management
map('n', '<leader>bn', '<cmd>enew<CR>', { desc = 'Buffer: new' })
map('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Buffer: delete' })
map('n', '<leader>bo', function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and buf ~= current then
      if vim.bo[buf].modified then
        vim.notify(string.format('Skipped closing %s (unsaved changes)', vim.api.nvim_buf_get_name(buf)), vim.log.levels.WARN)
      else
        vim.api.nvim_buf_delete(buf, {})
      end
    end
  end
end, { desc = 'Buffer: close others' })

-- Bufferline-specific mappings are registered inside its plugin spec

-- Centered scrolling
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation (still works inside tmux thanks to smart-splits)
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- Split resize/management mappings live with the smart-splits plugin

-- Toggle helpers
map('n', '<leader>uw', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify('Wrap ' .. (vim.wo.wrap and 'enabled' or 'disabled'))
end, { desc = 'Toggle wrap' })

map('n', '<leader>un', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.notify('Relative number ' .. (vim.wo.relativenumber and 'enabled' or 'disabled'))
end, { desc = 'Toggle relative numbers' })

map('n', '<leader>us', function()
  vim.opt.spell = not vim.opt.spell:get()
  vim.notify('Spell ' .. (vim.opt.spell:get() and 'enabled' or 'disabled'))
end, { desc = 'Toggle spell' })

map('n', '<leader>ut', function()
  require('mini.trailspace').trim()
  vim.notify 'Trailing whitespace trimmed'
end, { desc = 'Trim trailing whitespace' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('logan-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
