-- neotest.lua --
-- Test runner integration for multiple languages

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- Test adapters
    'nvim-neotest/neotest-python',
    'nvim-neotest/neotest-jest',
    'marilari88/neotest-vitest',
    'nvim-neotest/neotest-go',
    'rouge8/neotest-rust',
    'Issafalcon/neotest-dotnet',
    'alfaix/neotest-gtest', -- C++ gtest
  },
  keys = {
    {
      '<leader>Tt',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run nearest test',
    },
    {
      '<leader>TT',
      function()
        require('neotest').run.run(vim.fn.expand('%'))
      end,
      desc = 'Run all tests in file',
    },
    {
      '<leader>Tr',
      function()
        require('neotest').run.run_last()
      end,
      desc = 'Re-run last test',
    },
    {
      '<leader>Ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle test summary',
    },
    {
      '<leader>To',
      function()
        require('neotest').output.open({ enter = true, auto_close = true })
      end,
      desc = 'Show test output',
    },
    {
      '<leader>TO',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Toggle output panel',
    },
    {
      '<leader>TS',
      function()
        require('neotest').run.stop()
      end,
      desc = 'Stop test',
    },
    {
      '<leader>Td',
      function()
        require('neotest').run.run({ strategy = 'dap' })
      end,
      desc = 'Debug nearest test',
    },
    {
      '<leader>Ta',
      function()
        require('neotest').run.run({ suite = true })
      end,
      desc = 'Run all tests',
    },
    {
      '<leader>Tw',
      function()
        require('neotest').watch.toggle(vim.fn.expand('%'))
      end,
      desc = 'Toggle watch mode',
    },
    {
      '[T',
      function()
        require('neotest').jump.prev({ status = 'failed' })
      end,
      desc = 'Previous failed test',
    },
    {
      ']T',
      function()
        require('neotest').jump.next({ status = 'failed' })
      end,
      desc = 'Next failed test',
    },
  },
  opts = function()
    return {
      adapters = {
        require('neotest-python')({
          dap = { justMyCode = false },
          args = { '--tb=short' },
          runner = function()
            if vim.fn.filereadable('pytest.ini') == 1 or vim.fn.filereadable('pyproject.toml') == 1 then
              return 'pytest'
            end
            return 'unittest'
          end,
        }),
        require('neotest-jest')({
          jestCommand = 'npm test --',
          jestConfigFile = 'jest.config.js',
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),
        require('neotest-vitest'),
        require('neotest-go')({
          experimental = {
            test_table = true,
          },
          args = { '-count=1', '-timeout=60s' },
        }),
        require('neotest-rust')({
          args = { '--no-capture' },
          dap_adapter = 'codelldb',
        }),
        require('neotest-dotnet'),
        require('neotest-gtest'),
      },
      status = {
        virtual_text = true,
        signs = true,
      },
      icons = {
        expanded = '',
        child_prefix = '',
        child_indent = '',
        final_child_prefix = '',
        non_collapsible = '',
        collapsed = '',
        passed = '',
        running = '',
        failed = '',
        unknown = '',
        skipped = '',
      },
      floating = {
        border = 'rounded',
        max_height = 0.6,
        max_width = 0.6,
      },
      summary = {
        animated = true,
        enabled = true,
        expand_errors = true,
        follow = true,
        mappings = {
          attach = 'a',
          clear_marked = 'M',
          clear_target = 'T',
          debug = 'd',
          debug_marked = 'D',
          expand = { '<CR>', '<2-LeftMouse>' },
          expand_all = 'e',
          jumpto = 'i',
          mark = 'm',
          next_failed = 'J',
          output = 'o',
          prev_failed = 'K',
          run = 'r',
          run_marked = 'R',
          short = 'O',
          stop = 'u',
          target = 't',
          watch = 'w',
        },
        open = 'botright vsplit | vertical resize 50',
      },
      output = {
        enabled = true,
        open_on_run = 'short',
      },
      quickfix = {
        enabled = true,
        open = false,
      },
      diagnostic = {
        enabled = true,
        severity = vim.diagnostic.severity.ERROR,
      },
    }
  end,
  config = function(_, opts)
    local neotest_ns = vim.api.nvim_create_namespace('neotest')
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
          return message
        end,
      },
    }, neotest_ns)
    require('neotest').setup(opts)
  end,
}
