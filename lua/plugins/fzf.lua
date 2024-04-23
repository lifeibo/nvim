return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({})

	vim.keymap.set("n", "<leader>f", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
	vim.keymap.set("n", "<leader>a", "<cmd>lua require('fzf-lua').live_grep()<CR><CR>", { silent = true })
  end
}
