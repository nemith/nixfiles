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
							win = {
								input = { keys = { ["<Esc>"] = "" } },
								list = { keys = { ["<Esc>"] = "" } },
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

			-- Top Pickers & Explorer
			map("n", "<leader><space>", function()
				Snacks.picker.smart()
			end, "Smart Find Files")
			map("n", "<leader>,", function()
				Snacks.picker.buffers()
			end, "Buffers")
			map("n", "<leader>/", function()
				Snacks.picker.grep()
			end, "Grep")
			map("n", "<leader>:", function()
				Snacks.picker.command_history()
			end, "Command History")
			map("n", "<leader>n", function()
				Snacks.notifier.show_history()
			end, "Notification History")
			map("n", "<leader>e", function()
				Snacks.explorer()
			end, "File Explorer")

			-- find
			map("n", "<leader>fb", function()
				Snacks.picker.buffers()
			end, "Buffers")
			map("n", "<leader>fc", function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
			end, "Find Config File")
			map("n", "<leader>ff", function()
				Snacks.picker.files()
			end, "Find Files")
			map("n", "<leader>fg", function()
				Snacks.picker.git_files()
			end, "Find Git Files")
			map("n", "<leader>fp", function()
				Snacks.picker.projects()
			end, "Projects")
			map("n", "<leader>fr", function()
				Snacks.picker.recent()
			end, "Recent")

			-- git
			map("n", "<leader>gb", function()
				Snacks.picker.git_branches()
			end, "Git Branches")
			map("n", "<leader>gl", function()
				Snacks.picker.git_log()
			end, "Git Log")
			map("n", "<leader>gL", function()
				Snacks.picker.git_log_line()
			end, "Git Log Line")
			map("n", "<leader>gs", function()
				Snacks.picker.git_status()
			end, "Git Status")
			map("n", "<leader>gS", function()
				Snacks.picker.git_stash()
			end, "Git Stash")
			map("n", "<leader>gd", function()
				Snacks.picker.git_diff()
			end, "Git Diff (Hunks)")
			map("n", "<leader>gf", function()
				Snacks.picker.git_log_file()
			end, "Git Log File")

			-- Grep
			map("n", "<leader>sb", function()
				Snacks.picker.lines()
			end, "Buffer Lines")
			map("n", "<leader>sB", function()
				Snacks.picker.grep_buffers()
			end, "Grep Open Buffers")
			map("n", "<leader>sg", function()
				Snacks.picker.grep()
			end, "Grep")
			map({ "n", "x" }, "<leader>sw", function()
				Snacks.picker.grep_word()
			end, "Visual selection or word")

			-- search
			map("n", '<leader>s"', function()
				Snacks.picker.registers()
			end, "Registers")
			map("n", "<leader>s/", function()
				Snacks.picker.search_history()
			end, "Search History")
			map("n", "<leader>sa", function()
				Snacks.picker.autocmds()
			end, "Autocmds")
			map("n", "<leader>sc", function()
				Snacks.picker.command_history()
			end, "Command History")
			map("n", "<leader>sC", function()
				Snacks.picker.commands()
			end, "Commands")
			map("n", "<leader>sd", function()
				Snacks.picker.diagnostics()
			end, "Diagnostics")
			map("n", "<leader>sD", function()
				Snacks.picker.diagnostics_buffer()
			end, "Buffer Diagnostics")
			map("n", "<leader>sh", function()
				Snacks.picker.help()
			end, "Help Pages")
			map("n", "<leader>sH", function()
				Snacks.picker.highlights()
			end, "Highlights")
			map("n", "<leader>si", function()
				Snacks.picker.icons()
			end, "Icons")
			map("n", "<leader>sj", function()
				Snacks.picker.jumps()
			end, "Jumps")
			map("n", "<leader>sk", function()
				Snacks.picker.keymaps()
			end, "Keymaps")
			map("n", "<leader>sl", function()
				Snacks.picker.loclist()
			end, "Location List")
			map("n", "<leader>sm", function()
				Snacks.picker.marks()
			end, "Marks")
			map("n", "<leader>sM", function()
				Snacks.picker.man()
			end, "Man Pages")
			map("n", "<leader>sp", function()
				Snacks.picker.lazy()
			end, "Search for Plugin Spec")
			map("n", "<leader>sq", function()
				Snacks.picker.qflist()
			end, "Quickfix List")
			map("n", "<leader>sR", function()
				Snacks.picker.resume()
			end, "Resume")
			map("n", "<leader>su", function()
				Snacks.picker.undo()
			end, "Undo History")
			map("n", "<leader>uC", function()
				Snacks.picker.colorschemes()
			end, "Colorschemes")

			-- LSP
			map("n", "gd", function()
				Snacks.picker.lsp_definitions()
			end, "Goto Definition")
			map("n", "gD", function()
				Snacks.picker.lsp_declarations()
			end, "Goto Declaration")
			map("n", "gr", function()
				Snacks.picker.lsp_references()
			end, "References")
			map("n", "gI", function()
				Snacks.picker.lsp_implementations()
			end, "Goto Implementation")
			map("n", "gy", function()
				Snacks.picker.lsp_type_definitions()
			end, "Goto Type Definition")
			map("n", "<leader>ss", function()
				Snacks.picker.lsp_symbols()
			end, "LSP Symbols")
			map("n", "<leader>sS", function()
				Snacks.picker.lsp_workspace_symbols()
			end, "LSP Workspace Symbols")

			-- Other
			map("n", "<leader>z", function()
				Snacks.zen()
			end, "Toggle Zen Mode")
			map("n", "<leader>Z", function()
				Snacks.zen.zoom()
			end, "Toggle Zoom")
			map("n", "<leader>.", function()
				Snacks.scratch()
			end, "Toggle Scratch Buffer")
			map("n", "<leader>S", function()
				Snacks.scratch.select()
			end, "Select Scratch Buffer")
			map("n", "<leader>bd", function()
				Snacks.bufdelete()
			end, "Delete Buffer")
			map("n", "<leader>cR", function()
				Snacks.rename.rename_file()
			end, "Rename File")
			map("n", "<leader>un", function()
				Snacks.notifier.hide()
			end, "Dismiss All Notifications")
			map({ "n", "t" }, "]]", function()
				Snacks.words.jump(vim.v.count1)
			end, "Next Reference")
			map({ "n", "t" }, "[[", function()
				Snacks.words.jump(-vim.v.count1)
			end, "Prev Reference")

			-- Terminal (custom: keep your <C-\> binding)
			map("n", "<C-\\>", function()
				Snacks.terminal.toggle(nil, { win = { position = "bottom", height = 0.3, relative = "win" } })
			end, "Toggle terminal")
			map("t", "<C-\\>", function()
				Snacks.terminal.toggle(nil, { win = { position = "bottom", height = 0.3, relative = "win" } })
			end, "Toggle terminal")
			map("n", "<leader>tt", function()
				Snacks.terminal.toggle(nil, { win = { position = "bottom", height = 0.3, relative = "win" } })
			end, "[T]oggle [T]erminal")

			-- Toggle mappings
			Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
			Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
			Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
			Snacks.toggle.diagnostics():map("<leader>ud")
			Snacks.toggle.line_number():map("<leader>ul")
			Snacks.toggle
				.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
				:map("<leader>uc")
			Snacks.toggle.treesitter():map("<leader>uT")
			Snacks.toggle
				.option("background", { off = "light", on = "dark", name = "Dark Background" })
				:map("<leader>ub")
			Snacks.toggle.inlay_hints():map("<leader>uh")
			Snacks.toggle.indent():map("<leader>ug")
			Snacks.toggle.dim():map("<leader>uD")
		end,
	},
}
