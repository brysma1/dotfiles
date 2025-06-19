-- Mostly default options:
require("kanagawa").setup({
	compile = false,
	undercurl = true,
	commentStyle = { italic = true },
	functionStyle = {},
	keywordStyle = { italic = true },
	statementStyle = { bold = true },
	typeStyle = {},
	transparent = true,
	dimInactive = true,
	terminalColors = true,
	colors = {
		palette = {},
		theme = {
			all = {
				ui = {
					bg_gutter = "none",
				},
			},
		},
	},
	overrides = function(colors)
		return {
			LineNrAbove = { fg = colors.palette.springViolet1 },
			LineNr = { fg = colors.palette.sakuraPink },
			LineNrBelow = { fg = colors.palette.springViolet1 },
		}
	end,
	theme = "dragon",
	background = {
		dark = "dragon",
		light = "lotus",
	},
})

vim.cmd("colorscheme kanagawa")
