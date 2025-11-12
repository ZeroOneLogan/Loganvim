local disabled_filetypes = {
  ['neo-tree'] = true,
  ['lazy'] = true,
  ['mason'] = true,
  ['alpha'] = true,
  ['TelescopePrompt'] = true,
  gitcommit = true,
  gitrebase = true,
  help = true,
}

local disabled_buftypes = {
  nofile = true,
  prompt = true,
  terminal = true,
  quickfix = true,
}

if vim.g.sidekick_nes == nil then
  vim.g.sidekick_nes = true
end

local function set_global_nes_enabled(enabled)
  local new_state = enabled ~= false
  vim.g.sidekick_nes = new_state

  local ok, nes = pcall(require, 'sidekick.nes')
  if ok then
    nes.enable(new_state)
  end

  return new_state
end

local function toggle_global_nes()
  return set_global_nes_enabled(not vim.g.sidekick_nes)
end

local function is_buf_var_disabled(buf)
  local ok, value = pcall(vim.api.nvim_buf_get_var, buf, 'sidekick_nes')
  return ok and value == false
end

local function should_enable_nes(buf)
  if vim.g.sidekick_nes == false or is_buf_var_disabled(buf) then
    return false
  end

  if not vim.api.nvim_buf_is_loaded(buf) then
    return false
  end

  local bt = vim.api.nvim_get_option_value('buftype', { buf = buf })
  if disabled_buftypes[bt] then
    return false
  end

  local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
  if disabled_filetypes[ft] then
    return false
  end

  if vim.api.nvim_buf_line_count(buf) > 4000 then
    return false
  end

  return true
end

local function mux_backend()
  local is_zellij = (vim.env.ZELLIJ or '') ~= ''
  if is_zellij then
    return 'zellij', true
  end
  local is_tmux = (vim.env.TMUX or '') ~= ''
  if is_tmux then
    return 'tmux', true
  end
  return 'tmux', false
end

return {
  {
    'folke/sidekick.nvim',
    opts = function()
      local backend, enabled = mux_backend()
      return {
        nes = {
          enabled = should_enable_nes,
        },
        cli = {
          mux = {
            backend = backend,
            enabled = enabled,
          },
        },
      }
    end,
    keys = {
      {
        '<Tab>',
        function()
          if not require('sidekick').nes_jump_or_apply() then
            return '<Tab>' -- fallback to normal tab
          end
        end,
        expr = true,
        mode = { 'n' },
        desc = 'Goto/Apply Next Edit Suggestion',
      },
      {
        '<c-.>',
        function()
          require('sidekick.cli').toggle()
        end,
        desc = 'Sidekick Toggle',
        mode = { 'n', 't', 'i', 'x' },
      },
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle()
        end,
        desc = 'Sidekick Toggle CLI',
      },
      {
        '<leader>ac',
        function()
          require('sidekick.cli').toggle { name = 'codex', focus = true }
        end,
        desc = 'Sidekick Toggle Codex',
      },
      {
        '<leader>au',
        function()
          require('sidekick.cli').toggle { name = 'cursor', focus = true }
        end,
        desc = 'Sidekick Toggle Cursor',
      },
      {
        '<leader>as',
        function()
          require('sidekick.cli').select()
        end,
        desc = 'Select CLI',
      },
      {
        '<leader>ad',
        function()
          require('sidekick.cli').close()
        end,
        desc = 'Detach a CLI Session',
      },
      {
        '<leader>an',
        function()
          require('sidekick.nes').update()
        end,
        desc = 'Request Next Edit Suggestions',
      },
      {
        '<leader>aj',
        function()
          if not require('sidekick.nes').jump() then
            vim.notify('No Sidekick edits to jump to', vim.log.levels.INFO)
          end
        end,
        desc = 'Jump to Active Edit Suggestion',
      },
      {
        '<leader>ae',
        function()
          if not require('sidekick.nes').apply() then
            vim.notify('No Sidekick edits to apply', vim.log.levels.INFO)
          end
        end,
        desc = 'Apply Active Edit Suggestion',
      },
      {
        '<leader>at',
        function()
          require('sidekick.cli').send { msg = '{this}' }
        end,
        mode = { 'x', 'n' },
        desc = 'Send This',
      },
      {
        '<leader>af',
        function()
          require('sidekick.cli').send { msg = '{file}' }
        end,
        desc = 'Send File',
      },
      {
        '<leader>av',
        function()
          require('sidekick.cli').send { msg = '{selection}' }
        end,
        mode = { 'x' },
        desc = 'Send Visual Selection',
      },
      {
        '<leader>ap',
        function()
          require('sidekick.cli').prompt()
        end,
        mode = { 'n', 'x' },
        desc = 'Sidekick Select Prompt',
      },
      {
        '<leader>ao',
        function()
          local enabled = toggle_global_nes()
          local msg = enabled and 'Sidekick NES enabled' or 'Sidekick NES disabled'
          vim.notify(msg, vim.log.levels.INFO, { title = 'Sidekick' })
        end,
        desc = 'Toggle Sidekick NES',
      },
    },
  },
}
