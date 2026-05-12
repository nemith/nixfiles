return {
	"todo-comments.nvim",
	event = "DeferredUIEnter",
	after = function(_)
		require("todo-comments").setup({ signs = false })
	end,
}
