local getTemplateLocationForComponent = function()
  local params = vim.lsp.util.make_position_params(0)
  vim.lsp.buf_request(0, "angular/getTemplateLocationForComponent", params, function(_, result)
    if result then
      vim.lsp.util.jump_to_location(result, "utf-8")
    end
  end)
end

local getComponentsWithTemplateFile = function()
  local params = vim.lsp.util.make_position_params(0)
  vim.lsp.buf_request(0, "angular/getComponentsWithTemplateFile", params, function(_, result)
    if result then
      if #result == 1 then
        vim.lsp.util.jump_to_location(result[1], "utf-8")
      else
        vim.fn.setqflist({}, " ", {
          title = "Angular Language Server",
          items = vim.lsp.util.locations_to_items(result, "utf-8"),
        })
        vim.cmd.copen()
      end
    end
  end)
end

---@param id string
---@param cmd string | function
---@param desc string
local cmd = function(id, cmd, desc)
  vim.api.nvim_create_user_command(string.format("A%s", id), cmd, {
    desc = string.format("Angular » %s", desc),
  })
end

return {
  {
    "radvil2/nvim-treesitter-angular",
    ft = { "typescript", "html" },
    branch = "jsx-parser-fix",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
          if type(opts.ensure_installed) == "table" then
            vim.list_extend(opts.ensure_installed, {
              "scss",
              "graphql",
            })
          end
        end,
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    ---@type NeoLspOpts
    opts = {
      servers = {
        angularls = {
          single_file_support = true,
          root_dir = function(fname)
            local util = require("lspconfig").util
            local original = util.root_pattern("angular.json")(fname)
            local fallback = util.root_pattern("nx.json", "workspace.json")(fname)
            return original or fallback
          end,
        },
      },

      standalone_setups = {
        angularls = function()
          ---@param client lsp.Client
          require("neoverse.utils").on_lsp_attach(function(client)
            if client.name == "angularls" then
              client.server_capabilities.renameProvider = false
              cmd("t", getComponentsWithTemplateFile, "Goto component template file")
              cmd("c", getTemplateLocationForComponent, "Goto component class file")
            end
          end)
        end,
      },
    },
  },
}
