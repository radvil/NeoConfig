local M = {}

M.keys = {
  {
    "<Leader>bd",
    "<Cmd>BD<Cr>",
    desc = "Buffer » Delete",
  },
  {
    "<Leader>bf",
    "<Cmd>BF<Cr>",
    desc = "Buffer » Delete (force)",
  },
  {
    "<Leader>bD",
    "<Cmd>BAD<Cr>",
    desc = "Buffer » Delete all",
  },
  {
    "<Leader>bF",
    "<Cmd>BAF<Cr>",
    desc = "Buffer » Delete all (force)",
  },
}

M.init = function()
  vim.api.nvim_create_user_command("BD", function()
    require("mini.bufremove").delete(0, false)
  end, { desc = "Delete current buffer" })

  vim.api.nvim_create_user_command("BAD", function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(bufnr) then
        require("mini.bufremove").delete(bufnr, false)
      end
    end
  end, { desc = "Delete all buffers" })

  vim.api.nvim_create_user_command("BF", function()
    require("mini.bufremove").delete(0, true)
  end, { desc = "Delete current buffer (force)" })

  vim.api.nvim_create_user_command("BAF", function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(bufnr) then
        require("mini.bufremove").delete(bufnr, true)
      end
    end
  end, { desc = "Remove all buffers (force)" })
end

return M
