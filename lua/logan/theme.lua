local M = {}

local palette = {
  dark = {
    float_bg = '#11111b',
    border = '#7aa2f7',
    accent = '#f5c2e7',
    separator = '#313244',
    search = '#fab387',
    search_fg = '#0f0f17',
  },
  light = {
    float_bg = '#f7f7ff',
    border = '#1e1e2e',
    accent = '#d20f39',
    separator = '#b4befe',
    search = '#ffd803',
    search_fg = '#1f1d2b',
  },
}

local function dec_to_hex(color)
  if not color then
    return nil
  end
  return string.format('#%06x', color)
end

local function set_hl(group, values)
  local ok, existing = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok then
    values = vim.tbl_extend('force', existing, values)
  end
  vim.api.nvim_set_hl(0, group, values)
end

function M.apply()
  local variant = palette[vim.o.background] or palette.dark
  local ok, normal = pcall(vim.api.nvim_get_hl, 0, { name = 'Normal', link = false })
  local fg = (ok and dec_to_hex(normal.fg)) or '#cdd6f4'
  local bg = (ok and dec_to_hex(normal.bg)) or '#0b0c14'
  local float_fg = fg

  set_hl('NormalFloat', { bg = variant.float_bg, fg = float_fg })
  set_hl('FloatBorder', { fg = variant.border, bg = variant.float_bg })
  set_hl('FloatTitle', { fg = variant.accent, bg = variant.float_bg, bold = true })
  set_hl('FloatFooter', { fg = variant.accent, bg = variant.float_bg, italic = true })
  set_hl('Pmenu', { bg = variant.float_bg, fg = float_fg, blend = 0 })
  set_hl('PmenuSel', { bg = variant.accent, fg = variant.search_fg, bold = true })
  set_hl('WinSeparator', { fg = variant.separator })
  set_hl('NeoTreeWinSeparator', { fg = variant.separator })
  set_hl('CursorLineNr', { fg = variant.accent, bold = true })
  set_hl('Search', { fg = variant.search_fg or bg, bg = variant.search, bold = true })
  set_hl('IncSearch', { fg = bg, bg = variant.accent, bold = true })
  set_hl('IblScope', { fg = variant.accent, nocombine = true })
  set_hl('IblIndent', { fg = variant.separator, nocombine = true })
  set_hl('DiagnosticUnnecessary', { fg = variant.separator, italic = true })
end

function M.setup()
  M.apply()
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('LoganTheme', { clear = true }),
    callback = M.apply,
  })
end

return M
