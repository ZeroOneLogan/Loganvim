-- Diagnostics config --
return {
    -- tiny inline diagnostic plugin
    {
        'rachartier/tiny-inline-diagnostic.nvim',
        event = 'VeryLazy', -- adjust depending on lazy loading scheme
        priority = 1000,
        config = function()
            -- disable built in virtual text to avoid duplicate inline text
            vim.diagnostic.config { virtual_text = false }

            require('tiny-inline-diagnostic').setup {
                preset = 'modern', -- modern, classic, minimal, powerline, simple, nonerdfont, ghost, or amongus
                transparent_bg = false,
                transparent_cursorline = true,
                hi = {
                    error = 'DiagnosticError',
                    warn = 'DiagnosticWarn',
                    info = 'DiagnosticInfo',
                    hint = 'DiagnosticHint',
                    arrow = 'NonText',
                    background = 'CursorLine',
                    mixing_color = 'Normal',
                },
                options = {
                    show_source = { enabled = false, if_many = false },
                    use_icons_from_diagnostic = false,
                    set_arrow_to_diag_color = false,
                    add_messages = {
                        messages = true,
                        display_count = false,
                        use_max_severity = false,
                        show_multiple_glyphs = true,
                    },
                    throttle = 20,
                    softwrap = 30,
                    multilines = { enabled = false, always_show = false, trim_whitespaces = false, tabstop = 4 },
                    show_all_diags_on_cursorline = false,
                    enable_on_insert = false,
                    enable_on_select = false,
                    overflow = { mode = 'wrap', padding = 0 },
                    break_line = { enabled = false, after = 30 },
                    format = nil,
                    virt_texts = { priority = 2048 },
                    severity = {
                        vim.diagnostic.severity.ERROR,
                        vim.diagnostic.severity.WARN,
                        vim.diagnostic.severity.INFO,
                        vim.diagnostic.severity.HINT,
                    },
                    overwrite_events = nil,
                    override_open_float = false,
                },
            }
        end,
    },

    -- trouble.nvim plugin --
    {
        'folke/trouble.nvim',
        cmd = { 'Trouble', 'TroubleToggle' },
        keys = {
            { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
            { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
            -- more keys may be added here
        },
        config = function()
            require('trouble').setup {
                -- custom options here or leave empty for default settings
                auto_open = false,
                auto_close = true,
                use_lsp_diagnostic_signs = true,
                -- can also configure window layout, mode, etc:
                -- height = 10,
                -- mode = 'workspace_diagnostics',
            }
        end,
    },
}
