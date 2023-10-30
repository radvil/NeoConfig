local Utils = require("neoverse.utils")

-- reset
Utils.map({ "n", "x", "v" }, "<nL>", "<nop>")
Utils.map("", "<c-z>", ":undo<cr>", { nowait = true })
Utils.map("n", "Q", "q", { nowait = true, desc = "Toggle recording" })
Utils.map("n", "<a-q>", "<nop>")
Utils.map("n", "q", "<nop>")

-- base
Utils.map("v", "<", "<gv", { desc = "Indent left" })
Utils.map("v", ">", ">gv", { desc = "Indent right" })
Utils.map("n", "U", "<c-r>", { nowait = true, desc = "Redo" })
Utils.map("n", "ZZ", ":qa<cr>", { nowait = true, desc = "Quit" })
Utils.map("n", "<a-cr>", "o<esc>", { desc = "Add one line down" })
Utils.map("i", "<c-d>", "<del>", { desc = "Delete next char" })
Utils.map("i", "<c-h>", "<left>", { desc = "Shift one char left" })
Utils.map("i", "<c-l>", "<right>", { desc = "Shift one char right" })
Utils.map({ "i", "c" }, "<a-bs>", "<esc>ciw", { nowait = true, desc = "Delete backward" })
Utils.map({ "i", "c" }, "<a-i>", "<space><left>", { desc = "Tab backward" })
Utils.map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear hlsearch" })
Utils.map({ "n", "x", "v" }, "ga", "<esc>ggVG", { nowait = true, desc = "Select all" })
Utils.map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
Utils.map({ "n", "x", "o" }, "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })

-- stylua: ignore start

-- formatting
Utils.map({ "n", "v" }, "<leader>cf", function() Utils.format({ force = true }) end, { desc = "Code » Format document" })
Utils.map("n", "<leader>uf", function() Utils.format.toggle() end, { desc = "Toggle » Auto format (global)" })
Utils.map("n", "<leader>uF", function() Utils.format.toggle(true) end, { desc = "Toggle » Auto format (buffer)" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
Utils.map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Code » Line Diagnostics" })
Utils.map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
Utils.map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
Utils.map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
Utils.map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
Utils.map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
Utils.map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- clipboard
if vim.opt.clipboard ~= "unnamedplus" then
  local opt = function(desc) return { nowait = true, desc = string.format("System clipboard » %s", desc) } end
  Utils.map({ "n", "o", "x", "v" }, "gy", '"+y', opt("Yank"))
  Utils.map({ "n", "o", "x", "v" }, "gp", '"+p', opt("Paste after cursor"))
  Utils.map("n", "gY", '"+y$', opt("Yank line"))
  Utils.map("n", "gP", '"+P', opt("Paste before cursor"))
end

-- Clear search, diff update and redraw
Utils.map( "n", "<leader>ur", "<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>", { desc = "Redraw / update UI" })

-- swap lines
Utils.map("n", "<A-k>", ":m .-2<cr>==", { desc = "Swap current line up" })
Utils.map("n", "<A-j>", ":m .+1<cr>==", { desc = "Swap current line down" })
Utils.map("i", "<A-j>", "<esc>:m .+1<cr>==gi", { desc = "Swap current line down" })
Utils.map("i", "<A-k>", "<esc>:m .-2<cr>==gi", { desc = "Swap current line up" })
Utils.map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Swap selected lines up" })
Utils.map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Swap selected lines down" })

-- windows
Utils.map("n", "<leader>ww", "<c-w>p", { desc = "window » last used" })
Utils.map("n", "<leader>wd", "<c-w>c", { desc = "window » delete current" })
if not Utils.lazy_has("smart-splits.nvim") then
  Utils.map("n", "<c-h>", "<c-w>h", { remap = true, desc = "Window » Navigate left" })
  Utils.map("n", "<c-j>", "<c-w>j", { remap = true, desc = "Window » Navigate down" })
  Utils.map("n", "<c-k>", "<c-w>k", { remap = true, desc = "Window » Navigate up" })
  Utils.map("n", "<c-l>", "<c-w>l", { remap = true, desc = "Window » Navigate right" })
  Utils.map("n", "<c-up>", ":resize +2<cr>", { desc = "Window » Height++" })
  Utils.map("n", "<c-down>", ":resize -2<cr>", { desc = "Window » Height--" })
  Utils.map("n", "<c-left>", ":vertical resize -2<cr>", { desc = "Window » Width--" })
  Utils.map("n", "<c-right>", ":vertical resize +2<cr>", { desc = "Window » Width++" })
end

---buffers
Utils.map("n", "<leader>`", "<cmd>e #<cr>", { desc = "buffer » switch to other" })
Utils.map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "buffer » switch to other" })
Utils.map("n", "[b", ":bprevious<cr>", { desc = "buffer » previous" })
Utils.map("n", "]b", ":bnext<cr>", { desc = "buffer » next" })
if not Utils.lazy_has("bufferline.nvim") then
  Utils.map("n", "<a-[>", ":bprevious<cr>", { desc = "buffer » previous" })
  Utils.map("n", "<a-]>", ":bnext<cr>", { desc = "buffer » next" })
end
if not Utils.lazy_has("mini.bufremove") then
  Utils.map("n", "<leader>bd", ":bdelete<cr>", { desc = "buffer » delete current" })
  Utils.map("n", "<Leader>bD", ":bufdo bdelete<cr>", { desc = "buffer » delete all" })
end

Utils.map("n", "<leader>us", function() Utils.toggle.option("spell") end, { desc = "Toggle » Spell" })
Utils.map("n", "<leader>uw", function() Utils.toggle.option("wrap") end, { desc = "Toggle » Word wrap" })
Utils.map("n", "<leader>uc", function() Utils.toggle.option("cursorline") end, { desc = "Toggle » Cursor line" })
Utils.map("n", "<leader>un", function() Utils.toggle.number() end, { desc = "Toggle » Line numbers" })
Utils.map("n", "<leader>ux", function() Utils.toggle.diagnostics() end, { desc = "Toggle » Diagnostics" })

---floating terminal
local ft = function(cmd, root)
  local label = (type(cmd) == "table" and cmd[1] or cmd) or "Terminal"
  local opt = { size = { width = 0.6, height = 0.7 }, title = "  " .. label, title_pos = "right" }
  opt.border = vim.g.neo_transparent and "single" or "none"
  if root then opt.cwd = Utils.root.get() end
  Utils.terminal.open(cmd, opt)
end
Utils.map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
Utils.map("t", [[<c-\>]], "<cmd>close<cr>", { desc = "floating terminal » close [rwd]" })
Utils.map("n", [[<c-\>]], function() ft(nil, true) end, { desc = "floating terminal » open [rwd]" })
Utils.map("n", "<leader>fT", function() ft(nil) end, { desc = "floating terminal » open [cwd]" })
Utils.map("n", "<leader>ft", function() ft(nil, true) end, { desc = "floating terminal » open [rwd]" })
Utils.map("n", "<leader>tH", function() ft("btop") end, { desc = "floating terminal » open htop/btop" })
Utils.map("n", "<leader>tP", function() ft({ "ping", "9.9.9.9" }) end, { desc = "floating terminal » ping test" })

---lazygit
local lz = function(opts)
  Utils.terminal.open({ "lazygit" }, {
    unpack(opts or {}),
    title_pos = "right",
    title = "  LazyGit ",
    border = "single",
    ctrl_hjkl = false,
    esc_esc = false,
  })
end
Utils.map("n", "<leader>gg", function() lz() end, { desc = "lazygit [cwd]" })
Utils.map("n", "<leader>gG", function() lz({ cwd = Utils.root.get() }) end, { desc = "lazygit [rwd]" })

--stylua: ignore end

Utils.map("n", "<leader>uH", function()
  local next = vim.b.ts_highlight and "stop" or "start"
  vim.treesitter[next]()
  if next == "stop" then
    Utils.warn("Highlight stopped!", { title = "Treesitter Highlight" })
  else
    Utils.info("Highlight started!", { title = "Treesitter Highlight" })
  end
end, { desc = "Toggle » Treesitter Highlight" })
