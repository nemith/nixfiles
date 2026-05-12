return {
	"diffview.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewRefresh",
		"DiffviewFileHistory",
	},
	keys = {
		{ "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
		{ "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview File History (repo)" },
		{ "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History (current)" },
	},
	after = function(_)
		require("diffview").setup({
			enhanced_diff_hl = true,
			view = {
				merge_tool = {
					layout = "diff3_mixed",
					disable_diagnostics = true,
				},
			},
		})
	end,
}
