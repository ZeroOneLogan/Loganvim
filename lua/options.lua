-- options.lua --

-- Make line numbers default
vim.o.number = true
--  Change numbers to relative
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Show the mode
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true
vim.opt.splitkeep = 'screen'

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions while typing.
vim.o.inccommand = 'split'

-- Show which line cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10
vim.o.sidescrolloff = 8

-- Raise a dialog asking if you wish to save the current file(s)
vim.o.confirm = true

-- Option for some color themes
vim.opt.termguicolors = true

vim.opt.laststatus = 3
vim.opt.showbreak = '↪ '
vim.opt.swapfile = false
vim.opt.fillchars = {
  fold = ' ',
  foldopen = '',
  foldclose = '',
  foldsep = ' ',
  eob = ' ',
  diff = '╱',
}
vim.opt.shortmess:append 'WIcC'

-- Folds handled by nvim-ufo
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- * Use highlight groups for the cursor
-- vim.opt.guicursor = table.concat({
-- 'n-v-c:block-Cursor/lCursor',
-- 'i-ci-ve:ver25-Cursor/lCursor',
-- 'r-cr:hor20-Cursor/lCursor',
-- 'o:hor50-Cursor/lCursor',
-- 'sm:block-Cursor/lCursor',
-- }, ',')

-- * Recompute cursor colors whenever colorscheme changes
-- local aug = vim.api.nvim_create_augroup('ColorColorSync', { clear = true })
-- vim.api.nvim_create_autocmd('ColorScheme', {
-- group = aug,
-- callback = function()
-- local ok_bg = pcall(function()
-- local norm = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
-- local fg = norm.fg
-- local bg = norm.bg

-- if fg and bg then
-- vim.api.nvim_set_hl(0, 'Cursor', { fg = bg, bg = fg })
-- vim.api.nvim_set_hl(0, 'lCursor', { fg = bg, bg = fg })
-- vim.api.nvim_set_hl(0, 'TermCursor', { fg = bg, bg = fg })
-- else
-- vim.api.nvim_set_hl(0, 'Cursor', { reverse = true })
-- vim.api.nvim_set_hl(0, 'lCursor', { reverse = true })
-- vim.api.nvim_set_hl(0, 'TermCursor', { reverse = true })
-- end
-- end)
-- if not ok_bg then
-- vim.api.nvim_set_hl(0, 'Cursor', { reverse = true })
-- vim.api.nvim_set_hl(0, 'lCursor', { reverse = true })
-- vim.api.nvim_set_hl(0, 'TermCursor', { reverse = true })
-- end
-- end,
-- })

-- * Run once at startup so initial theme sets it too
-- vim.schedule(function()
-- vim.api.nvim_exec_autocmds('ColorScheme', {})
-- end)

-- Remove command line to make noice better looking
vim.opt.cmdheight = 0

-- vim: ts=2 sts=2 sw=2 et
