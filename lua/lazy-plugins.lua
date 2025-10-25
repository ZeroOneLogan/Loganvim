-- lazy-plugins.lua --
-- [[ Configure and install plugins ]]
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
    -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
    'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

    -- NOTE: Plugins can also be added by using a table,
    -- with the first argument being the link and the following
    -- keys can be used to configure plugin behavior/loading/etc.
    --
    -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
    --

    -- using `require 'path.name'` will
    -- include a plugin definition from file lua/path/name.lua

    require 'logan.plugins.gitsigns',

    require 'logan.plugins.which-key',

    require 'logan.plugins.telescope',

    require 'logan.plugins.lspconfig',

    require 'logan.plugins.conform',

    require 'logan.plugins.blink-cmp',

    require 'logan.plugins.colorthemes',

    require 'logan.plugins.todo-comments',

    require 'logan.plugins.mini',

    require 'logan.plugins.treesitter',

    require 'logan.plugins.debug',

    require 'logan.plugins.indent_line',

    require 'logan.plugins.lint',

    require 'logan.plugins.autopairs',

    require 'logan.plugins.neo-tree',

    require 'logan.plugins.alpha',

    require 'logan.plugins.bufferline',

    require 'logan.plugins.lualine',

    require 'logan.plugins.diagnostics',

    require 'logan.plugins.neogit',
}, {
    ui = {
        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
})
-- vim: ts=2 sts=2 sw=2 et
