local lackluster = require("lackluster")

local color = lackluster.color -- blue, green, red, orange, black, lack, luster, gray1-9

-- setup before set colorscheme
lackluster.setup({
	-- You can overwrite the following syntax colors by setting them to one of...
	--   1) a hexcode like "#a1b2c3" for a custom color
	--   2) "default" or nil will just use whatever lackluster's default is.
	tweek_syntax = {
		string = "default",
		-- string = "#a1b2c3", -- custom hexcode
		-- string = color.green, -- lackluster color
		string_escape = "default",
		comment = "default",
		builtin = "default", -- builtin modules and functions
		type = "default",
		keyword = "default",
		keyword_return = "default",
		keyword_exception = "default",
	},

	tweek_background = {
		normal = "none",
		telescope = "default",
		menu = "default",
		popup = "default",
	},
})

vim.cmd.colorscheme("lackluster")
