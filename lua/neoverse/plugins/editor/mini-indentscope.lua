---@type LazySpec
return {
  "echasnovski/mini.indentscope",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    symbol = "│",
    draw = { delay = 500 },
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
