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

-- python location
vim.g.python3_host_prog = '/Users/drewlogan/.venvs/nvim/bin/python'
-- vim: ts=2 sts=2 sw=2 et
