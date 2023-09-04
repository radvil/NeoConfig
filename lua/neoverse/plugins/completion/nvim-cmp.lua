-- TODO: set this to universal options
local transbg = true
local kind_icons = {
  Array = " ",
  Boolean = " ",
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Copilot = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = " ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = " ",
  Module = " ",
  Namespace = " ",
  Null = " ",
  Number = " ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = " ",
  String = " ",
  Struct = " ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = " ",
}

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "f3fora/cmp-spell",
  },

  opts = function()
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
        format = function(entry, vim_item)
          local item_kind = vim_item.kind
          local sources = {
            nvim_lsp = item_kind,
            luasnip = " Snippet",
            copilot = " Copilot",
            buffer = " Buffer",
            path = " Path",
          }
          vim_item.kind = kind_icons[item_kind]
          vim_item.menu = sources[entry.source.name]
          return vim_item
        end,
      },
      mapping = {
        ["<c-p>"] = cmp.mapping.select_prev_item({
          behavior = cmp.SelectBehavior.Insert,
        }),
        ["<c-n>"] = cmp.mapping.select_next_item({
          behavior = cmp.SelectBehavior.Insert,
        }),
        ["<c-u>"] = cmp.mapping.scroll_docs(-4),
        ["<c-d>"] = cmp.mapping.scroll_docs(4),
        ["<c-space>"] = cmp.mapping.complete(),
        ["<c-e>"] = cmp.mapping.abort(),
        ["<cr>"] = cmp.mapping.confirm({ select = true }),
        ["<c-o>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
      },
      sorting = defaults.sorting,
    }

    -- TODO: set universal option for this condition
    if transbg then
      opts.window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config.window.bordered(),
      }
    end

    return opts
  end,
}
