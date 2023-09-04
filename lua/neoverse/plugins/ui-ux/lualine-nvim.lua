local function fg(name)
  return function()
    ---@type {foreground?:number}?
    ---@diagnostic disable-next-line: undefined-field
    local hl = vim.api.nvim_get_hl_by_name(name, true)
    return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
  end
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    local config = require("neoverse.config")
    local state = require("neoverse.state")

    require("lualine").setup({
      options = {
        theme = config.statusline.theme,
        globalstatus = config.statusline.global,
        disabled_filetypes = {
          statusline = {
            "dashboard",
            "alpha",
          },
        },
      },
      extensions = { "neo-tree", "lazy" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = config.icons.Diagnostics.Error,
              warn = config.icons.Diagnostics.Warn,
              info = config.icons.Diagnostics.Info,
              hint = config.icons.Diagnostics.Hint,
            },
          },
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = {
              left = 1,
              right = 0,
            },
          },
          {
            "filename",
            path = config.statusline.global and state.barbecue and 1 or 0,
            symbols = {
              modified = "💋",
              readonly = " ",
              unnamed = "",
            },
          },
          {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return package.loaded["nvim-navic"] and require("nvim-navic").is_available() and not state.barbecue
            end,
          },
        },
        lualine_x = {
          {
            function()
              return require("noice").api.status.command.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
            color = fg("Statement"),
          },
          {
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = fg("Constant"),
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = fg("Special"),
          },
          {
            "diff",
            symbols = {
              added = config.icons.Git.Added .. " ",
              modified = config.icons.Git.Modified .. " ",
              removed = config.icons.Git.Deleted .. " ",
            },
          },
        },
        lualine_y = {
          {
            "progress",
            separator = " ",
            padding = {
              left = 1,
              right = 0,
            },
          },
          {
            "location",
            padding = {
              left = 0,
              right = 1,
            },
          },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
    })
  end,
}
