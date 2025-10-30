-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',

        -- Optional
        {
            's1n7ax/nvim-window-picker',
            config = function()
                require('window-picker').setup {
                    autoselect_one = true,
                    include_current = false,
                    filter_rules = {
                        bo = {
                            filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
                            buftype = { 'terminal', 'quickfix' },
                        },
                    },
                }
            end,
        },
        { 'antosha417/nvim-lsp-file-operations' },
    },
    lazy = false,
    keys = {
        { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    opts = {
        close_if_last_window = true,
        popup_border_style = 'rounded',
        sources = { 'filesystem', 'buffers', 'git_status' },
        filesystem = {
            bind_to_cwd = true,
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
            filtered_items = {
                visible = false,
                hide_dotfiles = true,
                hide_gitignored = true,
            },
            window = {
                mappings = {
                    ['\\'] = 'close_window',

                    ['<cr>'] = 'open_with_window_picker',
                    ['l'] = 'open_with_window_picker',
                    ['h'] = 'close_node',

                    ['P'] = 'toggle_preview',
                },
            },
        },

        default_component_configs = {
            indent = { with_markers = true },
            git_status = {
                symbols = {
                    added = '',
                    modified = '',
                    deleted = '',
                    renamed = '',
                    untracked = '★',
                    ignored = '◌',
                    unstaged = '✗',
                    staged = '✓',
                    conflict = '',
                },
            },
        },
    },

    config = function(_, opts)
        require('neo-tree').setup(opts)

        pcall(function()
            require('lsp-file-operations').setup()
        end)

        vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = 'Explorer (Neo-tree)' })
    end,
}
