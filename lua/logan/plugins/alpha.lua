return {
    -- Dashboard to greet
    {
        'goolord/alpha-nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local alpha = require 'alpha'
            local dashboard = require 'alpha.themes.dashboard'

            -- Set header
            dashboard.section.header.val = {

                '██╗      ██████╗  ██████╗  █████╗ ███╗   ██╗██╗   ██╗██╗███╗   ███╗',
                '██║     ██╔═══██╗██╔════╝ ██╔══██╗████╗  ██║██║   ██║██║████╗ ████║',
                '██║     ██║   ██║██║  ███╗███████║██╔██╗ ██║██║   ██║██║██╔████╔██║',
                '██║     ██║   ██║██║   ██║██╔══██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║',
                '███████╗╚██████╔╝╚██████╔╝██║  ██║██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║',
                '╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝',
                '',
                '               🌀 Welcome to LOGANVIM — Code. Flow. Dominate. 🌀',
                '',
            }

            -- Set menu
            dashboard.section.buttons.val = {
                dashboard.button('e', '  > New file', ':ene <BAR> startinsert <CR>'),
                dashboard.button('f', '󰈞  > Find file', ':Telescope find_files<CR>'),
                dashboard.button('r', '  > Recent', ':Telescope oldfiles<CR>'),
                dashboard.button('s', '  > Settings', ':e $MYVIMRC | :cd %:p:h<cr>'),
                dashboard.button('q', '󰅚  > Quit NVIM', ':qa<CR>'),
            }

            -- Send config to alpha
            alpha.setup(dashboard.config)
        end,
    },
}
