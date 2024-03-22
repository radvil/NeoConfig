return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "Exafunction/codeium.nvim",
      build = ":Codeium Auth",
      cmd = "Codeium",
      opts = {
        bin_path = vim.fn.stdpath("cache") .. "/codeium/bin",
        config_path = vim.fn.stdpath("cache") .. "/codeium/config.json",
        language_server_download_url = "https://github.com",
        api = {
          host = "server.codeium.com",
          port = "443",
        },
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "codeium",
        group_index = 1,
        priority = 100,
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_y, 2, Lonard.lualine.cmp_source("codeium"))
    end,
  },
}
