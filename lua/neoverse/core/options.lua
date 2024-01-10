vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.wrap = false
vim.opt.autowrite = true
vim.opt.confirm = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 7
vim.opt.shiftround = true
vim.opt.shiftwidth = 2

vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
vim.opt.laststatus = 3 -- global statusline = 3
vim.opt.timeoutlen = 400
vim.opt.winwidth = 7
vim.opt.winminwidth = 5
vim.opt.equalalways = false
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.pumblend = 0
vim.opt.pumheight = 10
vim.opt.smoothscroll = true

vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.wildmode = "longest:full,full"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.inccommand = "nosplit"
vim.opt.splitkeep = "screen"
vim.opt.signcolumn = "yes"
vim.opt.foldcolumn = "1"
vim.opt.clipboard = ""
vim.opt.mouse = "a"

vim.opt.spelllang = { "en" }
vim.opt.fillchars = {
  foldclose = "",
  foldopen = "",
  foldsep = " ",
  diff = "/",
  fold = " ",
  eob = " ",
}

vim.opt.shortmess:append({
  W = true,
  I = true,
  c = true,
})

vim.opt.sessionoptions = {
  "tabpages",
  "buffers",
  "winsize",
  "curdir",
  "folds",
}

vim.g.markdown_recommended_style = 0

if vim.g.neovide then
  ---@type "railgun" | "torpedo" | "pixiedust" | "sonicboom" | "ripple" | "wireframe"
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_hide_mouse_when_typing = false
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_transparency = 1 -- 0.87
  vim.opt.guifont = { "JetbrainsMono Nerd Font", ":h7.5" }
end

-- NeoVerse global options
vim.g.neo_autoformat = true
vim.g.neo_transparent = not vim.g.neovide
vim.g.neo_autocomplete = true
vim.g.neo_autopairs = true
vim.g.neo_winborder = vim.g.neo_transparent and "rounded" or "none"

-- NeoVerse root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.neo_root_spec = { "lsp", { ".git", "lua" }, "cwd" }
