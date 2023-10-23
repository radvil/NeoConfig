require("neoverse.utils").debug("Loading autocommands...")

local function augroup(name)
  return vim.api.nvim_create_augroup("nvmini_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_on_yanked"),
  callback = function()
    vim.highlight.on_yank({ timeout = 99 })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("goto_last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_<q>"),
  pattern = {
    "neo-tree-popup",
    "spectre_panel",
    "DressingInput",
    "flash_prompt",
    "cmp_menu",
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
    vim.keymap.set("n", "q", ":close<cr>", {
      buffer = event.buf,
      silent = true,
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_and_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- -- HACK: re-caclulate folds when entering a buffer through Telescope
-- -- @see https://github.com/nvim-telescope/telescope.nvim/issues/699
-- vim.api.nvim_create_autocmd("BufEnter", {
--   group = augroup("fix_folds"),
--   callback = function()
--     if vim.opt.foldmethod:get() == "expr" then
--       vim.schedule(function()
--         vim.opt.foldmethod = "expr"
--       end)
--     end
--   end,
-- })
