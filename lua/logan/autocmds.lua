-- autocmds.lua --
-- Auto commands for LoganVim
-- Optimized for Neovim 0.11.5

local augroup = function(name)
  return vim.api.nvim_create_augroup('loganvim-' .. name, { clear = true })
end

--  ╭──────────────────────────────────────────────────────────╮
--  │                   Highlight on Yank                      │
--  ╰──────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight-yank'),
  desc = 'Highlight when yanking text',
  callback = function()
    vim.hl.on_yank({ higroup = 'Visual', timeout = 200 })
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │                   Resize Splits                          │
--  ╰──────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd('VimResized', {
  group = augroup('resize-splits'),
  desc = 'Resize splits when window is resized',
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │                  Restore Cursor Position                 │
--  ╰──────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('last-loc'),
  desc = 'Go to last location when opening a buffer',
  callback = function(event)
    local exclude = { 'gitcommit', 'gitrebase', 'commit', 'rebase' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].loganvim_last_loc then
      return
    end
    vim.b[buf].loganvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │                   Close Special Buffers                  │
--  ╰──────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('close-with-q'),
  desc = 'Close special buffers with q',
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dbout',
    'gitsigns-blame',
    'grug-far',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
    'snacks_win',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd('close')
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │                    Wrap in Text Files                    │
--  ╰──────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('wrap-spell'),
  desc = 'Enable wrap and spell for text files',
  pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │                 Fix Conceallevel                         │
--  ╰──────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('json-conceal'),
  desc = 'Fix conceallevel for JSON files',
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │                Auto Create Parent Dirs                   │
--  ╰──────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup('auto-create-dir'),
  desc = 'Auto create parent directories when saving',
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │               Checktime on Focus/Buffer                  │
--  ╰──────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  desc = 'Check if file changed when focusing',
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │                  Big File Detection                      │
--  ╰──────────────────────────────────────────────────────────╯

vim.filetype.add({
  pattern = {
    ['.*'] = {
      function(path, buf)
        return vim.bo[buf]
            and vim.bo[buf].filetype ~= 'bigfile'
            and path
            and vim.fn.getfsize(path) > 1024 * 1024 * 1.5 -- 1.5MB
            and 'bigfile'
          or nil
      end,
    },
  },
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('bigfile'),
  desc = 'Disable features for big files',
  pattern = 'bigfile',
  callback = function(ev)
    vim.opt_local.spell = false
    vim.opt_local.swapfile = false
    vim.opt_local.undofile = false
    vim.opt_local.breakindent = false
    vim.opt_local.colorcolumn = ''
    vim.opt_local.statuscolumn = ''
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.foldcolumn = '0'
    vim.opt_local.winbar = ''
    vim.b[ev.buf].minianimate_disable = true

    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ev.buf) then
        vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ''
      end
    end)
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │              Man Page Better Settings                    │
--  ╰──────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('man-unlisted'),
  desc = 'Make man pages unlisted buffers',
  pattern = 'man',
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │                 Terminal Settings                        │
--  ╰──────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd('TermOpen', {
  group = augroup('terminal'),
  desc = 'Terminal buffer settings',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.statuscolumn = ''
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │               Auto Save on Focus Lost                    │
--  ╰──────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  group = augroup('auto-save'),
  desc = 'Auto save on focus lost',
  callback = function()
    if vim.bo.modified and vim.bo.buftype == '' and vim.fn.expand('%') ~= '' then
      vim.cmd('silent! update')
    end
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │              LSP Progress Notifications                  │
--  ╰──────────────────────────────────────────────────────────╯

-- Neovim 0.10+ has built-in LSP progress, use vim.lsp.status()
if vim.fn.has('nvim-0.10') == 1 then
  vim.api.nvim_create_autocmd('LspProgress', {
    group = augroup('lsp-progress'),
    desc = 'LSP Progress updates',
    callback = function(ev)
      local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
      vim.notify(vim.lsp.status(), 'info', {
        id = 'lsp_progress',
        title = 'LSP Progress',
        opts = function(notif)
          notif.icon = ev.data.params.value.kind == 'end' and ' '
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
      })
    end,
  })
end

--  ╭──────────────────────────────────────────────────────────╮
--  │             Disable New Line Comments                    │
--  ╰──────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd('BufEnter', {
  group = augroup('no-auto-comment'),
  desc = 'Disable auto commenting on new lines',
  callback = function()
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- vim: ts=2 sts=2 sw=2 et
