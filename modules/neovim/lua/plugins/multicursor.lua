return {
	"multicursor-nvim",
	keys = {
		{
			"<C-Up>",
			function()
				require("multicursor-nvim").lineAddCursor(-1)
			end,
			mode = { "n", "x" },
			desc = "Add cursor up",
		},
		{
			"<C-Down>",
			function()
				require("multicursor-nvim").lineAddCursor(1)
			end,
			mode = { "n", "x" },
			desc = "Add cursor down",
		},
		{
			"<leader>mn",
			function()
				require("multicursor-nvim").matchAddCursor(1)
			end,
			mode = { "n", "x" },
			desc = "Add cursor at next match",
		},
		{
			"<leader>mN",
			function()
				require("multicursor-nvim").matchAddCursor(-1)
			end,
			mode = { "n", "x" },
			desc = "Add cursor at prev match",
		},
		{
			"<leader>ms",
			function()
				require("multicursor-nvim").matchSkipCursor(1)
			end,
			mode = { "n", "x" },
			desc = "Skip to next match",
		},
		{
			"<leader>mS",
			function()
				require("multicursor-nvim").matchSkipCursor(-1)
			end,
			mode = { "n", "x" },
			desc = "Skip to prev match",
		},
		{
			"<leader>ma",
			function()
				require("multicursor-nvim").matchAllAddCursors()
			end,
			mode = { "n", "x" },
			desc = "Add cursor at all matches",
		},
		{
			"<leader>mc",
			function()
				require("multicursor-nvim").clearCursors()
			end,
			mode = { "n", "x" },
			desc = "Clear cursors",
		},
		{
			"<leader>mt",
			function()
				require("multicursor-nvim").toggleCursor()
			end,
			mode = { "n", "x" },
			desc = "Toggle cursor at position",
		},
		{
			"<leader>mr",
			function()
				require("multicursor-nvim").restoreCursors()
			end,
			mode = "n",
			desc = "Restore last cursors",
		},
		{
			"<leader>mA",
			function()
				require("multicursor-nvim").alignCursors()
			end,
			mode = "n",
			desc = "Align cursors",
		},
		{
			"I",
			function()
				require("multicursor-nvim").insertVisual()
			end,
			mode = "x",
			desc = "Insert before each visual line",
		},
		{
			"A",
			function()
				require("multicursor-nvim").appendVisual()
			end,
			mode = "x",
			desc = "Append after each visual line",
		},
	},
	after = function(_)
		require("multicursor-nvim").setup()
	end,
}
