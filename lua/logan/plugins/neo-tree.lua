-- neo-tree.lua --
-- File explorer for Neovim
-- Beautiful and feature-rich file browser

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    's1n7ax/nvim-window-picker',
  },
  cmd = 'Neotree',
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    -- Load neo-tree when opening a directory
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('NeoTreeInit', { clear = true }),
      callback = function()
        local f = vim.fn.expand('%:p')
        if vim.fn.isdirectory(f) ~= 0 then
          vim.cmd('Neotree current dir=' .. f)
          vim.api.nvim_clear_autocmds({ group = 'NeoTreeInit' })
        end
      end,
    })
  end,
  keys = {
    {
      '\\',
      function()
        require('neo-tree.command').execute({
          toggle = true,
          source = 'filesystem',
          position = 'left',
        })
      end,
      desc = 'Explorer (root dir)',
    },
    {
      '<leader>e',
      function()
        require('neo-tree.command').execute({
          toggle = true,
          source = 'filesystem',
          position = 'left',
        })
      end,
      desc = 'Explorer (root dir)',
    },
    {
      '<leader>E',
      function()
        require('neo-tree.command').execute({
          toggle = true,
          source = 'filesystem',
          position = 'float',
        })
      end,
      desc = 'Explorer Float',
    },
    {
      '<leader>ge',
      function()
        require('neo-tree.command').execute({
          source = 'git_status',
          toggle = true,
        })
      end,
      desc = 'Git Explorer',
    },
    {
      '<leader>be',
      function()
        require('neo-tree.command').execute({
          source = 'buffers',
          toggle = true,
        })
      end,
      desc = 'Buffer Explorer',
    },
  },
  opts = {
    sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
    open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf', 'Outline' },
    close_if_last_window = true,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    enable_normal_mode_for_inputs = false,
    sort_case_insensitive = true,
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        indent_size = 2,
        padding = 1,
        with_markers = true,
        indent_marker = '│',
        last_indent_marker = '└',
        highlight = 'NeoTreeIndentMarker',
        with_expanders = true,
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '',
        folder_empty_open = '',
        default = '',
        highlight = 'NeoTreeFileIcon',
      },
      modified = {
        symbol = '',
        highlight = 'NeoTreeModified',
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = 'NeoTreeFileName',
      },
      git_status = {
        symbols = {
          added = '',
          modified = '',
          deleted = '',
          renamed = '',
          untracked = '',
          ignored = '',
          unstaged = '󰄱',
          staged = '',
          conflict = '',
        },
      },
      diagnostics = {
        symbols = {
          hint = '󰌵',
          info = '',
          warn = '',
          error = '',
        },
        highlights = {
          hint = 'DiagnosticSignHint',
          info = 'DiagnosticSignInfo',
          warn = 'DiagnosticSignWarn',
          error = 'DiagnosticSignError',
        },
      },
    },
    commands = {},
    window = {
      position = 'left',
      width = 35,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ['<space>'] = 'none',
        ['<2-LeftMouse>'] = 'open',
        ['<cr>'] = 'open',
        ['<esc>'] = 'cancel',
        ['P'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = true } },
        ['l'] = 'focus_preview',
        ['s'] = 'open_split',
        ['v'] = 'open_vsplit',
        ['t'] = 'open_tabnew',
        ['w'] = 'open_with_window_picker',
        ['C'] = 'close_node',
        ['z'] = 'close_all_nodes',
        ['Z'] = 'expand_all_nodes',
        ['R'] = 'refresh',
        ['a'] = { 'add', config = { show_path = 'relative' } },
        ['A'] = 'add_directory',
        ['d'] = 'delete',
        ['r'] = 'rename',
        ['y'] = 'copy_to_clipboard',
        ['x'] = 'cut_to_clipboard',
        ['p'] = 'paste_from_clipboard',
        ['c'] = 'copy',
        ['m'] = 'move',
        ['e'] = 'toggle_auto_expand_width',
        ['q'] = 'close_window',
        ['?'] = 'show_help',
        ['<'] = 'prev_source',
        ['>'] = 'next_source',
        ['i'] = 'show_file_details',
        ['\\'] = 'close_window',
      },
    },
    filesystem = {
      bind_to_cwd = true,
      cwd_target = {
        sidebar = 'tab',
        current = 'window',
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      group_empty_dirs = false,
      hijack_netrw_behavior = 'open_default',
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          '.DS_Store',
          'thumbs.db',
          '.git',
        },
        never_show = {
          '.DS_Store',
          'thumbs.db',
        },
      },
      window = {
        mappings = {
          ['H'] = 'toggle_hidden',
          ['/'] = 'fuzzy_finder',
          ['D'] = 'fuzzy_finder_directory',
          ['#'] = 'fuzzy_sorter',
          ['f'] = 'filter_on_submit',
          ['<C-x>'] = 'clear_filter',
          ['<bs>'] = 'navigate_up',
          ['.'] = 'set_root',
          ['[g'] = 'prev_git_modified',
          [']g'] = 'next_git_modified',
          ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
          ['oc'] = { 'order_by_created', nowait = false },
          ['od'] = { 'order_by_diagnostics', nowait = false },
          ['og'] = { 'order_by_git_status', nowait = false },
          ['om'] = { 'order_by_modified', nowait = false },
          ['on'] = { 'order_by_name', nowait = false },
          ['os'] = { 'order_by_size', nowait = false },
          ['ot'] = { 'order_by_type', nowait = false },
        },
        fuzzy_finder_mappings = {
          ['<down>'] = 'move_cursor_down',
          ['<C-n>'] = 'move_cursor_down',
          ['<up>'] = 'move_cursor_up',
          ['<C-p>'] = 'move_cursor_up',
        },
      },
    },
    buffers = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      group_empty_dirs = true,
      show_unloaded = true,
      window = {
        mappings = {
          ['bd'] = 'buffer_delete',
          ['<bs>'] = 'navigate_up',
          ['.'] = 'set_root',
          ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
          ['oc'] = { 'order_by_created', nowait = false },
          ['od'] = { 'order_by_diagnostics', nowait = false },
          ['om'] = { 'order_by_modified', nowait = false },
          ['on'] = { 'order_by_name', nowait = false },
          ['os'] = { 'order_by_size', nowait = false },
          ['ot'] = { 'order_by_type', nowait = false },
        },
      },
    },
    git_status = {
      window = {
        position = 'float',
        mappings = {
          ['A'] = 'git_add_all',
          ['gu'] = 'git_unstage_file',
          ['ga'] = 'git_add_file',
          ['gr'] = 'git_revert_file',
          ['gc'] = 'git_commit',
          ['gp'] = 'git_push',
          ['gg'] = 'git_commit_and_push',
          ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
          ['oc'] = { 'order_by_created', nowait = false },
          ['od'] = { 'order_by_diagnostics', nowait = false },
          ['om'] = { 'order_by_modified', nowait = false },
          ['on'] = { 'order_by_name', nowait = false },
          ['os'] = { 'order_by_size', nowait = false },
          ['ot'] = { 'order_by_type', nowait = false },
        },
      },
    },
    document_symbols = {
      follow_cursor = true,
      client_filters = 'first',
      renderers = {
        root = {
          { 'indent' },
          { 'icon', default = 'C' },
          { 'name', zindex = 10 },
        },
        symbol = {
          { 'indent', with_expanders = true },
          { 'kind_icon', default = '?' },
          { 'container', content = { { 'name', zindex = 10 }, { 'kind_name', zindex = 20, align = 'right' } } },
        },
      },
      window = {
        mappings = {
          ['<cr>'] = 'jump_to_symbol',
          ['o'] = 'jump_to_symbol',
          ['A'] = 'noop',
          ['d'] = 'noop',
          ['y'] = 'noop',
          ['x'] = 'noop',
          ['p'] = 'noop',
          ['c'] = 'noop',
          ['m'] = 'noop',
          ['a'] = 'noop',
          ['/'] = 'filter',
          ['f'] = 'filter_on_submit',
        },
      },
      kinds = {
        Unknown = { icon = '?', hl = '' },
        Root = { icon = '', hl = 'NeoTreeRootName' },
        File = { icon = '󰈙', hl = 'Tag' },
        Module = { icon = '', hl = 'Exception' },
        Namespace = { icon = '󰌗', hl = 'Include' },
        Package = { icon = '󰏖', hl = 'Label' },
        Class = { icon = '󰌗', hl = 'Include' },
        Method = { icon = '', hl = 'Function' },
        Property = { icon = '󰆧', hl = '@property' },
        Field = { icon = '', hl = '@field' },
        Constructor = { icon = '', hl = '@constructor' },
        Enum = { icon = '󰒻', hl = '@number' },
        Interface = { icon = '', hl = 'Type' },
        Function = { icon = '󰊕', hl = 'Function' },
        Variable = { icon = '', hl = '@variable' },
        Constant = { icon = '', hl = 'Constant' },
        String = { icon = '󰀬', hl = 'String' },
        Number = { icon = '󰎠', hl = 'Number' },
        Boolean = { icon = '', hl = 'Boolean' },
        Array = { icon = '󰅪', hl = 'Type' },
        Object = { icon = '󰅩', hl = 'Type' },
        Key = { icon = '󰌋', hl = '' },
        Null = { icon = '', hl = 'Constant' },
        EnumMember = { icon = '', hl = 'Number' },
        Struct = { icon = '󰌗', hl = 'Type' },
        Event = { icon = '', hl = 'Constant' },
        Operator = { icon = '󰆕', hl = 'Operator' },
        TypeParameter = { icon = '󰊄', hl = 'Type' },
      },
    },
    source_selector = {
      winbar = true,
      statusline = false,
      show_scrolled_off_parent_node = true,
      sources = {
        { source = 'filesystem', display_name = ' 󰉓 Files ' },
        { source = 'buffers', display_name = ' 󰈚 Buffers ' },
        { source = 'git_status', display_name = ' 󰊢 Git ' },
        { source = 'document_symbols', display_name = '  Symbols ' },
      },
      content_layout = 'start',
      tabs_layout = 'equal',
      truncation_character = '…',
      tabs_min_width = nil,
      tabs_max_width = nil,
      padding = 0,
      separator = { left = '', right = '' },
      separator_active = nil,
      show_separator_on_edge = false,
      highlight_tab = 'NeoTreeTabInactive',
      highlight_tab_active = 'NeoTreeTabActive',
      highlight_background = 'NeoTreeTabInactive',
      highlight_separator = 'NeoTreeTabSeparatorInactive',
      highlight_separator_active = 'NeoTreeTabSeparatorActive',
    },
    event_handlers = {
      {
        event = 'file_opened',
        handler = function()
          require('neo-tree.command').execute({ action = 'close' })
        end,
      },
      {
        event = 'neo_tree_window_after_open',
        handler = function(args)
          if args.position == 'left' or args.position == 'right' then
            vim.cmd('wincmd =')
          end
        end,
      },
      {
        event = 'neo_tree_window_after_close',
        handler = function(args)
          if args.position == 'left' or args.position == 'right' then
            vim.cmd('wincmd =')
          end
        end,
      },
    },
  },
  config = function(_, opts)
    -- Configure window picker
    require('window-picker').setup({
      hint = 'floating-big-letter',
      selection_chars = 'FJDKSLA;CMRUEIWOQP',
      picker_config = {
        statusline_winbar_picker = {
          selection_display = function(char)
            return '%=' .. char .. '%='
          end,
          use_winbar = 'always',
        },
      },
      filter_rules = {
        autoselect_one = true,
        include_current_win = false,
        bo = {
          filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
          buftype = { 'terminal', 'quickfix' },
        },
      },
    })

    require('neo-tree').setup(opts)
  end,
}

-- vim: ts=2 sts=2 sw=2 et
