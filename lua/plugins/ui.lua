return {
    { "nvim-tree/nvim-web-devicons", lazy = true },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree",
        keys = {
            { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" },
        },
        config = function()
            require("ui.neo-tree")
        end,
    },
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        config = function()
            require("ui.bufferline")
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("ui.lualine")
        end,
    },
    {
        "akinsho/toggleterm.nvim",
        keys = {
            { "<leader>th", "<cmd>ToggleTerm<cr>", desc = "Terminal" },
            { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
            { "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", desc = "Toggle lazygit" },
        },
        config = function()
            require("ui.toggleterm")
        end,
    },
    {
        "folke/trouble.nvim",
        cmd = { "Trouble", "TroubleToggle" },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
            { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
        },
        config = function()
            require("ui.trouble")
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
    },
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require("ui.colorscheme")
        end,
    },
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        config = function()
            require("ui.dashboard")
            vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#AFEEEE" })
        end,
    },
    {
        "shellRaining/hlchunk.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("hlchunk").setup({
                chunk = {
                    enable = true,
                    style = { guibg = "#2E2E2E" },
                    exclude_filetypes = { "tex", "latex", "markdown" },
                },
                indent = {
                    enable = true,
                    char = "│",
                    style = { "Indent1", "Indent2", "Indent3", "Indent4", "Indent5", "Indent6" },
                },
                highlight = { "Indent1", "Indent2", "Indent3", "Indent4", "Indent5", "Indent6" },
                exclude_filetypes = { "alpha", "neo-tree", "toggleterm" },
            })
            vim.cmd([[
                highlight Indent1 guifg=#FF8FA1 gui=nocombine
                highlight Indent2 guifg=#FFC27F gui=nocombine
                highlight Indent3 guifg=#62C8C8 gui=nocombine
                highlight Indent4 guifg=#7FD1A8 gui=nocombine
                highlight Indent5 guifg=#A776B7 gui=nocombine
                highlight Indent6 guifg=#FFB84D gui=nocombine
            ]])
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("notify").setup({
                background_colour = "#000000",
                stages = "fade_in_slide_out",
                timeout = 2000,
                fps = 60,
                render = "default",
                icons = {
                    ERROR = "❌",
                    WARN = "⚠️",
                    INFO = "💬",
                    DEBUG = "🐞",
                    TRACE = "🔍",
                },
                on_open = function()
                    vim.fn.jobstart({
                        "paplay",
                        "/usr/share/sounds/freedesktop/stereo/complete.oga",
                    }, { detach = true })
                end,
            })

            require("noice").setup({
                cmdline = {
                    view = "cmdline_popup",
                    format = {
                        cmdline = { pattern = "^:", icon = "", lang = "vim", title = "コマンド" },
                        search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex", title = "検索" },
                        search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex", title = "検索" },
                    },
                },
                views = {
                    cmdline_popup = {
                        position = { row = "40%", col = "50%" },
                        size = { width = 60, height = "auto" },
                        border = { style = "rounded", title_pos = "left" },
                    },
                },
                lsp = {
                    progress = { enabled = false },
                    message = { enabled = false },
                    hover = { enabled = false },
                    signature = { enabled = false },
                },
                presets = { command_palette = false },
                routes = {
                    { filter = { event = "msg_show", kind = "", find = "lines yanked" }, opts = { skip = true } },
                    { filter = { event = "msg_show", kind = "", find = "line yanked" }, opts = { skip = true } },
                    { filter = { event = "msg_show", kind = "diagnostic" }, opts = { skip = true } },
                    {
                        filter = { event = "msg_show", kind = "", find = "No formatters available" },
                        opts = { skip = true },
                    },
                },
                messages = {
                    enabled = false,
                    view = "notify",
                    view_error = "notify",
                    view_warn = "notify",
                    view_history = "messages",
                    view_search = "virtualtext",
                },
            })
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup({
                plugins = { marks = true, registers = true, spelling = { enabled = true, suggestions = 20 } },
                win = { border = "rounded" },
                icons = { show = false },
            })
        end,
    },
    {
        "gen740/SmoothCursor.nvim",
        event = "VeryLazy",
        config = function()
            require("smoothcursor").setup({
                autostart = true,
                cursor = "",
                texthl = "SmoothCursor",
                linehl = nil,
                type = "default",
                fancy = {
                    enable = true,
                    head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil },
                    body = {
                        { cursor = "●", texthl = "SmoothCursorRed" },
                        { cursor = "●", texthl = "SmoothCursorOrange" },
                        { cursor = "●", texthl = "SmoothCursorYellow" },
                        { cursor = "●", texthl = "SmoothCursorGreen" },
                        { cursor = "•", texthl = "SmoothCursorAqua" },
                        { cursor = ".", texthl = "SmoothCursorBlue" },
                        { cursor = ".", texthl = "SmoothCursorPurple" },
                    },
                    tail = { cursor = nil, texthl = "SmoothCursor" },
                },
                flyin_effect = "bottom",
                speed = 25,
                intervals = 35,
                priority = 10,
                timeout = 3000,
                threshold = 3,
                disable_float_win = false,
                enabled_filetypes = nil,
                disabled_filetypes = { "help", "lazy" },
            })
        end,
    },
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        opts = {
            animation_time = 300,
            easing_function = "quadratic",
        },
    },
    {
        "Bekaboo/dropbar.nvim",
        event = { "BufReadPost", "BufNewFile" },
        url = "git@github.com:Bekaboo/dropbar.nvim.git",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                url = "git@github.com:nvim-telescope/telescope-fzf-native.nvim.git",
                build = "make",
            },
        },
        config = function()
            local dropbar_api = require("dropbar.api")
            vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
            vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
            vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
        end,
    },
    { "moll/vim-bbye", event = "VeryLazy" },
}
