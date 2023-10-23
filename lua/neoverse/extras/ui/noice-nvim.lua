local active = true

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
    -- stylua: ignore
    keys = {
      {
        "<leader>ul",
        function()
          active = not active
          require("noice")[active and "enable" or "disable"]()
          local msg = active and "Noice Logger + UX » Enabled" or "Noice Logger + UX » Disabled"
          local lvl = active and vim.log.levels.INFO or vim.log.levels.WARN
          vim.notify(msg, lvl)
        end,
        desc = "Logger » Toggle Noice Logger/UX",
      },
      { "<c-d>", function() if not require("noice.lsp").scroll(4) then return "<c-d>" end end, expr = true, desc = "Noice » Scroll forward", mode = {"i", "n", "s"} },
      { "<c-u>", function() if not require("noice.lsp").scroll(-4) then return "<c-u>" end end, expr = true, desc = "Noice » Scroll backward", mode = {"i", "n", "s"} },
      ---@diagnostic disable-next-line: param-type-mismatch
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Noice » Redirect cmdline" },
      { "<leader>ll", function() require("noice").cmd("last") end, desc = "Logger » Noice last message" },
      { "<leader>lh", function() require("noice").cmd("history") end, desc = "Logger » Noice message history" },
      { "<leader>la", function() require("noice").cmd("all") end, desc = "Logger » All noice messages" },
      { "<leader>ld", function() require("noice").cmd("dismiss") end, desc = "Logger » Dismiss noice messages" },
    },

  ---@param opts NoiceConfig
  config = function(_, opts)
    local Config = require("neoverse.config")
    local defaults = {
      health = { checker = true },
      presets = {
        inc_rename = true,
        long_message_to_split = true,
        command_palette = false,
        bottom_search = true,
        lsp_doc_border = true,
      },
      messages = {
        enabled = true,
        view = "mini",
        view_error = "mini",
        view_warn = "notify",
      },
      lsp = {
        progress = { enabled = false },
        ---message shown by lsp servers
        message = {
          enabled = true,
          view = "mini",
        },
        ---override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          silent = true,
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
        },
      },
      views = {
        ---display cmdline and popup menu together
        cmdline_popup = {
          relative = "editor",
          position = {
            col = "50%",
            row = 6,
            -- row = 18,
          },
          size = {
            width = 60,
            height = "auto",
          },
          border = {
            style = "single",
            padding = { 0, 1 },
          },
        },
        popupmenu = {
          relative = "editor",
          border = {
            style = "single",
            padding = { 0, 1 },
          },
          position = {
            col = "50%",
            row = 8,
          },
          size = {
            width = 60,
            height = 10,
          },
        },
      },
      routes = {
        ---show @recording as notify message
        {
          view = "notify",
          filter = {
            event = "msg_showmode",
          },
        },
        {
          view = "mini",
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
        },
      },
      notify = {
        enabled = true,
        view = "notify",
        opts = {
          replace = true,
          merge = true,
        },
      },
    }

    opts = vim.tbl_deep_extend("force", defaults, opts or {}) or defaults

    if opts and vim.g.neovide then
      opts.messages.view = "notify"
      opts.lsp.message.view = "notify"
      opts.routes[2].view = "notify"
    end

    if opts and not Config.transparent then
      opts.presets.lsp_doc_border = {
        views = {
          hover = {
            border = {
              style = "none",
            },
          },
        },
      }
      opts.views.cmdline_popup.border = {
        style = "none",
        padding = { 1, 2 },
      }
      opts.views.popupmenu.border = {
        style = "none",
        padding = { 1, 2 },
      }
      opts.views.cmdline_popup.win_options = {
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      }
      opts.views.popupmenu.win_options = {
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      }
    end

    require("noice").setup(opts)
  end,

  init = function()
    if require("neoverse.utils").lazy_has("which-key.nvim") then
      require("which-key").register({ mode = "n", ["<leader>l"] = { name = "Logger/Noice" } })
    end
  end,
}
