require("neo-tree").setup({
    window = {
        width = 25,
    },
    close_if_last_window = false,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
        filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = false,
        },
        follow_current_file = {
            enabled = true,
        },
    },
})
