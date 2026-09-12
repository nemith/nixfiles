return {
	"which-key.nvim",
	event = "DeferredUIEnter",
	after = function(_)
		require("which-key").setup({
			preset = "modern",
			delay = 0,
			icons = { mappings = vim.g.have_nerd_font },
			triggers = {
				{ "<auto>", mode = "nxso" },
			},
			defer = function(ctx)
				return ctx.mode == "V" or ctx.mode == "<C-V>"
			end,
			plugins = {
				presets = {
					operators = true,
					motions = true,
					text_objects = true,
					windows = true,
					nav = true,
					z = true,
					g = true,
				},
			},
			opts = {
				nowait = true,
			},
			spec = {
				{ "<leader>a", group = "[A]gent", mode = { "n", "v" } },
				{ "<leader>b", group = "[B]uffers" },
				{ "<leader>f", group = "[F]ind" },
				{ "<leader>l", group = "[L]SP", mode = { "n", "v" } },
				{ "<leader>q", group = "[Q]uit/session" },
				{ "<leader>s", group = "[S]earch", mode = { "n", "v" } },
				{ "<leader>t", group = "[T]oggles" },
				{ "gr", group = "LSP Actions", mode = { "n" } },
			},
		})
	end,
}
