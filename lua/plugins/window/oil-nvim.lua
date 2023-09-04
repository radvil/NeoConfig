return {
  "stevearc/oil.nvim",

  deactivate = function()
    vim.cmd([[Oil close]])
  end,

  keys = {
    {
      "<Leader>fe",
      function()
        require("oil").toggle_float()
      end,
      desc = "Float » Toggle Explorer (pwd)",
    },
    {
      "<Leader>fE",
      function()
        require("oil").toggle_float(vim.loop.cwd())
      end,
      desc = "Float » Toggle Explorer (cwd)",
    },
  },

  opts = {
    delete_to_trash = false,
    restore_win_options = true,
    trash_command = "trash-put",
    skip_confirm_for_simple_edits = false,
    prompt_save_on_select_new_entry = true,
    default_file_explorer = true,
    buf_options = { buflisted = false },
    use_default_keymaps = false,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["q"] = "actions.close",
      ["<cr>"] = "actions.select",
      ["^"] = "actions.open_cwd",
      ["H"] = "actions.toggle_hidden",
      ["gx"] = "actions.select_vsplit",
      ["gy"] = "actions.select_split",
      ["-"] = "actions.parent",
      ["K"] = "actions.preview",
      ["<leader>r"] = "actions.refresh",
    },
    win_options = {
      wrap = false,
      signcolumn = "no",
      cursorcolumn = false,
      foldcolumn = "0",
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = "n",
    },
    float = {
      padding = 2,
      max_width = 96,
      max_height = 45,
      border = "single",
      win_options = { winblend = 0 },
    },
  },
}
