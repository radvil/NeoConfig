---@diagnostic disable: missing-fields
-- reset
Lonard.map({ "n", "x", "v" }, "<nL>", "<nop>")
-- Lonard.map("", "<c-z>", ":undo<cr>", { nowait = true })
Lonard.map("n", "Q", "q", { nowait = true, desc = "toggle recording" })
-- Lonard.map("n", "<a-q>", "<nop>")
Lonard.map("n", "q", "<nop>")

-- base
Lonard.map("v", "<", "<gv", { desc = "indent left" })
Lonard.map("v", ">", ">gv", { desc = "indent right" })
Lonard.map("n", "U", "<c-r>", { nowait = true, desc = "redo" })
Lonard.map("n", "ZZ", ":conf qa<cr>", { nowait = true, desc = "quit all +confirmation" })
Lonard.map("n", "<a-cr>", "o<esc>", { desc = "add one line down" })
Lonard.map("i", "<c-d>", "<del>", { desc = "delete next char" })
Lonard.map("i", "<c-h>", "<left>", { desc = "shift one char left" })
Lonard.map("i", "<c-l>", "<right>", { desc = "shift one char right" })
Lonard.map({ "i", "c" }, "<a-bs>", "<esc>ciw", { nowait = true, desc = "delete backward" })
Lonard.map({ "i", "c" }, "<a-i>", "<space><left>", { desc = "tab backward" })
Lonard.map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "clear hlsearch" })
Lonard.map({ "n", "x", "v" }, "ga", "<esc>ggVG", { nowait = true, desc = "select all" })
Lonard.map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "next search result" })
Lonard.map({ "n", "x", "o" }, "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "prev search result" })
Lonard.map({ "n", "i", "x", "v", "s", "o", "c" }, "<a-q>", "<esc>", { desc = "[esc]" })

-- stylua: ignore start

-- formatting
Lonard.map({ "n", "v" }, "<leader>cf", function() Lonard.format({ force = true }) end, { desc = "code » format document" })
Lonard.map("n", "<leader>uf", function() Lonard.format.toggle() end, { desc = "toggle » auto format (global)" })
Lonard.map("n", "<leader>uF", function() Lonard.format.toggle(true) end, { desc = "toggle » auto format (buffer)" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
Lonard.map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "code » line diagnostics" })
Lonard.map("n", "]d", diagnostic_goto(true), { desc = "next diagnostic" })
Lonard.map("n", "[d", diagnostic_goto(false), { desc = "prev diagnostic" })
Lonard.map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "next error" })
Lonard.map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "prev error" })
Lonard.map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "next warning" })
Lonard.map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "prev warning" })

-- clipboard
if vim.opt.clipboard ~= "unnamedplus" then
  local opt = function(desc) return { nowait = true, desc = string.format("System clipboard » %s", desc) } end
  Lonard.map({ "n", "o", "x", "v" }, "gy", '"+y', opt("yank"))
  Lonard.map({ "n", "o", "x", "v" }, "gp", '"+p', opt("paste after cursor"))
  Lonard.map("n", "gY", '"+y$', opt("yank line"))
  Lonard.map("n", "gP", '"+P', opt("paste before cursor"))
end

-- Clear search, diff update and redraw
Lonard.map( "n", "<leader>ur", "<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>", { desc = "redraw / update ui" })

-- swap lines
Lonard.map("n", "<A-k>", ":m .-2<cr>==", { desc = "swap current line up" })
Lonard.map("n", "<A-j>", ":m .+1<cr>==", { desc = "swap current line down" })
Lonard.map("i", "<A-j>", "<esc>:m .+1<cr>==gi", { desc = "swap current line down" })
Lonard.map("i", "<A-k>", "<esc>:m .-2<cr>==gi", { desc = "swap current line up" })
Lonard.map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "swap selected lines up" })
Lonard.map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "swap selected lines down" })

-- windows
Lonard.map("n", "<leader>ww", "<c-w>p", { desc = "window » last used" })
Lonard.map("n", "<leader>wd", "<c-w>c", { desc = "window » delete current" })
if not Lonard.lazy_has("smart-splits.nvim") then
  Lonard.map("n", "<c-h>", "<c-w>h", { remap = true, desc = "window » navigate left" })
  Lonard.map("n", "<c-j>", "<c-w>j", { remap = true, desc = "window » navigate down" })
  Lonard.map("n", "<c-k>", "<c-w>k", { remap = true, desc = "window » navigate up" })
  Lonard.map("n", "<c-l>", "<c-w>l", { remap = true, desc = "window » navigate right" })
  Lonard.map("n", "<c-up>", ":resize +2<cr>", { desc = "window » height++" })
  Lonard.map("n", "<c-down>", ":resize -2<cr>", { desc = "window » height--" })
  Lonard.map("n", "<c-left>", ":vertical resize -2<cr>", { desc = "window » width--" })
  Lonard.map("n", "<c-right>", ":vertical resize +2<cr>", { desc = "window » width++" })
end

---buffers
Lonard.map("n", "<leader>`", "<cmd>e #<cr>", { desc = "go to recent buffer" })
Lonard.map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "go to recent [b]uffer" })
Lonard.map("n", "[b", ":bprevious<cr>", { desc = "buffer » previous" })
Lonard.map("n", "]b", ":bnext<cr>", { desc = "buffer » next" })
if not Lonard.lazy_has("bufferline.nvim") then
  Lonard.map("n", "<a-[>", ":bprevious<cr>", { desc = "buffer » previous" })
  Lonard.map("n", "<a-]>", ":bnext<cr>", { desc = "buffer » next" })
end
if not Lonard.lazy_has("mini.bufremove") then
  Lonard.map("n", "<leader>bd", ":bdelete<cr>", { desc = "buffer » delete current" })
  Lonard.map("n", "<Leader>bD", ":bufdo bdelete<cr>", { desc = "buffer » delete all" })
end

-- quickfix
Lonard.map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
Lonard.map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

Lonard.map("n", "<leader>us", function() Lonard.toggle.option("spell") end, { desc = "toggle » spell" })
Lonard.map("n", "<leader>uw", function() Lonard.toggle.option("wrap") end, { desc = "toggle » word wrap" })
Lonard.map("n", "<leader>uc", function() Lonard.toggle.option("cursorline") end, { desc = "toggle » cursor line" })
Lonard.map("n", "<leader>un", function() Lonard.toggle.number() end, { desc = "toggle » line numbers" })
Lonard.map("n", "<leader>ux", function() Lonard.toggle.diagnostics() end, { desc = "toggle » diagnostics" })
Lonard.map("n", "<leader>ub", function() Lonard.toggle("background", false, { "light", "dark" }) end, { desc = "toggle » background" })

---floating terminal
local ft = function(cmd, root)
  local label = (type(cmd) == "table" and cmd[1] or cmd) or "Terminal"
  local opt = { size = { width = 0.8, height = 0.8 }, title = "  " .. label, title_pos = "right" }
  if root then opt.cwd = Lonard.root.get() end
  Lonard.terminal.open(cmd, opt)
end
Lonard.map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
Lonard.map("n", [[<c-\>]], function() ft(nil) end, { desc = [[open term[\]nal (cwd)]] })
Lonard.map("t", [[<c-\>]], "<cmd>fclose<cr>", { desc = [[close term[\]nal (cwd)]]})
Lonard.map("n", "<leader>tN", function() ft(nil) end, { desc = "[N]ew terminal (cwd)" })
Lonard.map("n", "<leader>tn", function() ft(nil, true) end, { desc = "[n]ew terminal (root)" })
Lonard.map("n", "<leader>tH", function() ft("btop") end, { desc = "run [H]top" })
Lonard.map("n", "<leader>tP", function() ft({ "ping", "9.9.9.9" }) end, { desc = "run [P]ing test" })

---lazygit
Lonard.map("n", "<leader>gg", function() Lonard.lazygit({ cwd = Lonard.root.git() }) end, { desc = "open lazy[g]it (root)" })
Lonard.map("n", "<leader>gG", function() Lonard.lazygit() end, { desc = "lazy[G]it (cwd)" })
Lonard.map("n", "<leader>gH", function()
  local git_path = vim.api.nvim_buf_get_name(0)
  Lonard.lazygit({ args = { "lazygit", "-f", vim.trim(git_path) } })
end, { desc = "lazygit file [H]istory" })
Lonard.map("n", "<leader>gb", Lonard.lazygit.blame_line, { desc = "[g]it [b]lame line" })

--stylua: ignore end

Lonard.map("n", "<leader>uH", function()
  local next = vim.b.ts_highlight and "stop" or "start"
  vim.treesitter[next]()
  if next == "stop" then
    Lonard.warn("Highlight stopped!", { title = "treesitter highlight" })
  else
    Lonard.info("Highlight started!", { title = "treesitter highlight" })
  end
end, { desc = "toggle » treesitter highlight" })
