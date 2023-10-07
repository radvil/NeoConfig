---@type LazySpec
return {
  "echasnovski/mini.indentscope",
  event = { "BufReadPre", "BufNewFile" },

  keys = {
    {
      "<leader>uI",
      function()
        vim.g.miniindentscope_disable = not vim.g.miniindentscope_disable
        if vim.g.miniindentscope_disable then
          require("lazy.core.util").warn("Disabled", { title = "Indentscope" })
        else
          require("lazy.core.util").info("Enabled", { title = "Indentscope" })
        end
      end,
      desc = "Toggle » Mini Indentscope",
    },
  },

  opts = {
    -- symbol = "┊",
    symbol = "│",
    draw = { delay = 300 },
    options = { try_as_border = true },
    mappings = {
      goto_top = "[i",
      goto_bottom = "]i",
      object_scope = "ii",
      object_scope_with_border = "ai",
    },
  },

  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "DiffviewFiles",
        "fugitiveblame",
        "NeogitStatus",
        "Dashboard",
        "dashboard",
        "MundoDiff",
        "gitcommit",
        "NvimTree",
        "neo-tree",
        "fugitive",
        "Outline",
        "Trouble",
        "prompt",
        "dirbuf",
        "alpha",
        "Mundo",
        "edgy",
        "help",
        "dbui",
        "qf",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
