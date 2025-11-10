-- debug.lua --
--
-- Shows how to use the DAP plugin to debug.
--

return {
  -- NOTE: you can install new plugins here.
  'mfussenegger/nvim-dap',
  -- NOTE: you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps.
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    local mason_registry = require 'mason-registry'
    local function mason_package_path(name)
      local ok, package = pcall(mason_registry.get_package, name)
      if not ok or not package:is_installed() then
        return nil
      end
      return package:get_install_path()
    end

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'codelldb',
        'debugpy',
        'js-debug-adapter',
      },
    }
    local function extend(lang, configs)
      dap.configurations[lang] = dap.configurations[lang] or {}
      vim.list_extend(dap.configurations[lang], configs)
    end

    -- Dap UI setup
    dapui.setup {
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.7 },
            { id = 'breakpoints', size = 0.3 },
          },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl', size = 0.4 },
            { id = 'console', size = 0.6 },
          },
          size = 10,
          position = 'bottom',
        },
      },
      -- Set icons to characters that are more likely to work in every terminal.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        enabled = true,
        element = 'repl',
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- C++ setup with 'codelldb'
    dap.configurations.cpp = {
      {
        name = 'Launch executable',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }

    -- Reuse for C and Rust
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    local debugpy_path = mason_package_path 'debugpy'
    if debugpy_path then
      local python_executable = debugpy_path .. '/venv/bin/python'
      if vim.fn.has 'win32' == 1 then
        python_executable = debugpy_path .. '\\venv\\Scripts\\python.exe'
      end
      dap.adapters.python = {
        type = 'executable',
        command = python_executable,
        args = { '-m', 'debugpy.adapter' },
      }
      extend('python', {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          pythonPath = function()
            local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
            if venv and venv ~= '' then
              if vim.fn.has 'win32' == 1 then
                return venv .. '\\Scripts\\python.exe'
              else
                return venv .. '/bin/python'
              end
            end
            return vim.fn.exepath 'python3' or 'python3'
          end,
        },
      })
    end

    local js_debug_path = mason_package_path 'js-debug-adapter'
    if js_debug_path and vim.fn.executable 'node' == 1 then
      local debugger_path = js_debug_path .. '/js-debug/src/dapDebugServer.js'
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = '127.0.0.1',
        port = '${port}',
        executable = {
          command = 'node',
          args = { debugger_path, '${port}' },
        },
      }

      local js_languages = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte' }
      for _, language in ipairs(js_languages) do
        extend(language, {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
            runtimeExecutable = 'node',
            sourceMaps = true,
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach to process',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
        })
      end
    end

    -- Install golang specific config
    -- require('dap-go').setup {
    -- delve = {
    -- On Windows delve must be run attached or it crashes.
    -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    -- detached = vim.fn.has 'win32' == 0,
    -- },
    -- }
  end,
}
