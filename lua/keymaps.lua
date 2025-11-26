-- keymaps.lua --
-- Ultimate Keymap Configuration for LoganVim
-- Consistent, intuitive, and powerful key bindings

local map = vim.keymap.set

--  ╭──────────────────────────────────────────────────────────╮
--  │                    Better Defaults                       │
--  ╰──────────────────────────────────────────────────────────╯

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear highlights' })

-- Better up/down movement on wrapped lines
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Centered scrolling
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down (centered)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up (centered)' })
map('n', '<C-f>', '<C-f>zz', { desc = 'Page down (centered)' })
map('n', '<C-b>', '<C-b>zz', { desc = 'Page up (centered)' })

-- Centered search results
map('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
map('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })

-- Better indenting (stay in visual mode)
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Move lines up/down
map('n', '<A-j>', '<cmd>execute "move .+1"<cr>==', { desc = 'Move line down' })
map('n', '<A-k>', '<cmd>execute "move .-2"<cr>==', { desc = 'Move line up' })
map('i', '<A-j>', '<esc><cmd>move .+1<cr>==gi', { desc = 'Move line down' })
map('i', '<A-k>', '<esc><cmd>move .-2<cr>==gi', { desc = 'Move line up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Add blank lines
map('n', ']<Space>', ":<C-u>put =repeat(nr2char(10),v:count1)<CR>'[", { desc = 'Add blank line below', silent = true })
map('n', '[<Space>', ":<C-u>put!=repeat(nr2char(10),v:count1)<CR>']", { desc = 'Add blank line above', silent = true })

--  ╭──────────────────────────────────────────────────────────╮
--  │                      Save & Quit                         │
--  ╰──────────────────────────────────────────────────────────╯

map({ 'n', 'i', 'v', 's', 'x' }, '<C-s>', '<cmd>w<CR><Esc>', { desc = 'Save file' })
map('n', '<leader>wq', '<cmd>wall | qa<CR>', { desc = 'Save all & quit' })
map('n', '<leader>qq', '<cmd>qa<CR>', { desc = 'Quit all' })
map('n', '<leader>Q', '<cmd>qa!<CR>', { desc = 'Force quit all' })

--  ╭──────────────────────────────────────────────────────────╮
--  │                    Window Navigation                     │
--  ╰──────────────────────────────────────────────────────────╯

map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Window resize (handled by smart-splits when available)
map('n', '<C-Up>', '<cmd>resize +2<CR>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<CR>', { desc = 'Decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Increase window width' })

-- Window splits
map('n', '<leader>-', '<cmd>split<CR>', { desc = 'Split horizontal' })
map('n', '<leader>|', '<cmd>vsplit<CR>', { desc = 'Split vertical' })
map('n', '<leader>wd', '<C-w>c', { desc = 'Close window' })
map('n', '<leader>wo', '<C-w>o', { desc = 'Close other windows' })
map('n', '<leader>wm', '<cmd>only<CR>', { desc = 'Maximize window' })
map('n', '<leader>w=', '<C-w>=', { desc = 'Equal window sizes' })

--  ╭──────────────────────────────────────────────────────────╮
--  │                   Buffer Navigation                      │
--  ╰──────────────────────────────────────────────────────────╯

map('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '[b', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer' })

map('n', '<leader>bn', '<cmd>enew<CR>', { desc = 'New buffer' })
map('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete buffer' })
map('n', '<leader>bD', '<cmd>bdelete!<CR>', { desc = 'Force delete buffer' })
map('n', '<leader>bb', '<cmd>e #<CR>', { desc = 'Switch to other buffer' })

map('n', '<leader>bo', function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and buf ~= current then
      if vim.bo[buf].modified then
        vim.notify(string.format('Skipped: %s (unsaved)', vim.api.nvim_buf_get_name(buf)), vim.log.levels.WARN)
      else
        vim.api.nvim_buf_delete(buf, {})
      end
    end
  end
end, { desc = 'Close other buffers' })

--  ╭──────────────────────────────────────────────────────────╮
--  │                   Tab Navigation                         │
--  ╰──────────────────────────────────────────────────────────╯

map('n', '<leader><tab>l', '<cmd>tablast<CR>', { desc = 'Last tab' })
map('n', '<leader><tab>f', '<cmd>tabfirst<CR>', { desc = 'First tab' })
map('n', '<leader><tab>n', '<cmd>tabnew<CR>', { desc = 'New tab' })
map('n', '<leader><tab>]', '<cmd>tabnext<CR>', { desc = 'Next tab' })
map('n', '<leader><tab>[', '<cmd>tabprevious<CR>', { desc = 'Previous tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<CR>', { desc = 'Close tab' })
map('n', '<leader><tab>o', '<cmd>tabonly<CR>', { desc = 'Close other tabs' })

--  ╭──────────────────────────────────────────────────────────╮
--  │                    Terminal Mode                         │
--  ╰──────────────────────────────────────────────────────────╯

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-h>', '<cmd>wincmd h<CR>', { desc = 'Go to left window' })
map('t', '<C-j>', '<cmd>wincmd j<CR>', { desc = 'Go to lower window' })
map('t', '<C-k>', '<cmd>wincmd k<CR>', { desc = 'Go to upper window' })
map('t', '<C-l>', '<cmd>wincmd l<CR>', { desc = 'Go to right window' })

--  ╭──────────────────────────────────────────────────────────╮
--  │                      Diagnostics                         │
--  ╰──────────────────────────────────────────────────────────╯

map('n', '<leader>xd', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
map('n', '<leader>xq', vim.diagnostic.setloclist, { desc = 'Diagnostics quickfix' })

map('n', ']d', function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Next diagnostic' })

map('n', '[d', function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Previous diagnostic' })

map('n', ']e', function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = 'Next error' })

map('n', '[e', function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = 'Previous error' })

map('n', ']w', function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true })
end, { desc = 'Next warning' })

map('n', '[w', function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true })
end, { desc = 'Previous warning' })

--  ╭──────────────────────────────────────────────────────────╮
--  │                      UI Toggles                          │
--  ╰──────────────────────────────────────────────────────────╯

map('n', '<leader>uw', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify('Wrap ' .. (vim.wo.wrap and 'enabled' or 'disabled'))
end, { desc = 'Toggle wrap' })

map('n', '<leader>un', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.notify('Relative numbers ' .. (vim.wo.relativenumber and 'enabled' or 'disabled'))
end, { desc = 'Toggle relative numbers' })

map('n', '<leader>ul', function()
  vim.wo.number = not vim.wo.number
  vim.notify('Line numbers ' .. (vim.wo.number and 'enabled' or 'disabled'))
end, { desc = 'Toggle line numbers' })

map('n', '<leader>us', function()
  vim.wo.spell = not vim.wo.spell
  vim.notify('Spell check ' .. (vim.wo.spell and 'enabled' or 'disabled'))
end, { desc = 'Toggle spell check' })

map('n', '<leader>uc', function()
  vim.wo.cursorline = not vim.wo.cursorline
  vim.notify('Cursor line ' .. (vim.wo.cursorline and 'enabled' or 'disabled'))
end, { desc = 'Toggle cursor line' })

map('n', '<leader>uC', function()
  vim.wo.cursorcolumn = not vim.wo.cursorcolumn
  vim.notify('Cursor column ' .. (vim.wo.cursorcolumn and 'enabled' or 'disabled'))
end, { desc = 'Toggle cursor column' })

map('n', '<leader>ui', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  vim.notify('Inlay hints ' .. (vim.lsp.inlay_hint.is_enabled() and 'enabled' or 'disabled'))
end, { desc = 'Toggle inlay hints' })

map('n', '<leader>ud', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  vim.notify('Diagnostics ' .. (vim.diagnostic.is_enabled() and 'enabled' or 'disabled'))
end, { desc = 'Toggle diagnostics' })

map('n', '<leader>ub', function()
  local new_bg = vim.o.background == 'dark' and 'light' or 'dark'
  vim.o.background = new_bg
  vim.notify('Background: ' .. new_bg)
end, { desc = 'Toggle background' })

map('n', '<leader>ut', function()
  if vim.wo.conceallevel == 0 then
    vim.wo.conceallevel = 2
  else
    vim.wo.conceallevel = 0
  end
  vim.notify('Conceal level: ' .. vim.wo.conceallevel)
end, { desc = 'Toggle conceallevel' })

--  ╭──────────────────────────────────────────────────────────╮
--  │                      Clipboard                           │
--  ╰──────────────────────────────────────────────────────────╯

-- Paste without overwriting register
map('x', '<leader>p', [["_dP]], { desc = 'Paste without losing register' })

-- Delete without yanking
map({ 'n', 'v' }, '<leader>d', [["_d]], { desc = 'Delete without yanking' })

-- System clipboard operations
map({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank to system clipboard' })
map('n', '<leader>Y', [["+Y]], { desc = 'Yank line to system clipboard' })

--  ╭──────────────────────────────────────────────────────────╮
--  │                    Quick Fixes                           │
--  ╰──────────────────────────────────────────────────────────╯

-- Select all
map('n', '<C-a>', 'gg<S-v>G', { desc = 'Select all' })

-- Join lines without moving cursor
map('n', 'J', 'mzJ`z', { desc = 'Join lines (keep cursor)' })

-- Fix common typos
vim.cmd('cnoreabbrev W w')
vim.cmd('cnoreabbrev Q q')
vim.cmd('cnoreabbrev Wq wq')
vim.cmd('cnoreabbrev WQ wq')
vim.cmd('cnoreabbrev Qa qa')
vim.cmd('cnoreabbrev QA qa')

--  ╭──────────────────────────────────────────────────────────╮
--  │                   Quick Commands                         │
--  ╰──────────────────────────────────────────────────────────╯

map('n', '<leader>xl', '<cmd>lopen<CR>', { desc = 'Location list' })
map('n', '<leader>xc', '<cmd>copen<CR>', { desc = 'Quickfix list' })
map('n', '[q', vim.cmd.cprev, { desc = 'Previous quickfix' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next quickfix' })
map('n', '[l', vim.cmd.lprev, { desc = 'Previous location' })
map('n', ']l', vim.cmd.lnext, { desc = 'Next location' })

--  ╭──────────────────────────────────────────────────────────╮
--  │                   Lazy Plugin Manager                    │
--  ╰──────────────────────────────────────────────────────────╯

map('n', '<leader>l', '<cmd>Lazy<CR>', { desc = 'Lazy Plugin Manager' })

--  ╭──────────────────────────────────────────────────────────╮
--  │                   Info & Help                            │
--  ╰──────────────────────────────────────────────────────────╯

map('n', '<leader>?', '<cmd>Telescope help_tags<CR>', { desc = 'Search help' })
map('n', '<leader>:', '<cmd>Telescope command_history<CR>', { desc = 'Command history' })

-- vim: ts=2 sts=2 sw=2 et
