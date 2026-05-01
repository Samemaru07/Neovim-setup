return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = {
            { "<leader>f", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
            { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep string" },
            { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
            { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git/" },
                    mappings = {
                        i = {
                            ["<C-j>"] = false,
                        },
                    },
                },
            })
        end,
    },

    {
        "nvim-pack/nvim-spectre",
        cmd = { "Spectre" },
        keys = {
            { "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', desc = "Toggle Spectre" },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("spectre").setup({
                find_engine = { ["rg"] = { cmd = "rg", args = { "--vimgrep" } } },
            })
        end,
    },

    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    html = { "prettier" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescriptreact = { "prettier" },
                    python = { "ruff", "black" },
                    c = { "clang_format" },
                    cpp = { "clang_format" },
                    php = { "pint" },
                    lua = { "stylua" },
                    sh = { "shfmt" },
                    sql = { "pg_format" },
                    tex = { "latexindent" },
                    bib = { "latexindent" },
                    verilog = { "verible-verilog-format", lsp_fallback = false },
                    go = { "goimports" },
                    json = { "prettier" },
                    jsonc = { "prettier" },
                    qml = { "qmlformat" },
                    processing = { "clang_format" },
                    markdown = { "prettier", "markdownlink" },
                    css = { "prettier" },
                    scss = { "prettier" },
                    terraform = { "terraform_fmt" },
                    tf = { "terraform_fmt" },

                },
                formatters = {
                    ["verible-verilog-format"] = {
                        command = "/usr/local/bin/verible-verilog-format",
                        args = { "-" },
                    },
                    latexindent = {
                        command = "latexindent",
                        timeout_ms = 10000,
                        prepend_args = { "-logfile", "/dev/null" },
                    },
                    prettier = {
                        prepend_args = { "--trailing-comma", "none", "--tab-width", "4" },
                    },
                    stylua = {
                        prepend_args = { "--config-path", vim.fn.stdpath("config") .. "/tools/stylua.toml" },
                    },

                },
            })
        end,
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("core.lint")
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("gitsigns").setup()
        end,
    },
}
