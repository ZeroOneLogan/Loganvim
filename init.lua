--[[
  ╭──────────────────────────────────────────────────────────────────────╮
  │                                                                      │
  │   ██╗      ██████╗  ██████╗  █████╗ ███╗   ██╗██╗   ██╗██╗███╗   ███╗│
  │   ██║     ██╔═══██╗██╔════╝ ██╔══██╗████╗  ██║██║   ██║██║████╗ ████║│
  │   ██║     ██║   ██║██║  ███╗███████║██╔██╗ ██║██║   ██║██║██╔████╔██║│
  │   ██║     ██║   ██║██║   ██║██╔══██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║│
  │   ███████╗╚██████╔╝╚██████╔╝██║  ██║██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║│
  │   ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝│
  │                                                                      │
  │           Ultimate Neovim Distribution — v2.0                        │
  │           Optimized for Neovim 0.11.5                                │
  │                                                                      │
  ╰──────────────────────────────────────────────────────────────────────╯
--]]

-- Bootstrap version check
if vim.fn.has('nvim-0.10') == 0 then
  vim.api.nvim_echo({
    { 'LoganVim requires Neovim 0.10 or higher!\n', 'ErrorMsg' },
    { 'Please upgrade your Neovim installation.\n', 'WarningMsg' },
  }, true, {})
  return
end

--  ╭──────────────────────────────────────────────────────────╮
--  │                     Leader Keys                          │
--  ╰──────────────────────────────────────────────────────────╯

-- Set before lazy loading plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

--  ╭──────────────────────────────────────────────────────────╮
--  │                   Global Settings                        │
--  ╰──────────────────────────────────────────────────────────╯

-- Nerd Font availability
vim.g.have_nerd_font = true

-- LoganVim version
vim.g.loganvim_version = '2.0.0'

--  ╭──────────────────────────────────────────────────────────╮
--  │                    Core Modules                          │
--  ╰──────────────────────────────────────────────────────────╯

-- Load configuration in order
require('options')          -- Vim options
require('keymaps')          -- Key mappings
require('lazy-bootstrap')   -- Plugin manager installation
require('lazy-plugins')     -- Plugin configurations

--  ╭──────────────────────────────────────────────────────────╮
--  │                   Custom Modules                         │
--  ╰──────────────────────────────────────────────────────────╯

require('logan.terminalpop')  -- Floating terminal
require('logan.autocmds')     -- Auto commands

--  ╭──────────────────────────────────────────────────────────╮
--  │                  Colorscheme Setup                       │
--  ╰──────────────────────────────────────────────────────────╯

-- Save colorscheme on change
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('loganvim-colorscheme-save', { clear = true }),
  callback = function()
    local colorscheme = vim.g.colors_name
    if colorscheme then
      local path = vim.fn.stdpath('config') .. '/last_colorscheme.txt'
      vim.fn.writefile({ colorscheme }, path)
    end
  end,
})

-- Load theme module
local theme = require('logan.theme')

-- Restore last colorscheme or use default
local path = vim.fn.stdpath('config') .. '/last_colorscheme.txt'
if vim.fn.filereadable(path) == 1 then
  local last_colorscheme = vim.fn.readfile(path)[1]
  if not theme.load_colorscheme(last_colorscheme) then
    theme.load_colorscheme('tokyonight-night')
  end
else
  theme.load_colorscheme('tokyonight-night')
end

theme.setup()

--  ╭──────────────────────────────────────────────────────────╮
--  │                   Python Provider                        │
--  ╰──────────────────────────────────────────────────────────╯

local function setup_python_provider()
  local function has_pynvim(py)
    if not py or py == '' then return false end
    local ok = vim.fn.system({ py, '-c', 'import pynvim' })
    return vim.v.shell_error == 0
  end

  local candidates = {
    vim.fn.expand('~/.virtualenvs/nvim-py3/bin/python'),
    vim.env.NVIM_PYTHON3,
    vim.env.NVIM_PYTHON,
    (vim.env.VIRTUAL_ENV or '') ~= '' and (vim.env.VIRTUAL_ENV .. '/bin/python3') or nil,
    vim.fn.exepath('python3'),
  }

  for _, p in ipairs(candidates) do
    if p and has_pynvim(p) then
      vim.g.python3_host_prog = p
      return
    end
  end

  -- Only warn if Python is needed
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    once = true,
    callback = function()
      if not vim.g.python3_host_prog then
        vim.notify('No Python with pynvim found. Some features may be limited.', vim.log.levels.WARN)
      end
    end,
  })
end

-- Defer Python setup
vim.schedule(setup_python_provider)

--  ╭──────────────────────────────────────────────────────────╮
--  │                   Startup Complete                       │
--  ╰──────────────────────────────────────────────────────────╯

-- Display startup time (development only)
if vim.env.LOGANVIM_DEBUG then
  vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
      vim.defer_fn(function()
        local stats = require('lazy').stats()
        vim.notify(
          string.format('⚡ LoganVim loaded %d plugins in %.2fms', stats.loaded, stats.startuptime),
          vim.log.levels.INFO
        )
      end, 100)
    end,
  })
end

-- vim: ts=2 sts=2 sw=2 et
