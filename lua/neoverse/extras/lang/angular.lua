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
local create_command = function(id, cmd, desc)
  vim.api.nvim_create_user_command(string.format("A%s", id), cmd, {
    desc = string.format("Angular » %s", desc),
  })
end

local angular_root_pattern = { "angular.json", "project.json" }

local get_root_dir = function(root_dir)
  return require("lspconfig.util").root_pattern(unpack(angular_root_pattern))(root_dir)
end

return {
  recommended = function()
    return Lonard.extras.wants({
      root = angular_root_pattern,
    })
  end,

  {
    "nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "angular", "html", "scss" })
      end
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = { "*.html", "*.svg" },
        callback = function(ev)
          if not not get_root_dir(ev.match) then
            vim.treesitter.start(ev.buf, "angular")
          end
        end,
      })
    end,
  },

  -- depends on the typescript extra
  { import = "neoverse.extras.lang.typescript" },

  -- LSP Servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        angularls = {
          root_dir = get_root_dir,
          keys = {
            {
              "<leader>cr",
              function()
                vim.lsp.buf.rename(nil, {
                  filter = function(client)
                    return client.name == "angularls"
                  end,
                })
              end,
              desc = "Rename",
            },
          },
        },
      },
      standalone_setups = {
        angularls = function()
          create_command("c", goToComponentFile, "Go to component file")
          create_command("t", goToTemplateFile, "Go to template file")
        end,
      },
    },
  },
}
