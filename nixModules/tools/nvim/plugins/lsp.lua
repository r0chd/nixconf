local lspconfig = require("lspconfig")
local on_attach = function(_, _) end

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
