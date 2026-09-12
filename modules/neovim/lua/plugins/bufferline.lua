return {
	"bufferline.nvim",
	lazy = false,
	after = function(_)
		local config = {
			options = {
				diagnostics = "nvim_lsp",
				always_show_bufferline = true,
				show_close_icon = true,
				show_buffer_close_icons = true,
				offsets = {
					{
						filetype = "snacks_layout_box",
						highlight = "Directory",
						separator = true,
					},
				},
			},
		}

		if (vim.g.colors_name or ""):find("catppuccin") then
			config.highlights = require("catppuccin.special.bufferline").get_theme()
		end

		require("bufferline").setup(config)
		vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
		vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
		vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close [O]ther buffers" })
	end,
}
