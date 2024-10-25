require("dashboard").setup({
	theme = "doom",
	config = {
		header = {
			"",
			"",
			"",
			"",
			"██╗  ██╗██╗██╗     ██╗         ██╗   ██╗ ██████╗ ██╗   ██╗██████╗ ███████╗███████╗██╗     ███████╗",
			"██║ ██╔╝██║██║     ██║         ╚██╗ ██╔╝██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔════╝██║     ██╔════╝",
			"█████╔╝ ██║██║     ██║          ╚████╔╝ ██║   ██║██║   ██║██████╔╝███████╗█████╗  ██║     █████╗  ",
			"██╔═██╗ ██║██║     ██║           ╚██╔╝  ██║   ██║██║   ██║██╔══██╗╚════██║██╔══╝  ██║     ██╔══╝  ",
			"██║  ██╗██║███████╗███████╗       ██║   ╚██████╔╝╚██████╔╝██║  ██║███████║███████╗███████╗██║     ",
			"╚═╝  ╚═╝╚═╝╚══════╝╚══════╝       ╚═╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ",
			"",
			"",
			"",
		},
		center = {
			{ action = "Telescope find_files", desc = " Find file", icon = " ", key = "f" },
			{ action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
			{ action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
			{ action = "Telescope live_grep", desc = " Find text", icon = " ", key = "g" },
			{
				action = "edit" .. os.getenv("FLAKE"),
				desc = " Config",
				icon = " ",
				key = "c",
			},
			{ action = "qa", desc = " Quit", icon = " ", key = "q" },
		},
	},
})
