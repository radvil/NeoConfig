---@type LazySpec
return {
  "echasnovski/mini.surround",
  event = "BufReadPre",
  config = function(_, opts)
    opts.silent = true
    opts.respect_selectwon_type = true
    opts.mappings = {
      add = "so",
      delete = "sd",
      replace = "sc",
      find_left = "[s",
      find = "]s",
      highlight = "sh",
      update_n_lines = "",
    }
    vim.keymap.set("n", "s", "<nop>", { remap = true })
    require("mini.surround").setup(opts)
  end,
}
