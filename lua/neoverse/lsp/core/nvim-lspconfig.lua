---@diagnostic disable: assign-type-mismatch, param-type-mismatch
---@type LazySpec
local M = {}

M[1] = "neovim/nvim-lspconfig"

M.event = { "BufReadPre", "BufNewFile" }

M.dependencies = {
  "mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  { "folke/neodev.nvim", opts = {} },
  {
    "folke/neoconf.nvim",
    dependencies = "nvim-lspconfig",
    cmd = "Neoconf",
    config = false,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = "hrsh7th/nvim-cmp",
  },
}

---@class NeoLspOpts
M.opts = {
  capabilities = {},
  diagnostics = {
    float = { border = "rounded" },
    update_in_insert = false,
    severity_sort = true,
    underline = true,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "icons",
    },
  },
  ---@type NeoLspFormatOpts
  format = {
    autoformat = true,
    notify = false,
  },
  ---@type NeoLspMappingOpts
  mappings = {
    enable_defaults = true,
    ---@param client lsp.Client
    on_attach = function(client, bufnr)
      local active = false
      local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
      if inlay_hint and client.supports_method("textDocument/inlayHint") then
        inlay_hint(bufnr, active)
        vim.keymap.set("n", "<leader>uh", function()
          active = not active
          inlay_hint(bufnr, active)
          vim.notify(
            "LSP » Inlay hint " .. (active and "enabled" or "disabled") .. string.format(" [%s]", bufnr),
            vim.log.levels[active and "INFO" or "WARN"]
          )
        end, { buffer = bufnr, desc = "Toggle » Inlay hints" })
      end
    end,
  },
  prehook = function()
    ---@param name string
    ---@param cb function | string
    ---@param desc string
    local cmd = function(name, cb, desc)
      return vim.api.nvim_create_user_command("C" .. name, cb, { desc = "LSP » " .. desc })
    end
    cmd("R", "lua vim.lsp.buf.rename()", "Rename under cursor")
    cmd("A", "lua vim.lsp.buf.code_action()", "Code action")
    cmd("D", "Telescope lsp_definitions", "Find definitions")
    cmd("V", vim.lsp.buf.signature_help, "Signature help")
    cmd("I", "Telescope lsp_implementations", "Find implementations")
    cmd("L", "Telescope lsp_references", "Find references")
    cmd("T", "Telescope lsp_type_definitions", "Find type defintions")
  end,
  servers = {
    bashls = {},
    html = {},
    cssls = {},
    emmet_language_server = {},
    lua_ls = {
      mason = true,
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          completion = { callSnippet = "Replace" },
          hint = {
            enable = true,
            setType = true,
            paramType = true,
            paramName = "Disable",
            semicolon = "Disable",
            arrayIndex = "Disable",
          },
        },
      },
    },
  },
  ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
  standalone_setups = {
    -- tsserver = function(_, opts)
    --   require("typescript").setup({ server = opts })
    --   return true
    -- end,
    -- Specify * to use this function as a fallback for any server
    -- ["*"] = function(server, opts) end,
  },
}

M.config = function(_, opts)
  if require("neoverse.config").transparent then
    require("lspconfig.ui.windows").default_options.border = "rounded"
  end

  if require("neoverse.utils").lazy_has("neoconf.nvim") then
    local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
    require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
  end

  if opts.prehook then
    opts.prehook()
  end

  -- require("neoverse.lsp.bun-utils").setup({ "tailwindcss", "angularls", "tsserver", "eslint" })
  require("neoverse.lsp.diagnostic").setup(opts.diagnostics)
  require("neoverse.lsp.keymap").setup(opts.mappings)
  require("neoverse.lsp.format").setup(opts.format)

  local function setup(server)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    local setup_opts = vim.tbl_deep_extend("force", {
      capabilities = vim.deepcopy(
        vim.tbl_deep_extend(
          "force",
          {},
          capabilities,
          require("cmp_nvim_lsp").default_capabilities(),
          opts.capabilities or {}
        )
      ),
    }, opts.servers[server] or {})
    if opts.standalone_setups then
      if opts.standalone_setups[server] then
        if opts.standalone_setups[server](server, setup_opts) then
          return
        end
      elseif opts.standalone_setups["*"] then
        if opts.standalone_setups["*"](server, setup_opts) then
          return
        end
      end
    end
    require("lspconfig")[server].setup(setup_opts)
  end

  local mlsp_servers = {}
  local ensure_installed = {}
  local mlsp_ok, mlsp = pcall(require, "mason-lspconfig")

  if mlsp_ok then
    local server_pairs = require("mason-lspconfig.mappings.server")
    mlsp_servers = vim.tbl_keys(server_pairs.lspconfig_to_package)
  end

  for name, options in pairs(opts.servers) do
    if options then
      options = options == true and {} or options
      if options.mason == false or not vim.tbl_contains(mlsp_servers, name) then
        setup(name)
      else
        ensure_installed[#ensure_installed + 1] = name
      end
    end
  end

  if mlsp then
    mlsp.setup({
      ensure_installed = ensure_installed,
      handlers = {
        setup,
      },
    })
  end
end

return M
