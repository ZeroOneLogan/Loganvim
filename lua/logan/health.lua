-- health.lua --
-- Comprehensive Health Check for LoganVim
-- Optimized for Neovim 0.11.5

local M = {}

local function check_version()
  local verstr = tostring(vim.version())

  if not vim.version.ge then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return false
  end

  if vim.version.ge(vim.version(), '0.11.0') then
    vim.health.ok(string.format("Neovim version: '%s' (recommended for LoganVim v2)", verstr))
    return true
  elseif vim.version.ge(vim.version(), '0.10.0') then
    vim.health.warn(string.format("Neovim version: '%s' (0.11+ recommended for all features)", verstr))
    return true
  else
    vim.health.error(string.format("Neovim out of date: '%s'. LoganVim requires 0.10+", verstr))
    return false
  end
end

local function check_external_reqs()
  vim.health.info('Checking external dependencies...')

  -- Essential tools
  local essential = { 'git', 'rg', 'fd', 'fzf' }
  for _, exe in ipairs(essential) do
    if vim.fn.executable(exe) == 1 then
      vim.health.ok(string.format("Essential: '%s' found", exe))
    else
      vim.health.error(string.format("Missing essential tool: '%s'", exe))
    end
  end

  -- Build tools
  local build_tools = { 'make', 'gcc', 'node', 'npm' }
  for _, exe in ipairs(build_tools) do
    if vim.fn.executable(exe) == 1 then
      vim.health.ok(string.format("Build tool: '%s' found", exe))
    else
      vim.health.warn(string.format("Build tool not found: '%s' (may limit some plugins)", exe))
    end
  end

  -- Optional but recommended
  local optional = { 'lazygit', 'tree-sitter', 'cargo', 'go', 'python3', 'lua', 'luarocks' }
  for _, exe in ipairs(optional) do
    if vim.fn.executable(exe) == 1 then
      vim.health.ok(string.format("Optional: '%s' found", exe))
    else
      vim.health.info(string.format("Optional: '%s' not found", exe))
    end
  end

  return true
end

local function check_nerd_font()
  vim.health.info('Checking Nerd Font...')

  if vim.g.have_nerd_font then
    vim.health.ok('Nerd Font enabled (vim.g.have_nerd_font = true)')
  else
    vim.health.warn('Nerd Font disabled. Icons may not display correctly.')
    vim.health.info('Set vim.g.have_nerd_font = true in init.lua if you have a Nerd Font installed')
  end
end

local function check_python()
  vim.health.info('Checking Python support...')

  if vim.g.python3_host_prog and vim.g.python3_host_prog ~= '' then
    local py = vim.g.python3_host_prog
    if vim.fn.executable(py) == 1 then
      vim.health.ok(string.format("Python3 host: '%s'", py))

      -- Check pynvim
      local result = vim.fn.system({ py, '-c', 'import pynvim; print(pynvim.__version__)' })
      if vim.v.shell_error == 0 then
        vim.health.ok(string.format('pynvim version: %s', vim.trim(result)))
      else
        vim.health.warn('pynvim not installed. Run: pip install pynvim')
      end
    else
      vim.health.error(string.format("Python3 host not executable: '%s'", py))
    end
  else
    vim.health.info('Python3 host not configured (set vim.g.python3_host_prog if needed)')
  end
end

local function check_plugins()
  vim.health.info('Checking plugin manager...')

  local lazy_ok, lazy = pcall(require, 'lazy')
  if lazy_ok then
    local stats = lazy.stats()
    vim.health.ok(string.format('Lazy.nvim loaded: %d plugins (startup: %.2fms)', stats.loaded, stats.startuptime))
  else
    vim.health.error('Lazy.nvim not found')
  end
end

local function check_lsp()
  vim.health.info('Checking LSP configuration...')

  local mason_ok = pcall(require, 'mason')
  if mason_ok then
    vim.health.ok('Mason.nvim installed')
  else
    vim.health.warn('Mason.nvim not found - LSP servers need manual installation')
  end

  local lspconfig_ok = pcall(require, 'lspconfig')
  if lspconfig_ok then
    vim.health.ok('nvim-lspconfig installed')
  else
    vim.health.error('nvim-lspconfig not found')
  end

  -- Check active LSP clients
  local clients = vim.lsp.get_clients()
  if #clients > 0 then
    for _, client in ipairs(clients) do
      vim.health.ok(string.format('LSP active: %s', client.name))
    end
  else
    vim.health.info('No LSP clients currently active')
  end
end

local function check_treesitter()
  vim.health.info('Checking Treesitter...')

  local ts_ok, ts = pcall(require, 'nvim-treesitter.info')
  if ts_ok then
    vim.health.ok('nvim-treesitter installed')

    -- Check installed parsers
    local parsers = require('nvim-treesitter.parsers')
    local installed = {}
    for name, _ in pairs(parsers.get_parser_configs()) do
      if parsers.has_parser(name) then
        table.insert(installed, name)
      end
    end
    vim.health.ok(string.format('Installed parsers: %d', #installed))
  else
    vim.health.warn('nvim-treesitter not found')
  end
end

local function check_clipboard()
  vim.health.info('Checking clipboard...')

  if vim.fn.has('clipboard') == 1 then
    vim.health.ok('Clipboard support available')

    if vim.fn.executable('xclip') == 1 then
      vim.health.ok("Clipboard provider: 'xclip'")
    elseif vim.fn.executable('xsel') == 1 then
      vim.health.ok("Clipboard provider: 'xsel'")
    elseif vim.fn.executable('wl-copy') == 1 then
      vim.health.ok("Clipboard provider: 'wl-copy' (Wayland)")
    elseif vim.fn.executable('pbcopy') == 1 then
      vim.health.ok("Clipboard provider: 'pbcopy' (macOS)")
    else
      vim.health.warn('No clipboard provider found')
    end
  else
    vim.health.warn('Clipboard support not available')
  end
end

local function check_terminal()
  vim.health.info('Checking terminal...')

  local term = vim.env.TERM or 'unknown'
  local term_program = vim.env.TERM_PROGRAM or 'unknown'

  vim.health.ok(string.format('TERM: %s', term))
  vim.health.ok(string.format('TERM_PROGRAM: %s', term_program))

  if vim.env.TMUX then
    vim.health.ok('Running inside tmux')
  end

  if vim.o.termguicolors then
    vim.health.ok('True color (24-bit) enabled')
  else
    vim.health.warn('True color not enabled. Set vim.o.termguicolors = true')
  end
end

function M.check()
  vim.health.start('LoganVim Health Check')

  vim.health.info([[
╭──────────────────────────────────────────────────────────╮
│              LoganVim v2.0 - Health Check                │
│           Optimized for Neovim 0.11.5                    │
╰──────────────────────────────────────────────────────────╯

NOTE: Not every warning requires action.
Fix only warnings for tools and languages you use.
]])

  local uv = vim.uv or vim.loop
  local sysinfo = uv.os_uname()
  vim.health.info(string.format('System: %s %s (%s)', sysinfo.sysname, sysinfo.release, sysinfo.machine))

  -- Run all checks
  check_version()
  check_external_reqs()
  check_nerd_font()
  check_terminal()
  check_clipboard()
  check_python()
  check_plugins()
  check_lsp()
  check_treesitter()
end

return M
