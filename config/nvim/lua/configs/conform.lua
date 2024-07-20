local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    go = { "gofumpt" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },
}

require("conform").setup(options)
