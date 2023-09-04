-- TODO: set global options
local enabled = true
local activated = true
local transbg = true

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  -- stylua: ignore
  enabled = function() return enabled end,
  -- stylua: ignore
  keys = {
    {
      "<leader>lu",
      function()
        require("noice")[activated and "disable" or "enable"]()
        activated = not activated
        local msg = activated and "Noice UX » enabled" or "Noice UX » Disabled"
        local lvl = activated and vim.log.levels.INFO or vim.log.levels.WARN
        vim.notify(msg, lvl)
      end,
      desc = "Noice » Toggle",
    },
    { "<c-d>", function() if not require("noice.lsp").scroll(4) then return "<c-d>" end end, expr = true, desc = "Noice » Scroll forward", mode = {"i", "n", "s"} },
    { "<c-u>", function() if not require("noice.lsp").scroll(-4) then return "<c-u>" end end, expr = true, desc = "Noice » Scroll backward", mode = {"i", "n", "s"} },
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Noice » Redirect cmdline" },
    { "<leader>ll", function() require("noice").cmd("last") end, desc = "Noice » Last message" },
    { "<leader>lh", function() require("noice").cmd("history") end, desc = "Noice » History" },
    { "<leader>la", function() require("noice").cmd("all") end, desc = "Noice » All" },
    { "<leader>ld", function() require("noice").cmd("dismiss") end, desc = "Noice » Dismiss All" },
  },

  ---@param opts NoiceConfig
  config = function(_, opts)
    opts = vim.tbl_deep_extend("force", opts or {}, {
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
          position = {
            col = "50%",
            row = 5,
          },
          size = {
            width = 60,
            height = "auto",
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
        },
        popupmenu = {
          relative = "editor",
          border = {
            style = "rounded",
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
    })

    if opts and vim.g.neovide then
      opts.messages.view = "notify"
      opts.lsp.message.view = "notify"
      opts.routes[2].view = "notify"
    end

    if opts and not transbg then
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
}
