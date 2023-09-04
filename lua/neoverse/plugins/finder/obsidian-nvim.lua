---@param lhs string
---@param rhs string | function
local Kmap = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, {
    desc = string.format("Obsidian » %s", desc),
    noremap = false,
    expr = true,
  })
end

return {
  "epwalsh/obsidian.nvim",
  lazy = false,
  -- event = { "BufReadPre " .. minimal.note_vault .. "/**.md" },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>nc",
      ":ObsidianNew<cr>",
      desc = "Obsidian » Create new note",
    },
    {
      "<leader>no",
      ":ObsidianOpen<cr>",
      desc = "Obsidian » Open",
    },
    {
      "<leader>nb",
      ":ObsidianBacklinks<cr>",
      desc = "Obsidian » Show note's backlinks",
    },
    {
      "<leader>nn",
      ":ObsidianToday<cr>",
      desc = "Obsidian » Today/now note",
    },
    {
      "<leader>ny",
      ":ObsidianYesterday<cr>",
      desc = "Obsidian » Yesterday note",
    },
    {
      "<leader>nt",
      ":ObsidianTemplate<cr>",
      desc = "Obsidian » Insert a template",
    },
    {
      "gF",
      "<cmd>ObsidianLinkNew<cr>",
      desc = "Obsidian » Link to new note",
      mode = { "v", "x" },
    },
  },
  config = function()
    local obsidian = require("obsidian")
    obsidian.setup({
      mappings = {},
      -- TODO: set this to universal options
      dir = vim.fn.expand("~") .. "/Documents/obsidian-vault",
      finder = "telescope.nvim",
      completion = {
        nvim_cmp = true,
      },
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
    })

    Kmap("gf", function()
      if obsidian.util.cursor_on_markdown_link() then
        return "<cmd>ObsidianFollowLink<cr>"
      else
        return "gf"
      end
    end, "Follow link")
  end,
}
