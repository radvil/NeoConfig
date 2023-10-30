local create_note_with_title = function()
  vim.ui.input({
    prompt = "Note title: ",
    completion = "file_in_path", -- :h command-completion
    default = "",
  }, function(value)
    if not value then
      vim.notify("Note creation canceled", vim.log.levels.WARN, {
        title = "Obsidian",
        icon = "󱙒 ",
      })
    else
      vim.cmd("ObsidianNew " .. value)
      -- no need extra notification here since obsidian.nvim has already handled this
    end
  end)
end

local M = {
  "epwalsh/obsidian.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  lazy = true,
}

M.keys = {
  {
    "<leader>nc",
    create_note_with_title,
    desc = "note[obsidian] » create new note",
  },
  {
    "<leader>no",
    "<cmd>ObsidianOpen<cr>",
    desc = "note[obsidian] » open",
  },
  {
    "<leader>nn",
    "<cmd>ObsidianToday<cr>",
    desc = "note[obsidian] » today/now note",
  },
  {
    "<leader>ny",
    "<cmd>ObsidianYesterday<cr>",
    desc = "note[obsidian] » yesterday note",
  },
  {
    "<leader>nb",
    ft = "markdown",
    "<cmd>ObsidianBacklinks<cr>",
    desc = "obsidian » show note's backlinks",
  },
  {
    "<leader>nt",
    ft = "markdown",
    "<cmd>ObsidianTemplate<cr>",
    desc = "obsidian » insert a template",
  },
  {
    "gF",
    ft = "markdown",
    "<cmd>ObsidianLinkNew<cr>",
    desc = "obsidian » link to new note",
    mode = { "v", "x" },
  },
}

M.opts = {
  mappings = {},
  finder = "telescope.nvim",
  dir = vim.g.neo_notesdir,
  completion = { nvim_cmp = true },
  daily_notes = {
    folder = "+daily",
    date_format = "%Y-%m-%d",
  },
  follow_url_func = function(url)
    vim.fn.jobstart({ "xdg-open", url })
  end,
  note_id_func = function(title)
    local suffix = ""
    if title ~= nil then
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return tostring(os.time()) .. "-" .. suffix
  end,
}

M.init = function()
  local Utils = require("neoverse.utils")
  Utils.map("n", "gf", function()
    if require("obsidian").util.cursor_on_markdown_link() then
      return "<cmd>ObsidianFollowLink<cr>"
    else
      return "gf"
    end
  end, { desc = "obsidian » follow link" })
  if Utils.lazy_has("which-key.nvim") then
    require("which-key").register({ mode = "n", ["<leader>n"] = { name = "note[obsidian]" } })
  end
end

return M
