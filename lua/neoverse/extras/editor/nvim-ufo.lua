local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" … 󰁂 %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    },
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async", "luukvbaal/statuscol.nvim" },
    event = { "LazyFile", "BufWinEnter" },
    -- stylua: ignore
    keys = {
      {
        "zR",
        function() require("ufo").openAllFolds() end,
        desc = "UFO » Open all folds",
      },
      {
        "zr",
        function() require("ufo").openFoldsExceptKinds() end,
        desc = "UFO » Open folds excepts kinds",
      },
      {
        "zM",
        function() require("ufo").closeAllFolds() end,
        desc = "UFO » Close all folds",
      },
      {
        "[z",
        function()
          require("ufo").goPreviousClosedFold()
          vim.schedule(function() require("ufo").peekFoldedLinesUnderCursor() end)
        end,
        desc = "UFO » Peek prev fold",
      },
      {
        "]z",
        function()
          require("ufo").goNextClosedFold()
          vim.schedule(function() require("ufo").peekFoldedLinesUnderCursor() end)
        end,
        desc = "UFO » Peek next fold",
      },
    },

    opts = {
      provider_selector = function(_, filetype, _)
        return ({
          typescript = { "treesitter", "indent" },
          html = { "treesitter", "indent" },
          python = { "indent" },
          vim = "indent",
          git = "",
          Outline = "",
        })[filetype]
      end,
      -- open_fold_hl_timeout = 150,
      fold_virt_text_handler = handler,
      preview = {
        win_config = {
          border = vim.g.neo_transparent and "single" or "none",
          winhighlight = "Normal:Folded",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "gg",
          jumpBot = "G",
        },
      },
    },
  },
}
