return {
  "stevearc/oil.nvim",

  deactivate = function()
    vim.cmd([[Oil close]])
  end,

  keys = {
    {
      "<Leader>fe",
      function()
        require("oil").open()
      end,
      desc = "File Explorer » Open (pwd)",
    },
    {
      "<Leader>fE",
      function()
        require("oil").open(vim.loop.cwd())
      end,
      desc = "File Explorer » Open (cwd)",
    },
  },

  opts = {
    delete_to_trash = true,
    restore_win_options = true,
    trash_command = "trash-put",
    skip_confirm_for_simple_edits = false,
    prompt_save_on_select_new_entry = true,
    default_file_explorer = true,
    buf_options = { buflisted = true },
    use_default_keymaps = false,
    cleanup_delay_ms = 500,
    view_options = {
      show_hidden = true,
    },
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
