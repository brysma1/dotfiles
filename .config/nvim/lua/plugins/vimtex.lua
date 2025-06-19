return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_mappings_enabled = true
		vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex" }
	end,
}
