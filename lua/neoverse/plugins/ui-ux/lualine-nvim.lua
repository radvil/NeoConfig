local function fg(name)
  return function()
    ---@type {foreground?:number}?
    local hl = vim.api.nvim_get_hl(vim.api.nvim_get_hl_id_by_name(name), {})
    return hl and hl.foreground and {
      fg = string.format("#%06x", hl.foreground),
    }
  end
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    local Config = require("neoverse.config")
    local State = require("neoverse.state")

    require("lualine").setup({
      options = {
        theme = "auto",
        globalstatus = true,
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
        -- lualine_b = { "branch" },
        lualine_b = {
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
            path = 0,
            symbols = {
              modified = "💋",
              readonly = " ",
              unnamed = "",
            },
          },
        },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = Config.icons.Diagnostics.Error,
              warn = Config.icons.Diagnostics.Warn,
              info = Config.icons.Diagnostics.Info,
              hint = Config.icons.Diagnostics.Hint,
            },
          },
          {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return package.loaded["nvim-navic"] and require("nvim-navic").is_available() and not State.barbecue
            end,
          },
        },
        lualine_x = {},
        lualine_y = {
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
              added = Config.icons.Git.Added .. " ",
              modified = Config.icons.Git.Modified .. " ",
              removed = Config.icons.Git.Deleted .. " ",
            },
          },
        },
        lualine_z = {
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
      },
    })
  end,
}
