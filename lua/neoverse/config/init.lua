---@type NeoVerseOpts
local M = {}

---@class NeoVerseOpts
local defaults = {
  transparent = false,

  ---@type string|fun()
  colorscheme = function()
    require("tokyonight").load()
  end,

  ---@type fun() | nil
  after_config_init = nil,

  --TODO: reformat icons options
  icons = {
    diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    },
    git = {
      added = " ",
      modified = " ",
      removed = " ",
    },
    kinds = {
      Array = " ",
      Boolean = " ",
      Class = " ",
      Color = " ",
      Constant = " ",
      Constructor = " ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = " ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = " ",
      Module = " ",
      Namespace = " ",
      Null = " ",
      Number = " ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = " ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = " ",
    },
  },
}

---@type NeoVerseOpts | nil
local options

function M.bootstrap(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {})

  if vim.fn.argc(-1) == 0 then
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("NeoVerse", { clear = true }),
      pattern = "VeryLazy",
      callback = function()
        M.after_config_init()
      end,
    })
  else
    M.after_config_init()
  end

  require("lazy.core.util").try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      require("lazy.core.util").error(msg)
      vim.cmd.colorscheme("habamax")
    end,
  })
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    ---@cast options NeoVerseOpts
    return options[key]
  end,
})

return M
