local M = {}

M.opts = function()
  local logo = [[
_____________________                              _____________________
`-._                 \           |\__/|           /                 _.-'
    \                 \          |    |          /                 /    
     \                 `-_______/      \_______-'                 /     
      /                                                          \      
     /_____________                                  _____________\     
                   `----._                    _.----'                   
                          `--.            .--'                          
                              `-.      .-'                              
                                 \    /                                 
                                  \  /                                  
                                   \/                                   
      ]]

  logo = string.rep("\n", 5) .. logo .. "\n"
  local opts = {
    theme = "doom",
    hide = {
      -- this is taken care of by lualine
      -- enabling this messes up the actual laststatus setting after loading a file
      statusline = false,
    },
    config = {
      header = vim.split(logo, "\n"),
      center = {
        {
          action = "NeoSessionRestore",
          desc = " Resume session",
          icon = "🕗",
          key = "s",
        },
        {
          action = "Telescope oldfiles",
          desc = " Recent files",
          icon = "📁",
          key = "r",
        },
        {
          action = "Telescope find_files",
          desc = " Find files",
          icon = "🔭",
          key = "f",
        },
        {
          action = "Telescope live_grep",
          desc = " Grep words",
          icon = "🔎",
          key = "w",
        },
        {
          action = "NeoNotes",
          desc = " Find notes",
          icon = "📌",
          key = "n",
        },
        {
          action = "NeoDotfiles",
          desc = " Config files",
          icon = "🔧",
          key = "d",
        },
        {
          action = "Lazy",
          desc = " Manage plugins",
          icon = "📎",
          key = "p",
        },
        {
          action = "NeoExtras",
          desc = " Manage extra",
          icon = " ",
          key = "x",
        },
        {
          action = "qa",
          desc = " Quit session",
          icon = "⭕",
          key = "q",
        },
      },
      footer = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
      end,
    },
  }

  for _, button in ipairs(opts.config.center) do
    button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
  end

  -- close Lazy and re-open when the dashboard is ready
  if vim.o.filetype == "lazy" then
    vim.cmd.close()
    vim.api.nvim_create_autocmd("User", {
      pattern = "DashboardLoaded",
      callback = function()
        require("lazy").show()
      end,
    })
  end
  return opts
end

return M
