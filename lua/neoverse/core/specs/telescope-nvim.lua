local Icons = {
  FindHiddens = "󰈈 ",
  FindNotes = "󱙓 ",
  FindKeymaps = "󰌌 ",
  FindHighlights = " ",
  FindHelpTags = "󰋖",
  FindFiles = " ",
  ResumeLast = " ",
  LiveGrepWords = "󱀽 ",
  FindColorschemes = " ",
  FindInstalledPlugins = " ",
  FindRecentFiles = " ",
  GrepStrings = " ",
  MarkList = "󰙒 ",
  JumpList = " ",
  Buffers = " ",
}

---@param lhs string
---@param cmd string | function
---@param desc string
---@param mode? "n" | "v"
local Kmap = function(lhs, cmd, desc, mode)
  return {
    lhs,
    cmd,
    desc = string.format("Telescope » %s", desc):lower(),
    mode = mode or "n",
  }
end

function _G.NeoTelescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    local Utils = require("neoverse.utils")
    builtin = params.builtin
    opts = params.opts
    ---@type table
    opts = vim.tbl_deep_extend("force", { cwd = Utils.root() }, opts or {})
    local is_git_root = vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git")
    if is_git_root then
      if builtin == "files" or builtin == "live_grep" or builtin == "grep_string" then
        opts.prompt_title = opts.prompt_title .. " <git>"
        opts.layout_config = {
          prompt_position = "bottom",
          height = 0.6,
        }
      end
      if
        builtin == "files"
        and vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git")
        and not vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.ignore")
        and not vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.rgignore")
      then
        builtin = "git_files"
        opts.show_untracked = true
      end
    else
      if builtin == "files" then
        builtin = "find_files"
        opts.show_untracked = false
      end
      opts.layout_config = {
        prompt_position = "top",
        height = 0.9,
      }
    end
    if opts.cwd and opts.cwd ~= vim.loop.cwd() then
      opts.attach_mappings = function(_, map)
        map("i", "<c-c>", function()
          local action_state = require("telescope.actions.state")
          local line = action_state.get_current_line()
          NeoTelescope(
            params.builtin,
            vim.tbl_deep_extend("force", {}, params.opts or {}, {
              default_text = line,
              cwd = false,
            })
          )()
        end)
        return true
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

local M = {}

M.config = function(_, opts)
  local actions = require("telescope.actions")
  local mappings = {
    ["<a-space>"] = actions.close,
    ["<cr>"] = actions.select_default,
    ["<c-y>"] = actions.select_default,
    ["<c-v>"] = actions.select_vertical,
    ["<c-x>"] = actions.select_horizontal,
    ["<a-cr>"] = actions.select_tab,
    ["<c-t>"] = actions.select_tab,
    ["<c-p>"] = actions.move_selection_previous,
    ["<c-n>"] = actions.move_selection_next,
    ["<a-j>"] = actions.cycle_history_next,
    ["<a-k>"] = actions.cycle_history_prev,
    ["<c-u>"] = actions.preview_scrolling_up,
    ["<c-d>"] = actions.preview_scrolling_down,
    ["<a-d>"] = function()
      local action_state = require("telescope.actions.state")
      local line = action_state.get_current_line()
      NeoTelescope("find_files", {
        prompt_title = Icons.FindHiddens .. "Find files (no hidden)",
        sorting_strategy = "descending",
        default_text = line,
        no_ignore = true,
        hidden = true,
      })()
    end,
  }
  local NeoDefaults = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = {
        prompt_position = "top",
        width = 0.9,
        height = 0.9,
      },
      sorting_strategy = "ascending",
      prompt_prefix = " 🔭 ",
      selection_caret = "👉",
      mappings = {
        ["i"] = mappings,
        ["n"] = vim.tbl_extend("force", mappings, {
          ["<esc>"] = actions.close,
          ["q"] = actions.close,
        }),
      },
    },
  }
  -- vim.print("telescope.nvim setup call with border » " .. vim.g.neo_winborder)
  if vim.g.neo_winborder == "single" then
    NeoDefaults.defaults.borderchars = {
      "─",
      "│",
      "─",
      "│",
      "┌",
      "┐",
      "┘",
      "└",
    }
  end
  opts = vim.tbl_deep_extend("force", NeoDefaults, opts or {})
  require("telescope").setup(opts)
end

M.init = function()
  ---register telescope dotfiles on VimEnter here
  vim.api.nvim_create_user_command(
    "NeoDotfiles",
    NeoTelescope("find_files", {
      prompt_title = "🔧 DOTFILES",
      cwd = os.getenv("DOTFILES"),
    }),
    { desc = "telescope » open dotfiles" }
  )
  ---register custom note trigger
  vim.api.nvim_create_user_command(
    "NeoNotes",
    NeoTelescope("find_files", {
      prompt_title = Icons.FindNotes .. "Find notes",
      cwd = vim.g.neo_notesdir,
    }),
    { desc = "telescope » find notes" }
  )
end

M.keys = {
  Kmap("<leader>/N", ":NeoNotes<cr>", "Find notes"),
  Kmap("<leader>/d", ":NeoDotfiles<cr>", "Find dotfiles"),
  Kmap("<leader>/m", ":Telescope man_pages<cr>", "Find man pages"),
  Kmap("<leader>/g", ":Telescope git_files<cr>", "Git files"),
  Kmap("<leader>/b", ":Telescope git_branches<cr>", "Git branches"),
  Kmap("<leader>/o", ":Telescope vim_options<cr>", "Find vim options"),
  Kmap("<leader>/:", ":Telescope command_history<cr>", "Command history"),
  Kmap("<leader>/c", ":Telescope commands<cr>", "Find available commands"),
  Kmap("<leader>/X", ":Telescope diagnostics<cr>", "Workspace diagnostics"),
  Kmap("<leader>/x", ":Telescope diagnostics bufnr=0<cr>", "Find diagnostics [cwd]"),
  Kmap("<leader>/k", NeoTelescope("keymaps", { prompt_title = Icons.FindKeymaps .. "Keymaps" }), "Find keymaps"),

  Kmap(
    "<leader>/H",
    NeoTelescope("highlights", { prompt_title = Icons.FindHighlights .. "Highlights" }),
    "Find highlights"
  ),

  Kmap("<f1>", NeoTelescope("help_tags", { prompt_title = Icons.FindHelpTags .. " Help tags" }), "Find help tags"),
  Kmap("<leader>//", NeoTelescope("resume", { prompt_title = Icons.ResumeLast .. "Continue" }), "Continue last action"),
  Kmap("<c-p>", NeoTelescope("files", { prompt_title = Icons.FindFiles .. "Files" }), "Find files [root]"),
  Kmap(
    "<leader>/f",
    NeoTelescope("files", {
      prompt_title = Icons.FindFiles .. "Files",
    }),
    "Find files [root]"
  ),
  Kmap(
    "<leader>/F",
    NeoTelescope("files", {
      prompt_title = Icons.FindFiles .. "Files",
      cwd = vim.loop.cwd(),
    }),
    "Find files [cwd]"
  ),

  Kmap(
    "<leader>/w",
    NeoTelescope("live_grep", {
      prompt_title = Icons.LiveGrepWords .. "Live grep word",
      layout_strategy = "vertical",
    }),
    "Live grep word [root]"
  ),

  Kmap(
    "<leader>/W",
    NeoTelescope("live_grep", {
      prompt_title = Icons.LiveGrepWords .. "Live grep word",
      layout_strategy = "vertical",
      cwd = vim.loop.cwd(),
    }),
    "Live grep word [cwd]"
  ),

  Kmap(
    "<leader>/C",
    NeoTelescope("colorscheme", {
      prompt_title = Icons.FindColorschemes .. "Colorscheme",
      enable_preview = true,
    }),
    "Colorscheme"
  ),

  Kmap(
    "<leader>/p",
    NeoTelescope("find_files", {
      prompt_title = Icons.FindInstalledPlugins .. "Find installed plugins",
      cwd = vim.fn.stdpath("data"),
    }),
    "Find installed plugins"
  ),

  Kmap(
    "<leader>/r",
    NeoTelescope("oldfiles", {
      prompt_title = Icons.FindRecentFiles .. "Recent files [cwd]",
      initial_mode = "normal",
      cwd = vim.loop.cwd(),
    }),
    "Recent files [cwd]"
  ),

  Kmap(
    "<leader>/R",
    NeoTelescope("oldfiles", {
      prompt_title = Icons.FindRecentFiles .. "Recent files",
      initial_mode = "normal",
      cwd = false,
    }),
    "Recent Files"
  ),

  Kmap(
    "<leader>/s",
    NeoTelescope("grep_string", {
      prompt_title = Icons.GrepStrings .. "Grep strings",
      layout_strategy = "vertical",
    }),
    "Grep strings [root]"
  ),

  Kmap(
    "<leader>/s",
    NeoTelescope("grep_string", {
      prompt_title = Icons.GrepStrings .. "Grep selection",
      layout_strategy = "vertical",
      mode = "v",
    }),
    "Grep selection [root]",
    "v"
  ),

  Kmap(
    "<leader>/S",
    NeoTelescope("grep_string", {
      prompt_title = Icons.GrepStrings .. "Grep strings",
      layout_strategy = "vertical",
      cwd = vim.loop.cwd(),
    }),
    "Grep strings [cwd]"
  ),

  Kmap(
    "<leader>/S",
    NeoTelescope("grep_string", {
      prompt_title = Icons.GrepStrings .. "Grep selection",
      layout_strategy = "vertical",
      cwd = vim.loop.cwd(),
    }),
    "Grep selection [cwd]",
    "v"
  ),

  Kmap(
    "<leader>'",
    NeoTelescope("marks", {
      prompt_title = Icons.MarkList .. "Mark list",
      initial_mode = "normal",
    }),
    "Mark list"
  ),

  Kmap(
    "<leader>;",
    NeoTelescope("jumplist", {
      prompt_title = Icons.JumpList .. "Jump list",
      initial_mode = "normal",
    }),
    "Jump list"
  ),

  Kmap(
    "<leader><tab>",
    NeoTelescope("buffers", {
      prompt_title = Icons.FindRecentFiles .. "Buffers [cwd]",
      ignore_current_buffer = false,
      initial_mode = "normal",
      cwd = vim.loop.cwd(),
    }),
    "Buffers [cwd]"
  ),

  Kmap(
    "<leader>,",
    NeoTelescope("buffers", {
      prompt_title = Icons.Buffers .. "Buffers [all]",
      ignore_current_buffer = false,
      initial_mode = "normal",
      sort_lastused = true,
      sort_mru = true,
      cwd = false,
    }),
    "Buffers [all]"
  ),
}

return M
