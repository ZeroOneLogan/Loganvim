-- theme.lua --
-- Advanced Theme Management for LoganVim
-- Handles colorscheme switching and UI consistency

local M = {}

--  ╭──────────────────────────────────────────────────────────────╮
--  │                    Colorscheme Providers                     │
--  ╰──────────────────────────────────────────────────────────────╯

local scheme_providers = {
  -- Tokyo Night variants
  tokyonight = 'tokyonight',
  ['tokyonight-day'] = 'tokyonight',
  ['tokyonight-moon'] = 'tokyonight',
  ['tokyonight-night'] = 'tokyonight',
  ['tokyonight-storm'] = 'tokyonight',

  -- Catppuccin variants
  catppuccin = 'catppuccin',
  ['catppuccin-latte'] = 'catppuccin',
  ['catppuccin-frappe'] = 'catppuccin',
  ['catppuccin-macchiato'] = 'catppuccin',
  ['catppuccin-mocha'] = 'catppuccin',

  -- VSCode variants
  vscode = 'vscode',
  ['vscode-dark'] = 'vscode',

  -- GitHub variants
  github_dark = 'github-theme',
  github_dark_dimmed = 'github-theme',
  github_light = 'github-theme',

  -- Kanagawa variants
  kanagawa = 'kanagawa',
  ['kanagawa-dragon'] = 'kanagawa',
  ['kanagawa-lotus'] = 'kanagawa',
  ['kanagawa-wave'] = 'kanagawa',

  -- Nightfox variants
  nightfox = 'nightfox',
  dayfox = 'nightfox',
  dawnfox = 'nightfox',
  duskfox = 'nightfox',
  terafox = 'nightfox',
  carbonfox = 'nightfox',

  -- Rose Pine variants
  ['rose-pine'] = 'rose-pine',
  ['rose-pine-moon'] = 'rose-pine',
  ['rose-pine-dawn'] = 'rose-pine',

  -- OneDark variants
  onedark = 'onedarkpro',
  onedark_dark = 'onedarkpro',
  onedark_vivid = 'onedarkpro',

  -- Others
  nord = 'nord',
  dracula = 'dracula',
  sequoia = 'sequoia',
  ['night-owl'] = 'night-owl',
}

--  ╭──────────────────────────────────────────────────────────────╮
--  │                       Color Palettes                         │
--  ╰──────────────────────────────────────────────────────────────╯

local palettes = {
  dark = {
    float_bg = '#11111b',
    float_fg = '#cdd6f4',
    border = '#7aa2f7',
    accent = '#f5c2e7',
    separator = '#313244',
    search = '#fab387',
    search_fg = '#0f0f17',
    selection = '#313244',
  },
  light = {
    float_bg = '#f7f7ff',
    float_fg = '#4c4f69',
    border = '#1e66f5',
    accent = '#d20f39',
    separator = '#b4befe',
    search = '#ffd803',
    search_fg = '#1f1d2b',
    selection = '#dce0e8',
  },
}

--  ╭──────────────────────────────────────────────────────────────╮
--  │                      Helper Functions                        │
--  ╰──────────────────────────────────────────────────────────────╯

local function dec_to_hex(color)
  if not color then return nil end
  return string.format('#%06x', color)
end

local function set_hl(group, values)
  local ok, existing = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok and existing then
    values = vim.tbl_extend('force', existing, values)
  end
  vim.api.nvim_set_hl(0, group, values)
end

local function ensure_provider_loaded(scheme)
  local provider = scheme_providers[scheme]
  if not provider then return end

  local ok_config, lazy_config = pcall(require, 'lazy.core.config')
  if not ok_config or not lazy_config.plugins or not lazy_config.plugins[provider] then
    return
  end

  local ok, lazy = pcall(require, 'lazy')
  if ok then
    lazy.load({ plugins = { provider } })
  end
end

--  ╭──────────────────────────────────────────────────────────────╮
--  │                      Public Functions                        │
--  ╰──────────────────────────────────────────────────────────────╯

---Load a colorscheme
---@param scheme string Name of the colorscheme
---@return boolean success
function M.load_colorscheme(scheme)
  if not scheme or scheme == '' then
    return false
  end

  ensure_provider_loaded(scheme)

  local ok, err = pcall(vim.cmd.colorscheme, scheme)
  if not ok then
    vim.notify('Failed to load colorscheme: ' .. scheme .. '\n' .. tostring(err), vim.log.levels.WARN)
    return false
  end
  return true
end

---Apply consistent highlight overrides
function M.apply()
  local bg = vim.o.background
  local palette = palettes[bg] or palettes.dark

  -- Get current Normal colors
  local ok, normal = pcall(vim.api.nvim_get_hl, 0, { name = 'Normal', link = false })
  local fg = (ok and dec_to_hex(normal.fg)) or palette.float_fg
  local bg_color = (ok and dec_to_hex(normal.bg)) or '#1a1b26'

  -- Float windows
  set_hl('NormalFloat', { bg = palette.float_bg, fg = fg })
  set_hl('FloatBorder', { fg = palette.border, bg = palette.float_bg })
  set_hl('FloatTitle', { fg = palette.accent, bg = palette.float_bg, bold = true })
  set_hl('FloatFooter', { fg = palette.accent, bg = palette.float_bg, italic = true })

  -- Popup menu
  set_hl('Pmenu', { bg = palette.float_bg, fg = fg })
  set_hl('PmenuSel', { bg = palette.accent, fg = palette.search_fg, bold = true })
  set_hl('PmenuSbar', { bg = palette.separator })
  set_hl('PmenuThumb', { bg = palette.accent })

  -- Window separators
  set_hl('WinSeparator', { fg = palette.separator })
  set_hl('VertSplit', { fg = palette.separator })

  -- Cursor line number
  set_hl('CursorLineNr', { fg = palette.accent, bold = true })

  -- Search
  set_hl('Search', { fg = palette.search_fg, bg = palette.search, bold = true })
  set_hl('IncSearch', { fg = bg_color, bg = palette.accent, bold = true })
  set_hl('CurSearch', { fg = bg_color, bg = palette.accent, bold = true })

  -- Indent
  set_hl('IblScope', { fg = palette.accent, nocombine = true })
  set_hl('IblIndent', { fg = palette.separator, nocombine = true })

  -- Mini.indentscope
  set_hl('MiniIndentscopeSymbol', { fg = palette.accent })

  -- Diagnostics
  set_hl('DiagnosticUnnecessary', { fg = palette.separator, italic = true })

  -- Treesitter context
  set_hl('TreesitterContext', { bg = palette.float_bg })
  set_hl('TreesitterContextLineNumber', { fg = palette.accent })

  -- Telescope
  set_hl('TelescopeBorder', { fg = palette.border, bg = palette.float_bg })
  set_hl('TelescopeNormal', { bg = palette.float_bg })
  set_hl('TelescopePromptBorder', { fg = palette.border, bg = palette.float_bg })
  set_hl('TelescopePromptNormal', { bg = palette.float_bg })
  set_hl('TelescopeResultsBorder', { fg = palette.border, bg = palette.float_bg })
  set_hl('TelescopePreviewBorder', { fg = palette.border, bg = palette.float_bg })
  set_hl('TelescopeSelection', { bg = palette.selection })

  -- Neo-tree
  set_hl('NeoTreeNormal', { bg = palette.float_bg })
  set_hl('NeoTreeNormalNC', { bg = palette.float_bg })
  set_hl('NeoTreeWinSeparator', { fg = palette.separator, bg = palette.float_bg })

  -- Blink.cmp
  set_hl('BlinkCmpMenu', { bg = palette.float_bg })
  set_hl('BlinkCmpMenuBorder', { fg = palette.border, bg = palette.float_bg })
  set_hl('BlinkCmpMenuSelection', { bg = palette.selection })
  set_hl('BlinkCmpDoc', { bg = palette.float_bg })
  set_hl('BlinkCmpDocBorder', { fg = palette.border, bg = palette.float_bg })
  set_hl('BlinkCmpSource', { fg = palette.separator })

  -- Noice
  set_hl('NoiceCmdlinePopup', { bg = palette.float_bg })
  set_hl('NoiceCmdlinePopupBorder', { fg = palette.border, bg = palette.float_bg })
  set_hl('NoicePopupmenu', { bg = palette.float_bg })
  set_hl('NoicePopupmenuBorder', { fg = palette.border, bg = palette.float_bg })

  -- Alpha
  set_hl('AlphaHeader', { fg = palette.accent })
  set_hl('AlphaButtons', { fg = fg })
  set_hl('AlphaShortcut', { fg = palette.border })
  set_hl('AlphaFooter', { fg = palette.separator, italic = true })

  -- Which-key
  set_hl('WhichKeyFloat', { bg = palette.float_bg })
  set_hl('WhichKeyBorder', { fg = palette.border, bg = palette.float_bg })

  -- Notify
  set_hl('NotifyBackground', { bg = palette.float_bg })
end

---Setup theme module
function M.setup()
  -- Apply initial highlights
  M.apply()

  -- Auto-load providers before colorscheme changes
  if not vim.g.loganvim_theme_setup then
    vim.g.loganvim_theme_setup = true

    vim.api.nvim_create_autocmd('ColorSchemePre', {
      group = vim.api.nvim_create_augroup('loganvim-theme-pre', { clear = true }),
      callback = function(event)
        ensure_provider_loaded(event.match)
      end,
    })
  end

  -- Re-apply highlights after colorscheme changes
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('loganvim-theme', { clear = true }),
    callback = M.apply,
  })
end

---Toggle between light and dark mode
function M.toggle_background()
  vim.o.background = vim.o.background == 'dark' and 'light' or 'dark'
  vim.notify('Background: ' .. vim.o.background)
end

---Get current palette
---@return table
function M.get_palette()
  return palettes[vim.o.background] or palettes.dark
end

return M
