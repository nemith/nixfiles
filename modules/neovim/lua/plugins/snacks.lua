return {
	{
		"nvim-web-devicons",
		dep_of = "snacks.nvim",
	},
	{
		"snacks.nvim",
		lazy = false,
		after = function(_)
			local Snacks = require("snacks")
			Snacks.setup({
				bigfile = { enabled = true },
				quickfile = { enabled = true },
				explorer = {
					enabled = true,
					replace_netrw = true,
					trash = true,
				},
				picker = {
					enabled = true,
					sources = {
						explorer = {
							auto_close = true,
							jump = { close = true },
							layout = { preset = "vertical", preview = false },
							win = {
								input = { keys = { ["<Esc>"] = "close" } },
								list = { keys = { ["<Esc>"] = "close" } },
							},
						},
					},
				},
				terminal = {
					enabled = true,
					interactive = true,
				},
				notifier = { enabled = true },
				input = { enabled = true },
				words = { enabled = true },
				statuscolumn = { enabled = true },
				scratch = { enabled = true },
				scope = { enabled = true },
				indent = { enabled = true },
				scroll = { enabled = true },
				dim = { enabled = true },
				image = { enabled = true },
			})

			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { desc = desc })
			end

			vim.api.nvim_create_user_command("Colorschemes", function()
				Snacks.picker.colorschemes()
			end, { desc = "Preview and select a colorscheme" })
			vim.api.nvim_create_user_command("Notifications", function()
				Snacks.notifier.show_history()
			end, { desc = "Show notification history" })
			vim.api.nvim_create_user_command("NotificationsDismiss", function()
				Snacks.notifier.hide()
			end, { desc = "Dismiss all notifications" })

			-- Top Pickers & Explorer
			map("n", "<leader><space>", function()
				Snacks.picker.smart()
			end, "Smart find files")
			map("n", "<leader>,", function()
				Snacks.picker.buffers()
			end, "Buffers")
			map("n", "<leader>/", function()
				Snacks.picker.grep()
			end, "Grep")
			map("n", "<leader>:", function()
				Snacks.picker.command_history()
			end, "Command history")
			map("n", "<leader>e", function()
				local explorers = Snacks.picker.get({ source = "explorer" })
				if explorers[1] then
					explorers[1]:close()
				else
					Snacks.explorer()
				end
			end, "Toggle file [E]xplorer")

			-- find
			map("n", "<leader>fc", function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
			end, "Find [C]onfig file")
			map("n", "<leader>ff", function()
				Snacks.picker.files()
			end, "[F]ind files")
			map("n", "<leader>fp", function()
				Snacks.picker.projects()
			end, "[P]rojects")
			map("n", "<leader>fr", function()
				Snacks.picker.recent()
			end, "[R]ecent files")
			map("n", "<leader>fR", function()
				Snacks.rename.rename_file()
			end, "[R]ename file")

			-- Grep
			map("n", "<leader>sb", function()
				Snacks.picker.lines()
			end, "[B]uffer lines")
			map("n", "<leader>sB", function()
				Snacks.picker.grep_buffers()
			end, "Grep open [B]uffers")
			map({ "n", "x" }, "<leader>sw", function()
				Snacks.picker.grep_word()
			end, "[W]ord or selection")

			-- search
			map("n", "<leader>s/", function()
				Snacks.picker.search_history()
			end, "Search history")
			map("n", "<leader>sC", function()
				Snacks.picker.commands()
			end, "[C]ommands")
			map("n", "<leader>sh", function()
				Snacks.picker.help()
			end, "[H]elp pages")
			map("n", "<leader>sk", function()
				Snacks.picker.keymaps()
			end, "[K]eymaps")
			map("n", "<leader>sl", function()
				Snacks.picker.loclist()
			end, "[L]ocation list")
			map("n", "<leader>sq", function()
				Snacks.picker.qflist()
			end, "[Q]uickfix list")
			map("n", "<leader>sR", function()
				Snacks.picker.resume()
			end, "[R]esume")
			map("n", "<leader>su", function()
				Snacks.picker.undo()
			end, "[U]ndo history")

			-- LSP
			map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "Code [A]ction")
			map("n", "<leader>ld", function()
				Snacks.picker.lsp_definitions()
			end, "[D]efinition")
			map("n", "<leader>lD", function()
				Snacks.picker.lsp_declarations()
			end, "[D]eclaration")
			map("n", "<leader>lb", function()
				Snacks.picker.diagnostics_buffer()
			end, "[B]uffer diagnostics")
			map("n", "<leader>lw", function()
				Snacks.picker.diagnostics()
			end, "[W]orkspace diagnostics")
			map("n", "<leader>lh", vim.lsp.buf.hover, "[H]over documentation")
			map("n", "<leader>li", function()
				Snacks.picker.lsp_implementations()
			end, "[I]mplementations")
			map("n", "<leader>lr", vim.lsp.buf.rename, "[R]ename symbol")
			map("n", "<leader>lR", function()
				Snacks.picker.lsp_references()
			end, "[R]eferences")
			map("n", "<leader>ls", function()
				Snacks.picker.lsp_symbols()
			end, "[S]ymbols")
			map("n", "<leader>lS", function()
				Snacks.picker.lsp_workspace_symbols()
			end, "[S]ymbols (workspace)")
			map("n", "<leader>lt", function()
				Snacks.picker.lsp_type_definitions()
			end, "[T]ype definition")

			-- Other
			map("n", "<leader>.", function()
				Snacks.scratch()
			end, "Toggle Scratch Buffer")
			map("n", "<leader>bd", function()
				Snacks.bufdelete()
			end, "[D]elete buffer")
			map({ "n", "t" }, "]]", function()
				Snacks.words.jump(vim.v.count1)
			end, "Next Reference")
			map({ "n", "t" }, "[[", function()
				Snacks.words.jump(-vim.v.count1)
			end, "Prev Reference")

			-- Toggle mappings
			Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
			Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
			Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
			Snacks.toggle.diagnostics():map("<leader>td")
			Snacks.toggle.line_number():map("<leader>tl")
			Snacks.toggle
				.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
				:map("<leader>tc")
			Snacks.toggle.treesitter():map("<leader>tT")
			Snacks.toggle
				.option("background", { off = "light", on = "dark", name = "Dark Background" })
				:map("<leader>tb")
			Snacks.toggle.inlay_hints():map("<leader>th")
			Snacks.toggle.indent():map("<leader>tg")
			Snacks.toggle.dim():map("<leader>tD")
			Snacks.toggle.zoom():map("<leader>tz")
		end,
	},
}
