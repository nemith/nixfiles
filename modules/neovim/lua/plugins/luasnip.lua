return {
	"LuaSnip",
	event = "DeferredUIEnter",
	after = function(_)
		require("luasnip").setup({})
	end,
}
