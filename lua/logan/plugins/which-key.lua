-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `opts` key (recommended), the configuration runs
-- after the plugin has been loaded as `require(MODULE).setup(opts)`.

return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>b', group = '[B]uffer' },
        { '<leader>w', group = '[W]indow' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>u', group = '[U]I toggles' },
        { '<leader>r', group = '[R]efactor' },
        { '<leader>q', group = '[Q] Sessions' },
        { '<leader>x', group = '[X]Trouble' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },

        -- Session commands
        { '<leader>qs', desc = 'Session restore last' },
        { '<leader>ql', desc = 'Session restore previous' },
        { '<leader>qd', desc = 'Session stop' },

        -- Diagnostics quickfix
        { '<leader>xq', desc = 'Diagnostics quickfix list' },

        -- Harpoon helpers
        { '<leader>ha', desc = 'Harpoon add file' },
        { '<leader>hh', desc = 'Harpoon menu' },
        { '<leader>hn', desc = 'Harpoon next' },
        { '<leader>hp', desc = 'Harpoon prev' },
        { '<leader>hx', desc = 'Harpoon remove' },

        -- Spectre/refactor
        { '<leader>rr', desc = 'Find & replace (Spectre)' },
        { '<leader>rw', desc = 'Word replace (Spectre)' },
        { '<leader>rf', desc = 'File replace (Spectre)' },

        -- Buffers
        { '<leader>bn', desc = 'New buffer' },
        { '<leader>bd', desc = 'Delete buffer' },
        { '<leader>bo', desc = 'Close other buffers' },
        { '<leader>bp', desc = 'Pick buffer' },
        { '<leader>b<', desc = 'Move buffer left' },
        { '<leader>b>', desc = 'Move buffer right' },
        { ']b', desc = 'Next buffer' },
        { '[b', desc = 'Previous buffer' },

        -- Windows
        { '<leader>wr', desc = 'Resize mode' },
        { '<leader>wh', desc = 'Swap buffer left' },
        { '<leader>wl', desc = 'Swap buffer right' },
        { '<leader>wj', desc = 'Swap buffer down' },
        { '<leader>wk', desc = 'Swap buffer up' },

        -- Outline
        { '<leader>o', desc = 'Symbols outline' },

        -- === Treesitter Groups ===
        { '<leader>ts', group = '[T]reesitter [S]elect' },
        { '<leader>tx', group = '[T]reesitter Swa[p]' },
        { '<leader>tc', desc = '[T]reesitter [C]ontext Toggle' },
        { '<leader>uw', desc = 'Toggle wrap' },
        { '<leader>un', desc = 'Toggle relative numbers' },
        { '<leader>us', desc = 'Toggle spell' },
        { '<leader>ut', desc = 'Trim trailing whitespace' },

        --- Swap parameters
        { '<leader>ta', desc = 'Swap parameter -> Next' },
        { '<leader>tA', desc = 'Swap parameter -> Prev' },

        --- Incremental Selection
        { 'gnn', desc = 'TS Start Selection' },
        { 'grn', desc = 'TS Expand Node' },
        { 'grm', desc = 'TS Shrink Node' },
        { 'grc', desc = 'TS Expand Scope' },

        --- Textobjects
        { 'af', desc = 'Select Function (outer)', mode = { 'n', 'x' } },
        { 'if', desc = 'Select Function (inner)', mode = { 'n', 'x' } },
        { 'ac', desc = 'Select Class (outer)', mode = { 'n', 'x' } },
        { 'ic', desc = 'Select Class (inner)', mode = { 'n', 'x' } },
        { 'aa', desc = 'Select Param (outer)', mode = { 'n', 'x' } },
        { 'ia', desc = 'Select Param (inner)', mode = { 'n', 'x' } },
        { 'al', desc = 'Select Loop (outer)', mode = { 'n', 'x' } },
        { 'il', desc = 'Select Loop (inner)', mode = { 'n', 'x' } },

        --- Motions
        { ']m', desc = 'Next Function Start' },
        { '[m', desc = 'Prev Function Start' },
        { ']M', desc = 'Next Function End' },
        { '[M', desc = 'Prev Function End' },
        { ']]', desc = 'Next Class Start' },
        { '[[', desc = 'Prev Class Start' },
        { '][', desc = 'Next Class End' },
        { '[]', desc = 'Prev Class End' },

        --- Peek
        { 'gp', desc = 'Peek Function Definition' },
        { 'gP', desc = 'Peek Class Definition' },

        --- Context Navigation
        { '[c', desc = 'Go to parent context' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
