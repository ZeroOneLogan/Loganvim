local uv = vim.uv or vim.loop

local function is_executable(cmd)
  return vim.fn.executable(cmd) == 1
end

local eslint_root_files = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.json',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.ts',
  'eslint.config.js',
  'eslint.config.cjs',
  'eslint.config.mjs',
  'eslint.config.ts',
  'package.json',
}

local function has_eslint_config(ctx)
  local filename = ctx.filename
  if not filename or filename == '' then
    local bufnr = ctx.bufnr or 0
    filename = vim.api.nvim_buf_get_name(bufnr)
  end

  if filename == '' then
    return false
  end

  local dir = vim.fs.dirname(filename)
  if not dir or dir == '' then
    return false
  end

  local found = vim.fs.find(eslint_root_files, {
    upward = true,
    path = dir,
    stop = uv.os_homedir(),
    type = 'file',
  })

  if not found[1] then
    return false
  end

  if vim.fs.basename(found[1]) ~= 'package.json' then
    return true
  end

  local ok_read, contents = pcall(vim.fn.readfile, found[1])
  if not ok_read then
    return false
  end

  local ok, pkg = pcall(vim.fn.json_decode, table.concat(contents, '\n'))
  if not ok or type(pkg) ~= 'table' then
    return false
  end

  return pkg.eslintConfig ~= nil or (pkg.devDependencies and pkg.devDependencies.eslint)
end

local clang_tidy_root_files = {
  '.clang-tidy',
  'compile_commands.json',
  'compile_flags.txt',
}

local function has_clang_tidy_config(ctx)
  local filename = ctx.filename
  if not filename or filename == '' then
    local bufnr = ctx.bufnr or 0
    filename = vim.api.nvim_buf_get_name(bufnr)
  end

  if filename == '' then
    return false
  end

  local dir = vim.fs.dirname(filename)
  if not dir or dir == '' then
    return false
  end

  local found = vim.fs.find(clang_tidy_root_files, {
    upward = true,
    path = dir,
    stop = uv.os_homedir(),
    type = 'file',
  })

  return found[1] ~= nil
end

return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint-cli2' },
        python = { 'ruff' },
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        svelte = { 'eslint_d' },
        vue = { 'eslint_d' },
        c = { 'clangtidy' },
        cpp = { 'clangtidy' },
        objc = { 'clangtidy' },
        objcpp = { 'clangtidy' },
        bash = { 'shellcheck' },
        sh = { 'shellcheck' },
      }

      lint.linters.eslint_d = vim.tbl_deep_extend('force', lint.linters.eslint_d or {}, {
        -- Avoid running eslint_d when the project has no config so we don't
        -- spam errors in throwaway buffers.
        condition = has_eslint_config,
      })

      lint.linters.clangtidy = vim.tbl_deep_extend('force', lint.linters.clangtidy or {}, {
        condition = function(ctx)
          return has_clang_tidy_config(ctx) and is_executable 'clang-tidy'
        end,
      })

      lint.linters.shellcheck = vim.tbl_deep_extend('force', lint.linters.shellcheck or {}, {
        condition = function()
          return is_executable 'shellcheck'
        end,
      })

      lint.linters.ruff = vim.tbl_deep_extend('force', lint.linters.ruff or {}, {
        condition = function()
          return is_executable 'ruff'
        end,
      })

      lint.linters.pylint = vim.tbl_deep_extend('force', lint.linters.pylint or {}, {
        condition = function()
          return is_executable 'pylint'
        end,
      })

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })

      vim.api.nvim_create_user_command('LintPylint', function()
        if vim.fn.executable 'pylint' ~= 1 then
          vim.notify('pylint executable not found in PATH', vim.log.levels.WARN)
          return
        end
        lint.try_lint { 'pylint' }
      end, { desc = 'Run pylint once (heavy)' })
    end,
  },
}
