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
				{ "<leader>s", group = "[S]earch", mode = { "n", "v" } },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
				{ "<leader>a", group = "AI/Claude Code" },
				{ "gr", group = "LSP Actions", mode = { "n" } },
			},
		})
	end,
}
