-- which-key.lua --
-- Complete Keymap Documentation for LoganVim
-- Organized, intuitive, and beautiful

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    --  ╭──────────────────────────────────────────────────────────╮
    --  │                       Presets                            │
    --  ╰──────────────────────────────────────────────────────────╯

    preset = 'modern',
    delay = 0,
    notify = true,

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Icons                             │
    --  ╰──────────────────────────────────────────────────────────╯

    icons = {
      breadcrumb = '»',
      separator = '➜',
      group = '+',
      ellipsis = '…',
      mappings = vim.g.have_nerd_font,
      rules = {},
      colors = true,
      keys = vim.g.have_nerd_font and {
        Up = ' ',
        Down = ' ',
        Left = ' ',
        Right = ' ',
        C = '󰘴 ',
        M = '󰘵 ',
        D = '󰘳 ',
        S = '󰘶 ',
        CR = '󰌑 ',
        Esc = '󱊷 ',
        ScrollWheelDown = '󱕐 ',
        ScrollWheelUp = '󱕑 ',
        NL = '󰌑 ',
        BS = '󰁮',
        Space = '󱁐 ',
        Tab = '󰌒 ',
        F1 = '󱊫',
        F2 = '󱊬',
        F3 = '󱊭',
        F4 = '󱊮',
        F5 = '󱊯',
        F6 = '󱊰',
        F7 = '󱊱',
        F8 = '󱊲',
        F9 = '󱊳',
        F10 = '󱊴',
        F11 = '󱊵',
        F12 = '󱊶',
      } or {},
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        Window                            │
    --  ╰──────────────────────────────────────────────────────────╯

    win = {
      no_overlap = true,
      border = 'rounded',
      padding = { 1, 2 },
      title = true,
      title_pos = 'center',
      zindex = 1000,
      bo = {},
      wo = {
        winblend = 0,
      },
    },

    layout = {
      width = { min = 20 },
      spacing = 3,
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                    Group Definitions                     │
    --  ╰──────────────────────────────────────────────────────────╯

    spec = {
      -- Leader groups
      { '<leader>a', group = 'AI/Sidekick', icon = '󰚩' },
      { '<leader>b', group = 'Buffer', icon = '' },
      { '<leader>c', group = 'Code', icon = '' },
      { '<leader>C', group = 'Copilot Chat', icon = '' },
      { '<leader>d', group = 'Debug', icon = '' },
      { '<leader>f', group = 'File/Find', icon = '' },
      { '<leader>g', group = 'Git', icon = '' },
      { '<leader>h', group = 'Hunk/Git', icon = '' },
      { '<leader>l', group = 'Lazy', icon = '󰒲' },
      { '<leader>n', group = 'Notifications', icon = '' },
      { '<leader>q', group = 'Session', icon = '' },
      { '<leader>r', group = 'Refactor', icon = '' },
      { '<leader>s', group = 'Search', icon = '' },
      { '<leader>t', group = 'Toggle/Treesitter', icon = '' },
      { '<leader>T', group = 'Test', icon = '󰙨' },
      { '<leader>u', group = 'UI', icon = '' },
      { '<leader>w', group = 'Window', icon = '' },
      { '<leader>x', group = 'Diagnostics', icon = '' },
      { '<leader><tab>', group = 'Tab', icon = '󰓩' },

      -- Sidekick commands
      { '<leader>aa', desc = 'Toggle CLI' },
      { '<leader>ac', desc = 'Toggle Codex' },
      { '<leader>au', desc = 'Toggle Cursor' },
      { '<leader>ad', desc = 'Detach CLI' },
      { '<leader>ae', desc = 'Apply Edit' },
      { '<leader>af', desc = 'Send File' },
      { '<leader>aj', desc = 'Jump to Edit' },
      { '<leader>an', desc = 'Refresh Suggestions' },
      { '<leader>ao', desc = 'Toggle NES' },
      { '<leader>ap', desc = 'Select Prompt', mode = { 'n', 'x' } },
      { '<leader>as', desc = 'Select CLI' },
      { '<leader>at', desc = 'Send This', mode = { 'n', 'x' } },
      { '<leader>av', desc = 'Send Visual', mode = { 'x' } },

      -- Buffer commands
      { '<leader>bb', desc = 'Switch to other' },
      { '<leader>bd', desc = 'Delete buffer' },
      { '<leader>bD', desc = 'Force delete' },
      { '<leader>bn', desc = 'New buffer' },
      { '<leader>bo', desc = 'Close others' },
      { '<leader>bp', desc = 'Pick buffer' },
      { '<leader>b<', desc = 'Move left' },
      { '<leader>b>', desc = 'Move right' },

      -- Code actions
      { '<leader>ca', desc = 'Code action', mode = { 'n', 'v' } },
      { '<leader>cA', desc = 'Source action' },
      { '<leader>cl', desc = 'Code lens' },
      { '<leader>cL', desc = 'Refresh lens' },
      { '<leader>cs', desc = 'Symbols (Trouble)' },

      -- Copilot Chat
      { '<leader>Cc', desc = 'Toggle Chat', mode = { 'n', 'v' } },
      { '<leader>Cq', desc = 'Quick Chat', mode = { 'n', 'v' } },
      { '<leader>Ce', desc = 'Explain code', mode = { 'n', 'v' } },
      { '<leader>Cr', desc = 'Review code', mode = { 'n', 'v' } },
      { '<leader>Cf', desc = 'Fix code', mode = { 'n', 'v' } },
      { '<leader>Co', desc = 'Optimize code', mode = { 'n', 'v' } },
      { '<leader>Cd', desc = 'Generate docs', mode = { 'n', 'v' } },
      { '<leader>Ct', desc = 'Generate tests', mode = { 'n', 'v' } },
      { '<leader>Cm', desc = 'Commit message' },
      { '<leader>CM', desc = 'Staged commit msg' },
      { '<leader>CD', desc = 'Fix diagnostic', mode = { 'n', 'v' } },

      -- Debug
      { '<leader>db', desc = 'Toggle breakpoint' },
      { '<leader>dB', desc = 'Conditional breakpoint' },
      { '<leader>dc', desc = 'Continue' },
      { '<leader>di', desc = 'Step into' },
      { '<leader>do', desc = 'Step out' },
      { '<leader>dO', desc = 'Step over' },
      { '<leader>dr', desc = 'Toggle REPL' },
      { '<leader>ds', desc = 'Start/Continue' },
      { '<leader>dt', desc = 'Terminate' },
      { '<leader>du', desc = 'Toggle UI' },

      -- Git
      { '<leader>gg', desc = 'Neogit' },
      { '<leader>gb', desc = 'Blame line' },
      { '<leader>gd', desc = 'Diff index' },
      { '<leader>gD', desc = 'Diff HEAD' },

      -- Git hunks
      { '<leader>hs', desc = 'Stage hunk', mode = { 'n', 'v' } },
      { '<leader>hr', desc = 'Reset hunk', mode = { 'n', 'v' } },
      { '<leader>hS', desc = 'Stage buffer' },
      { '<leader>hu', desc = 'Undo stage' },
      { '<leader>hR', desc = 'Reset buffer' },
      { '<leader>hp', desc = 'Preview hunk' },
      { '<leader>hb', desc = 'Blame line' },
      { '<leader>hd', desc = 'Diff index' },
      { '<leader>hD', desc = 'Diff HEAD' },

      -- Harpoon
      { '<leader>ha', desc = 'Add file' },
      { '<leader>hh', desc = 'Toggle menu' },
      { '<leader>hn', desc = 'Next file' },
      { '<leader>hx', desc = 'Remove file' },

      -- Session
      { '<leader>qs', desc = 'Restore session' },
      { '<leader>ql', desc = 'Last session' },
      { '<leader>qd', desc = 'Stop session' },

      -- Refactor
      { '<leader>rn', desc = 'Rename' },
      { '<leader>rr', desc = 'Find & replace' },
      { '<leader>rw', desc = 'Replace word' },
      { '<leader>rf', desc = 'Replace in file' },

      -- Search (Telescope)
      { '<leader>s/', desc = 'Search in open files' },
      { '<leader>s.', desc = 'Recent files' },
      { '<leader>sb', desc = 'Buffers' },
      { '<leader>sc', desc = 'Commands' },
      { '<leader>sd', desc = 'Diagnostics' },
      { '<leader>sf', desc = 'Files' },
      { '<leader>sg', desc = 'Grep' },
      { '<leader>sh', desc = 'Help' },
      { '<leader>sk', desc = 'Keymaps' },
      { '<leader>sm', desc = 'Marks' },
      { '<leader>sn', desc = 'Neovim files' },
      { '<leader>so', desc = 'Options' },
      { '<leader>sr', desc = 'Resume' },
      { '<leader>ss', desc = 'Document symbols' },
      { '<leader>sS', desc = 'Workspace symbols' },
      { '<leader>sw', desc = 'Word under cursor' },

      -- Test
      { '<leader>Tt', desc = 'Run nearest' },
      { '<leader>TT', desc = 'Run file' },
      { '<leader>Tr', desc = 'Re-run last' },
      { '<leader>Ts', desc = 'Toggle summary' },
      { '<leader>To', desc = 'Show output' },
      { '<leader>TO', desc = 'Output panel' },
      { '<leader>TS', desc = 'Stop test' },
      { '<leader>Td', desc = 'Debug test' },
      { '<leader>Ta', desc = 'Run all' },
      { '<leader>Tw', desc = 'Watch mode' },

      -- Toggle/Treesitter
      { '<leader>tb', desc = 'Toggle blame' },
      { '<leader>tc', desc = 'TS Context toggle' },
      { '<leader>tD', desc = 'Show deleted' },
      { '<leader>th', desc = 'Inlay hints' },
      { '<leader>tp', desc = 'TS Context: go to parent' },
      { '<leader>ta', desc = 'Swap param next' },
      { '<leader>tA', desc = 'Swap param prev' },

      -- UI Toggles
      { '<leader>ub', desc = 'Toggle background' },
      { '<leader>uc', desc = 'Toggle cursor line' },
      { '<leader>uC', desc = 'Toggle cursor column' },
      { '<leader>ud', desc = 'Toggle diagnostics' },
      { '<leader>ui', desc = 'Toggle inlay hints' },
      { '<leader>ul', desc = 'Toggle line numbers' },
      { '<leader>un', desc = 'Toggle relative numbers' },
      { '<leader>us', desc = 'Toggle spell' },
      { '<leader>ut', desc = 'Toggle conceallevel' },
      { '<leader>uw', desc = 'Toggle wrap' },

      -- Windows
      { '<leader>wd', desc = 'Close window' },
      { '<leader>wh', desc = 'Swap left' },
      { '<leader>wj', desc = 'Swap down' },
      { '<leader>wk', desc = 'Swap up' },
      { '<leader>wl', desc = 'Swap right' },
      { '<leader>wm', desc = 'Maximize' },
      { '<leader>wo', desc = 'Close others' },
      { '<leader>wr', desc = 'Resize mode' },
      { '<leader>w=', desc = 'Equal sizes' },

      -- Diagnostics/Trouble
      { '<leader>xd', desc = 'Line diagnostics' },
      { '<leader>xq', desc = 'Quickfix list' },
      { '<leader>xl', desc = 'Location list' },
      { '<leader>xL', desc = 'Location list (Trouble)' },
      { '<leader>xQ', desc = 'Quickfix (Trouble)' },
      { '<leader>xt', desc = 'Todos (Trouble)' },
      { '<leader>xx', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', desc = 'Buffer diagnostics' },

      -- Misc
      { '<leader>/', desc = 'Fuzzy search buffer' },
      { '<leader>-', desc = 'Split horizontal' },
      { '<leader>|', desc = 'Split vertical' },
      { '<leader>:', desc = 'Command history' },
      { '<leader>?', desc = 'Search help' },
      { '<leader>f', desc = 'Format buffer', mode = '' },
      { '<leader>o', desc = 'Symbol outline' },
      { '<leader>Q', desc = 'Force quit all' },
      { '<leader>qq', desc = 'Quit all' },
      { '<leader>wq', desc = 'Save all & quit' },

      -- Motions
      { ']b', desc = 'Next buffer' },
      { '[b', desc = 'Previous buffer' },
      { ']c', desc = 'Next git change' },
      { '[c', desc = 'Previous git change' },
      { ']d', desc = 'Next diagnostic' },
      { '[d', desc = 'Previous diagnostic' },
      { ']e', desc = 'Next error' },
      { '[e', desc = 'Previous error' },
      { ']w', desc = 'Next warning' },
      { '[w', desc = 'Previous warning' },
      { ']q', desc = 'Next quickfix' },
      { '[q', desc = 'Previous quickfix' },
      { ']t', desc = 'Next Trouble item' },
      { '[t', desc = 'Previous Trouble item' },
      { ']T', desc = 'Next failed test' },
      { '[T', desc = 'Previous failed test' },
      { ']m', desc = 'Next function start' },
      { '[m', desc = 'Previous function start' },
      { ']M', desc = 'Next function end' },
      { '[M', desc = 'Previous function end' },
      { ']]', desc = 'Next class start' },
      { '[[', desc = 'Previous class start' },
      { '][', desc = 'Next class end' },
      { '[]', desc = 'Previous class end' },
      { ']<Space>', desc = 'Add blank line below' },
      { '[<Space>', desc = 'Add blank line above' },

      -- LSP
      { 'gd', desc = 'Goto definition' },
      { 'gD', desc = 'Goto declaration' },
      { 'gr', desc = 'Goto references' },
      { 'gI', desc = 'Goto implementation' },
      { 'gy', desc = 'Goto type definition' },
      { 'gK', desc = 'Signature help' },
      { 'K', desc = 'Hover documentation' },

      -- Treesitter
      { 'gnn', desc = 'Start selection' },
      { 'grn', desc = 'Expand node' },
      { 'grm', desc = 'Shrink node' },
      { 'grc', desc = 'Expand scope' },
      { 'gp', desc = 'Peek function definition' },
      { 'gP', desc = 'Peek class definition' },

      -- Text objects
      { 'af', desc = 'Function (outer)', mode = { 'o', 'x' } },
      { 'if', desc = 'Function (inner)', mode = { 'o', 'x' } },
      { 'ac', desc = 'Class (outer)', mode = { 'o', 'x' } },
      { 'ic', desc = 'Class (inner)', mode = { 'o', 'x' } },
      { 'aa', desc = 'Parameter (outer)', mode = { 'o', 'x' } },
      { 'ia', desc = 'Parameter (inner)', mode = { 'o', 'x' } },
      { 'al', desc = 'Loop (outer)', mode = { 'o', 'x' } },
      { 'il', desc = 'Loop (inner)', mode = { 'o', 'x' } },

      -- Flash
      { 's', desc = 'Flash jump', mode = { 'n', 'x', 'o' } },
      { 'S', desc = 'Flash treesitter', mode = { 'n', 'x', 'o' } },
      { 'r', desc = 'Flash remote', mode = 'o' },
      { 'R', desc = 'Flash treesitter search', mode = { 'o', 'x' } },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
