local api = vim.api
local map = vim.keymap.set

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- my key
map({"n", "v"}, "<C-e>", "$", option)
map({"n", "v"}, "<C-a>", "^", option)

-- Copy to system board
map("v", "<c-y>", '"+y', option)

map("n", "<C-u>", "%", option)

-- paste without yanking
-- map({"n", "v"}, "p", "P", option)

function cal()
    local line1, line2
    line1 = api.nvim_win_get_cursor(0)[1]
    line2 = line1

    local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
    if not lines then
        return
    end
    for i, v in pairs(lines) do
        local str = v:match("(.*)=")
        if str then
            local fn = loadstring("return " .. str)
            if fn then
                local res = str .. "=" .. fn()
                lines[i] = lines[i]:gsub("^.*=.*$", res)
            end
        end
    end
    api.nvim_call_function("setline", {line1, lines})
end

map({"n", "v"}, "<leader>c", ":lua cal()<CR>", option)
