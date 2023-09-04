-- TODO: set this to universal options
local activated = true

return {
  "utilyre/barbecue.nvim",
  event = "VeryLazy",
  name = "barbecue",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>ub",
      function()
        local lvl = activated and vim.log.levels.INFO or vim.log.levels.WARN
        local status = activated and "Enabled" or "Disabled"
        require("barbecue.ui").toggle(activated)
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
    show_basename = true,
    show_modified = true,
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
      group = vim.api.nvim_create_augroup("barbecue.updater", {}),
      callback = function()
        if activated then
          require("barbecue.ui").update()
        end
      end,
    })
  end,
}
