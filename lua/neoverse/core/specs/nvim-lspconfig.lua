local Utils = require("neoverse.utils")

---@diagnostic disable: param-type-mismatch
local M = {}

---@class NeoLspOpts
M.opts = {
  capabilities = {},
  ---@class NeoLspDiagOpts
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
  ---@class NeoLspInlayHintsOpts
  inlay_hints = {
    enabled = false,
  },
  servers = {
    bashls = {},
    html = {},
    cssls = {},
    emmet_language_server = {},
    jsonls = {
      on_new_config = function(new_config)
        new_config.settings.json.schemas = new_config.settings.json.schemas or {}
        vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
      end,
      settings = {
        json = {
          format = { enable = true },
          validate = { enable = true },
        },
      },
    },
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
  if vim.g.neo_transparent then
    require("lspconfig.ui.windows").default_options.border = "rounded"
  end

  if Utils.lazy_has("neoconf.nvim") then
    local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
    require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
  end

  require("neoverse.core.lsp.autocmds").setup()

  -- register formatter along with autoformat
  Utils.format.register(Utils.lsp.formatter())

  require("neoverse.core.lsp.keymaps").setup()
  require("neoverse.core.lsp.diagnostics").setup(opts.diagnostics)
  require("neoverse.core.lsp.inlay-hints").setup(opts.inlay_hints)

  local cmp_nvim_lsp = Utils.call("cmp_nvim_lsp")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or {},
    opts.capabilities or {}
  )

  local function setup(server)
    local server_opts = vim.tbl_deep_extend("force", {
      capabilities = vim.deepcopy(capabilities),
    }, opts.servers[server] or {})
    if opts.standalone_setups then
      if opts.standalone_setups[server] then
        if opts.standalone_setups[server](server, server_opts) then
          return
        end
      elseif opts.standalone_setups["*"] then
        if opts.standalone_setups["*"](server, server_opts) then
          return
        end
      end
    end
    require("lspconfig")[server].setup(server_opts)
  end

  local mlsp_servers = {}
  local ensure_installed = {}
  local mason_lspconfig = Utils.call("mason-lspconfig")

  if mason_lspconfig then
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

  if mason_lspconfig then
    mason_lspconfig.setup({
      ensure_installed = ensure_installed,
      handlers = {
        setup,
      },
    })
  end

  if Utils.lsp.get_config("denols") and Utils.lsp.get_config("tsserver") then
    local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
    Utils.lsp.disable("tsserver", is_deno)
    Utils.lsp.disable("denols", function(root_dir)
      return not is_deno(root_dir)
    end)
  end
end

return M
