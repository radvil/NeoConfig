return {
  "luukvbaal/statuscol.nvim",
  event = "LazyFile",
  opts = function()
    local builtin = require("statuscol.builtin")
    return {
      relculright = true,
      ft_ignore = {
        "DiffviewFiles",
        "dashboard",
        "NvimTree",
        "neo-tree",
        "Outline",
        "Trouble",
      },
      segments = {
        {
          text = { "%s" },
          click = "v:lua.ScSa",
        },
        -- {
        --   text = {
        --     function(args)
        --       local buf = vim.api.nvim_win_get_buf(args.win)
        --       local marks = vim.fn.getmarklist(buf)
        --       vim.list_extend(marks, vim.fn.getmarklist())
        --       local res = "%*"
        --       for _, item in ipairs(marks) do
        --         if item.pos[1] == buf and item.pos[2] == args.lnum and item.mark:match("[a-zA-Z]") then
        --           res = item.mark:sub(2)
        --           break
        --         end
        --       end
        --       return "%#DiagnosticHint#%=" .. res
        --     end,
        --     " ",
        --   },
        --   condition = {
        --     function(args)
        --       return args.win == vim.api.nvim_get_current_win()
        --     end,
        --   },
        -- },
        {
          text = { builtin.lnumfunc, " " },
          click = "v:lua.ScLa",
        },
        {
          text = { builtin.foldfunc, " " },
          click = "v:lua.ScFa",
        },
      },
    }
  end,
}
