require("conform").setup({
	formatters_by_ft = {
		rust = { "rustfmt" },
		lua = { "stylua" },
		nix = { "alejandra" },
		c = { "clang_format" },
		csharp = { "dotnet-csharpier" },
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		css = { "prettierd" },
		scss = { "prettierd" },
		html = { "prettierd" },
		json = { "prettierd" },
		yaml = { "prettierd" },
		markdown = { "prettierd" },
		asm = { "asmfmt" },
		zig = { "zig fmt" },
		sh = { "shfmt" },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
