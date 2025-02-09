local opts = {
    preset = "powerline",
    disabled_ft = { "markdown", "text" },
}

require("tiny-inline-diagnostic").setup(opts)

require("nvchad.lsp").diagnostic_config()

local x = vim.diagnostic.severity
vim.diagnostic.config {
    virtual_text = false,
    virtual_lines = true,
    signs = {
        text = {
            [x.ERROR] = "E",
            [x.WARN] = "W",
            [x.INFO] = "I",
            [x.HINT] = "H",
        },
        numhl = {
            [x.ERROR] = "DiagnosticError",
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
}
return opts
