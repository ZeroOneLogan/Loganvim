return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      local animate = require 'mini.animate'
      animate.setup {
        cursor = { enable = false },
        scroll = { enable = false },
        resize = { enable = false },
        open = { enable = false },
        close = { enable = false },
      }

      require('mini.splitjoin').setup {
        mappings = {
          toggle = 'gs',
        },
      }

      require('mini.trailspace').setup()
      local trailspace_group = vim.api.nvim_create_augroup('LoganTrailspace', { clear = true })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = trailspace_group,
        callback = function()
          if vim.bo.filetype == 'markdown' or vim.bo.filetype == 'gitcommit' then
            return
          end
          if vim.bo.modifiable and not vim.bo.readonly then
            require('mini.trailspace').trim()
          end
        end,
      })

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      -- local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      -- statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      -- return '%2l:%-2v'
      -- end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
