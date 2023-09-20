local function generate_bufferline_hls()
  return function()
    local ctp = require("catppuccin")
    local config = require("neoverse.config")
    local C = require("catppuccin.palettes").get_palette()
    --stylua: ignore
    if not C then return {} end

    local O = ctp.options
    local active_bg = config.palette.bg2
    local inactive_bg = C.base
    local bg_highlight = C.crust
    local separator_fg = C.surface1
    local styles = { "bold", "italic" }

    local highlights = {
      -- buffers
      background = { bg = inactive_bg },
      buffer_visible = { fg = C.surface1, bg = inactive_bg },
      buffer_selected = { fg = C.text, bg = active_bg, style = styles }, -- current
      -- Duplicate
      duplicate_selected = { fg = C.text, bg = active_bg, style = styles },
      duplicate_visible = { fg = C.surface1, bg = inactive_bg, style = styles },
      duplicate = { fg = C.surface1, bg = inactive_bg, style = styles },
      -- tabs
      tab = { fg = C.surface1, bg = inactive_bg },
      tab_selected = { fg = C.sky, bg = active_bg, bold = true },
      tab_separator = { fg = separator_fg, bg = inactive_bg },
      tab_separator_selected = { fg = separator_fg, bg = active_bg },

      tab_close = { fg = C.red, bg = inactive_bg },
      indicator_selected = { fg = C.peach, bg = active_bg, style = styles },
      -- separators
      separator = { fg = separator_fg, bg = inactive_bg },
      separator_visible = { fg = separator_fg, bg = inactive_bg },
      separator_selected = { fg = separator_fg, bg = active_bg },
      offset_separator = { fg = separator_fg, bg = active_bg },
      -- close buttons
      close_button = { fg = C.surface1, bg = inactive_bg },
      close_button_visible = { fg = C.surface1, bg = inactive_bg },
      close_button_selected = { fg = C.red, bg = active_bg },
      -- Empty fill
      fill = { bg = bg_highlight },
      -- Numbers
      numbers = { fg = C.subtext0, bg = inactive_bg },
      numbers_visible = { fg = C.subtext0, bg = inactive_bg },
      numbers_selected = { fg = C.subtext0, bg = active_bg, style = styles },
      -- Errors
      error = { fg = C.red, bg = inactive_bg },
      error_visible = { fg = C.red, bg = inactive_bg },
      error_selected = { fg = C.red, bg = active_bg, style = styles },
      error_diagnostic = { fg = C.red, bg = inactive_bg },
      error_diagnostic_visible = { fg = C.red, bg = inactive_bg },
      error_diagnostic_selected = { fg = C.red, bg = active_bg },
      -- Warnings
      warning = { fg = C.yellow, bg = inactive_bg },
      warning_visible = { fg = C.yellow, bg = inactive_bg },
      warning_selected = { fg = C.yellow, bg = active_bg, style = styles },
      warning_diagnostic = { fg = C.yellow, bg = inactive_bg },
      warning_diagnostic_visible = { fg = C.yellow, bg = inactive_bg },
      warning_diagnostic_selected = { fg = C.yellow, bg = active_bg },
      -- Infos
      info = { fg = C.sky, bg = inactive_bg },
      info_visible = { fg = C.sky, bg = inactive_bg },
      info_selected = { fg = C.sky, bg = active_bg, style = styles },
      info_diagnostic = { fg = C.sky, bg = inactive_bg },
      info_diagnostic_visible = { fg = C.sky, bg = inactive_bg },
      info_diagnostic_selected = { fg = C.sky, bg = active_bg },
      -- Hint
      hint = { fg = C.teal, bg = inactive_bg },
      hint_visible = { fg = C.teal, bg = inactive_bg },
      hint_selected = { fg = C.teal, bg = active_bg, style = styles },
      hint_diagnostic = { fg = C.teal, bg = inactive_bg },
      hint_diagnostic_visible = { fg = C.teal, bg = inactive_bg },
      hint_diagnostic_selected = { fg = C.teal, bg = active_bg },
      -- Diagnostics
      diagnostic = { fg = C.subtext0, bg = inactive_bg },
      diagnostic_visible = { fg = C.subtext0, bg = inactive_bg },
      diagnostic_selected = { fg = C.subtext0, bg = active_bg, style = styles },
      -- Modified
      modified = { fg = C.peach, bg = inactive_bg },
      modified_selected = { fg = C.peach, bg = active_bg },
    }

    for _, color in pairs(highlights) do
      -- Because default is gui=bold,italic
      color.italic = false
      color.bold = false

      if color.style then
        for _, style in pairs(color.style) do
          color[style] = true
          if O.no_italic and style == "italic" then
            color[style] = false
          end
          if O.no_bold and style == "bold" then
            color[style] = false
          end
        end
      end
      color.style = nil
    end
    return highlights
  end
end

return {
  "akinsho/nvim-bufferline.lua",
  event = "BufReadPre",
  keys = function()
    local Kmap = function(lhs, cmd, desc)
      cmd = string.format("<cmd>BufferLine%s<cr>", cmd)
      desc = string.format("Buffer » %s", desc)
      return { lhs, cmd, desc = desc }
    end
    return {
      Kmap("<a-b>", "Pick", "Pick"),
      Kmap("<leader>bS", "SortByTabs", "Sort by tabs"),
      Kmap("<leader>bs", "SortByDirectory", "Sort by directory"),
      Kmap("<leader>bp", "TogglePin", "Toggle pin"),
      Kmap("<a-.>", "MoveNext", "Shift right"),
      Kmap("<a-,>", "MovePrev", "Shift left"),
      Kmap("<a-[>", "CyclePrev", "Switch prev"),
      Kmap("<a-]>", "CycleNext", "Switch next"),
      Kmap("<a-1>", "GoToBuffer 1", "Switch 1st"),
      Kmap("<a-2>", "GoToBuffer 2", "Switch 2nd"),
      Kmap("<a-3>", "GoToBuffer 3", "Switch 3rd"),
      Kmap("<a-4>", "GoToBuffer 4", "Switch 4th"),
      Kmap("<a-5>", "GoToBuffer 5", "Switch 5th"),
      Kmap("<leader>bB", "CloseLeft", "Close left"),
      Kmap("<leader>bW", "CloseRight", "Close right"),
      Kmap("<leader>bC", "CloseOthers", "Close others"),
      Kmap("<a-q>", "PickClose", "Pick & close"),
    }
  end,

  opts = function(_, opts)
    vim.opt.mousemoveevent = true

    local defaults = {
      options = {
        show_close_icon = false,
        always_show_bufferline = false,
        mode = "buffers",
        diagnostics = "nvim_lsp",
        ---@type "insert_after_current" | "insert_at_end" | "id" | "extension" | "relative_directory" | "directory" | "tabs"
        sort_by = "insert_at_end",
        show_tab_indicators = true,
        close_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        right_mouse_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        ---@type "thin" | "padded_slant" | "slant" | "thick" | "none"
        separator_style = "thin",
        indicator = {
          ---@type "icon" | "underline" | "none"
          style = "icon",
        },
        hover = {
          enabled = true,
          reveal = { "close" },
          delay = 200,
        },
        offsets = {
          {
            filetype = "neo-tree",
            text = "~ TREE VIEW ~",
            highlight = "BufferLineFill",
            text_align = "center",
            separator = false,
          },
        },
      },
    }

    opts = vim.tbl_deep_extend("force", defaults, opts or {})

    local Utils = require("neoverse.utils")
    local Config = require("neoverse.config")

    if Utils.call("catppuccin") and Config.transparent and string.match(vim.g.colors_name, "catppuccin") then
      opts.highlights = generate_bufferline_hls()
    end

    return opts
  end,
}
