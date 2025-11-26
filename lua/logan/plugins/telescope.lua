-- telescope.lua --
-- Ultimate Fuzzy Finder Configuration
-- Fast, feature-rich, and beautifully integrated

return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  version = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable('make') == 1
      end,
    },
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  keys = {
    --  ╭────────────────────────────────────────────────────────╮
    --  │                     File Search                        │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader>sf',
      function()
        require('telescope.builtin').find_files()
      end,
      desc = 'Search files',
    },
    {
      '<leader>sF',
      function()
        require('telescope.builtin').find_files({ hidden = true, no_ignore = true })
      end,
      desc = 'Search all files',
    },
    {
      '<leader>s.',
      function()
        require('telescope.builtin').oldfiles()
      end,
      desc = 'Recent files',
    },
    {
      '<leader>sn',
      function()
        require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })
      end,
      desc = 'Neovim config files',
    },

    --  ╭────────────────────────────────────────────────────────╮
    --  │                     Text Search                        │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader>sg',
      function()
        require('telescope.builtin').live_grep()
      end,
      desc = 'Live grep',
    },
    {
      '<leader>sG',
      function()
        require('telescope.builtin').live_grep({
          additional_args = function()
            return { '--hidden', '--no-ignore' }
          end,
        })
      end,
      desc = 'Live grep (all files)',
    },
    {
      '<leader>sw',
      function()
        require('telescope.builtin').grep_string()
      end,
      desc = 'Search current word',
    },
    {
      '<leader>s/',
      function()
        require('telescope.builtin').live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end,
      desc = 'Search in open files',
    },
    {
      '<leader>/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find(
          require('telescope.themes').get_dropdown({
            winblend = 10,
            previewer = true,
          })
        )
      end,
      desc = 'Fuzzy search buffer',
    },

    --  ╭────────────────────────────────────────────────────────╮
    --  │                   Buffer & Tabs                        │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader><leader>',
      function()
        require('telescope.builtin').buffers({
          sort_lastused = true,
          sort_mru = true,
        })
      end,
      desc = 'Switch buffers',
    },
    {
      '<leader>sb',
      function()
        require('telescope.builtin').buffers()
      end,
      desc = 'Search buffers',
    },

    --  ╭────────────────────────────────────────────────────────╮
    --  │                     Help & Docs                        │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader>sh',
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = 'Search help',
    },
    {
      '<leader>sH',
      function()
        require('telescope.builtin').highlights()
      end,
      desc = 'Search highlights',
    },
    {
      '<leader>sm',
      function()
        require('telescope.builtin').man_pages()
      end,
      desc = 'Man pages',
    },

    --  ╭────────────────────────────────────────────────────────╮
    --  │                     Vim Internals                      │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader>sk',
      function()
        require('telescope.builtin').keymaps()
      end,
      desc = 'Search keymaps',
    },
    {
      '<leader>sc',
      function()
        require('telescope.builtin').commands()
      end,
      desc = 'Search commands',
    },
    {
      '<leader>:',
      function()
        require('telescope.builtin').command_history()
      end,
      desc = 'Command history',
    },
    {
      '<leader>so',
      function()
        require('telescope.builtin').vim_options()
      end,
      desc = 'Vim options',
    },
    {
      '<leader>sM',
      function()
        require('telescope.builtin').marks()
      end,
      desc = 'Search marks',
    },
    {
      '<leader>sj',
      function()
        require('telescope.builtin').jumplist()
      end,
      desc = 'Jump list',
    },
    {
      '<leader>sr',
      function()
        require('telescope.builtin').resume()
      end,
      desc = 'Resume last search',
    },
    {
      '<leader>ss',
      function()
        require('telescope.builtin').builtin()
      end,
      desc = 'Select Telescope picker',
    },

    --  ╭────────────────────────────────────────────────────────╮
    --  │                     Diagnostics                        │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader>sd',
      function()
        require('telescope.builtin').diagnostics({ bufnr = 0 })
      end,
      desc = 'Buffer diagnostics',
    },
    {
      '<leader>sD',
      function()
        require('telescope.builtin').diagnostics()
      end,
      desc = 'Workspace diagnostics',
    },

    --  ╭────────────────────────────────────────────────────────╮
    --  │                     Git Search                         │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader>gc',
      function()
        require('telescope.builtin').git_commits()
      end,
      desc = 'Git commits',
    },
    {
      '<leader>gs',
      function()
        require('telescope.builtin').git_status()
      end,
      desc = 'Git status',
    },
    {
      '<leader>gB',
      function()
        require('telescope.builtin').git_branches()
      end,
      desc = 'Git branches',
    },

    --  ╭────────────────────────────────────────────────────────╮
    --  │                   File Browser                         │
    --  ╰────────────────────────────────────────────────────────╯

    {
      '<leader>fe',
      function()
        require('telescope').extensions.file_browser.file_browser({
          path = '%:p:h',
          select_buffer = true,
        })
      end,
      desc = 'File browser',
    },
  },

  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                   Flash Integration                      │
    --  ╰──────────────────────────────────────────────────────────╯

    local function flash_jump(prompt_bufnr)
      local ok, flash = pcall(require, 'flash')
      if not ok then return end

      flash.jump({
        pattern = '^',
        label = { after = { 0, 0 } },
        search = {
          mode = 'search',
          exclude = {
            function(win)
              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'TelescopeResults'
            end,
          },
        },
        action = function(match)
          local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
          picker:set_selection(match.pos[1] - 1)
        end,
      })
    end

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                      Setup                               │
    --  ╰──────────────────────────────────────────────────────────╯

    telescope.setup({
      defaults = {
        prompt_prefix = '   ',
        selection_caret = '  ',
        entry_prefix = '   ',
        multi_icon = ' + ',
        sorting_strategy = 'ascending',
        layout_strategy = 'flex',
        layout_config = {
          horizontal = {
            prompt_position = 'top',
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.90,
          height = 0.85,
          preview_cutoff = 120,
        },
        path_display = { 'filename_first' },
        file_ignore_patterns = {
          '%.git/',
          'node_modules/',
          '__pycache__/',
          '%.cache/',
          '%.next/',
          'dist/',
          'build/',
          '%.o',
          '%.a',
          '%.out',
          '%.class',
          '%.pdf',
          '%.mkv',
          '%.mp4',
          '%.zip',
        },
        winblend = 0,
        border = true,
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        set_env = { COLORTERM = 'truecolor' },

        mappings = {
          i = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-n>'] = actions.move_selection_next,
            ['<C-p>'] = actions.move_selection_previous,
            ['<C-c>'] = actions.close,
            ['<CR>'] = actions.select_default,
            ['<C-x>'] = actions.select_horizontal,
            ['<C-v>'] = actions.select_vertical,
            ['<C-t>'] = actions.select_tab,
            ['<C-u>'] = actions.preview_scrolling_up,
            ['<C-d>'] = actions.preview_scrolling_down,
            ['<C-f>'] = actions.preview_scrolling_down,
            ['<C-b>'] = actions.preview_scrolling_up,
            ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
            ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            ['<C-l>'] = actions.complete_tag,
            ['<C-s>'] = flash_jump,
            ['<C-/>'] = actions.which_key,
          },
          n = {
            ['<esc>'] = actions.close,
            ['q'] = actions.close,
            ['<CR>'] = actions.select_default,
            ['<C-x>'] = actions.select_horizontal,
            ['<C-v>'] = actions.select_vertical,
            ['<C-t>'] = actions.select_tab,
            ['j'] = actions.move_selection_next,
            ['k'] = actions.move_selection_previous,
            ['gg'] = actions.move_to_top,
            ['G'] = actions.move_to_bottom,
            ['<C-u>'] = actions.preview_scrolling_up,
            ['<C-d>'] = actions.preview_scrolling_down,
            ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
            ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            ['s'] = flash_jump,
            ['?'] = actions.which_key,
          },
        },
      },

      pickers = {
        find_files = {
          hidden = true,
          find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
        },
        live_grep = {
          additional_args = function()
            return { '--hidden', '--glob', '!.git/' }
          end,
        },
        buffers = {
          show_all_buffers = true,
          sort_lastused = true,
          theme = 'dropdown',
          previewer = false,
          mappings = {
            i = {
              ['<C-d>'] = actions.delete_buffer,
            },
            n = {
              ['d'] = actions.delete_buffer,
            },
          },
        },
        oldfiles = {
          only_cwd = true,
        },
        colorscheme = {
          enable_preview = true,
        },
      },

      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown({
            winblend = 10,
          }),
        },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        file_browser = {
          theme = 'ivy',
          hijack_netrw = false,
          hidden = true,
          respect_gitignore = false,
        },
      },
    })

    -- Load extensions
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
    pcall(telescope.load_extension, 'file_browser')
    pcall(telescope.load_extension, 'notify')
  end,
}

-- vim: ts=2 sts=2 sw=2 et
