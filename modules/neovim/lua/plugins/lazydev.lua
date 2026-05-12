local get_nix_plugin_path = require("nix").get_nix_plugin_path

return {
	"lazydev.nvim",
	cmd = { "LazyDev" },
	ft = "lua",
	after = function(_)
		local lze_path = get_nix_plugin_path("lze")
		local lzextras_path = get_nix_plugin_path("lzextras")
		require("lazydev").setup({
			library = {
				{ words = { "lze" }, path = lze_path and (lze_path .. "/lua") or nil },
				{ words = { "lzextras" }, path = lzextras_path and (lzextras_path .. "/lua") or nil },
			},
		})
	end,
}
