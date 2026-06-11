-- disable mouse
vim.opt.mouse = ""

-- nano eol position
vim.opt.virtualedit = "onemore"

-- dont wrap lines
vim.opt.wrap = false

-- highlight current line
vim.opt.cursorline = true

-- show lines
vim.opt.number = true
-- relative numbers
-- vim.opt.relativenumber = true
-- 10 visible lines above/below cursor when scrolling
vim.opt.scrolloff = 10

-- ignore case when searching
vim.opt.ignorecase = true
-- unless search contains capital
vim.opt.smartcase = true

-- convert tab to spaces
vim.opt.expandtab = true
-- tab = 4 spaces
vim.opt.tabstop = 4
-- 4 spaces for auto-indents
vim.opt.shiftwidth = 4
--insert idents in a smart way
vim.opt.smartindent = true

-- share system clipboard
vim.opt.clipboard = "unnamedplus"

-- persistent undo
vim.opt.undofile = true

-- 24-bit color
vim.opt.termguicolors = true

--auto pair
local function pair(open, close)
    return function()
        local col = vim.fn.col('.')
        local line = vim.api.nvim_get_current_line()

        if line:sub(col, col) == close then
            return '<Right>'
        end

        return open .. close .. '<Left>'
    end
end

vim.keymap.set('i', '(', pair('(', ')'), { expr = true })
vim.keymap.set('i', '[', pair('[', ']'), { expr = true })
vim.keymap.set('i', '{', pair('{', '}'), { expr = true })
vim.keymap.set('i', '"', pair('"', '"'), { expr = true })
vim.keymap.set('i', "'", pair("'", "'"), { expr = true })

-- navigation
vim.keymap.set('n', '<C-Left>', '<C-w>h')
vim.keymap.set('n', '<C-Down>',  '<C-w>j')
vim.keymap.set('n', '<C-Up>',    '<C-w>k')
vim.keymap.set('n', '<C-Right>', '<C-w>l')

--
-- custom snippets
--

local snippet_group = vim.api.nvim_create_augroup("UserSnippets", { clear = true })

-- html
vim.api.nvim_create_autocmd("FileType", {
    pattern = "html",
    group = snippet_group,
    callback = function()
        vim.keymap.set("n", "!html", function()
            vim.api.nvim_buf_set_lines(0, 0, -1, false, {
                "<!DOCTYPE html>",
                "<html lang=\"en\">",
                "<head>",
                "    <meta charset=\"UTF-8\">",
                "    <title>Document</title>",
                "</head>",
                "<body>",
                "",
                "</body>",
                "</html>",
            })
        end, { buffer = true })
    end,
})

-- C
vim.api.nvim_create_autocmd("FileType", {
    pattern = "c",
    group = snippet_group,
    callback = function()
        vim.keymap.set("n", "!clang", function()
            vim.api.nvim_buf_set_lines(0, 0, -1, false, {
                "#include <stdio.h>",
                "",
                "int main(int argc, char *argv[]) {",
                "    ",
                "    return 0;",
                "}",
            })
        end, { buffer = true })
    end,
})

-- line bullshit
vim.keymap.set("i", "<Left>", function()
    local col = vim.fn.col(".")
    if col == 1 then
        return "<Up><End>"
    end
    return "<Left>"
end, { expr = true })

vim.keymap.set("i", "<Right>", function()
    local col = vim.fn.col(".")
    local line = vim.fn.line(".")

    if col > #vim.fn.getline(line) then
        return "<Down><Home>"
    end
    return "<Right>"
end, { expr = true })
