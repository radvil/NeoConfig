-- TODO: set universal options whether to use nvim-tree or neo-tree
if true then
  return {}
end

return {
  {
    "akinsho/nvim-bufferline.lua",
    opts = {
      options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = require("neoverse.common.icons").Vim .. " NVIM TREE",
            highlight = "BufferLineBackground",
            text_align = "left",
            separator = false,
          },
        },
      },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons", "s1n7ax/nvim-window-picker" },
    keys = {
      -- TODO: toggle between nvim-tree and oil-nvim
      {
        "<Leader>e",
        function()
          require("nvim-tree.api").tree.toggle({
            path = require("neoverse.utils").get_root(),
          })
        end,
        desc = "NvimTree » Toggle (root)",
      },
      {
        "<Leader>E",
        function()
          require("nvim-tree.api").tree.toggle({
            path = vim.loop.cwd(),
          })
        end,
        desc = "NvimTree » Toggle",
      },
    },

    init = function()
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if require("nvim-tree.api").tree.is_visible() then
            vim.cmd("NvimTreeRefresh")
          end
        end,
      })
    end,

    config = function()
      local Icons = require("neoverse.config").icons

      require("nvim-tree").setup({
        hijack_netrw = false,
        hijack_cursor = true,
        update_focused_file = {
          enable = true,
        },
        filesystem_watchers = {
          enable = true,
        },
        git = {
          enable = true,
          ignore = false,
          timeout = 200,
        },
        modified = {
          enable = true,
          show_on_dirs = false,
          show_on_open_dirs = false,
        },
        view = {
          side = "left",
          width = 36,
        },
        diagnostics = {
          enable = true,
          show_on_dirs = false,
          icons = {
            warning = Icons.Diagnostics.Warn,
            error = Icons.Diagnostics.Error,
            hint = Icons.Diagnostics.Hint,
            info = Icons.Diagnostics.Info,
          },
        },
        renderer = {
          highlight_opened_files = "name",
          root_folder_label = false,
          highlight_git = true,
          indent_markers = {
            enable = true,
            icons = {
              edge = "│",
              corner = "»",
              item = "┊",
              none = "»",
            },
          },
          icons = {
            webdev_colors = true,
            git_placement = "after",
            modified_placement = "after",
            padding = " ",
            glyphs = {
              git = {
                untracked = Icons.Git.Untracked,
                unstaged = Icons.Git.Unstaged,
                unmerged = Icons.Git.Modified,
                renamed = Icons.Git.Renamed,
                deleted = Icons.Git.Deleted,
                ignored = Icons.Git.Ignored,
                staged = Icons.Git.Staged,
              },
            },
          },
          special_files = {
            "index.ts",
            "Cargo.toml",
            "README.md",
            "readme.md",
            "Makefile",
            "init.lua",
            "angular.json",
          },
        },
        filters = {
          dotfiles = true,
          custom = {
            "node_modules",
            "\\.cache",
            "dist",
          },
        },
        trash = {
          require_confirm = true,
          cmd = "trash",
        },
        notify = {
          threshold = vim.log.levels.INFO,
        },
        actions = {
          use_system_clipboard = true,
          open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
              enable = true,
              picker = require("window-picker").pick_window,
              exclude = {
                buftype = { "nofile", "terminal", "help" },
                filetype = {
                  -- popups
                  "noice",
                  "flash_prompt",
                  "WhichKey",
                  "lazy",
                  "lspinfo",
                  "mason",
                  "neo-tree-popup",
                  "notify",
                  "oil",
                  "prompt",
                  "TelescopePrompt",
                  "TelescopeResults",
                  "DressingInput",
                  "cmp_menu",

                  -- windows
                  "NeogitStatus",
                  "prompt",
                  "Dashboard",
                  "dashboard",
                  "alpha",
                  "help",
                  "dbui",
                  "DiffviewFiles",
                  "Mundo",
                  "MundoDiff",
                  "NvimTree",
                  "neo-tree",
                  "Outline",
                  "fugitive",
                  "fugitiveblame",
                  "gitcommit",
                  "Trouble",
                  "dirbuf",
                  "edgy",
                  "qf",
                },
              },
            },
          },
        },
        on_attach = function(buffer)
          local api = require("nvim-tree.api")
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, {
              desc = desc,
              buffer = buffer,
              noremap = true,
              nowait = true,
            })
          end

          -- general
          map("R", api.tree.reload, "Tree » Refresh")
          map("H", api.tree.toggle_hidden_filter, "Tree » Toggle hidden")
          map("K", api.node.show_info_popup, "Tree » Info")
          map("?", api.tree.toggle_help, "Tree » Help")

          -- node open
          map("w", api.node.open.edit, "Node » Open » Edit")
          map("<2-LeftMouse>", api.node.open.no_window_picker, "Node » Open » No picker")
          map("l", api.node.open.no_window_picker, "Node » Open » No picker")
          map("<CR>", api.node.open.no_window_picker, "Node » Open » No picker")
          map("<c-v>", api.node.open.vertical, "Node » Open » Vertical")
          map("<c-x>", api.node.open.horizontal, "Node » Open » Horizontal")

          -- node nav
          map("<BS>", api.node.navigate.parent_close, "Node » Nav » Parent close")
          map("h", api.node.navigate.parent_close, "Node » Nav » Parent close")
          map("b", api.node.navigate.parent, "Node » Nav » Parent")
          map("]d", api.node.navigate.diagnostics.next, "Node » Nav » Diagnostics » Next")
          map("[d", api.node.navigate.diagnostics.prev, "Node » Nav » Diagnostics » Prev")

          -- tree
          map("zR", api.tree.expand_all, "Tree » Expand all")
          map("zM", api.tree.collapse_all, "Tree » Collapse all")
          map("<", api.tree.change_root_to_parent, "Tree » Change root backward")
          map(">", api.tree.change_root_to_node, "Tree » Change root forward")

          -- file system
          map("a", api.fs.create, "FS » Create")
          map("x", api.fs.cut, "FS » Cut")
          map("d", api.fs.trash, "FS » Move to trash")
          map("D", api.fs.remove, "FS » Delete")
          map("c", api.fs.copy.node, "FS » Copy")
          map("y", api.fs.copy.filename, "FS » Copy filename")
          map("Y", api.fs.copy.relative_path, "FS » Copy relative path")
          map("<C-y>", api.fs.copy.absolute_path, "FS » Copy absolute path")
          map("<esc>", api.fs.clear_clipboard, "FS » Clear clipboard")
          map("p", api.fs.paste, "FS » Paste")
          map("r", api.fs.rename, "FS » Rename")
        end,
      })
    end,
  },
}
