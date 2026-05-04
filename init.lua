local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

math.randomseed(os.time())

vim.g.mapleader = " "

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("plugins")

vim.filetype.add({
    extension = {
        j2 = "jinja2",
        jinja = "jinja2",
        jinja2 = "jinja2",
        tfvars = "terraform",
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "terraform-vars",
    callback = function()
        vim.bo.filetype = "terraform"
    end,
})

-- Disable formatter for .tfvars files
vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*.tfvars",
    callback = function()
        vim.b.disable_autoformat = true
    end,
})

-- swap / backup / undo ディレクトリの保証
local data_dir = vim.fn.stdpath("data")
local swap_dir = data_dir .. "/swap//"
local backup_dir = data_dir .. "/backup//"
local undo_dir = data_dir .. "/undo//"

local function ensure_dir(path)
    if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, "p")
    end
end

ensure_dir(swap_dir)
ensure_dir(backup_dir)
ensure_dir(undo_dir)

vim.o.swapfile = true
vim.o.directory = swap_dir

vim.o.backup = true
vim.o.backupdir = backup_dir

vim.o.undofile = true
vim.o.undodir = undo_dir

-- WSL クリップボード設定
if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = {
        name = "win32yank-wsl",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
    }
end
