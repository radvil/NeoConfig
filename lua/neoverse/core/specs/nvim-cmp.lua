local M = {}

M.opts = function()
  local cmp = require("cmp")
  local defaults = require("cmp.config.default")()
  local opts = {
    completion = {
      completeopt = "menu,menuone,noinsert",
    },
    experimental = {
      ghost_text = {
        hl_group = "LspCodeLens",
      },
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
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
      ["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<cr>"] = cmp.mapping.confirm({ select = true }),
      ["<c-u>"] = cmp.mapping.scroll_docs(-4),
      ["<c-d>"] = cmp.mapping.scroll_docs(4),
      ["<c-space>"] = cmp.mapping.complete(),
      ["<c-x>"] = cmp.mapping.abort(),
    },
    sorting = defaults.sorting,
  }
  if vim.g.neo_transparent then
    opts.window = {
      documentation = cmp.config.window.bordered(),
      completion = cmp.config.window.bordered(),
    }
  end
  return opts
end

---@param opts cmp.ConfigSchema
M.config = function(_, opts)
  for _, source in ipairs(opts.sources) do
    source.group_index = source.group_index or 1
  end
  require("cmp").setup(opts)
end

return M
