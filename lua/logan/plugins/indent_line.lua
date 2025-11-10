local rainbow_highlights = {
  'RainbowDelimiterRed',
  'RainbowDelimiterYellow',
  'RainbowDelimiterBlue',
  'RainbowDelimiterOrange',
  'RainbowDelimiterGreen',
  'RainbowDelimiterViolet',
  'RainbowDelimiterCyan',
}

return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    dependencies = { 'HiPhish/rainbow-delimiters.nvim' },
    opts = function()
      local hooks = require 'ibl.hooks'

      -- Borrow rainbow-delimiter extmarks to color scopes so the guides
      -- and delimiter highlights always stay in sync.
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        for _, name in ipairs(rainbow_highlights) do
          local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
          if ok then
            hl.nocombine = true
            vim.api.nvim_set_hl(0, name, hl)
          end
        end
      end)

      return {
        indent = {
          char = '▏',
          highlight = 'IblIndent',
        },
        scope = {
          enabled = true,
          show_start = false,
          show_end = false,
          highlight = rainbow_highlights,
        },
        whitespace = {
          remove_blankline_trail = true,
        },
      }
    end,
  },
}
