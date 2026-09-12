return {
	"persistence.nvim",
	event = "VimEnter",
	keys = {
		{
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "Restore [S]ession",
		},
		{
			"<leader>qS",
			function()
				require("persistence").select()
			end,
			desc = "Select [S]ession",
		},
		{
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restore [L]ast session",
		},
		{
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "[D]on't save current session",
		},
	},
	after = function(_)
		require("persistence").setup({})
	end,
}
