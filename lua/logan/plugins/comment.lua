return {
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    dependencies = {
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = { enable_autocmd = false },
        config = function(_, opts)
          require('ts_context_commentstring').setup(opts)
        end,
      },
    },
    opts = function()
      local ok, integration = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
      return {
        padding = true,
        ignore = '^$',
        ---@diagnostic disable-next-line: assign-type-mismatch
        pre_hook = ok and integration and integration.create_pre_hook() or nil,
      }
    end,
    config = function(_, opts)
      require('Comment').setup(opts)

      -- fine tune uncommon filetypes
      local ft = require 'Comment.ft'
      ft.set('svelte', { '<!--%s-->' })
      ft.set('graphql', { '# %s' })
    end,
  },
}
