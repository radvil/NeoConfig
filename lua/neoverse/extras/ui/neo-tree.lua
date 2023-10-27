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
          dir = require("neoverse.utils").root.get(),
          reveal_force_cwd = false,
          position = "left",
          reveal = false,
          toggle = true,
        })
      end,
      desc = "neotree » toggle (root)",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({
          dir = vim.loop.cwd(),
          position = "left",
          toggle = true,
        })
      end,
      desc = "neotree » toggle (cwd)",
    },
    {
      "<leader><cr>",
      function()
        require("neo-tree.command").execute({
          source = "buffers",
          position = "right",
          action = "focus",
          selector = false,
          reveal = true,
          toggle = true,
        })
      end,
      desc = "neotree » toggle buffers",
    },
  },
  opts = {
    default_component_configs = {
      indent = {
        padding = 0,
        with_markers = true,
        with_expanders = false,
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
      -- width = 44,
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
        ["<a-[>"] = "prev_source",
        ["<a-]>"] = "next_source",

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
        enabled = false,
        leave_dirs_open = true,
      },
      window = {
        mappings = {
          ["."] = "set_root",
          ["/"] = "fuzzy_finder",
          ["H"] = "toggle_hidden",
          ["<bs>"] = "navigate_up",
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
        },
      },
    },

    buffers = {
      show_unloaded = true,
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
    },

    sources = {
      "filesystem",
      "git_status",
      "buffers",
      -- "document_symbols",
    },

    source_selector = {
      winbar = false,
      statusline = false,
      truncation_character = "…",
      show_scrolled_off_parent_node = false, -- HACK: enable this caused flickering on "InsertEnter"
      sources = {
        {
          source = "filesystem",
          display_name = " 󰙅 filesystem",
        },
        -- {
        --   source = "buffers",
        --   display_name = "  buffers",
        -- },
        {
          source = "git_status",
          display_name = "  gitsource",
        },
      },
    },
  },

  config = function(_, opts)
    local function on_move(data)
      require("neoverse.utils").lsp.on_rename(data.source, data.destination)
    end
    -- local on_tree_enter = function()
    --   vim.cmd([[setlocal relativenumber]])
    -- end

    local events = require("neo-tree.events")
    opts.event_handlers = opts.event_handlers or {}

    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
      -- { event = events.NEO_TREE_BUFFER_ENTER, handler = on_tree_enter },
    })

    local has_lualine = require("neoverse.utils").lazy_has("lualine.nvim")
    opts.source_selector.winbar = has_lualine
    opts.source_selector.statusline = not has_lualine

    require("neo-tree").setup(opts)
    vim.api.nvim_create_autocmd("TermClose", {
      group = require("neoverse.utils").create_augroup("neotree_reload_gitstatus", true),
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })
  end,
}
