return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "s1n7ax/nvim-window-picker" },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,

  keys = {
    {
      "<Leader>e",
      function()
        if require("zen-mode.view").is_open() then
          local oil = require("oil")
          if require("oil.util").is_oil_bufnr(0) then
            oil.close()
          else
            oil.open()
          end
        else
          require("neo-tree.command").execute({
            dir = require("neoverse.utils").get_root(),
            toggle = true,
          })
        end
      end,
      desc = "Tree » Toggle (root)",
    },
    {
      "<leader>E",
      function()
        if require("zen-mode.view").is_open() then
          require("oil").open(vim.loop.cwd())
        else
          require("neo-tree.command").execute({
            dir = vim.loop.cwd(),
            toggle = true,
          })
        end
      end,
      desc = "Tree » Toggle",
    },
    {
      "<leader><cr>",
      ":Neotree buffers<cr>",
      desc = "Tree » Buffers",
    },
  },

  config = function(_, opts)
    local Icons = require("neoverse.config").icons
    local i = function(icon)
      return string.format("%s ", icon)
    end
    opts.default_component_configs = {
      indent = {
        with_markers = true,
        with_expanders = false,
        -- indent_marker = "┊",
        expander_collapsed = Icons.Folds.Collapsed,
        expander_expanded = Icons.Folds.Expanded,
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
    }
    opts.window = {
      width = 40,
      position = "left",
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
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

        ["a"] = "add",
        ["d"] = "delete",
        ["r"] = "rename",
        ["<F2>"] = "rename",
        ["c"] = "copy",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",

        ["?"] = "show_help",
        ["K"] = { "toggle_preview", config = { use_float = true } },
        ["<esc>"] = "revert_preview",
        ["R"] = "refresh",
      },
    }

    opts.filesystem = {
      bind_to_cwd = false,
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = "disabled",
      follow_current_file = {
        enabled = true,
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
        },
      },
    }

    opts.buffers = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
    }

    opts.source_selector = {
      winbar = true,
      statusline = false,
      truncation_character = "…",
      show_scrolled_off_parent_node = false, -- HACK: enable this caused flickering on "InsertEnter"
      highlight_tab = "BufferLineBackground",
      highlight_separator = "BufferLineBackground",
      highlight_background = "BufferLineBackground",
      highlight_tab_active = "BufferLineBufferSelected",
      highlight_separator_active = "BufferLineIndicatorSelected",
      sources = {
        {
          source = "filesystem",
          display_name = " 󰙅 files",
        },
        {
          source = "buffers",
          display_name = "  buffers",
        },
        {
          source = "git_status",
          display_name = "  git",
        },
      },
    }

    require("neo-tree").setup(opts)

    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })
  end,
}
