return { 
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jayp0521/mason-null-ls.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			-- import mason plugin safely
			local mason_status, mason = pcall(require, "mason")
			if not mason_status then
				print("load mason failed")
				return
			end

			mason.setup()

			-- import mason-lspconfig plugin safely
			local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
			if not mason_lspconfig_status then
				print("load mason-lspconfig failed")
				return
			end

			mason_lspconfig.setup({
				-- list of servers for mason to install
				ensure_installed = {"gopls"},
				-- auto-install configured servers (with lspconfig)
				automatic_installation = true -- not the same as ensure_installed
			})

			-- import mason-null-ls plugin safely
			local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
			if not mason_null_ls_status then
				print("load mason-null-ls failed")
				return
			end

			mason_null_ls.setup({
				-- list of formatters & linters for mason to install
				ensure_installed = {"golangci-lint", "goimports"},
				-- auto-install configured formatters & linters (with null-ls)
				automatic_installation = true
			})

			require("lspconfig").gopls.setup({})

			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
			vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
					vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set('n', '<space>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
					vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
					vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', '<space>f', function()
						vim.lsp.buf.format { async = true }
					end, opts)
				end,
			})


			local status, lspconfig = pcall(require, "lspconfig")
			if not status then
				print("load lspconfig failed")
				return
			end


			-- import cmp-nvim-lsp plugin safely
			local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if not cmp_nvim_lsp_status then
				print("load cmp_nvim_lsp failed")
				return
			end

			-- used to enable autocompletion (assign to every lsp server config)
			local capabilities = cmp_nvim_lsp.default_capabilities()

			local on_attach = function(client, bufnr)
				-- 保存退出时自动格式化代码
				if client.server_capabilities.documentFormattingProvider then
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = vim.api.nvim_create_augroup("Format", { clear = true }),
						buffer = bufnr,
						callback = function() vim.lsp.buf.format() end
					})
				end

				vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- 跳转至定义处
				vim.keymap.set("n", "ff", "<cmd>lua vim.lsp.buf.format()<CR>", opts)     -- 格式化代码
			end

			lspconfig["gopls"].setup {
				capabilities = capabilities,
				on_attach = on_attach,
			}

			lspconfig["lua_ls"].setup {
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostic = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false
						},
					}
				}
			}


		end,
	},
}
