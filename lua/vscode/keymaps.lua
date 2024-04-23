local api = vim.api
local map = vim.keymap.set

local option = {
    noremap = true,
    silent = true
}

map("n", "gh", ":call VSCodeNotify('workbench.action.previousEditor')<CR>", option)
map("n", "<C-h>", ":call VSCodeNotify('workbench.action.focusLeftGroup')<CR>", option)
map("n", "gl", ":call VSCodeNotify('workbench.action.nextEditor')<CR>", option)
map("n", "<C-l>", ":call VSCodeNotify('workbench.action.focusRightGroup')<CR>", option)

map("n", "<leader>k", ":call VSCodeNotify('bookmarks.toggle')<CR>", option)
map("n", "<leader>p", ":call VSCodeNotify('bookmarks.jumpToPrevious')<CR>", option)
map("n", "<leader>n", ":call VSCodeNotify('bookmarks.jumpToNext')<CR>", option)

map("n", "<leader>b", ":call VSCodeNotify('bookmarksExplorer.focus')<CR>", option)
map("n", "<leader>a", ":call VSCodeNotify('workbench.action.findInFiles')<CR>", option)
map("n", "<leader>d",
    ":call VSCodeNotify('workbench.action.debug.stop')<CR>:call VSCodeNotify('workbench.action.debug.start')<CR>",
    option)
map("n", "<leader>r",
    ":call VSCodeNotify('workbench.action.debug.stop')<CR>:call VSCodeNotify('workbench.action.debug.start')<CR>",
    option)

map("n", "<leader>t", ":call VSCodeNotify('workbench.view.explorer')<CR>", option)
map("n", "<C-]>", ":call VSCodeNotify('editor.action.goToReferences')<CR>", option)

map("n", "u", ":call VSCodeNotify('undo')<CR>", option)
map("n", "<C-r>", ":call VSCodeNotify('redo')<CR>", option)

map("n", "<leader>x", ":call VSCodeNotify('editor.action.commentLine')<CR>", option)

-- joplin
map("n", "<C-j><C-o>", ":call VSCodeNotify('joplinNote.search')<CR>", option)

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function comment()
    local line1 = vim.api.nvim_buf_get_mark(0, "<")[1]
    local line2 = vim.api.nvim_buf_get_mark(0, ">")[1]
    vim.api.nvim_call_function("VSCodeNotifyRange", {"editor.action.commentLine", line1, line2, 1})
end

map("v", "<leader>x", ":lua comment()<CR>", option)
