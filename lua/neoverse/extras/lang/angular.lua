local goToTemplateFile = function()
  local params = vim.lsp.util.make_position_params(0)
  vim.lsp.buf_request(0, "angular/getTemplateLocationForComponent", params, function(_, result)
    if result then
      vim.lsp.util.jump_to_location(result, "utf-8")
    end
  end)
end

local goToComponentFile = function()
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

-- ---@param root_dir? string
-- local getNgCmd = function(root_dir)
--   local bun = os.getenv("HOME") .. "/.bun"
--   local bun_libs = string.format("%s/install/global/node_modules", bun)
--   return {
--     bun .. "/bin/ngserver",
--     "--stdio",
--     "--tsProbeLocations",
--     root_dir .. "," .. bun_libs,
--     "--ngProbeLocations",
--     root_dir .. "," .. bun_libs .. "/@angular/language-server/node_modules",
--   }
-- end

return {
  -- desc = "Angular LSP configuration",
  recommended = function()
    return Lonard.extras.wants({
      ft = {
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      root = { "tsconfig.json", "package.json", "angular.json" },
    })
  end,

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_install) == "table" then
        vim.list_extend(opts.ensure_install, { "angular", "scss" })
      end
    end,
  },

  {
    "nvim-lspconfig",
    ---@type NeoLspOpts
    opts = {
      servers = {
        angularls = {
          -- mason = false,
          single_file_support = true,
          -- on_new_config = function(new_config, new_root_dir)
          --   new_config.cmd = getNgCmd(new_root_dir)
          -- end,
          root_dir = function(fname)
            local util = require("lspconfig").util
            local original = util.root_pattern("angular.json", "project.json")(fname)
            local nx_fallback = util.root_pattern("nx.json", "workspace.json")(fname)
            local git_fallback = util.root_pattern(".git")(fname)
            return original or nx_fallback or git_fallback
          end,
        },
      },
      standalone_setups = {
        angularls = function()
          ---@param client lsp.Client
          Lonard.lsp.on_attach(function(client)
            if client.name == "angularls" then
              client.server_capabilities.renameProvider = false
              cmd("c", goToComponentFile, "Go to component file")
              cmd("t", goToTemplateFile, "Go to template file")
            end
          end)
          return false
        end,
      },
    },
  },
}
