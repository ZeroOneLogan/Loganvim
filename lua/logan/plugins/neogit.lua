-- neogit.lua --
-- Magit-like git interface for Neovim
-- Beautiful and powerful git workflow

return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Neogit',
    keys = {
      {
        '<leader>gg',
        function()
          require('neogit').open()
        end,
        desc = 'Neogit status',
      },
      {
        '<leader>gG',
        function()
          require('neogit').open({ kind = 'split' })
        end,
        desc = 'Neogit status (split)',
      },
      {
        '<leader>gl',
        function()
          require('neogit').open({ 'log' })
        end,
        desc = 'Neogit log',
      },
      {
        '<leader>gc',
        function()
          require('neogit').open({ 'commit' })
        end,
        desc = 'Neogit commit',
      },
      {
        '<leader>gp',
        function()
          require('neogit').open({ 'push' })
        end,
        desc = 'Neogit push',
      },
      {
        '<leader>gP',
        function()
          require('neogit').open({ 'pull' })
        end,
        desc = 'Neogit pull',
      },
    },
    opts = {
      disable_hint = false,
      disable_context_highlighting = false,
      disable_signs = false,
      disable_commit_confirmation = true,
      disable_builtin_notifications = false,
      disable_insert_on_commit = 'auto',

      filewatcher = {
        interval = 1000,
        enabled = true,
      },

      graph_style = 'unicode',

      git_services = {
        ['github.com'] = 'https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1',
        ['gitlab.com'] = 'https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}',
      },

      telescope_sorter = function()
        return require('telescope').extensions.fzf.native_fzf_sorter()
      end,

      use_per_project_settings = true,
      remember_settings = true,
      auto_refresh = true,
      sort_branches = '-committerdate',
      kind = 'tab',

      console_timeout = 2000,
      auto_show_console = true,
      notification_icon = '󰊢',
      status = {
        recent_commit_count = 10,
      },

      commit_editor = {
        kind = 'split',
      },
      commit_select_view = {
        kind = 'tab',
      },
      commit_view = {
        kind = 'vsplit',
        verify_commit = vim.fn.executable('gpg') == 1,
      },
      log_view = {
        kind = 'tab',
      },
      rebase_editor = {
        kind = 'split',
      },
      reflog_view = {
        kind = 'tab',
      },
      merge_editor = {
        kind = 'split',
      },
      tag_editor = {
        kind = 'split',
      },
      preview_buffer = {
        kind = 'split',
      },
      popup = {
        kind = 'split',
      },
      refs_view = {
        kind = 'tab',
      },

      signs = {
        hunk = { '', '' },
        item = { '', '' },
        section = { '', '' },
      },

      integrations = {
        telescope = true,
        diffview = true,
        fzf_lua = false,
      },

      sections = {
        sequencer = {
          folded = false,
          hidden = false,
        },
        untracked = {
          folded = false,
          hidden = false,
        },
        unstaged = {
          folded = false,
          hidden = false,
        },
        staged = {
          folded = false,
          hidden = false,
        },
        stashes = {
          folded = true,
          hidden = false,
        },
        unpulled_upstream = {
          folded = true,
          hidden = false,
        },
        unmerged_upstream = {
          folded = false,
          hidden = false,
        },
        unpulled_pushRemote = {
          folded = true,
          hidden = false,
        },
        unmerged_pushRemote = {
          folded = false,
          hidden = false,
        },
        recent = {
          folded = true,
          hidden = false,
        },
        rebase = {
          folded = true,
          hidden = false,
        },
      },

      mappings = {
        commit_editor = {
          ['q'] = 'Close',
          ['<c-c><c-c>'] = 'Submit',
          ['<c-c><c-k>'] = 'Abort',
        },
        rebase_editor = {
          ['p'] = 'Pick',
          ['r'] = 'Reword',
          ['e'] = 'Edit',
          ['s'] = 'Squash',
          ['f'] = 'Fixup',
          ['x'] = 'Execute',
          ['d'] = 'Drop',
          ['b'] = 'Break',
          ['q'] = 'Close',
          ['<cr>'] = 'OpenCommit',
          ['gk'] = 'MoveUp',
          ['gj'] = 'MoveDown',
          ['<c-c><c-c>'] = 'Submit',
          ['<c-c><c-k>'] = 'Abort',
        },
        finder = {
          ['<cr>'] = 'Select',
          ['<c-c>'] = 'Close',
          ['<esc>'] = 'Close',
          ['<c-n>'] = 'Next',
          ['<c-p>'] = 'Previous',
          ['<down>'] = 'Next',
          ['<up>'] = 'Previous',
          ['<tab>'] = 'MultiselectToggleNext',
          ['<s-tab>'] = 'MultiselectTogglePrevious',
          ['<c-j>'] = 'NOP',
        },
        popup = {
          ['?'] = 'HelpPopup',
          ['A'] = 'CherryPickPopup',
          ['D'] = 'DiffPopup',
          ['M'] = 'RemotePopup',
          ['P'] = 'PushPopup',
          ['X'] = 'ResetPopup',
          ['Z'] = 'StashPopup',
          ['b'] = 'BranchPopup',
          ['c'] = 'CommitPopup',
          ['f'] = 'FetchPopup',
          ['l'] = 'LogPopup',
          ['m'] = 'MergePopup',
          ['p'] = 'PullPopup',
          ['r'] = 'RebasePopup',
          ['v'] = 'RevertPopup',
          ['w'] = 'WorktreePopup',
        },
        status = {
          ['q'] = 'Close',
          ['I'] = 'InitRepo',
          ['1'] = 'Depth1',
          ['2'] = 'Depth2',
          ['3'] = 'Depth3',
          ['4'] = 'Depth4',
          ['<tab>'] = 'Toggle',
          ['x'] = 'Discard',
          ['s'] = 'Stage',
          ['S'] = 'StageUnstaged',
          ['<c-s>'] = 'StageAll',
          ['u'] = 'Unstage',
          ['U'] = 'UnstageStaged',
          ['$'] = 'CommandHistory',
          ['#'] = 'Console',
          ['Y'] = 'YankSelected',
          ['<c-r>'] = 'RefreshBuffer',
          ['<enter>'] = 'GoToFile',
          ['<c-v>'] = 'VSplitOpen',
          ['<c-x>'] = 'SplitOpen',
          ['<c-t>'] = 'TabOpen',
          ['{'] = 'GoToPreviousHunkHeader',
          ['}'] = 'GoToNextHunkHeader',
        },
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                      Diffview                            │
  --  ╰──────────────────────────────────────────────────────────╯

  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = 'Diff view' },
      { '<leader>gf', '<cmd>DiffviewFileHistory %<CR>', desc = 'File history' },
      { '<leader>gF', '<cmd>DiffviewFileHistory<CR>', desc = 'Branch history' },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = 'diff2_horizontal',
        },
        merge_tool = {
          layout = 'diff3_mixed',
          disable_diagnostics = true,
        },
        file_history = {
          layout = 'diff2_horizontal',
        },
      },
      file_panel = {
        listing_style = 'tree',
        tree_options = {
          flatten_dirs = true,
          folder_statuses = 'only_folded',
        },
        win_config = {
          position = 'left',
          width = 35,
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = 'combined',
            },
            multi_file = {
              diff_merges = 'first-parent',
            },
          },
        },
        win_config = {
          position = 'bottom',
          height = 16,
        },
      },
      commit_log_panel = {
        win_config = {},
      },
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      hooks = {},
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
