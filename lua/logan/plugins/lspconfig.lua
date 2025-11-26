-- lspconfig.lua --
-- Ultimate LSP Configuration for Neovim 0.11.5
-- Optimized for performance and feature completeness

return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                    Lazydev for Lua                       │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'lazy.nvim', words = { 'LazyVim' } },
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                  Main LSP Configuration                  │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    dependencies = {
      { 'mason-org/mason.nvim', opts = { ui = { border = 'rounded' } } },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0 } } } },
      'saghen/blink.cmp',
      'b0o/schemastore.nvim',
    },
    config = function()
      --  ╭────────────────────────────────────────────────────────╮
      --  │                    LSP Attach Handler                  │
      --  ╰────────────────────────────────────────────────────────╯

      local navic_ok, navic = pcall(require, 'nvim-navic')

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('loganvim-lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then return end

          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Navigation
          map('gd', function() require('telescope.builtin').lsp_definitions() end, 'Goto Definition')
          map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
          map('gr', function() require('telescope.builtin').lsp_references() end, 'Goto References')
          map('gI', function() require('telescope.builtin').lsp_implementations() end, 'Goto Implementation')
          map('gy', function() require('telescope.builtin').lsp_type_definitions() end, 'Goto Type Definition')

          -- Symbols
          map('<leader>ss', function() require('telescope.builtin').lsp_document_symbols() end, 'Document Symbols')
          map('<leader>sS', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, 'Workspace Symbols')

          -- Code Actions
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
          map('<leader>cA', function()
            vim.lsp.buf.code_action({ context = { only = { 'source' }, diagnostics = {} } })
          end, 'Source Action')

          -- Hover & Signature
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gK', vim.lsp.buf.signature_help, 'Signature Help')
          map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help', 'i')

          -- Workspace
          map('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder')
          map('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder')
          map('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, 'List Workspace Folders')

          -- Inlay hints (Neovim 0.10+)
          if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, 'Toggle Inlay Hints')

            -- Enable inlay hints by default for certain file types
            local inlay_hint_filetypes = { 'rust', 'go', 'typescript', 'typescriptreact' }
            if vim.tbl_contains(inlay_hint_filetypes, vim.bo[event.buf].filetype) then
              vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
            end
          end

          -- Document highlight
          if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('loganvim-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('loganvim-lsp-detach', { clear = true }),
              callback = function(ev)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = 'loganvim-lsp-highlight', buffer = ev.buf })
              end,
            })
          end

          -- Code lens
          if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
            map('<leader>cl', vim.lsp.codelens.run, 'Run Code Lens')
            map('<leader>cL', vim.lsp.codelens.refresh, 'Refresh Code Lens')
          end

          -- Navic breadcrumbs
          if navic_ok and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol) then
            navic.attach(client, event.buf)
          end
        end,
      })

      --  ╭────────────────────────────────────────────────────────╮
      --  │                  Diagnostic Config                     │
      --  ╰────────────────────────────────────────────────────────╯

      vim.diagnostic.config({
        severity_sort = true,
        update_in_insert = false,
        float = {
          focusable = true,
          style = 'minimal',
          border = 'rounded',
          source = true,
          header = '',
          prefix = '',
        },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          spacing = 4,
          source = 'if_many',
          prefix = function(diagnostic)
            local icons = { '󰅚', '󰀪', '󰋽', '󰌶' }
            return icons[diagnostic.severity] or '●'
          end,
        },
        virtual_lines = false, -- Enable for inline diagnostics
      })

      --  ╭────────────────────────────────────────────────────────╮
      --  │                    UI Customization                    │
      --  ╰────────────────────────────────────────────────────────╯

      -- Rounded borders for LSP windows
      local border = 'rounded'
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

      --  ╭────────────────────────────────────────────────────────╮
      --  │                    Capabilities                        │
      --  ╰────────────────────────────────────────────────────────╯

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable folding support for nvim-ufo
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local function disable_formatting(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end

      --  ╭────────────────────────────────────────────────────────╮
      --  │                  Server Configurations                 │
      --  ╰────────────────────────────────────────────────────────╯

      local schemastore_ok, schemastore = pcall(require, 'schemastore')

      local servers = {
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              codeLens = { enable = true },
              completion = { callSnippet = 'Replace' },
              diagnostics = { disable = { 'missing-fields' } },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = 'Disable',
                semicolon = 'Disable',
                arrayIndex = 'Disable',
              },
            },
          },
        },

        -- TypeScript/JavaScript
        ts_ls = {
          on_attach = disable_formatting,
          settings = {
            typescript = {
              format = { enable = false },
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              format = { enable = false },
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            completions = { completeFunctionCalls = true },
          },
        },

        -- Web
        html = {},
        cssls = {},
        tailwindcss = {},
        svelte = {},
        astro = {},
        emmet_ls = {},

        -- JSON/YAML
        jsonls = schemastore_ok and {
          settings = {
            json = {
              schemas = schemastore.json.schemas(),
              validate = { enable = true },
            },
          },
        } or {},
        yamlls = schemastore_ok and {
          settings = {
            yaml = {
              schemaStore = { enable = false, url = '' },
              schemas = schemastore.yaml.schemas(),
            },
          },
        } or {},

        -- Python
        pyright = {
          settings = {
            pyright = { autoImportCompletion = true },
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'openFilesOnly',
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'basic',
              },
            },
          },
        },
        ruff = {},

        -- Go
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { '-.git', '-.vscode', '-.idea', '-.venv', '-node_modules' },
              semanticTokens = true,
            },
          },
        },

        -- Rust (rust-analyzer)
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              checkOnSave = {
                allFeatures = true,
                command = 'clippy',
                extraArgs = { '--no-deps' },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ['async-trait'] = { 'async_trait' },
                  ['napi-derive'] = { 'napi' },
                  ['async-recursion'] = { 'async_recursion' },
                },
              },
              inlayHints = {
                bindingModeHints = { enable = false },
                chainingHints = { enable = true },
                closingBraceHints = { enable = true, minLines = 25 },
                closureReturnTypeHints = { enable = 'never' },
                lifetimeElisionHints = { enable = 'never', useParameterNames = false },
                maxLength = 25,
                parameterHints = { enable = true },
                reborrowHints = { enable = 'never' },
                renderColons = true,
                typeHints = {
                  enable = true,
                  hideClosureInitialization = false,
                  hideNamedConstructor = false,
                },
              },
            },
          },
        },

        -- C/C++
        clangd = {
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
            '--header-insertion=iwyu',
          },
          init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticHighlighting = true,
          },
          on_attach = disable_formatting,
          capabilities = { offsetEncoding = { 'utf-16' } },
        },

        -- Bash
        bashls = {},

        -- Docker
        dockerls = {},
        docker_compose_language_service = {},

        -- SQL
        sqlls = {},

        -- GraphQL
        graphql = {},

        -- Prisma
        prismals = {},

        -- TOML
        taplo = {},

        -- Markdown
        marksman = {},
      }

      --  ╭────────────────────────────────────────────────────────╮
      --  │                    Tool Installation                   │
      --  ╰────────────────────────────────────────────────────────╯

      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, {
        -- Formatters
        'stylua',
        'prettierd',
        'prettier',
        'shfmt',
        'clang-format',

        -- Linters
        'ruff',
        'eslint_d',
        'markdownlint-cli2',
        'shellcheck',

        -- DAP
        'codelldb',
        'debugpy',
        'js-debug-adapter',

        -- Other tools
        'taplo',
      })

      require('mason-tool-installer').setup({
        ensure_installed = ensure_installed,
        auto_update = false,
        run_on_start = true,
      })

      require('mason-lspconfig').setup({
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
