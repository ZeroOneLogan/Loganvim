-- config.lua --
-- Central configuration module for LoganVim
-- Easy customization for users

local M = {}

---@class LoganVimConfig
---@field colorscheme string Default colorscheme
---@field transparent boolean Enable transparent background
---@field animations boolean Enable animations
---@field icons boolean Use Nerd Font icons
---@field diagnostics LoganVimDiagnostics Diagnostics configuration
---@field lsp LoganVimLsp LSP configuration
---@field format LoganVimFormat Format configuration
---@field ui LoganVimUI UI configuration

---@class LoganVimDiagnostics
---@field virtual_text boolean Show virtual text
---@field signs boolean Show signs
---@field underline boolean Underline errors
---@field float boolean Show float on hover

---@class LoganVimLsp
---@field inlay_hints boolean Enable inlay hints
---@field codelens boolean Enable code lens
---@field semantic_tokens boolean Enable semantic tokens

---@class LoganVimFormat
---@field on_save boolean Format on save
---@field timeout number Format timeout in ms

---@class LoganVimUI
---@field border string Border style (none, single, double, rounded, solid, shadow)
---@field winblend number Window transparency (0-100)

---@type LoganVimConfig
M.defaults = {
  colorscheme = 'tokyonight-night',
  transparent = false,
  animations = true,
  icons = true,

  diagnostics = {
    virtual_text = true,
    signs = true,
    underline = true,
    float = true,
  },

  lsp = {
    inlay_hints = true,
    codelens = true,
    semantic_tokens = true,
  },

  format = {
    on_save = true,
    timeout = 500,
  },

  ui = {
    border = 'rounded',
    winblend = 0,
  },
}

---@type LoganVimConfig
M.options = {}

---Setup LoganVim configuration
---@param opts LoganVimConfig?
function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.defaults, opts or {})

  -- Apply some options immediately
  vim.g.have_nerd_font = M.options.icons

  -- Apply colorscheme
  if M.options.colorscheme then
    vim.schedule(function()
      local ok = pcall(vim.cmd.colorscheme, M.options.colorscheme)
      if not ok then
        vim.notify('Colorscheme ' .. M.options.colorscheme .. ' not found', vim.log.levels.WARN)
      end
    end)
  end
end

---Get a configuration value
---@param path string Dot-separated path (e.g., "lsp.inlay_hints")
---@return any
function M.get(path)
  local keys = vim.split(path, '.', { plain = true })
  local value = M.options

  for _, key in ipairs(keys) do
    if type(value) ~= 'table' then
      return nil
    end
    value = value[key]
  end

  return value
end

---Set a configuration value
---@param path string Dot-separated path
---@param value any Value to set
function M.set(path, value)
  local keys = vim.split(path, '.', { plain = true })
  local target = M.options

  for i = 1, #keys - 1 do
    local key = keys[i]
    if type(target[key]) ~= 'table' then
      target[key] = {}
    end
    target = target[key]
  end

  target[keys[#keys]] = value
end

---Check if icons are enabled
---@return boolean
function M.icons_enabled()
  return M.options.icons ~= false
end

---Get icon or fallback text
---@param icon string Nerd Font icon
---@param fallback string Fallback text
---@return string
function M.icon(icon, fallback)
  if M.icons_enabled() then
    return icon
  end
  return fallback or ''
end

---Get border style
---@return string
function M.border()
  return M.options.ui.border or 'rounded'
end

---Check if feature is enabled
---@param feature string Feature path
---@return boolean
function M.enabled(feature)
  return M.get(feature) ~= false
end

return M
