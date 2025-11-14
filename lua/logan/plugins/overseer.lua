return {
  'stevearc/overseer.nvim',
  cmd = {
    'OverseerRun',
    'OverseerToggle',
    'OverseerTaskAction',
    'OverseerTaskInfo',
    'CppBuild',
    'CppRun',
    'CppConfigure',
    'CppBear',
    'CppInitCMake',
  },
  keys = {
    {
      '<leader>cb',
      function()
        require('logan.cpp').build()
      end,
      desc = 'C++ build (auto-detect project type)',
    },
    {
      '<leader>cr',
      function()
        require('logan.cpp').run()
      end,
      desc = 'C++ run (last target)',
    },
    {
      '<leader>cC',
      function()
        require('logan.cpp').configure()
      end,
      desc = 'C++ configure (CMake/Bear)',
    },
    {
      '<leader>cB',
      function()
        require('logan.cpp').bear()
      end,
      desc = 'C++ make with Bear',
    },
    {
      '<leader>ci',
      function()
        require('logan.cpp').init_cmake()
      end,
      desc = 'C++ init CMakeLists.txt',
    },
    { '<leader>ct', '<cmd>OverseerToggle<CR>', desc = 'Tasks: toggle list' },
  },
  config = function()
    local overseer = require 'overseer'
    overseer.setup {
      strategy = 'termopen',
    }
    require('logan.cpp').setup()
  end,
}
