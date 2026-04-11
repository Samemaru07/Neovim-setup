local bufferline = require("bufferline")

bufferline.setup({
    options = {
        mode = "buffers",
        numbers = function(opts)
            return string.format("%d:", opts.ordinal)
        end,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
        end,
        separator_style = "thick",
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        offsets = {
            {
                filetype = "neo-tree",
                text = "エクスプローラ",
                text_align = "center",
                separator = true,
            },
        },
        hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
        },
        indicator = {
            style = "none",
        },
        tab_size = 20,
        padding = 1,
    },
})
