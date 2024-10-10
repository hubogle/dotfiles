-- load defaults i.e lua_lsp
dofile(vim.g.base46_cache .. "lsp")
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "gopls", "pylsp", "lua_ls", "bashls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
    }
end

-- configuring single server, example: typescript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

vim.diagnostic.config {
    virtual_text = false,
    signs = true, -- never show signs
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        style = "minimal",
        border = "rounded",
        source = "always",
    },
}
