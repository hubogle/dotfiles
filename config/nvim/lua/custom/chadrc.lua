-- Just an example, supposed to be placed in /lua/custom/

local M = {}
local plugins = require "custom.plugins"
local plugin_conf = require "custom.configs" -- 插件变量配置

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.ui = {
   theme = "gruvchad", -- 更改主题
}

M.options = {
   user = function()
      vim.opt.encoding = "utf-8"
      vim.opt.relativenumber = true -- 相对行号
   end,
}

M.plugins = {
   install = plugins,
   status = {
      colorizer = true,
      dashboard = true,
   },
   default_plugin_config_replace = {
      dashboard = "custom.plugins.dashboard",
      nvim_treesitter = plugin_conf.treesitter,
      nvim_tree = plugin_conf.nvimtree,
      statusline = plugin_conf.statusline,
   },
}

return M
