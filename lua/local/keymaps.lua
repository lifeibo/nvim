local api = vim.api
local map = vim.keymap.set
local opt = vim.opt

-- comment
--map({"n", "v"}, "<leader>x", ":gcc", option)

map("n", "<c-h>", "<c-w>h", option)
map("n", "<c-l>", "<c-w>l", option)
map("n", "<c-u>", "%", option)

opt.relativenumber = false -- Relative line numbers
opt.clipboard = ""
opt.wrap = true            -- Disable line wrap

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

opt.autowrite = true

opt.paste = true

-- save last session
vim.opt.sessionoptions = 'buffers,curdir,tabpages,winsize'
local path = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/')
vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
        vim.fn.mkdir(path, 'p')
        vim.cmd('mks! ' .. path .. vim.fn.sha256(vim.fn.getcwd()) .. '.vim')
    end
})

vim.api.nvim_create_user_command('Resume', function()
    local fname = path .. vim.fn.sha256(vim.fn.getcwd()) .. '.vim'
    if vim.fn.filereadable(fname) ~= 0 then
        vim.cmd.source(fname)
    end
end, {})

vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function()
        local line = vim.fn.line('\'"')
        if line > 1 and line <= vim.fn.line('$') then
            vim.cmd.normal('g\'"')
        end
    end
})

-- resume last session
map("n", "<leader>r", ":Resume<CR>", option)

-- quickfix
quickfix_is_open = false
function quickfixToggle()
    if quickfix_is_open then
        quickfix_is_open = false
        vim.cmd("cclose")
    else
        quickfix_is_open = true
        vim.cmd("copen")
    end
end

map({ "n", "v" }, "<leader>q", ":lua quickfixToggle()<CR>", option)
-- end quickfix

-- tree
nvim_tree_is_open = false
function nvimTreeToggle()
    if nvij_tree_is_open then
        nvim_tree_is_open = false
        vim.cmd("NvimTreeToggle")
    else
        nvim_tree_is_open = true
        vim.cmd("NvimTreeFindFile")
    end
end

map({ "n", "v" }, "<leader>t", ":lua nvimTreeToggle()<CR>", option)

map({ "n", "v" }, "<leader>w", ":bwipeout<CR>", option)
-- end quickfix
