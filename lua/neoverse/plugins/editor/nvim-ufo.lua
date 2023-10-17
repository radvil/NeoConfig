local activated = true

local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" ▊▊ 󰁂 %d "):format(endLnum - lnum)
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
    -- Modify nvim-lspconfig for nvim-ufo
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
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "UFO » Open all folds",
      },
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        desc = "UFO » Open folds excepts kinds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "UFO » Close all folds",
      },
      {
        "[z",
        function()
          require("ufo").goPreviousClosedFold()
          require("ufo").peekFoldedLinesUnderCursor()
        end,
        desc = "UFO » Peek prev fold",
      },
      {
        "]z",
        function()
          require("ufo").goNextClosedFold()
          require("ufo").peekFoldedLinesUnderCursor()
        end,
        desc = "UFO » Peek next fold",
      },
      {
        "<Leader>uz",
        function()
          activated = not activated
          if activated then
            vim.cmd.UfoEnable()
            vim.notify("Nvim ufo enabled!", vim.log.levels.INFO)
          else
            vim.cmd.UfoDisable()
            vim.notify("Nvim ufo disabled!", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle » Fold Marker",
      },
    },

    config = function(_, opts)
      local Config = require("neoverse.config")
      local ftMap = {
        typescript = { "treesitter", "indent" },
        html = { "treesitter", "indent" },
        python = { "indent" },
        vim = "indent",
        git = "",
        Outline = "",
      }

      ---@type UfoConfig
      local defaults = {
        provider_selector = function(_, filetype, _)
          return ftMap[filetype]
        end,
        -- open_fold_hl_timeout = 150,
        fold_virt_text_handler = handler,
        preview = {
          win_config = {
            border = Config.transparent and "single" or "none",
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
      }

      opts = vim.tbl_deep_extend("force", defaults, opts or {})
      require("ufo").setup(opts)
    end,
  },
}
