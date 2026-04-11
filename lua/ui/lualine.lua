local function skkeleton_mode()
    local mode = vim.fn["skkeleton#mode"]()
    if mode == "hira" then
        return "[あ]"
    elseif mode == "kata" then
        return "[ア]"
    elseif mode == "hankata" then
        return "[ｱ]"
    else
        return "[A]"
    end
end

require("lualine").setup({
    options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { "alpha" },
    },
    sections = {
        lualine_a = {
            {
                "noice",
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
            },
            {
                function()
                    if vim.bo.buftype == "terminal" then
                        local m = vim.api.nvim_get_mode().mode
                        if m == "t" then
                            return "ターミナル -- TERMINAL --"
                        else
                            return "ターミナル -- TERMINAL-NORMAL --"
                        end
                    end
                    return ""
                end,
                color = function()
                    if vim.bo.buftype == "terminal" then
                        local m = vim.api.nvim_get_mode().mode
                        if m == "t" then
                            return { fg = "#000000", bg = "#d19a66" }
                        else
                            return { fg = "#000000", bg = "#61afef" }
                        end
                    end
                    return nil
                end,
                separator = { right = "" },
            },
        },
        lualine_b = {
            {
                "mode",
                cond = function()
                    return vim.o.buftype ~= "terminal" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
                color = function()
                    local mode_colors = {
                        n = { fg = "#000000", bg = "#89b4fa" },
                        i = { fg = "#000000", bg = "#a6e3a1" },
                        v = { fg = "#000000", bg = "#cba6f7" },
                        V = { fg = "#000000", bg = "#cba6f7" },
                        ["\22"] = { fg = "#000000", bg = "#cba6f7" },
                        R = { fg = "#000000", bg = "#f38ba8" },
                        c = { fg = "#000000", bg = "#f9e2af" },
                    }
                    local m = vim.api.nvim_get_mode().mode
                    return mode_colors[m] or { fg = "#000000", bg = "#708090" }
                end,
                separator = { right = "" },
            },
            {
                "branch",
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
                color = { fg = "#000000", bg = "#778899" },
                separator = { right = "" },
            },
        },
        lualine_c = {
            {
                function()
                    if vim.bo.buftype == "terminal" then
                        return ""
                    end
                    local ft = vim.bo.filetype
                    if ft == "NvimTree" then
                        return "" -- ここを空文字に変更
                    end
                    if ft == "alpha" then
                        return ""
                    end

                    if vim.bo.modified then
                        return "そんなファイル、保存してやる！！"
                    else
                        return "保存しておけばどうということはない！"
                    end
                end,
                color = nil,
            },
        },
        lualine_x = {
            {
                function()
                    return ""
                end,
            },
        },
        lualine_y = {
            {
                "progress",
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
                color = { fg = "#000000", bg = "#778899" },
            },
        },
        lualine_z = {
            {
                "location",
                cond = function()
                    return vim.bo.buftype == "" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
                color = { fg = "#000000", bg = "#778899" },
            },
            {
                skkeleton_mode,
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha"
                end,
                color = { fg = "#000000", bg = "#5f676f" },
                padding = { left = 1, right = 1 },
                separator = { fg = "#ffffff", left = "" },
            },
            {
                "filetype",
                cond = function()
                    return vim.bo.buftype == "" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
                colored = true,
                padding = { left = 1, right = 1 },
                color = { fg = "#000000", bg = "#708090" },
                separator = { left = "" },
            },
            {
                "encoding",
                cond = function()
                    return vim.bo.buftype == "" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
                padding = { left = 1, right = 1 },
                color = { fg = "#000000", bg = "#708090" },
                separator = { left = "" },
            },
        },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            {
                function()
                    -- NvimTreeの場合も空文字を返すように変更
                    return ""
                end,
            },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
})
