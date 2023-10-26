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
    event = "VeryLazy",
  },
  {
    "ThePrimeagen/harpoon",
    opts = get("harpoon").opts,
    keys = get("harpoon").keys,
    event = "LazyFile",
  },
  {
    "radvil2/windows.nvim",
    dependencies = "anuvyklack/middleclass",
    opts = get("windows-nvim").opts,
    keys = get("windows-nvim").keys,
    event = "VeryLazy",
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
    keys = get("gitsigns-nvim").keys,
  },
  {
    "nvimdev/dashboard-nvim",
    opts = get("dashboard-nvim").opts,
    event = "VimEnter",
  },
  {
    "nvim-telescope/telescope.nvim",
    config = get("telescope-nvim").config,
    init = get("telescope-nvim").init,
    keys = get("telescope-nvim").keys,
    cmd = "Telescope",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
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
      "b0o/SchemaStore.nvim",
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
    "L3MON4D3/LuaSnip",
    config = get("luasnip").config,
    opts = get("luasnip").opts,
    keys = get("luasnip").keys,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    opts = get("nvim-cmp").opts,
    config = get("nvim-cmp").config,
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  },
  {
    "echasnovski/mini.surround",
    opts = get("mini-surround").opts,
    keys = get("mini-surround").keys,
    init = get("mini-surround").init,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    keys = get("nvim-autopairs").keys,
    event = "InsertEnter",
    opts = {},
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    config = get("nvim-treesitter").config,
    opts = get("nvim-treesitter").opts,
    keys = get("nvim-treesitter").keys,
    init = get("nvim-treesitter").init,
    build = ":TSUpdate",
    cmd = {
      "TSUpdateSync",
      "TSUpdate",
      "TSInstall",
    },
    event = {
      "LazyFile",
      "VeryLazy",
    },
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
    event = "VeryLazy",
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    keys = get("persistence-nvim").keys,
    opts = get("persistence-nvim").opts,
    init = get("persistence-nvim").init,
  },
  {
    "epwalsh/obsidian.nvim",
    config = get("obsidian-nvim").config,
    init = get("obsidian-nvim").init,
    keys = get("obsidian-nvim").keys,
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    --stylua: ignore
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = get("markdown-preview-nvim").keys,
    cmd = "MarkdownPreviewToggle",
    ft = { "markdown" },
    lazy = true,
  },

  -- extensions loader
  require("neoverse.utils").extras.get_specs_by_prios({
    -- ["neoverse.extras.ui.which-key-nvim"] = 9997,
    ["neoverse.extras.ui.legendary-nvim"] = 9996,
    ["neoverse.extras.editor.symbols-outline"] = 100,
  }),
}
