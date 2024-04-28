local M = {}

M.opts = function()
  local cmp = require("cmp")
  local defaults = require("cmp.config.default")()
  return {
    completion = {
      completeopt = "menu,menuone,noinsert",
    },
    experimental = {
      ghost_text = {
        hl_group = "LspCodeLens",
      },
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "buffer", keyword_length = 3 },
      { name = "path" },
      {
        name = "spell",
        option = {
          keep_all_entries = false,
          enable_in_context = function()
            return true
          end,
        },
      },
    }),
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(_, vim_item)
        local item_kind = vim_item.kind
        vim_item.kind = require("neoverse.config").icons.Kinds[item_kind]
        vim_item.menu = string.format("🔸%s", item_kind)
        return vim_item
      end,
    },
    mapping = {
      ["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<c-y>"] = cmp.mapping.confirm({ select = true }),
      ["<c-u>"] = cmp.mapping.scroll_docs(-4),
      ["<c-d>"] = cmp.mapping.scroll_docs(4),
      ["<c-space>"] = cmp.mapping.complete(),
      -- ["<a-q>"] = cmp.mapping.close(),
      ["<c-e>"] = cmp.mapping.abort(),
    },
    sorting = defaults.sorting,
  }
end

---@param opts cmp.ConfigSchema
M.config = function(_, opts)
  local cmp = require("cmp")
  for _, source in ipairs(opts.sources) do
    source.group_index = source.group_index or 1
  end
  if vim.g.neo_transparent then
    opts.window = {
      documentation = cmp.config.window.bordered(),
      completion = cmp.config.window.bordered(),
    }
  end
  cmp.setup(opts)
end

return M
