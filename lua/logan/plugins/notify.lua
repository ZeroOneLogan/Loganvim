return {
  'rcarriga/nvim-notify',
  opts = {
    stages = 'static',
    timeout = 2000,
    render = 'wrapped-compact',
    top_down = false,
    background_colour = '#000000',
  },
  config = function(_, opts)
    local notify = require 'notify'
    notify.setup(opts)
    vim.notify = notify
  end,
}
