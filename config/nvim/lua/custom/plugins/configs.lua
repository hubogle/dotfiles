local M = {}

M.treesitter = {
   ensure_installed = {
      "lua",
      "go",
      "python",
   },
}

M.nvimtree = {
   git = {
      enable = true,
   },
   view = {
      side = "left",
      width = 20,
   },
   renderer = {
        highlight_git = true,
        icons = {
            show = {
                git = true,
            },
        },
    },
}

return M
