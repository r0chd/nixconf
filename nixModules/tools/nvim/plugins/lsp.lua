local lspconfig = require("lspconfig")
local on_attach = function(client, bufnr) end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.zls.setup({
	on_attach = on_attach,
	cmd = { "zls" },
	filetypes = { "zig" },
	single_file_support = true,
	capabilities = capabilities,
})

lspconfig.clangd.setup({
	cmd = { "clangd" },
	filetypes = { "c" },
})

lspconfig.rnix.setup({
	cmd = { "nil" },
	filetypes = { "nix" },
})

lspconfig.omnisharp.setup({
	on_attach = on_attach,
	cmd = { "OmniSharp" },
})

lspconfig.sumneko_lua.setup({
	cmd = { "lua-language-server" },
	on_attach = on_attach,
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

lspconfig.html.setup({
	cmd = { "html-languageserver", "--stdio" },
	on_attach = on_attach,
})

lspconfig.asm_lsp.setup({
	cmd = { "asm-lsp" },
	filetypes = { "asm" },
})

lspconfig.tsserver.setup({
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_dir = function(fname)
		return require("lspconfig").util.root_pattern("tsconfig.json")(fname)
			or require("lspconfig").util.root_pattern("package.json", "jsconfig.json", ".git")(fname)
	end,
})

local opts = {
	tools = {
		runnables = {
			use_telescope = true,
		},
		inlay_hints = {
			auto = true,
			show_parameter_hints = true,
			parameter_hints_prefix = "",
			other_hints_prefix = "",
		},
	},

	server = {
		on_attach = on_attach,
		settings = {
			["rust-analyzer"] = {
				cargo = {
					features = { "all" },
				},
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
}
