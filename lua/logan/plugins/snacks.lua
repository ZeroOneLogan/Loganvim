local term = (vim.env.TERM or ''):lower()
local term_program = (vim.env.TERM_PROGRAM or ''):lower()
local has_kitty = term:find 'kitty' ~= nil
local has_ghostty = term_program == 'ghostty'

if has_ghostty then
  vim.env.SNACKS_GHOSTTY = 'true'
end

if has_kitty then
  vim.env.SNACKS_KITTY = 'true'
end

if vim.env.TMUX then
  vim.env.SNACKS_TMUX = 'true'
end

return {
  'folke/snacks.nvim',
  event = 'VeryLazy',
  opts = {
    image = {
      enabled = has_kitty or has_ghostty,
      backend = 'kitty',
      tmux = vim.env.TMUX ~= nil,
      integrations = { markdown = { enabled = true } },
    },
    notifier = { enabled = false },
    picker = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
  },
}
