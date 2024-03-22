local M = {}

M.keys = {
  {
    "<leader>sw",
    function()
      require("spectre").open_visual({
        cwd = Lonard.root.get(),
        select_word = true,
      })
    end,
    desc = "spectre search » current word [root]",
  },
  {
    "<leader>sw",
    function()
      require("spectre").open_visual({
        cwd = Lonard.root.get(),
      })
    end,
    desc = "spectre search » selected words [root]",
    mode = { "v" },
  },
  {
    "<leader>sW",
    function()
      require("spectre").open_visual({
        cwd = vim.loop.cwd(),
        select_word = true,
      })
    end,
    desc = "spectre search » current word [cwd]",
  },
  {
    "<leader>sd",
    function()
      require("spectre").open_file_search({ select_word = true })
    end,
    desc = "spectre search » current word [doc]",
  },
}

M.opts = {
  opts = { open_cmd = "noswapfile new" },
  mapping = {
    ["run_current_replace"] = {
      map = "<Leader>r",
      cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
      desc = "SPECTRE exec » REPLACE current line  ",
    },
    ["run_replace"] = {
      map = "<leader>R",
      cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
      desc = "SPECTRE exec » REPLACE all  ",
    },
    ["send_to_qf"] = {
      map = "<leader>q",
      cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
      desc = "SPECTRE exec » SEND all to quickfix ",
    },
  },
}

return M
