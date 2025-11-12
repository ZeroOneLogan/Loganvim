-- git interface --
return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional: nice diff view
    },
    cmd = 'Neogit',
    keys = {
      {
        '<leader>gg',
        function()
          require('neogit').open()
        end,
        desc = 'Open Neogit',
      },
    },
    config = function()
      local neogit = require 'neogit'
      neogit.setup {
        disable_commit_confirmation = true,
        integrations = {
          diffview = true, -- enable if diffview installed
        },
        signs = {
          -- { CLOSED, OPENED }
          section = { '', '' },
          item = { '', '' },
          hunk = { '', '' },
        },
      }
    end,
  },
}
