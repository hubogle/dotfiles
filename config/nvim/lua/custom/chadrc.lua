-- Just an example, supposed to be placed in /lua/custom/

local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

-- 覆盖插件配置
local pluginConfs = require "custom.plugins.configs"

M.ui = {
   theme = "onenord",
   -- transparency = true, -- 开启透明，行也透明
   theme_toggle = { "onenord", "onenord_light" }, -- 主题切换
   hl_override = {
      CursorLine = { -- 光标行
         bg = "one_bg",
      },
      Normal = {}
      -- Normal = {
      -- bg = "none" -- 背景色彩
      --    fg = "none" -- 字体颜色
      -- },
   },
}

if vim.fn.has('gui_running') == 0 then -- 非 GUI 背景设置为透明
   M.ui["hl_override"]["Normal"]["bg"] = "none"
end

M.plugins = {
   override = {
      ["nvim-treesitter/nvim-treesitter"] = pluginConfs.treesitter,
      ["kyazdani42/nvim-tree.lua"] = pluginConfs.nvimtree,
   },
   user = require "custom.plugins",
}

return M
