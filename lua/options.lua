-- options.lua --
-- Ultimate Neovim 0.11.5 Configuration Options
-- Optimized for performance and modern development

local opt = vim.opt
local g = vim.g

--  ╭──────────────────────────────────────────────────────────╮
--  │                    Performance Tuning                    │
--  ╰──────────────────────────────────────────────────────────╯

-- Disable unused built-in plugins for faster startup
g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_matchit = 1
g.loaded_matchparen = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_remote_plugins = 1

-- Faster rendering
opt.ttyfast = true
opt.lazyredraw = false -- Disabled for noice.nvim compatibility
opt.synmaxcol = 240    -- Limit syntax highlighting for long lines

--  ╭──────────────────────────────────────────────────────────╮
--  │                      Line Numbers                        │
--  ╰──────────────────────────────────────────────────────────╯

opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.signcolumn = 'yes'
opt.statuscolumn = '%s%=%{v:relnum?v:relnum:v:lnum} '

--  ╭──────────────────────────────────────────────────────────╮
--  │                      UI Settings                         │
--  ╰──────────────────────────────────────────────────────────╯

opt.termguicolors = true
opt.cursorline = true
opt.cursorlineopt = 'number,line'
opt.showmode = false -- Shown in lualine
opt.showcmd = false
opt.cmdheight = 0    -- Hide command line when not in use (noice handles this)
opt.laststatus = 3   -- Global statusline
opt.pumheight = 12   -- Maximum popup menu height
opt.pumblend = 10    -- Popup menu transparency
opt.winblend = 10    -- Floating window transparency
opt.conceallevel = 2 -- Hide markdown markers
opt.concealcursor = '' -- Show concealed text on cursor line

-- Better window separator and visual elements
opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',
}

opt.listchars = {
  tab = '→ ',
  extends = '⟩',
  precedes = '⟨',
  trail = '·',
  nbsp = '␣',
  eol = '↲',
}
opt.list = true
opt.showbreak = '↪ '

--  ╭──────────────────────────────────────────────────────────╮
--  │                     Mouse & Scrolling                    │
--  ╰──────────────────────────────────────────────────────────╯

opt.mouse = 'a'
opt.mousemodel = 'extend'
opt.mousescroll = 'ver:3,hor:6'
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.smoothscroll = true -- Neovim 0.10+ smooth scrolling

--  ╭──────────────────────────────────────────────────────────╮
--  │                    Editing Behavior                      │
--  ╰──────────────────────────────────────────────────────────╯

opt.virtualedit = 'block' -- Allow cursor beyond end of line in visual block
opt.inccommand = 'split'  -- Live preview of substitutions
opt.confirm = true        -- Confirm before closing unsaved buffers
opt.breakindent = true    -- Preserve indentation on wrapped lines
opt.linebreak = true      -- Wrap at word boundaries
opt.wrap = false          -- No wrap by default

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.shiftround = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep --smart-case --hidden'

--  ╭──────────────────────────────────────────────────────────╮
--  │                    Splits & Windows                      │
--  ╰──────────────────────────────────────────────────────────╯

opt.splitbelow = true
opt.splitright = true
opt.splitkeep = 'screen'
opt.equalalways = false -- Don't auto-resize windows

--  ╭──────────────────────────────────────────────────────────╮
--  │                   Persistence & Undo                     │
--  ╰──────────────────────────────────────────────────────────╯

opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Session options
opt.sessionoptions = {
  'buffers',
  'curdir',
  'tabpages',
  'winsize',
  'help',
  'globals',
  'skiprtp',
  'folds',
}

-- Shada (shared data) - better session persistence
opt.shada = "!,'100,<50,s10,h"

--  ╭──────────────────────────────────────────────────────────╮
--  │                    Timing & Updates                      │
--  ╰──────────────────────────────────────────────────────────╯

opt.updatetime = 200    -- Faster CursorHold events
opt.timeoutlen = 300    -- Time to wait for a mapped sequence
opt.ttimeoutlen = 10    -- Time to wait for a key code sequence

--  ╭──────────────────────────────────────────────────────────╮
--  │                      Clipboard                           │
--  ╰──────────────────────────────────────────────────────────╯

-- Sync with system clipboard (deferred for faster startup)
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

--  ╭──────────────────────────────────────────────────────────╮
--  │                        Folding                           │
--  ╰──────────────────────────────────────────────────────────╯

opt.foldcolumn = '1'
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldtext = ''  -- Neovim 0.10+ native fold text

--  ╭──────────────────────────────────────────────────────────╮
--  │                     Spell Checking                       │
--  ╰──────────────────────────────────────────────────────────╯

opt.spell = false
opt.spelllang = { 'en' }
opt.spelloptions = { 'camel' }

--  ╭──────────────────────────────────────────────────────────╮
--  │                    Completion                            │
--  ╰──────────────────────────────────────────────────────────╯

opt.completeopt = 'menu,menuone,noselect,preview'
opt.complete:remove { 't' }  -- Don't scan tags
opt.wildmode = 'longest:full,full'
opt.wildoptions = 'pum'
opt.wildignorecase = true

-- Files to ignore in completion/file search
opt.wildignore = {
  '*.o', '*.obj', '*.dylib', '*.bin', '*.dll', '*.exe',
  '*/.git/*', '*/.svn/*', '*/__pycache__/*', '*/build/**',
  '*.jpg', '*.png', '*.jpeg', '*.bmp', '*.gif', '*.webp',
  '*.pdf', '*.epub', '*.zip', '*.tar', '*.gz',
  '*.DS_Store', '*.swp', '*.lock', 'package-lock.json',
  'node_modules/*', '.next/*', 'dist/*', 'coverage/*',
}

--  ╭──────────────────────────────────────────────────────────╮
--  │                  Format & Diff Options                   │
--  ╰──────────────────────────────────────────────────────────╯

opt.formatoptions = 'jcroqlnt'
opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'hiddenoff',
  'algorithm:histogram',
  'linematch:60',
  'indent-heuristic',
}

--  ╭──────────────────────────────────────────────────────────╮
--  │                    Short Messages                        │
--  ╰──────────────────────────────────────────────────────────╯

opt.shortmess:append {
  W = true, -- Don't show "written" when writing
  I = true, -- Don't show intro message
  c = true, -- Don't show ins-completion-menu messages
  C = true, -- Don't show scanning messages
  s = true, -- Don't show "search hit BOTTOM" messages
}

--  ╭──────────────────────────────────────────────────────────╮
--  │                  Neovim 0.11+ Features                   │
--  ╰──────────────────────────────────────────────────────────╯

if vim.fn.has('nvim-0.11') == 1 then
  -- Native snippet expansion
  opt.completeopt:append('fuzzy')

  -- Better defaults for LSP
  vim.lsp.set_log_level('OFF')  -- Reduce log noise

  -- Enable new default mappings
  g.lsp_auto_enable = true
end

-- vim: ts=2 sts=2 sw=2 et fdm=marker
