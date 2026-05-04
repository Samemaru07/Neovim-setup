local M = {}

local orig_hover = vim.lsp.buf.hover
vim.lsp.buf.hover = function()
    orig_hover({ border = "rounded" })
end

M.on_attach = function(client, bufnr)
    if client.name == "terraformls" then
        client.server_capabilities.semanticTokensProvider = nil
    end

    local map = vim.keymap.set
    local opts = { noremap = true, silent = true, buffer = bufnr }

    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "gi", vim.lsp.buf.implementation, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    map("n", "[d", vim.diagnostic.goto_prev, opts)
    map("n", "]d", vim.diagnostic.goto_next, opts)
    map("n", "<leader>dl", vim.diagnostic.open_float, opts)
end

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

return M
