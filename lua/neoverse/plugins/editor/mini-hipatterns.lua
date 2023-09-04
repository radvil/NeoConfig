---@type LazySpec
return {
  "echasnovski/mini.hipatterns",
  event = "BufReadPre",
  config = function()
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
      delay = { text_change = 200, scroll = 50 },
      highlighters = {
        debug = { pattern = "%f[%w]()TOGGLE()%f[%W]", group = "NvimMiniYellow" },
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    })
  end,
}
