local M = {}

local scheme_providers = {
  tokyonight = 'tokyonight',
  ['tokyonight-day'] = 'tokyonight',
  ['tokyonight-moon'] = 'tokyonight',
  ['tokyonight-night'] = 'tokyonight',
  ['tokyonight-storm'] = 'tokyonight',
  catppuccin = 'catppuccin',
  ['catppuccin-latte'] = 'catppuccin',
  ['catppuccin-frappe'] = 'catppuccin',
  ['catppuccin-macchiato'] = 'catppuccin',
  ['catppuccin-mocha'] = 'catppuccin',
  vscode = 'vscode',
  ['vscode-dark'] = 'vscode',
  ['vscode-dark-plus'] = 'vscode',
  ['vscode-light'] = 'vscode',
  ['vscode-light-plus'] = 'vscode',
  ['github_dark'] = 'github-theme',
  ['github_dark_colorblind'] = 'github-theme',
  ['github_dark_default'] = 'github-theme',
  ['github_dark_dimmed'] = 'github-theme',
  ['github_dark_high_contrast'] = 'github-theme',
  ['github_dark_tritanopia'] = 'github-theme',
  ['github_light'] = 'github-theme',
  ['github_light_colorblind'] = 'github-theme',
  ['github_light_default'] = 'github-theme',
  ['github_light_high_contrast'] = 'github-theme',
  ['github_light_tritanopia'] = 'github-theme',
  sequoia = 'sequoia',
  nord = 'nord',
  nightfox = 'nightfox',
  dayfox = 'nightfox',
  dawnfox = 'nightfox',
  duskfox = 'nightfox',
  terafox = 'nightfox',
  carbonfox = 'nightfox',
  alabaster = 'alabaster',
  rusty = 'rusty',
  ['night-owl'] = 'night-owl',
  kanagawa = 'kanagawa',
  ['kanagawa-dragon'] = 'kanagawa',
  ['kanagawa-lotus'] = 'kanagawa',
  ['kanagawa-wave'] = 'kanagawa',
  onedark = 'onedarkpro',
  ['onedark_dark'] = 'onedarkpro',
  ['onedark_vivid'] = 'onedarkpro',
  onedarker = 'onedarkpro',
  onelight = 'onedarkpro',
  everforest = 'everforest',
  ['everforest-hard'] = 'everforest',
  ['everforest-medium'] = 'everforest',
  ['everforest-soft'] = 'everforest',
  ['rose-pine'] = 'rose-pine',
  ['rose-pine-moon'] = 'rose-pine',
  ['rose-pine-dawn'] = 'rose-pine',
  dracula = 'dracula',
  lackluster = 'lackluster',
  oscura = 'oscura',
}

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

local function ensure_provider_loaded(scheme)
  local provider = scheme_providers[scheme]
  if not provider then
    return
  end
  local ok_config, lazy_config = pcall(require, 'lazy.core.config')
  if not ok_config then
    return
  end
  if not lazy_config.plugins or not lazy_config.plugins[provider] then
    return
  end
  local ok, lazy = pcall(require, 'lazy')
  if not ok then
    return
  end
  lazy.load { plugins = { provider } }
end

function M.load_colorscheme(scheme)
  if not scheme or scheme == '' then
    return false
  end
  ensure_provider_loaded(scheme)
  local ok, err = pcall(vim.cmd.colorscheme, scheme)
  if not ok then
    vim.notify(err, vim.log.levels.WARN)
  end
  return ok
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
  if not vim.g.logan_colorscheme_loader then
    vim.g.logan_colorscheme_loader = true
    vim.api.nvim_create_autocmd('ColorSchemePre', {
      group = vim.api.nvim_create_augroup('LoganColorschemePre', { clear = true }),
      callback = function(event)
        ensure_provider_loaded(event.match)
      end,
    })
  end
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('LoganTheme', { clear = true }),
    callback = M.apply,
  })
end

return M
