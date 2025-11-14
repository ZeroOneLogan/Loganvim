local uv = vim.uv or vim.loop
local SEP = package.config:sub(1, 1)

local M = {}

local default_jobs = (uv and uv.available_parallelism and uv.available_parallelism()) or 4
default_jobs = math.max(default_jobs, 2)

local defaults = {
  build_dir = 'build/nvim',
  cmake_build_dir = 'build',
  single_file = {
    compiler = 'clang++',
    flags = { '-std=c++20', '-O0', '-g', '-Wall', '-Wextra', '-pedantic' },
    include_dirs = {},
  },
  bear = {
    jobs = default_jobs,
  },
}

local options = vim.deepcopy(defaults)

local state = {
  single = {}, -- [root] = { binary = path }
  make_run_cmd = {},
  did_setup = false,
}

local function notify(msg, level)
  vim.notify('[cpp] ' .. msg, level or vim.log.levels.INFO)
end

local joinpath = vim.fs and vim.fs.joinpath
if not joinpath then
  joinpath = function(...)
    return table.concat({ ... }, SEP)
  end
end

local function dirname(path)
  if vim.fs and vim.fs.dirname then
    return vim.fs.dirname(path)
  end
  local pattern = '(.+)' .. SEP .. '[^' .. SEP .. ']+' .. '$'
  local dir = path:match(pattern)
  return dir or '.'
end

local function sanitize_project_name(name)
  if not name or name == '' then
    return 'app'
  end
  local sanitized = name:gsub('%s+', '_'):gsub('[^%w_]+', '_')
  if sanitized == '' then
    return 'app'
  end
  return sanitized
end

local function normalize(path)
  return vim.fn.fnamemodify(path, ':p')
end

local function relpath(path, root)
  if not path or path == '' or not root or root == '' then
    return nil
  end
  if vim.fs and vim.fs.relpath then
    return vim.fs.relpath(path, root)
  end
  local abs_path = normalize(path)
  local abs_root = normalize(root)
  if abs_path:sub(1, #abs_root) ~= abs_root then
    return nil
  end
  local remainder = abs_path:sub(#abs_root + 1)
  return remainder:gsub('^' .. SEP .. '?', '')
end

local function exists(path)
  return vim.fn.filereadable(path) == 1
end

local function dir_exists(path)
  return vim.fn.isdirectory(path) == 1
end

local function is_cpp(path)
  if not path or path == '' then
    return false
  end
  local lower = path:lower()
  return lower:match '%.c%+%+$' or lower:match '%.cc$' or lower:match '%.cxx$' or lower:match '%.cpp$'
end

local function current_cpp_relative(root)
  local file = vim.api.nvim_buf_get_name(0)
  if not is_cpp(file) then
    return nil
  end
  return relpath(file, root)
end

local function write_file(path, lines)
  local ok, err = pcall(vim.fn.writefile, lines, path)
  if not ok then
    notify('Failed to write ' .. path .. ': ' .. err, vim.log.levels.ERROR)
    return false
  end
  return true
end

local function parse_args(argstr)
  if not argstr or argstr == '' then
    return {}
  end
  return vim.split(argstr, '%s+', { trimempty = true })
end

local function shell_command(cmdline)
  local shell = (vim.o.shell ~= '' and vim.o.shell) or 'sh'
  local flag = (vim.o.shellcmdflag ~= '' and vim.o.shellcmdflag) or '-c'
  return { shell, flag, cmdline }
end

local function run_task(name, cmd, cwd)
  local ok, overseer = pcall(require, 'overseer')
  if not ok then
    notify('overseer.nvim not available', vim.log.levels.ERROR)
    return
  end
  local ok_new, task = pcall(overseer.new_task, {
    name = name,
    cmd = cmd,
    cwd = cwd,
  })
  if not ok_new then
    notify('Failed to start task: ' .. task, vim.log.levels.ERROR)
    return
  end
  task:start()
end

local function find_root()
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  local start = (name ~= '' and dirname(name)) or (uv and uv.cwd and uv.cwd()) or vim.loop.cwd()
  if vim.fs and vim.fs.find then
    local found = vim.fs.find({ 'CMakeLists.txt', 'compile_commands.json', '.git' }, { path = start, upward = true })
    if #found > 0 then
      local path = found[1]
      if path:sub(-4) == '.git' then
        return dirname(path)
      end
      if dir_exists(path) then
        return path
      end
      return dirname(path)
    end
  end
  return start
end

local function project_type(root)
  if exists(joinpath(root, 'CMakeLists.txt')) then
    return 'cmake'
  end
  if exists(joinpath(root, 'Makefile')) or exists(joinpath(root, 'makefile')) then
    return 'make'
  end
  return 'single'
end

local function ensure_dir(path)
  if dir_exists(path) then
    return
  end
  vim.fn.mkdir(path, 'p')
end

local function ensure_cmake()
  local ok = pcall(require, 'cmake-tools')
  if not ok then
    notify('cmake-tools.nvim is not installed. Run :Lazy install', vim.log.levels.ERROR)
  end
  return ok
end

local function ensure_cmake_generated(root)
  local build_dir = options.cmake_build_dir or 'build'
  local cmake_dir = build_dir
  if not build_dir:match '^%s*/' then
    cmake_dir = joinpath(root, build_dir)
  end
  if exists(joinpath(cmake_dir, 'CMakeCache.txt')) then
    return true
  end
  notify('Running :CMakeGenerate (first-time configure)', vim.log.levels.INFO)
  vim.cmd 'CMakeGenerate'
  return exists(joinpath(cmake_dir, 'CMakeCache.txt'))
end

local function single_build_dir(root)
  local dir = options.build_dir or 'build/nvim'
  if dir:match '^%s*/' then
    return dir
  end
  return joinpath(root, dir)
end

local function build_single_file(root)
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].modified then
    vim.cmd 'silent write'
  end
  local file = vim.api.nvim_buf_get_name(buf)
  if file == '' then
    notify('Save the file before building it', vim.log.levels.WARN)
    return
  end
  local out_dir = single_build_dir(root)
  ensure_dir(out_dir)
  local binary = joinpath(out_dir, vim.fn.fnamemodify(file, ':t:r'))
  local cmd = { options.single_file.compiler }
  vim.list_extend(cmd, options.single_file.flags or {})
  for _, inc in ipairs(options.single_file.include_dirs or {}) do
    table.insert(cmd, '-I' .. inc)
  end
  table.insert(cmd, file)
  table.insert(cmd, '-o')
  table.insert(cmd, binary)
  run_task('Build ' .. vim.fn.fnamemodify(file, ':t'), cmd, root)
  state.single[root] = { binary = binary }
  notify(('Building %s → %s'):format(vim.fn.fnamemodify(file, ':t'), binary))
end

local function run_single_file(root, argstr)
  local entry = state.single[root]
  if not entry or not entry.binary then
    notify('Nothing to run. Build the current file first (:CppBuild).', vim.log.levels.WARN)
    return
  end
  if not exists(entry.binary) then
    notify('Cached binary is missing. Rebuild first.', vim.log.levels.WARN)
    return
  end
  local cmd = { entry.binary }
  vim.list_extend(cmd, parse_args(argstr))
  run_task('Run ' .. vim.fn.fnamemodify(entry.binary, ':t'), cmd, root)
end

local function ensure_make_run_cmd(root)
  if state.make_run_cmd[root] then
    return state.make_run_cmd[root]
  end
  local cmdline = vim.fn.input('Run command (e.g. "make run" or "./bin/app"): ', 'make run')
  if cmdline == '' then
    return nil
  end
  state.make_run_cmd[root] = cmdline
  return cmdline
end

local function ensure_parallel_flag(args)
  for _, arg in ipairs(args) do
    if arg == '-j' or arg:match '^-j%d*$' then
      return args
    end
  end
  table.insert(args, '-j' .. tostring(options.bear.jobs or 4))
  return args
end

function M.bear(argstr)
  local root = find_root()
  if project_type(root) ~= 'make' then
    notify('No Makefile detected for Bear build', vim.log.levels.WARN)
    return
  end
  if vim.fn.executable 'bear' ~= 1 then
    notify('bear executable not found in PATH', vim.log.levels.ERROR)
    return
  end
  local args = parse_args(argstr)
  ensure_parallel_flag(args)
  local cmd = { 'bear', '--', 'make' }
  vim.list_extend(cmd, args)
  run_task('bear make', cmd, root)
end

function M.init_cmake(opts)
  opts = opts or {}
  local root = find_root()
  local cmake_path = joinpath(root, 'CMakeLists.txt')
  if exists(cmake_path) and not opts.force then
    notify('CMakeLists.txt already exists. Use :CppInitCMake! to overwrite.', vim.log.levels.WARN)
    return
  end
  local project = sanitize_project_name(opts.project_name or vim.fn.fnamemodify(root, ':t'))
  if exists(cmake_path) and opts.force then
    notify('Overwriting existing CMakeLists.txt', vim.log.levels.INFO)
  end
  local rel_src = current_cpp_relative(root)
  local lines = {
    'cmake_minimum_required(VERSION 3.20)',
    ('project(%s LANGUAGES CXX)'):format(project),
    '',
    'set(CMAKE_CXX_STANDARD 20)',
    'set(CMAKE_CXX_STANDARD_REQUIRED ON)',
    'set(CMAKE_EXPORT_COMPILE_COMMANDS ON)',
    '',
    'add_executable(${PROJECT_NAME}',
  }
  if rel_src then
    table.insert(lines, ('  %s'):format(rel_src))
  else
    table.insert(lines, '  src/main.cpp')
    table.insert(lines, '  # add more source files here')
  end
  table.insert(lines, ')')
  table.insert(lines, '')
  table.insert(lines, '# target_include_directories(${PROJECT_NAME} PRIVATE include)')
  table.insert(lines, '# target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -pedantic)')
  if write_file(cmake_path, lines) then
    notify('Created ' .. cmake_path)
    vim.cmd('edit ' .. cmake_path)
  end
end

function M.configure()
  local root = find_root()
  local kind = project_type(root)
  if kind == 'cmake' then
    if ensure_cmake() then
      vim.cmd 'CMakeGenerate'
    end
    return
  end
  if kind == 'make' then
    M.bear ''
    return
  end
  ensure_dir(single_build_dir(root))
  notify('Single-file builds ready under ' .. single_build_dir(root))
end

function M.build()
  local root = find_root()
  local kind = project_type(root)
  if kind == 'cmake' then
    if ensure_cmake() then
      ensure_cmake_generated(root)
      vim.cmd 'CMakeBuild'
    end
    return
  end
  if kind == 'make' then
    M.bear ''
    return
  end
  build_single_file(root)
end

function M.run(argstr, opts)
  opts = opts or {}
  local root = find_root()
  local kind = project_type(root)
  if kind == 'cmake' then
    if ensure_cmake() then
      ensure_cmake_generated(root)
      vim.cmd 'CMakeRun'
    end
    return
  end
  if kind == 'make' then
    if opts.force_prompt then
      state.make_run_cmd[root] = nil
    end
    local cmdline = ensure_make_run_cmd(root)
    if not cmdline then
      notify('Aborted run (no command provided)', vim.log.levels.WARN)
      return
    end
    local full = cmdline
    if argstr and argstr ~= '' then
      full = full .. ' ' .. argstr
    end
    run_task('make run', shell_command(full), root)
    return
  end
  run_single_file(root, argstr)
end

function M.setup(opts)
  if state.did_setup then
    return
  end
  state.did_setup = true
  options = vim.tbl_deep_extend('force', options, opts or {})
  vim.api.nvim_create_user_command('CppBuild', function()
    M.build()
  end, { desc = 'Build current C++ project or translation unit' })
  vim.api.nvim_create_user_command('CppRun', function(cmd_opts)
    M.run(cmd_opts.args, { force_prompt = cmd_opts.bang })
  end, { desc = 'Run the most recent C++ binary/target', nargs = '*', complete = 'file', bang = true })
  vim.api.nvim_create_user_command('CppConfigure', function()
    M.configure()
  end, { desc = 'Configure current C++ project (CMake/Bear)' })
  vim.api.nvim_create_user_command('CppBear', function(cmd_opts)
    M.bear(cmd_opts.args)
  end, { desc = 'Run make via Bear to refresh compile_commands', nargs = '*', complete = 'file' })
  vim.api.nvim_create_user_command('CppInitCMake', function(cmd_opts)
    M.init_cmake { force = cmd_opts.bang }
  end, { desc = 'Generate a starter CMakeLists.txt', bang = true })
end

return M
