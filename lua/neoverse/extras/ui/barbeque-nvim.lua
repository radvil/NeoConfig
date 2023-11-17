local active = true

return {
  "utilyre/barbecue.nvim",
  event = "BufReadPost",
  name = "barbecue",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>ub",
      function()
        local next = not active
        local lvl = next and vim.log.levels.INFO or vim.log.levels.WARN
        local status = next and "Enabled" or "Disabled"
        require("barbecue.ui").toggle(next)
        active = next
        vim.notify("Barbeque » " .. status, lvl)
      end,
      desc = "Toggle » Barbeque/Navic",
    },
  },
  opts = {
    context_follow_icon_color = false,
    create_autocmd = false,
    attach_navic = false,
    show_dirname = false,
    show_basename = false,
    show_modified = false,
  },
  config = function(_, opts)
    require("barbecue").setup(opts)
    vim.api.nvim_create_autocmd({
      "WinScrolled",
      "BufWinEnter",
      "CursorHold",
      "InsertLeave",
      "BufModifiedSet",
    }, {
      group = vim.api.nvim_create_augroup("NeoBarbecueUpdate", {}),
      callback = function()
        if active then
          require("barbecue.ui").update()
        end
      end,
    })
  end,
}
