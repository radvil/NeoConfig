---@diagnostic disable: cast-local-type, param-type-mismatch
local Icons = require("neoverse.config").icons

local i = function(icon)
  return string.format("%s ", icon)
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  dependencies = { "nvim-tree/nvim-web-devicons", "s1n7ax/nvim-window-picker" },

  keys = {
    {
      "<Leader>e",
      function()
        require("neo-tree.command").execute({
          dir = require("neoverse.utils").root(),
          selector = true,
          reveal = true,
          toggle = true,
        })
      end,
      desc = "neotree » toggle filesystem [root]",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({
          dir = vim.loop.cwd(),
          selector = true,
          toggle = true,
        })
      end,
      desc = "neotree » toggle filesystem [cwd]",
    },
    {
      "<leader><cr>",
      function()
        require("neo-tree.command").execute({
          dir = require("neoverse.utils").root(),
          source = "buffers",
          action = "focus",
          reveal = true,
          toggle = true,
        })
      end,
      desc = "neotree » toggle buffers [root]",
    },
    {
      "<Leader>fp",
      function()
        require("neo-tree.command").execute({
          dir = vim.fn.stdpath("data"),
          position = "current",
          selector = false,
          action = "focus",
        })
      end,
      desc = "neotree » browse plugins dir",
    },
  },
  opts = {
    hide_root_node = true,
    default_component_configs = {
      indent = {
        padding = 0,
        with_markers = true,
        with_expanders = true,
      },
      git_status = {
        symbols = {
          -- Change type
          added = i(Icons.Git.Added),
          deleted = i(Icons.Git.Deleted),
          modified = i(Icons.Git.Modified),
          renamed = i(Icons.Git.Renamed),
          -- Status type
          staged = i(Icons.Git.Staged),
          unstaged = i(Icons.Git.Unstaged),
          untracked = i(Icons.Git.Untracked),
          conflict = i(Icons.Git.Conflict),
          ignored = i(Icons.Git.Ignored),
        },
      },
    },

    window = {
      width = 40,
      position = "left",
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ["<space>"] = false,
        ["l"] = "open",
        ["w"] = "open_with_window_picker",
        ["<cr>"] = "open",
        ["<2-LeftMouse>"] = "open",
        ["<c-v>"] = "open_vsplit",
        ["<c-x>"] = "open_split",
        ["<c-t>"] = "open_tabnew",
        ["<a-cr>"] = "open_tabnew",

        ["h"] = "close_node",
        ["za"] = "toggle_node",
        ["zc"] = "close_node",
        ["zM"] = "close_all_nodes",
        ["zR"] = "expand_all_nodes",

        ["r"] = "rename",
        ["<F2>"] = "rename",
        ["?"] = "show_help",
        ["K"] = { "toggle_preview", config = { use_float = true } },
        ["<esc>"] = "revert_preview",
        ["R"] = "refresh",
      },
    },

    filesystem = {
      bind_to_cwd = false,
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = "disabled",
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      window = {
        mappings = {
          ["."] = "set_root",
          ["/"] = "fuzzy_finder",
          ["H"] = "toggle_hidden",
          ["-"] = "navigate_up",
          ["f"] = "filter_on_submit",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
          ["<a-space>"] = "clear_filter",
          ["a"] = "add",
          ["d"] = "delete",
          ["y"] = "copy_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy",
          ["x"] = "cut_to_clipboard",
          ["<space>"] = "none",
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
          end,
        },
      },
    },

    buffers = {
      show_unloaded = true,
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      window = {
        mappings = {
          ["d"] = "buffer_delete",
          ["a"] = false,
          ["y"] = false,
          ["p"] = false,
          ["c"] = false,
          ["x"] = false,
        },
      },
    },

    source_selector = {
      winbar = false,
      statusline = false,
    },
  },

  config = function(_, opts)
    local Utils = require("neoverse.utils")
    local function on_move(data)
      Utils.lsp.on_rename(data.source, data.destination)
    end

    local events = require("neo-tree.events")
    opts.event_handlers = opts.event_handlers or {}

    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    })

    require("neo-tree").setup(opts)
    vim.api.nvim_create_autocmd("TermClose", {
      group = Utils.create_augroup("neotree_reload_gitstatus", true),
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })
  end,
}
