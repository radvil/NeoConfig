return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",

  keys = {
    {
      "<Leader>wz",
      ":ZenMode<cr>",
      desc = "Window » Zen Mode Toggle",
    },
    {
      "<Leader>e",
      "<cmd>NeoZenToggleRoot<cr>",
      desc = "File Tree » Toggle (root)",
    },
    {
      "<Leader>E",
      "<cmd>NeoZenToggleCwd<cr>",
      desc = "File Tree » Toggle (cwd)",
    },
  },

  opts = {
    window = {
      backdrop = 0.95,
      width = 120,
      height = 1,
      options = {
        foldcolumn = "0",
        list = true, -- disable whitespace chars
      },
    },
  },

  init = function()
    local Utils = require("neoverse.utils")

    if Utils.call("neo-tree") and Utils.call("oil") then
      vim.api.nvim_create_user_command("NeoZenToggleRoot", function()
        if require("zen-mode.view").is_open() then
          if require("oil.util").is_oil_bufnr(0) then
            require("oil").close()
          else
            require("oil").open()
          end
        else
          require("neo-tree.command").execute({
            dir = Utils.root.get(),
            toggle = true,
          })
        end
      end, { desc = "File Tree » Toggle (root)" })

      vim.api.nvim_create_user_command("NeoZenToggleCwd", function()
        if require("zen-mode.view").is_open() then
          if require("oil.util").is_oil_bufnr(0) then
            require("oil").close()
          else
            require("oil").open(vim.loop.cwd())
          end
        else
          require("neo-tree.command").execute({
            dir = Utils.root.get(),
            toggle = true,
          })
        end
      end, { desc = "File Tree » Toggle (cwd)" })
    end
  end,
}
