-- init.lua --

-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd font
vim.g.have_nerd_font = true

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

-- [[ Terminal pop ui ]]
require 'logan.terminalpop'

-- local use_minimal_default_colors = false

-- if use_minimal_default_colors then
-- vim.cmd.colorscheme 'default'

-- local mod = 'utils.colors'
-- if package.loaded[mod] then
-- package.loaded[mod] = nil
-- end

-- require(mod)
-- else
-- vim.cmd.colorscheme 'tokyonight-night'
-- end

-- Save last used colorscheme to a file
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local colorscheme = vim.g.colors_name
    local path = vim.fn.stdpath 'config' .. '/last_colorscheme.txt'
    vim.fn.writefile({ colorscheme }, path)
  end,
})

-- Load last used colorscheme on startup
local path = vim.fn.stdpath 'config' .. '/last_colorscheme.txt'
if vim.fn.filereadable(path) == 1 then
  local last_colorscheme = vim.fn.readfile(path)[1]
  pcall(vim.cmd.colorscheme, last_colorscheme)
else
  vim.cmd.colorscheme 'tokyonight-night' -- fallback
end

require('logan.theme').setup()

-- python location
-- vim.g.python3_host_prog = '/Users/drewlogan/.venvs/nvim/bin/python'
local function has_pynvim(py)
  if py == '' then
    return false
  end
  local ok = vim.fn.system { py, '-c', 'import pynvim' }
  return vim.v.shell_error == 0
end

local function detect_python_host()
  local candidates = {
    vim.fn.expand '~/.venvs/nvim/bin/python',
    vim.env.NVIM_PYTHON3,
    vim.env.NVIM_PYTHON,
    (vim.env.VIRTUAL_ENV or '') ~= '' and (vim.env.VIRTUAL_ENV .. '/bin/python3') or nil,
    vim.fn.exepath 'python3',
  }
  for _, p in ipairs(candidates) do
    if p and has_pynvim(p) then
      return p
    end
  end
end

local py = detect_python_host()
if py then
  vim.g.python3_host_prog = py
else
  vim.schedule(function()
    vim.notify('No python with pynvim found for python3_host_prog', vim.log.levels.WARN)
  end)
end
-- vim: ts=2 sts=2 sw=2 et
