-- debug.lua --
-- Complete Debugging Configuration for LoganVim
-- Support for multiple languages with beautiful UI

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- DAP UI
    {
      'rcarriga/nvim-dap-ui',
      dependencies = { 'nvim-neotest/nvim-nio' },
      keys = {
        {
          '<leader>du',
          function()
            require('dapui').toggle({})
          end,
          desc = 'DAP: Toggle UI',
        },
        {
          '<leader>de',
          function()
            require('dapui').eval()
          end,
          desc = 'DAP: Eval',
          mode = { 'n', 'v' },
        },
      },
      opts = {
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.4 },
              { id = 'breakpoints', size = 0.2 },
              { id = 'stacks', size = 0.2 },
              { id = 'watches', size = 0.2 },
            },
            size = 50,
            position = 'left',
          },
          {
            elements = {
              { id = 'repl', size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            size = 0.25,
            position = 'bottom',
          },
        },
        floating = {
          max_height = 0.9,
          max_width = 0.5,
          border = 'rounded',
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
        controls = {
          enabled = true,
          element = 'repl',
          icons = {
            pause = '',
            play = '',
            step_into = '',
            step_over = '',
            step_out = '',
            step_back = '',
            run_last = '',
            terminate = '',
            disconnect = '',
          },
        },
        icons = { expanded = '▾', collapsed = '▸', current_frame = '󰁕' },
      },
      config = function(_, opts)
        local dap = require('dap')
        local dapui = require('dapui')
        dapui.setup(opts)

        dap.listeners.after.event_initialized['dapui_config'] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated['dapui_config'] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited['dapui_config'] = function()
          dapui.close({})
        end
      end,
    },

    -- Virtual text for variables
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        virt_text_pos = 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      },
    },

    -- Mason integration
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },

  keys = {
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'DAP: Toggle breakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end,
      desc = 'DAP: Conditional breakpoint',
    },
    {
      '<leader>dl',
      function()
        require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
      end,
      desc = 'DAP: Log point',
    },
    {
      '<leader>dc',
      function()
        require('dap').continue()
      end,
      desc = 'DAP: Continue',
    },
    {
      '<leader>dC',
      function()
        require('dap').run_to_cursor()
      end,
      desc = 'DAP: Run to cursor',
    },
    {
      '<leader>dg',
      function()
        require('dap').goto_()
      end,
      desc = 'DAP: Go to line',
    },
    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = 'DAP: Step into',
    },
    {
      '<leader>dj',
      function()
        require('dap').down()
      end,
      desc = 'DAP: Down',
    },
    {
      '<leader>dk',
      function()
        require('dap').up()
      end,
      desc = 'DAP: Up',
    },
    {
      '<leader>do',
      function()
        require('dap').step_out()
      end,
      desc = 'DAP: Step out',
    },
    {
      '<leader>dO',
      function()
        require('dap').step_over()
      end,
      desc = 'DAP: Step over',
    },
    {
      '<leader>dp',
      function()
        require('dap').pause()
      end,
      desc = 'DAP: Pause',
    },
    {
      '<leader>dr',
      function()
        require('dap').repl.toggle()
      end,
      desc = 'DAP: Toggle REPL',
    },
    {
      '<leader>ds',
      function()
        require('dap').session()
      end,
      desc = 'DAP: Session',
    },
    {
      '<leader>dt',
      function()
        require('dap').terminate()
      end,
      desc = 'DAP: Terminate',
    },
    {
      '<leader>dw',
      function()
        require('dap.ui.widgets').hover()
      end,
      desc = 'DAP: Widgets',
    },
    -- Function keys
    { '<F5>', function() require('dap').continue() end, desc = 'DAP: Continue' },
    { '<F10>', function() require('dap').step_over() end, desc = 'DAP: Step over' },
    { '<F11>', function() require('dap').step_into() end, desc = 'DAP: Step into' },
    { '<F12>', function() require('dap').step_out() end, desc = 'DAP: Step out' },
  },

  config = function()
    local dap = require('dap')
    local mason_registry = require('mason-registry')

    --  ╭────────────────────────────────────────────────────────╮
    --  │                     Breakpoint UI                      │
    --  ╰────────────────────────────────────────────────────────╯

    vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef' })
    vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379' })

    vim.fn.sign_define('DapBreakpoint', {
      text = '',
      texthl = 'DapBreakpoint',
      linehl = '',
      numhl = '',
    })
    vim.fn.sign_define('DapBreakpointCondition', {
      text = '',
      texthl = 'DapBreakpoint',
      linehl = '',
      numhl = '',
    })
    vim.fn.sign_define('DapLogPoint', {
      text = '',
      texthl = 'DapLogPoint',
      linehl = '',
      numhl = '',
    })
    vim.fn.sign_define('DapStopped', {
      text = '',
      texthl = 'DapStopped',
      linehl = 'DapStopped',
      numhl = 'DapStopped',
    })
    vim.fn.sign_define('DapBreakpointRejected', {
      text = '',
      texthl = 'DapBreakpoint',
      linehl = '',
      numhl = '',
    })

    --  ╭────────────────────────────────────────────────────────╮
    --  │                    Mason DAP Setup                     │
    --  ╰────────────────────────────────────────────────────────╯

    require('mason-nvim-dap').setup({
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'codelldb',
        'debugpy',
        'js-debug-adapter',
        'delve',
      },
    })

    --  ╭────────────────────────────────────────────────────────╮
    --  │                    Adapter Setup                       │
    --  ╰────────────────────────────────────────────────────────╯

    local function get_mason_path(pkg)
      local ok, package = pcall(mason_registry.get_package, pkg)
      if not ok or not package:is_installed() then
        return nil
      end
      return package:get_install_path()
    end

    -- C/C++/Rust with codelldb
    local codelldb_path = get_mason_path('codelldb')
    if codelldb_path then
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = codelldb_path .. '/extension/adapter/codelldb',
          args = { '--port', '${port}' },
        },
      }

      local cpp_config = {
        {
          name = 'Launch',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          terminal = 'integrated',
        },
        {
          name = 'Attach to process',
          type = 'codelldb',
          request = 'attach',
          pid = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
      }

      dap.configurations.cpp = cpp_config
      dap.configurations.c = cpp_config
      dap.configurations.rust = cpp_config
    end

    -- Python with debugpy
    local debugpy_path = get_mason_path('debugpy')
    if debugpy_path then
      local python_path = debugpy_path .. '/venv/bin/python'
      if vim.fn.has('win32') == 1 then
        python_path = debugpy_path .. '\\venv\\Scripts\\python.exe'
      end

      dap.adapters.python = {
        type = 'executable',
        command = python_path,
        args = { '-m', 'debugpy.adapter' },
      }

      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          pythonPath = function()
            local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
            if venv then
              if vim.fn.has('win32') == 1 then
                return venv .. '\\Scripts\\python.exe'
              end
              return venv .. '/bin/python'
            end
            return vim.fn.exepath('python3') or 'python3'
          end,
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file with arguments',
          program = '${file}',
          args = function()
            local args_string = vim.fn.input('Arguments: ')
            return vim.split(args_string, ' ')
          end,
          pythonPath = function()
            local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
            if venv then
              return venv .. '/bin/python'
            end
            return vim.fn.exepath('python3') or 'python3'
          end,
        },
      }
    end

    -- JavaScript/TypeScript with js-debug-adapter
    local js_debug_path = get_mason_path('js-debug-adapter')
    if js_debug_path and vim.fn.executable('node') == 1 then
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { js_debug_path .. '/js-debug/src/dapDebugServer.js', '${port}' },
        },
      }

      local js_config = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
      }

      dap.configurations.javascript = js_config
      dap.configurations.typescript = js_config
      dap.configurations.javascriptreact = js_config
      dap.configurations.typescriptreact = js_config
    end

    -- Go with delve
    local delve_path = get_mason_path('delve')
    if delve_path then
      dap.adapters.delve = {
        type = 'server',
        port = '${port}',
        executable = {
          command = delve_path .. '/dlv',
          args = { 'dap', '-l', '127.0.0.1:${port}' },
        },
      }

      dap.configurations.go = {
        {
          type = 'delve',
          name = 'Debug',
          request = 'launch',
          program = '${file}',
        },
        {
          type = 'delve',
          name = 'Debug test',
          request = 'launch',
          mode = 'test',
          program = '${file}',
        },
        {
          type = 'delve',
          name = 'Debug test (go.mod)',
          request = 'launch',
          mode = 'test',
          program = './${relativeFileDirname}',
        },
      }
    end
  end,
}

-- vim: ts=2 sts=2 sw=2 et
