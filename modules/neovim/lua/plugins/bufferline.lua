return {
	"bufferline.nvim",
	lazy = false,
	after = function(_)
		require("bufferline").setup({
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
		})
		vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
		vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
		vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "[B]uffer close [O]thers" })

		if (vim.g.colors_name or ""):find("catppuccin") then
			vim.opts.highlights = require("catppuccin.special.bufferline").get_theme()
		end
	end,
}
