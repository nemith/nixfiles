return {
	"blink.cmp",
	event = "DeferredUIEnter",
	after = function(_)
		require("blink.cmp").setup({
			keymap = { preset = "enter" },
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = { auto_show = false },
			},
			sources = {
				default = { "lsp", "path", "snippets" },
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true },
		})
	end,
}
