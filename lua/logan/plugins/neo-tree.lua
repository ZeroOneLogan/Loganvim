return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    hijack_netrw_behavior = 'open_current',
    source_selector = {
      winbar = true,
      statusline = false,
      sources = {
        { source = 'filesystem', display_name = ' Files' },
        { source = 'buffers', display_name = ' Buffers' },
        { source = 'git_status', display_name = ' Git' },
      },
    },
    default_component_configs = {
      indent = {
        with_markers = true,
        with_expanders = true,
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '󰜌',
      },
      git_status = {
        symbols = {
          added = '',
          deleted = '',
          modified = '',
          renamed = '',
          untracked = '',
          ignored = '',
          unstaged = '󰄱',
          staged = '',
          conflict = '',
        },
      },
    },
    filesystem = {
      bind_to_cwd = true,
      cwd_target = {
        sidebar = 'global',
        current = 'window',
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { '.DS_Store', 'thumbs.db' },
        never_show = { '.git', '.venv' },
      },
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ['P'] = {
            'toggle_preview',
            config = {
              use_float = false,
            },
          },
          ['\\'] = 'close_window',
        },
      },
    },
    event_handlers = {
      {
        event = 'file_opened',
        handler = function()
          require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },
  },
}
