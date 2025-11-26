-- copilot-chat.lua --
-- AI-powered pair programming with GitHub Copilot Chat

return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' },
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    cmd = {
      'CopilotChat',
      'CopilotChatOpen',
      'CopilotChatClose',
      'CopilotChatToggle',
      'CopilotChatExplain',
      'CopilotChatReview',
      'CopilotChatFix',
      'CopilotChatOptimize',
      'CopilotChatDocs',
      'CopilotChatTests',
      'CopilotChatCommit',
    },
    keys = {
      -- Chat commands
      {
        '<leader>Cc',
        '<cmd>CopilotChatToggle<CR>',
        desc = 'Toggle Copilot Chat',
        mode = { 'n', 'v' },
      },
      {
        '<leader>Cq',
        function()
          local input = vim.fn.input('Quick Chat: ')
          if input ~= '' then
            require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
          end
        end,
        desc = 'Quick Chat',
        mode = { 'n', 'v' },
      },
      -- Code assistance
      {
        '<leader>Ce',
        '<cmd>CopilotChatExplain<CR>',
        desc = 'Explain code',
        mode = { 'n', 'v' },
      },
      {
        '<leader>Cr',
        '<cmd>CopilotChatReview<CR>',
        desc = 'Review code',
        mode = { 'n', 'v' },
      },
      {
        '<leader>Cf',
        '<cmd>CopilotChatFix<CR>',
        desc = 'Fix code',
        mode = { 'n', 'v' },
      },
      {
        '<leader>Co',
        '<cmd>CopilotChatOptimize<CR>',
        desc = 'Optimize code',
        mode = { 'n', 'v' },
      },
      {
        '<leader>Cd',
        '<cmd>CopilotChatDocs<CR>',
        desc = 'Generate docs',
        mode = { 'n', 'v' },
      },
      {
        '<leader>Ct',
        '<cmd>CopilotChatTests<CR>',
        desc = 'Generate tests',
        mode = { 'n', 'v' },
      },
      -- Git helpers
      {
        '<leader>Cm',
        '<cmd>CopilotChatCommit<CR>',
        desc = 'Generate commit message',
      },
      {
        '<leader>CM',
        '<cmd>CopilotChatCommitStaged<CR>',
        desc = 'Generate staged commit message',
      },
      -- Diagnostic help
      {
        '<leader>CD',
        '<cmd>CopilotChatFixDiagnostic<CR>',
        desc = 'Fix diagnostic',
        mode = { 'n', 'v' },
      },
      -- Chat history
      {
        '<leader>Ch',
        function()
          local actions = require('CopilotChat.actions')
          require('CopilotChat.integrations.telescope').pick(actions.help_actions())
        end,
        desc = 'Help actions',
      },
      {
        '<leader>Cp',
        function()
          local actions = require('CopilotChat.actions')
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
        end,
        desc = 'Prompt actions',
        mode = { 'n', 'v' },
      },
    },
    opts = {
      model = 'gpt-4o', -- Default model
      auto_follow_cursor = false,
      show_help = true,
      show_folds = true,
      highlight_selection = true,
      context = 'buffers', -- Use all open buffers as context

      question_header = '## User ',
      answer_header = '## Copilot ',
      error_header = '## Error ',

      window = {
        layout = 'vertical',
        width = 0.4,
        height = 0.5,
        relative = 'editor',
        border = 'rounded',
        title = ' Copilot Chat ',
        footer = nil,
        row = nil,
        col = nil,
        zindex = 1,
      },

      mappings = {
        complete = {
          insert = '<Tab>',
        },
        close = {
          normal = 'q',
          insert = '<C-c>',
        },
        reset = {
          normal = '<C-r>',
          insert = '<C-r>',
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-s>',
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>',
        },
        yank_diff = {
          normal = 'gy',
          register = '"',
        },
        show_diff = {
          normal = 'gd',
        },
        show_system_prompt = {
          normal = 'gp',
        },
        show_user_selection = {
          normal = 'gs',
        },
      },

      -- Custom prompts
      prompts = {
        Explain = {
          prompt = '/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.',
        },
        Review = {
          prompt = '/COPILOT_REVIEW Review the selected code.',
          callback = function(response, source)
            -- Custom callback for review
            vim.notify('Code review complete!', vim.log.levels.INFO)
          end,
        },
        Fix = {
          prompt = '/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.',
        },
        Optimize = {
          prompt = '/COPILOT_GENERATE Optimize the selected code to improve performance and readability.',
        },
        Docs = {
          prompt = '/COPILOT_GENERATE Please add documentation comments to the selected code.',
        },
        Tests = {
          prompt = '/COPILOT_GENERATE Please generate tests for my code.',
        },
        FixDiagnostic = {
          prompt = 'Please assist with the following diagnostic issue in file:',
          selection = require('CopilotChat.select').diagnostics,
        },
        Commit = {
          prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
          selection = require('CopilotChat.select').gitdiff,
        },
        CommitStaged = {
          prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
          selection = function(source)
            return require('CopilotChat.select').gitdiff(source, true)
          end,
        },
        Refactor = {
          prompt = '/COPILOT_GENERATE Please refactor the selected code to improve its clarity and readability.',
        },
        BetterNamings = {
          prompt = 'Please provide better names for the following variables and functions.',
        },
        Summarize = {
          prompt = 'Please summarize the following text.',
        },
        Spelling = {
          prompt = 'Please correct any grammar and spelling errors in the following text.',
        },
        Wording = {
          prompt = 'Please improve the grammar and wording of the following text.',
        },
        Concise = {
          prompt = 'Please rewrite the following text to make it more concise.',
        },
      },
    },
    config = function(_, opts)
      local chat = require('CopilotChat')
      local select = require('CopilotChat.select')

      -- Custom system prompts
      opts.prompts.BetterNamings.selection = select.buffer

      chat.setup(opts)

      -- Create user commands
      vim.api.nvim_create_user_command('CopilotChatVisual', function(args)
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = '*', range = true })

      vim.api.nvim_create_user_command('CopilotChatBuffer', function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = '*', range = true })

      -- Set up CMP integration if available
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-*',
        callback = function()
          vim.opt_local.relativenumber = true
          vim.opt_local.number = true

          -- Get current filetype and set it to markdown if the copilot chat buffer
          local ft = vim.bo.filetype
          if ft == 'copilot-chat' then
            vim.bo.filetype = 'markdown'
          end
        end,
      })
    end,
  },
}
