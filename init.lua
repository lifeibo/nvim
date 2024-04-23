if vim.g.vscode then
	-- Basic settings
	require("common.keymaps")
	require("common.basic")
	require("vscode.keymaps")
else
	-- Basic settings
	require("common.keymaps")
	require("common.basic")
	require("lazynvim-init")
	require("local.keymaps")
end
