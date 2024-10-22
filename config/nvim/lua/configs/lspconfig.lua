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
lspconfig["lua_ls"].setup {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "use", "vim" },
                disable = { "different-requires" },
            },
            hint = {
                enable = true,
                setType = true,
            },
            telemetry = {
                enable = false,
            },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
}

vim.diagnostic.config {
    virtual_text = false,
    -- signs = false, -- never show signs
    signs = {
        --support diagnostic severity / diagnostic type name
        text = { ["ERROR"] = " ", ["WARN"] = "!", ["INFO"] = " ", ["HINT"] = "󰌵" },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        style = "minimal",
        border = "rounded",
    },
}
