vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.vert", "*.frag" },
	command = "set filetype=glsl",
})

vim.defer_fn(function()
	require("nvim-treesitter.configs").setup({
		highlight = {
			enable = true,
			use_languagetree = true,
		},
		indent = { enable = true },
		autotags = {
			enable = true,
			enable_rename = true,
			enable_close = true,
			enable_close_on_slash = true,
		},
	})
end, 0)
