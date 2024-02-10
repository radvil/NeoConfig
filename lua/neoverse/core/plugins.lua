---@return LazySpec
local function get(name)
  return require("neoverse.core.specs." .. name)
end

if vim.fn.has("nvim-0.9.0") == 0 then
  vim.api.nvim_echo({
    { "NeoVerse requires Neovim >= 0.9.0\n", "ErrorMsg" },
    { "Press any key to exit", "MoreMsg" },
  }, true, {})
  vim.fn.getchar()
  vim.cmd([[quit]])
  return {}
end

require("neoverse.config").init()

return {
  "folke/lazy.nvim",
  {
    "radvil/NeoVerse",
    priority = 99999,
    config = true,
    version = "*",
    lazy = false,
    cond = true,
  },

  -- ui/ux
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = { default = true },
    lazy = true,
  },
  {
    "s1n7ax/nvim-window-picker",
    opts = get("nvim-window-picker").opts,
    keys = get("nvim-window-picker").keys,
    event = "BufAdd",
  },
  {
    "ThePrimeagen/harpoon",
    opts = get("harpoon").opts,
    keys = get("harpoon").keys,
    lazy = true,
  },
  {
    "radvil2/windows.nvim",
    lazy = true,
    dependencies = { "anuvyklack/middleclass", "anuvyklack/animation.nvim" },
    opts = get("windows-nvim").opts,
    keys = get("windows-nvim").keys,
    config = get("windows-nvim").config,
  },
  {
    "stevearc/dressing.nvim",
    config = get("dressing-nvim").config,
    opts = get("dressing-nvim").opts,
    init = get("dressing-nvim").init,
    lazy = true,
  },
  {
    "stevearc/oil.nvim",
    opts = get("oil-nvim").opts,
    keys = get("oil-nvim").keys,
    deactivate = function()
      vim.cmd([[Oil close]])
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    opts = get("smart-splits-nvim").opts,
    keys = get("smart-splits-nvim").keys,
    lazy = true,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = get("gitsigns-nvim").opts,
  },
  {
    "nvimdev/dashboard-nvim",
    opts = get("dashboard-nvim").opts,
    event = "VimEnter",
  },
  {
    "nvim-lualine/lualine.nvim",
    init = get("lualine-nvim").init,
    opts = get("lualine-nvim").opts,
    event = "VeryLazy",
  },
  {
    "nvim-telescope/telescope.nvim",
    config = get("telescope-nvim").config,
    init = get("telescope-nvim").init,
    keys = get("telescope-nvim").keys,
    cmd = "Telescope",
    lazy = true,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "rcarriga/nvim-notify",
        keys = {
          {
            "<leader>/n",
            function()
              require("telescope").extensions.notify.notify()
            end,
            desc = "telescope » notifications",
          },
        },
      },
    },
  },

  -- colorscheme
  {
    "catppuccin/nvim",
    config = get("catppuccin-nvim").config,
    name = "catppuccin",
    priority = 9999,
    lazy = false,
  },

  --- lsp / linters / formatters
  {
    "williamboman/mason.nvim",
    config = get("mason-nvim").config,
    opts = get("mason-nvim").opts,
    keys = get("mason-nvim").keys,
    build = ":MasonUpdate",
    cmd = "Mason",
  },
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    opts = get("nvim-lspconfig").opts,
    config = get("nvim-lspconfig").config,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "williamboman/mason.nvim",
      {
        "folke/neoconf.nvim",
        dependencies = "neovim/nvim-lspconfig",
        cmd = "Neoconf",
        config = false,
      },
      {
        "folke/neodev.nvim",
        opts = {},
      },
    },
  },
  {
    "b0o/SchemaStore.nvim",
    version = false,
    lazy = true,
  },
  {
    "stevearc/conform.nvim",
    dependencies = "williamboman/mason.nvim",
    config = get("conform-nvim").config,
    keys = get("conform-nvim").keys,
    opts = get("conform-nvim").opts,
    init = get("conform-nvim").init,
    cmd = "ConformInfo",
    lazy = true,
  },
  {
    "mfussenegger/nvim-lint",
    config = get("nvim-lint").config,
    opts = get("nvim-lint").opts,
    event = "LazyFile",
  },

  --- completion
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    config = get("luasnip").config,
    opts = get("luasnip").opts,
    keys = get("luasnip").keys,
  },
  {
    "hrsh7th/nvim-cmp",
    config = get("nvim-cmp").config,
    opts = get("nvim-cmp").opts,
    event = "InsertEnter",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    config = get("nvim-treesitter").config,
    opts = get("nvim-treesitter").opts,
    keys = get("nvim-treesitter").keys,
    init = get("nvim-treesitter").init,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    event = { "LazyFile", "VeryLazy" },
    build = ":TSUpdate",
  },

  -- editor
  {
    "numToStr/Comment.nvim",
    event = "BufReadPre",
    opts = {
      padding = true,
      sticky = true,
    },
  },
  {
    "echasnovski/mini.bufremove",
    keys = get("mini-bufremove").keys,
    init = get("mini-bufremove").init,
  },
  {
    "nvim-pack/nvim-spectre",
    keys = get("nvim-spectre").keys,
    opts = get("nvim-spectre").opts,
    cmd = "Spectre",
    build = false,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = get("indent-blankline").config,
    keys = get("indent-blankline").keys,
    event = "LazyFile",
    main = "ibl",
  },
  {
    "RRethy/vim-illuminate",
    config = get("vim-illuminate").config,
    opts = get("vim-illuminate").opts,
    init = get("vim-illuminate").init,
    keys = get("vim-illuminate").keys,
    event = "LazyFile",
  },

  -- misc
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "tpope/vim-repeat",
    event = "BufReadPre",
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    keys = get("persistence-nvim").keys,
    opts = get("persistence-nvim").opts,
  },

  -- extensions loader
  require("neoverse.utils").extras.get_specs_by_prios({
    ["neoverse.extras.ui.which-key-nvim"] = 9997,
    ["neoverse.extras.ui.legendary-nvim"] = 9996,
    ["neoverse.extras.completion.codeium"] = 9994,
    ["neoverse.extras.editor.symbols-outline"] = 100,
  }),
}
