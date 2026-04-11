return {
    {
        "lervag/vimtex",
        ft = { "tex", "latex", "bib" },
        init = function()
            vim.fn.delete("/tmp/nvimsocket")
            vim.fn.serverstart("/tmp/nvimsocket")
            vim.g.vimtex_compiler_progname = "/home/samemaru/.local/bin/nvr"
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk_engines = { _ = "-lualatex" }
            vim.g.vimtex_compiler_latexmk = {
                continuous = 1,
                options = {
                    "-synctex=1",
                    "-interaction=nonstopmode",
                    "-file-line-error",
                    "-halt-on-error",
                    "-shell-escape",
                },
            }
            vim.g.vimtex_view_general_viewer = "zathura"
            vim.g.vimtex_view_general_options =
                '-x "/home/samemaru/.local/bin/nvr --servername /tmp/nvimsocket --remote-silent +%{line} %{input}" --synctex-forward @line:0:@tex @pdf'
        end,
    },

    { "vhda/verilog_systemverilog.vim", ft = { "verilog", "systemverilog" } },

    {
        "tpope/vim-dadbod",
        cmd = { "DB" },
        dependencies = { "kristijanhusak/vim-dadbod-ui" },
        config = function()
            vim.g.db_ui_save_location = "~/.config/nvim/db_ui"
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },

    {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "psql" },
        dependencies = { "tpope/vim-dadbod" },
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql", "mysql", "psql" },
                callback = function()
                    local cmp = require("cmp")
                    cmp.setup.buffer({
                        sources = cmp.config.sources({
                            { name = "vim-dadbod-completion" },
                        }, {
                            { name = "buffer" },
                            { name = "path" },
                        }),
                    })
                end,
            })
        end,
    },

    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = "cd app & npm install",
        config = function()
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_open_to_the_world = 0
            vim.g.mkdp_open_ip = "127.0.0.1"

            -- OS判別
            local is_wsl = (function()
                local output = vim.fn.systemlist("uname -r")
                if not output[1] then
                    return false
                end
                return output[1]:lower():find("microsoft") ~= nil
            end)()

            if is_wsl then
                -- WSL環境の設定
                vim.g.mkdp_browser = ""
                vim.g.mkdp_browserfunc = "OpenWslBrowser"
                vim.cmd([[
                function! OpenWslBrowser(url)
                    call system('wslview ' . shellescape(a:url))
                endfunction
            ]])
            else
                -- Arch Linuxの設定
                vim.g.mkdp_browser = ""
                vim.g.mkdp_browserfunc = ""
            end
        end,
    },

    {
        "aidavdw/bibcite.nvim",
        cmd = { "CiteOpen", "CiteInsert", "CitePeek", "CiteNote" },
        keys = {},
        opts = function()
            local cwd = vim.fn.getcwd()
            local config = {
                bibtex_path = "~/Documents/research/references.bib",
                pdf_dir = "~/Documents/research/papers",
                notes_dir = "~/Documents/research/notes",
                text_file_open_mode = "vsplit",
            }
            if string.find(cwd, "/home/samemaru/projects/Project_A") then
                config.bibtex_path = "/home/samemaru/projects/Project_A/references.bib"
                config.pdf_dir = "/home/samemaru/projects/Project_A/pdfs"
            elseif string.find(cwd, "/home/samemaru/3rd_year/experiment3/amp_fh") then
                config.bibtex_path = "/home/samemaru/3rd_year/experiment3/amp_fh/ref/references.bib"
            end
            return config
        end,
    },

    { "sophacles/vim-processing", ft = "processing" },
}
