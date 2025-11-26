-- harpoon.lua --
-- Quick file navigation
-- Mark files and jump to them instantly

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',
  opts = {
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
      key = function()
        return vim.loop.cwd()
      end,
    },
    menu = {
      width = vim.api.nvim_win_get_width(0) - 8,
    },
  },
  keys = function()
    local harpoon = require('harpoon')
    return {
      {
        '<leader>ha',
        function()
          harpoon:list():add()
          vim.notify('Added to Harpoon', vim.log.levels.INFO)
        end,
        desc = 'Harpoon add file',
      },
      {
        '<leader>hh',
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'Harpoon menu',
      },
      {
        '<leader>hx',
        function()
          harpoon:list():remove()
          vim.notify('Removed from Harpoon', vim.log.levels.INFO)
        end,
        desc = 'Harpoon remove file',
      },
      {
        '<leader>hc',
        function()
          harpoon:list():clear()
          vim.notify('Cleared Harpoon list', vim.log.levels.INFO)
        end,
        desc = 'Harpoon clear list',
      },
      {
        '<leader>hn',
        function()
          harpoon:list():next()
        end,
        desc = 'Harpoon next',
      },
      {
        '<leader>hp',
        function()
          harpoon:list():prev()
        end,
        desc = 'Harpoon previous',
      },
      {
        '<leader>h1',
        function()
          harpoon:list():select(1)
        end,
        desc = 'Harpoon file 1',
      },
      {
        '<leader>h2',
        function()
          harpoon:list():select(2)
        end,
        desc = 'Harpoon file 2',
      },
      {
        '<leader>h3',
        function()
          harpoon:list():select(3)
        end,
        desc = 'Harpoon file 3',
      },
      {
        '<leader>h4',
        function()
          harpoon:list():select(4)
        end,
        desc = 'Harpoon file 4',
      },
      {
        '<leader>h5',
        function()
          harpoon:list():select(5)
        end,
        desc = 'Harpoon file 5',
      },
      -- Alt key shortcuts for even faster access
      {
        '<A-1>',
        function()
          harpoon:list():select(1)
        end,
        desc = 'Harpoon file 1',
      },
      {
        '<A-2>',
        function()
          harpoon:list():select(2)
        end,
        desc = 'Harpoon file 2',
      },
      {
        '<A-3>',
        function()
          harpoon:list():select(3)
        end,
        desc = 'Harpoon file 3',
      },
      {
        '<A-4>',
        function()
          harpoon:list():select(4)
        end,
        desc = 'Harpoon file 4',
      },
      {
        '<A-5>',
        function()
          harpoon:list():select(5)
        end,
        desc = 'Harpoon file 5',
      },
    }
  end,
  config = function(_, opts)
    local harpoon = require('harpoon')
    harpoon:setup(opts)

    -- Telescope integration
    local ok, telescope = pcall(require, 'telescope')
    if ok then
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end

      vim.keymap.set('n', '<leader>ht', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Harpoon Telescope' })
    end
  end,
}

-- vim: ts=2 sts=2 sw=2 et
