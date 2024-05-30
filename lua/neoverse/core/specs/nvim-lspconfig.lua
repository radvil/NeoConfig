---@diagnostic disable: param-type-mismatch
local M = {}

---@class NeoLspOpts
M.opts = {
  capabilities = {},
  ---@class NeoLspDiagOpts
  diagnostics = {
    float = { border = vim.g.neo_winborder },
    update_in_insert = false,
    severity_sort = true,
    underline = true,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "icons",
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = Lonard.config.icons.Diagnostics.Error,
        [vim.diagnostic.severity.WARN] = Lonard.config.icons.Diagnostics.Warn,
        [vim.diagnostic.severity.HINT] = Lonard.config.icons.Diagnostics.Hint,
        [vim.diagnostic.severity.INFO] = Lonard.config.icons.Diagnostics.Info,
      },
    },
  },
  ---@class NeoLspInlayHintsOpts
  inlay_hints = {
    enabled = false,
  },
  -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
  -- Be aware that you also will need to properly configure your LSP server to
  -- provide the code lenses.
  ---@class NeoLspCodeLensOpts
  codelens = {
    enabled = false,
  },
  -- Enable lsp cursor word highlighting
  document_highlight = {
    enabled = true,
  },
  servers = {
    bashls = {},
    html = {
      -- mason = false,
      -- cmd = {
      --   os.getenv("HOME") .. "/.bun/bin/vscode-html-language-server",
      --   "--stdio",
      -- },
    },
    cssls = {
      -- mason = false,
      -- cmd = {
      --   os.getenv("HOME") .. "/.bun/bin/vscode-css-language-server",
      --   "--stdio",
      -- },
    },
    emmet_language_server = {
      -- mason = false,
      -- cmd = {
      --   os.getenv("HOME") .. "/.bun/bin/emmet-language-server",
      --   "--stdio",
      -- },
    },
    jsonls = {
      -- mason = false,
      -- cmd = {
      --   os.getenv("HOME") .. "/.bun/bin/vscode-json-languageserver",
      --   "--stdio",
      -- },
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
          workspace = {
            checkThirdParty = false,
          },
          codeLens = {
            enable = true,
          },
          completion = {
            callSnippet = "Replace",
          },
          doc = {
            privateName = { "^_" },
          },
          hint = {
            enable = true,
            setType = false,
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
  if Lonard.lazy_has("neoconf.nvim") then
    require("neoconf").setup(Lonard.opts("neoconf.nvim"))
  end

  local border = vim.g.neo_winborder
  require("lspconfig.ui.windows").default_options.border = border

  require("neoverse.core.lsp.autocmds").setup()

  -- setup for autoformat
  Lonard.format.register(Lonard.lsp.formatter())

  -- setup default keymaps for all lsp
  Lonard.lsp.on_attach(require("neoverse.core.lsp.keymaps").on_attach)
  Lonard.lsp.setup()
  Lonard.lsp.on_dynamic_capability(require("neoverse.core.lsp.keymaps").on_attach)
  Lonard.lsp.words.setup(opts.document_highlight)

  require("neoverse.core.lsp.diagnostics").setup(opts.diagnostics)
  require("neoverse.core.lsp.inlay-hints").setup(opts.inlay_hints)
  require("neoverse.core.lsp.codelens").setup(opts.codelens)

  if not Lonard.lazy_has("noice.nvim") then
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
    -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
    --- https://github.com/neovim/neovim/issues/20457#issuecomment-1266782345
    vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
      config = config or {}
      config.border = border
      config.focus_id = ctx.method
      if not (result and result.contents) then
        return
      end
      local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
      -- markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
      if vim.tbl_isempty(markdown_lines) then
        return
      end
      return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
    end
  end

  local cmp_nvim_lsp = Lonard.call("cmp_nvim_lsp")
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
    if opts.standalone_setups[server] then
      if opts.standalone_setups[server](server, server_opts) then
        return
      end
    elseif opts.standalone_setups["*"] then
      if opts.standalone_setups["*"](server, server_opts) then
        return
      end
    end
    require("lspconfig")[server].setup(server_opts)
  end

  local mlsp_servers = {}
  local ensure_installed = {}
  local mason_lspconfig = Lonard.call("mason-lspconfig")

  if mason_lspconfig then
    local server_pairs = require("mason-lspconfig.mappings.server")
    mlsp_servers = vim.tbl_keys(server_pairs.lspconfig_to_package)
  end

  for server, server_opts in pairs(opts.servers) do
    if server_opts then
      server_opts = server_opts == true and {} or server_opts
      if server_opts.enabled ~= false then
        -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
        if server_opts.mason == false or not vim.tbl_contains(mlsp_servers, server) then
          setup(server)
        else
          ensure_installed[#ensure_installed + 1] = server
        end
      end
    end
  end

  if mason_lspconfig then
    mason_lspconfig.setup({
      ensure_installed = vim.tbl_deep_extend(
        "force",
        ensure_installed,
        Lonard.opts("mason-lspconfig.nvim").ensure_installed or {}
      ),
      handlers = {
        setup,
      },
    })
  end

  if Lonard.lsp.is_enabled("denols") and Lonard.lsp.is_enabled("vtsls") then
    local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
    Lonard.lsp.disable("vtsls", is_deno)
    Lonard.lsp.disable("denols", function(root_dir)
      return not is_deno(root_dir)
    end)
  end
end

return M
