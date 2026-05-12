return {
	"catppuccin-nvim",
	lazy = false,
	after = function(_)
		require("catppuccin").setup({
			dim_inactive = { enabled = true },
			lsp_styles = {
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			integrations = {
				snacks = true,
				which_key = true,
			},
		})

		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
