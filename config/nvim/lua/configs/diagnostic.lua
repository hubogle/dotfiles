local M = {}

M.setup = function()
    require("nvchad.lsp").diagnostic_config()

    local x = vim.diagnostic.severity
    vim.diagnostic.config {
        virtual_text = false,
        virtual_lines = { current_line = true },
        signs = {
            text = {
                [x.ERROR] = "",
                [x.WARN] = "",
                [x.INFO] = "",
                [x.HINT] = "",
            },
            numhl = {
                [x.ERROR] = "DiagnosticError",
                [x.WARN] = "DiagnosticWarn",
                [x.INFO] = "DiagnosticInfo",
                [x.HINT] = "DiagnosticHint",
            },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    }
end

return M