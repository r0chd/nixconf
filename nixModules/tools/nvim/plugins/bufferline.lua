vim.g.mapleader = " "

vim.opt.termguicolors = true

vim.api.nvim_set_keymap(
	"n",
	"<leader>bd",
	"<cmd>bd!<CR>",
	{ noremap = true, silent = true, desc = "Close current buffer" }
)

vim.api.nvim_set_keymap("n", "L", "<cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "H", "<cmd>BufferLineCyclePrev<CR>", { noremap = true, silent = true })

require("bufferline").setup({})
