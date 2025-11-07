return {
  {
    'kevinhwang91/nvim-ufo',
    event = 'BufReadPost',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      local ufo = require 'ufo'

      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ('   %d lines'):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        if targetWidth < 0 then
          targetWidth = 0
        end
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, chunk[2] })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. string.rep(' ', targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'Comment' })
        return newVirtText
      end

      ufo.setup {
        provider_selector = function(_, filetype)
          local lsp_with_folds = { python = true, rust = true }
          if lsp_with_folds[filetype] then
            return { 'lsp', 'indent' }
          end
          return { 'treesitter', 'indent' }
        end,
        close_fold_kinds_for_ft = {
          default = { 'imports', 'comment' },
        },
        fold_virt_text_handler = handler,
      }

      vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'UFO: open all folds' })
      vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'UFO: close all folds' })
      vim.keymap.set('n', 'zr', ufo.openFoldsExceptKinds, { desc = 'UFO: open folds except kinds' })
      vim.keymap.set('n', 'zm', ufo.closeFoldsWith, { desc = 'UFO: close folds with kind' })
      vim.keymap.set('n', 'zp', function()
        local pending = ufo.peekFoldedLinesUnderCursor()
        if not pending then
          vim.lsp.buf.hover()
        end
      end, { desc = 'UFO: peek fold' })
    end,
  },
}
