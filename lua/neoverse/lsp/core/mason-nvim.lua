return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = {
    {
      "<leader>fm",
      vim.cmd.Mason,
      desc = "Float » Mason",
    },
  },

  config = function(_, opts)
    local NeoConfig = require("neoverse.config")
    opts = vim.tbl_deep_extend("force", opts or {}, {
      ui = {
        border = NeoConfig.transparent and "single" or "none",
        icons = NeoConfig.icons.Mason,
      },
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    })
    require("mason").setup(opts)
    local registry = require("mason-registry")
    local function ensure_installed()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = registry.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end
    if registry.refresh then
      registry.refresh(ensure_installed)
    else
      ensure_installed()
    end
  end,
}

