return {
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    opts = function()
      local ok, themes = pcall(require, 'telescope.themes')
      return {
        input = {
          border = 'rounded',
          win_options = { winblend = 0 },
          get_config = function()
            if vim.api.nvim_buf_get_option(0, 'filetype') == 'neo-tree' then
              return { enabled = false }
            end
          end,
        },
        select = {
          backend = { 'telescope', 'builtin' },
          telescope = ok and themes.get_cursor() or nil,
          builtin = {
            border = 'rounded',
            relative = 'editor',
          },
        },
      }
    end,
  },
}
