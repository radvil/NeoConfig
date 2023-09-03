return {
  "echasnovski/mini.splitjoin",
  event = "BufReadPre",
  config = function()
    require("mini.splitjoin").setup({
      mappings = {
        toggle = "",
        split = "",
        join = "",
      },
    })
    vim.keymap.set("n", "<leader>uj", function()
      require("mini.splitjoin").toggle()
    end, { desc = "Toggle » Split/join" })
  end,
}
