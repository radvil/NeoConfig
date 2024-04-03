local blacklist = {
  -- popups
  "TelescopeResults",
  "TelescopePrompt",
  "neo-tree-popup",
  "DressingInput",
  "flash_prompt",
  "cmp_menu",
  "WhichKey",
  "incline",
  "notify",
  "prompt",
  "notify",
  "noice",
  "lazy",

  -- windows
  "DiffviewFiles",
  "checkhealth",
  "dashboard",
  "NvimTree",
  "neo-tree",
  "Outline",
  "prompt",
  "oil",
  "qf",
}

local Kmap = function(lhs, cmd, desc)
  cmd = string.format("<cmd>BufferLine%s<cr>", cmd)
  desc = string.format("bufferline » %s", desc)
  return { lhs, cmd, desc = desc }
end

return {
  "akinsho/bufferline.nvim",
  dependencies = "mini.bufremove",
  event = "LazyFile",
  keys = {
    Kmap("<a-b>", "Pick", "pick & enter"),
    Kmap("<a-q>", "PickClose", "pick & close"),
    Kmap("<leader>bc", "PickClose", "pick & close"),
    Kmap("<a-[>", "CyclePrev", "switch prev"),
    Kmap("<a-]>", "CycleNext", "switch next"),
    Kmap("<a-1>", "GoToBuffer 1", "switch 1st"),
    Kmap("<a-2>", "GoToBuffer 2", "switch 2nd"),
    Kmap("<a-3>", "GoToBuffer 3", "switch 3rd"),
    Kmap("<a-4>", "GoToBuffer 4", "switch 4th"),
    Kmap("<a-5>", "GoToBuffer 5", "switch 5th"),
    Kmap("<leader>bB", "CloseLeft", "close left"),
    Kmap("<leader>bW", "CloseRight", "close right"),
    Kmap("<leader>bC", "CloseOthers", "close others"),
    -- nontab users
    Kmap("<a-.>", "MoveNext", "shift right"),
    Kmap("<a-,>", "MovePrev", "shift left"),
    Kmap("<leader>bS", "SortByTabs", "sort by tabs"),
    Kmap("<leader>bs", "SortByDirectory", "sort by directory"),
    Kmap("<leader>bp", "TogglePin", "toggle pin"),
  },

  opts = {
    options = {
      offsets = {},
      mode = "buffers",
      diagnostics = "nvim_lsp",
      show_close_icon = false,
      show_buffer_icons = true,
      always_show_bufferline = true,
      ---@type "insert_after_current" | "insert_at_end" | "id" | "extension" | "relative_directory" | "directory" | "tabs"
      sort_by = "insert_after_current",
      move_wraps_at_ends = true,
      show_tab_indicators = true,
      ---@type "thin" | "padded_slant" | "slant" | "thick" | "none"
      separator_style = "thin",
      close_command = function(n)
        require("mini.bufremove").delete(n, false)
      end,
      right_mouse_command = function(n)
        require("mini.bufremove").delete(n, false)
      end,
      indicator = {
        ---@type "icon" | "underline" | "none"
        style = "icon",
      },
      hover = {
        enabled = true,
        reveal = { "close" },
        delay = 100,
      },
      custom_filter = function(bufnr)
        return not vim.tbl_contains(blacklist, vim.bo[bufnr].filetype)
      end,
    },
  },

  init = function()
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd("BufAdd", {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}
