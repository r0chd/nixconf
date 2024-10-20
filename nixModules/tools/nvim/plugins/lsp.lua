local lspconfig = require("lspconfig")
local on_attach = function(client, _)
	--if client.server_capabilities.inlayHintProvider then
	--	vim.lsp.inlay_hint.enable(true)
	--end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.clangd.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "cpp", "c" },
})

lspconfig.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_dir = function(fname)
		return require("lspconfig").util.root_pattern("tsconfig.json")(fname)
			or require("lspconfig").util.root_pattern("package.json", "jsconfig.json", ".git")(fname)
	end,
})

lspconfig.yamlls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "yaml" },
})

lspconfig.asm_lsp.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "asm-lsp" },
	filetypes = { "asm", "vmasm" },
})

lspconfig.dockerls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "dockerfile" },
})

lspconfig.zls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "zls" },
	filetypes = { "zig" },
	single_file_support = true,
	root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
	settings = {
		zls = {
			warn_style = true,
		},
	},
})

lspconfig.rnix.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "nil" },
	filetypes = { "nix" },
})

lspconfig.html.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "html-languageserver", "--stdio" },
	filetypes = { "html" },
})

lspconfig.cssls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "css-languageserver", "--stdio" },
	filetypes = { "css", "scss", "less" },
})

lspconfig.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				enable = true,
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
			},
		},
	},
})

lspconfig.omnisharp.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "OmniSharp", "--languageserver" },
	filetypes = { "cs" },
})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"gD",
	"<cmd>lua vim.lsp.buf.declaration()<CR>",
	{ noremap = true, silent = true, desc = "Go to declaration" }
)
vim.api.nvim_set_keymap(
	"n",
	"gd",
	"<cmd>lua vim.lsp.buf.definition()<CR>",
	{ noremap = true, silent = true, desc = "Go to definition" }
)
