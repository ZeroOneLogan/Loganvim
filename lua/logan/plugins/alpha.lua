return {
  -- Dashboard to greet
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      math.randomseed(vim.uv.hrtime() % 1e9)
      local quotes = {
        { 'Discipline unlocks flow.', 'Drew Logan' },
        { 'Elegance is deliberate.', 'Naoto Fukasawa' },
        { 'Less noise. More signal.', 'Unknown' },
        { 'Code boldly. Refactor softly.', 'LoganVim' },
      }
      local quote = quotes[math.random(#quotes)]

      -- Set header
      dashboard.section.header.val = {
        '██╗      ██████╗  ██████╗  █████╗ ███╗   ██╗██╗   ██╗██╗███╗   ███╗',
        '██║     ██╔═══██╗██╔════╝ ██╔══██╗████╗  ██║██║   ██║██║████╗ ████║',
        '██║     ██║   ██║██║  ███╗███████║██╔██╗ ██║██║   ██║██║██╔████╔██║',
        '██║     ██║   ██║██║   ██║██╔══██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║',
        '███████╗╚██████╔╝╚██████╔╝██║  ██║██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║',
        '╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝',
        '',
        '    🌀 Welcome to LOGANVIM — Code. Flow. Dominate. 🌀',
        '',
      }

      -- Set menu
      dashboard.section.buttons.val = {
        dashboard.button('e', '  > New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('f', '󰈞  > Find file', ':Telescope find_files<CR>'),
        dashboard.button('r', '  > Recent', ':Telescope oldfiles<CR>'),
        dashboard.button('p', '  > Restore session', ':lua require("persistence").load()<CR>'),
        dashboard.button('s', '  > Settings', ':e $MYVIMRC | :cd %:p:h<cr>'),
        dashboard.button('q', '󰅚  > Quit NVIM', ':qa<CR>'),
      }

      -- Footer
      local stats = require('lazy').stats()
      local v = vim.version()
      local stats_line =
        string.format('  %d plugins in %.0fms  •  NVIM %d.%d.%d  •  %s', stats.count, stats.startuptime, v.major, v.minor, v.patch, os.date '%A %b %d')
      dashboard.section.footer.val = {
        stats_line,
        string.format('“%s” — %s', quote[1], quote[2]),
      }
      dashboard.section.footer.opts.hl = 'Comment'

      -- Send config to alpha
      alpha.setup(dashboard.config)
    end,
  },
}
