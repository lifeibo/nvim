return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        -- keys = {
        --     { "<leader>t", "<cmd>NvimTreeFindFile<cr>", desc = "NeoTree" },
        -- },
        config = function()
            require("nvim-tree").setup {}
        end
    }
}
