vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "ts_ls",
    }
})

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = {
                -- Tell the LSP which version of Lua youre using
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the LSP to recognize the 'vim' global
                globals = {
                    'vim',
                    'require',
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false
            },
        },
    },
})
