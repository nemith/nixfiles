return {
	"agent-term.nvim",
	lazy = false,
	priority = 40,
	after = function(_)
		local agent_term = require("agent_term")
		local context = require("agent_term.context.builder")
		local controller = require("agent_term.ui.controller")
		local terminal = require("agent_term.runtime.session")
		local Snacks = require("snacks")

		agent_term.setup({
			agents = { "codex", "claude" },
			active_agent = "codex",
			float = {
				host = "snacks",
				width = 0.85,
				height = 0.8,
				border = "rounded",
			},
			panel = {
				position = "right",
				width = 0.35,
			},
			keymaps = false,
		})

		local agent_view = "panel"

		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { desc = desc })
		end

		local function open_agent()
			controller.open(agent_view)
		end

		local function switch_agent(name)
			if agent_term.set_active_agent(name) then
				open_agent()
			end
		end

		local function send_context(message, err)
			if not message then
				vim.notify(err or "No agent context available", vim.log.levels.INFO)
				return
			end
			if not controller.open(agent_view, { enter_insert = false }) then
				return
			end
			if not terminal.send(message) then
				vim.notify("Agent session is not running", vim.log.levels.ERROR)
				return
			end
			vim.notify("Context sent to " .. (agent_term.get_active_agent() or "agent"))
			vim.cmd.startinsert()
		end

		local function send_selection()
			local first = vim.fn.getpos("v")
			local last = vim.fn.getpos(".")
			local first_line = math.min(first[2], last[2])
			local last_line = math.max(first[2], last[2])
			local message, err = context.selection_message({
				range = 2,
				line1 = first_line,
				line2 = last_line,
			})
			if not message then
				send_context(nil, err)
				return
			end

			local ok, region = pcall(vim.fn.getregion, first, last, { type = vim.fn.mode() })
			if ok and #region > 0 then
				local selected_text = table.concat(region, "\n")
				local fence = "```"
				while selected_text:find(fence, 1, true) do
					fence = fence .. "`"
				end
				local block = table.concat({
					"selected_text:",
					fence .. vim.bo.filetype,
					selected_text,
					fence,
				}, "\n")
				message = message:gsub("</neovim%-context>\n$", block .. "\n</neovim-context>\n")
			end

			send_context(message)
		end

		local function send_files()
			Snacks.picker.files({
				title = "Files for Agent",
				confirm = function(picker)
					local paths = {}
					local seen = {}
					for _, item in ipairs(picker:selected({ fallback = true })) do
						local path = Snacks.picker.util.path(item)
						if path and not seen[path] then
							seen[path] = true
							paths[#paths + 1] = vim.fs.relpath(vim.fn.getcwd(), path) or path
						end
					end
					picker:close()
					if #paths == 0 then
						return
					end
					table.sort(paths)
					local lines = {
						"<neovim-context>",
						"This is ambient context from the user's current Neovim editor state.",
						"Use these files only when relevant to the user's next prompt.",
						"",
						"type: files",
						"files:",
					}
					for _, path in ipairs(paths) do
						lines[#lines + 1] = "- " .. path
					end
					lines[#lines + 1] = "</neovim-context>"
					vim.schedule(function()
						send_context(table.concat(lines, "\n") .. "\n")
					end)
				end,
			})
		end

		map("n", "<leader>aa", function()
			controller.toggle(agent_view)
		end, "Toggle [A]ctive agent")
		map("n", "<leader>ax", function()
			switch_agent("codex")
		end, "Open Code[x]")
		map("n", "<leader>ac", function()
			switch_agent("claude")
		end, "Open [C]laude")
		map("n", "<leader>ap", function()
			vim.ui.select({ "codex", "claude" }, { prompt = "Agent" }, function(choice)
				if choice then
					switch_agent(choice)
				end
			end)
		end, "[P]ick agent")
		map("n", "<leader>av", function()
			agent_view = agent_view == "panel" and "float" or "panel"
			open_agent()
		end, "Toggle agent [V]iew")
		map("n", "<leader>ab", function()
			send_context(context.buffer_message())
		end, "Send [B]uffer to agent")
		map("x", "<leader>as", send_selection, "Send [S]election to agent")
		map("n", "<leader>af", send_files, "Send [F]iles to agent")
		map("n", "<leader>ad", function()
			send_context(context.diagnostics_message())
		end, "Send [D]iagnostics to agent")
	end,
}
