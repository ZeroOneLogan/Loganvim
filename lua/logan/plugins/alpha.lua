-- alpha.lua --
-- Beautiful Dashboard for LoganVim
-- Modern, informative, and visually stunning

return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Header Art                         │
    --  ╰──────────────────────────────────────────────────────────╯

    local headers = {
      {
        [[                                                                     ]],
        [[       ████ ██████           █████      ██                     ]],
        [[      ███████████             █████                             ]],
        [[      █████████ ███████████████████ ███   ███████████   ]],
        [[     █████████  ███    █████████████ █████ ██████████████   ]],
        [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
        [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
        [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
        [[                                                                       ]],
      },
      {
        [[                                                    ]],
        [[ ██╗      ██████╗  ██████╗  █████╗ ███╗   ██╗]],
        [[ ██║     ██╔═══██╗██╔════╝ ██╔══██╗████╗  ██║]],
        [[ ██║     ██║   ██║██║  ███╗███████║██╔██╗ ██║]],
        [[ ██║     ██║   ██║██║   ██║██╔══██║██║╚██╗██║]],
        [[ ███████╗╚██████╔╝╚██████╔╝██║  ██║██║ ╚████║]],
        [[ ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝]],
        [[          ██╗   ██╗██╗███╗   ███╗            ]],
        [[          ██║   ██║██║████╗ ████║            ]],
        [[          ██║   ██║██║██╔████╔██║            ]],
        [[          ╚██╗ ██╔╝██║██║╚██╔╝██║            ]],
        [[           ╚████╔╝ ██║██║ ╚═╝ ██║            ]],
        [[            ╚═══╝  ╚═╝╚═╝     ╚═╝            ]],
        [[                                                    ]],
      },
      {
        [[                                   ]],
        [[   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ]],
        [[    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠶⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿          ]],
        [[          ⠉⠶⣔⣚⣤⣭⣥⣯⣦⣭⣶⣾⣿⣿⣿⣿⣿⣿⣿          ]],
        [[             ⠈⠻⢿⣾⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿          ]],
        [[                 ⠈⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿          ]],
        [[    ⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠀⢸⣿⣿⣿⣿          ]],
        [[    ⢻⣷⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⢀⣴⣿⣿⣿⣿⣿          ]],
        [[     ⠈⢿⣧⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣴⣾⣿⣿⣿⣿⣿⣿          ]],
        [[      ⠀⠙⣿⣿⣿⣿⣶⣶⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿          ]],
        [[        ⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿          ]],
        [[           ⠀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿          ]],
        [[                                   ]],
      },
      {
        [[                               ]],
        [[  ▄▄▄       ██▓███   ██▓  ]],
        [[ ▒████▄    ▓██░  ██▒▓██▒  ]],
        [[ ▒██  ▀█▄  ▓██░ ██▓▒▒██▒  ]],
        [[ ░██▄▄▄▄██ ▒██▄█▓▒ ▒░██░  ]],
        [[  ▓█   ▓██▒▒██▒ ░  ░░██░  ]],
        [[  ▒▒   ▓▒█░▒▓▒░ ░  ░░▓    ]],
        [[   ▒   ▒▒ ░░▒ ░      ▒ ░  ]],
        [[   ░   ▒   ░░        ▒ ░  ]],
        [[       ░  ░          ░    ]],
        [[                               ]],
      },
    }

    -- Select random header
    math.randomseed(vim.uv.hrtime() % 1e9)
    dashboard.section.header.val = headers[math.random(#headers)]
    dashboard.section.header.opts.hl = 'AlphaHeader'

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Buttons                            │
    --  ╰──────────────────────────────────────────────────────────╯

    local button = function(key, icon, label, action)
      local btn = dashboard.button(key, icon .. '  ' .. label, action)
      btn.opts.hl = 'AlphaButtons'
      btn.opts.hl_shortcut = 'AlphaShortcut'
      return btn
    end

    dashboard.section.buttons.val = {
      button('f', '', 'Find file', ':Telescope find_files<CR>'),
      button('n', '', 'New file', ':ene <BAR> startinsert<CR>'),
      button('r', '', 'Recent files', ':Telescope oldfiles<CR>'),
      button('g', '󰱼', 'Find text', ':Telescope live_grep<CR>'),
      button('p', '', 'Projects', ':Telescope projects<CR>'),
      button('s', '', 'Restore session', ':lua require("persistence").load()<CR>'),
      button('c', '', 'Configuration', ':e $MYVIMRC<CR>'),
      button('l', '󰒲', 'Lazy plugins', ':Lazy<CR>'),
      button('m', '', 'Mason', ':Mason<CR>'),
      button('h', '󰋠', 'Health check', ':checkhealth<CR>'),
      button('q', '', 'Quit', ':qa<CR>'),
    }

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Footer                             │
    --  ╰──────────────────────────────────────────────────────────╯

    local function footer()
      local stats = require('lazy').stats()
      local v = vim.version()
      local datetime = os.date(' %A, %B %d')

      -- Random quotes
      local quotes = {
        { 'Discipline unlocks flow.', 'Drew Logan' },
        { 'Elegance is deliberate.', 'Naoto Fukasawa' },
        { 'Less noise. More signal.', 'Unknown' },
        { 'Code boldly. Refactor softly.', 'LoganVim' },
        { 'Simplicity is the ultimate sophistication.', 'Leonardo da Vinci' },
        { 'First, solve the problem. Then, write the code.', 'John Johnson' },
        { 'Make it work, make it right, make it fast.', 'Kent Beck' },
        { 'Any fool can write code that a computer can understand.', 'Martin Fowler' },
        { 'The best error message is the one that never shows up.', 'Thomas Fuchs' },
        { 'Talk is cheap. Show me the code.', 'Linus Torvalds' },
      }
      local quote = quotes[math.random(#quotes)]

      return {
        '',
        string.format('  %d plugins in %.1fms', stats.loaded, stats.startuptime),
        '',
        string.format('  v%d.%d.%d  󰙴 LoganVim v%s', v.major, v.minor, v.patch, vim.g.loganvim_version or '2.0'),
        datetime,
        '',
        string.format('"%s"', quote[1]),
        string.format('— %s', quote[2]),
      }
    end

    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = 'AlphaFooter'

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Layout                             │
    --  ╰──────────────────────────────────────────────────────────╯

    dashboard.section.buttons.opts.spacing = 1

    dashboard.config.layout = {
      { type = 'padding', val = 2 },
      dashboard.section.header,
      { type = 'padding', val = 2 },
      dashboard.section.buttons,
      { type = 'padding', val = 1 },
      dashboard.section.footer,
    }

    dashboard.config.opts.noautocmd = true

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                      Highlights                          │
    --  ╰──────────────────────────────────────────────────────────╯

    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      once = true,
      callback = function()
        dashboard.section.footer.val = footer()
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    alpha.setup(dashboard.config)

    -- Disable folding on alpha buffer
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'alpha',
      callback = function()
        vim.opt_local.foldenable = false
        vim.opt_local.cursorline = false
      end,
    })
  end,
}
