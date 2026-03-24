local toggleterm = require("toggleterm")

toggleterm.setup({
    direction = "float",
    start_in_insert = true,
    close_on_exit = false,
    float_opts = {
        border = "rounded",
        width = math.floor(vim.o.columns * 0.85),
        height = math.floor(vim.o.lines * 0.85),
    },
    winbar = { enabled = false },
    env = { TOGGLETERM = "1" },
    on_open = function()
        vim.schedule(function()
            vim.cmd("startinsert")
        end)
    end,
    on_focus = function()
        vim.schedule(function()
            vim.cmd("startinsert")
        end)
    end,
})

vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true, desc = "Toggle Terminal" })

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    close_on_exit = true,
})

function _lazygit_toggle()
    lazygit:toggle()
end

vim.keymap.set(
    "n",
    "<leader>g",
    "<cmd>lua _lazygit_toggle()<CR>",
    { noremap = true, silent = true, desc = "Toggle lazygit" }
)
