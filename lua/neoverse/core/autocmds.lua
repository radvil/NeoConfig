local Utils = require("neoverse.utils")

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = Utils.create_augroup("checktime"),
  command = "checktime",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = Utils.create_augroup("highlight_on_yanked"),
  callback = function()
    vim.highlight.on_yank({ timeout = 99 })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = Utils.create_augroup("goto_last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = Utils.create_augroup("on_popup_ui_opened"),
  pattern = {
    "neo-tree-popup",
    "spectre_panel",
    "DressingInput",
    "flash_prompt",
    "cmp_menu",
    "NvimTree",
    "neo-tree",
    "WhichKey",
    "lspinfo",
    "Outline",
    "notify",
    "prompt",
    "mason",
    "noice",
    "lazy",
    "help",
    "qf",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.wo.foldcolumn = "0"
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = Utils.create_augroup("wrap_and_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = Utils.create_augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})
