return {
	"guess-indent.nvim",
	lazy = false,
	after = function(_)
		require("guess-indent").setup({})
	end,
}
