return {
  'Civitasv/cmake-tools.nvim',
  dependencies = {
    'stevearc/overseer.nvim',
  },
  ft = { 'c', 'cpp', 'objc', 'objcpp', 'cmake' },
  cmd = {
    'CMakeGenerate',
    'CMakeBuild',
    'CMakeRun',
    'CMakeClean',
    'CMakeInstall',
    'CMakeClose',
    'CMakeSelectBuildType',
    'CMakeSelectBuildTarget',
    'CMakeSelectKit',
  },
  opts = {
    cmake_build_directory = 'build',
    cmake_build_type = 'Debug',
    cmake_generate_options = {
      '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON',
      '-DCMAKE_C_COMPILER=clang',
      '-DCMAKE_CXX_COMPILER=clang++',
    },
  },
  config = function(_, opts)
    require('cmake-tools').setup(opts)
  end,
}
