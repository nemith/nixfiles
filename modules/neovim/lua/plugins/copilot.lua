return {
	"copilot.lua",
	event = "InsertEnter",
	cmd = { "Copilot" },
	after = function(_)
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<Tab>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			panel = { enabled = false },
		})
	end,
}
