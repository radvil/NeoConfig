---@type LazySpec
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  enabled = function()
    return require("neoverse.config").dashboard.enabled
      and require("neoverse.config").dashboard.provider == "alpha-nvim"
  end,
  dependencies = { "folke/persistence.nvim" },
  opts = function()
    local db = require("alpha.themes.dashboard")
    local logo = [[
MMMMMMMMMMMMMMMMM.                             MMMMMMMMMMMMMMMMMM
 `MMMMMMMMMMMMMMMM           M\  /M           MMMMMMMMMMMMMMMM'
   `MMMMMMMMMMMMMMM          MMMMMM          MMMMMMMMMMMMMMM'
     MMMMMMMMMMMMMMM-_______MMMMMMMM_______-MMMMMMMMMMMMMMM
      MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
      MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
     .MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.
               `MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM'
                      `MMMMMMMMMMMMMMMMMM'
                          `MMMMMMMMMM'
                             MMMMMM 
                              MMMM
                               MM
]]
    db.section.header.val = vim.split(logo, "\n")
    db.section.buttons.val = {
      db.button("s", "🕗" .. " Resume session", [[:lua require('persistence').load()<cr>]]),
      db.button("o", "📁" .. " Recent files", ":Telescope oldfiles<cr>"),
      db.button("f", "🔭" .. " Find files", ":Telescope find_files<cr>"),
      db.button("w", "🔎" .. " Search words", ":Telescope live_grep<cr>"),
      db.button("t", "📌" .. " List all tasks", ":TodoTelescope<cr>"),
      db.button("d", "🔧" .. " Config files", ":Dotfiles<cr>"),
      db.button("p", "📎" .. " Manage plugins", ":Lazy<cr>"),
      db.button("q", "⭕" .. " Quit session", ":qa<cr>"),
    }
    for _, button in ipairs(db.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    db.section.header.opts.hl = "AlphaHeader"
    db.section.buttons.opts.hl = "AlphaButtons"
    db.section.footer.opts.hl = "AlphaFooter"
    db.opts.layout[1].val = 3
    return db
  end,

  config = function(_, db)
    require("alpha").setup(db.opts)

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        db.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " libs in " .. ms .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
