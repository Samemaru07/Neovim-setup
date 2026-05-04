local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    -- 論文
    s("article", {
        t("@article{"),
        i(1, "key"),
        t({ ",", "    author  = {" }),
        i(2, "Last, First and Last, First"),
        t({ "},", "    title   = {" }),
        i(3),
        t({ "},", "    journal = {" }),
        i(4),
        t({ "},", "    year    = {" }),
        i(5, "2024"),
        t({ "},", "    volume  = {" }),
        i(6),
        t({ "},", "    number  = {" }),
        i(7),
        t({ "},", "    pages   = {" }),
        i(8, "1--10"),
        t({ "},", "    doi     = {" }),
        i(9),
        t({ "}", "}" }),
    }),

    -- 書籍
    s("book", {
        t("@book{"),
        i(1, "key"),
        t({ ",", "    author    = {" }),
        i(2, "Last, First"),
        t({ "},", "    title     = {" }),
        i(3),
        t({ "},", "    publisher = {" }),
        i(4),
        t({ "},", "    address   = {" }),
        i(5),
        t({ "},", "    year      = {" }),
        i(6, "2024"),
        t({ "},", "    edition   = {" }),
        i(7, "1st"),
        t({ "}", "}" }),
    }),

    -- Webサイト
    s("web", {
        t("@online{"),
        i(1, "key"),
        t({ ",", "    author       = {" }),
        i(2),
        t({ "},", "    title        = {" }),
        i(3),
        t({ "},", "    organization = {" }),
        i(4),
        t({ "},", "    date         = {" }),
        i(5, "2024-01-01"),
        t({ "},", "    url          = {" }),
        i(6),
        t({ "},", "    urldate      = {" }),
        i(7, "2024-01-01"),
        t({ "}", "}" }),
    }),
}
