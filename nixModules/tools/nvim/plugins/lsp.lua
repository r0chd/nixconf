local lspconfig = require("lspconfig")
local on_attach = function(_, _) end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = {
	zls = {
		cmd = { "zls" },
		filetypes = { "zig" },
		single_file_support = true,
	},
	clangd = {
		cmd = { "clangd" },
		filetypes = { "c" },
	},
	rnix = {
		cmd = { "nil" },
		filetypes = { "nix" },
	},
	asm_lsp = {
		cmd = { "asm-lsp" },
		filetypes = { "asm" },
	},
	html = {
		cmd = { "html-languageserver", "--stdio" },
		filetypes = { "html" },
	},
	cssls = {
		cmd = { "css-languageserver", "--stdio" },
		filetypes = { "css", "scss", "less" },
	},
	sumneko_lua = {
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
	},
	tsserver = {
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
	},
}

for server, config in pairs(servers) do
	config.on_attach = on_attach
	config.capabilities = capabilities
	lspconfig[server].setup(config)
end
