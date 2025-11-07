vim.env.SNACKS_GHOSTTY = 'true'
vim.env.SNACKS_KITTY = 'true'
vim.env.SNACKS_TMUX = 'true'

return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    image = { enabled = true, backend = 'kitty', tmux = vim.env.TMUX ~= nil, integrations = { markdown = { enabled = true } } },
    notifier = { enabled = false },
    picker = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
  },
}
