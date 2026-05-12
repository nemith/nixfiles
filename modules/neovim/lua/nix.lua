do
	local ok = pcall(require, vim.g.nix_info_plugin_name)
	if not ok then
		package.loaded[vim.g.nix_info_plugin_name] = setmetatable({}, {
			__call = function(_, default)
				return default
			end,
		})
	end
	require(vim.g.nix_info_plugin_name).isNix = vim.g.nix_info_plugin_name ~= nil
end

local nixInfo = require(vim.g.nix_info_plugin_name)

local function get_nix_plugin_path(name)
	return nixInfo(nil, "plugins", "lazy", name) or nixInfo(nil, "plugins", "start", name)
end

local lze = setmetatable(require("lze"), getmetatable(require("lzextras")))

lze.register_handlers({ lze.lsp })

lze.h.lsp.set_ft_fallback(function(name)
	local lspcfg = get_nix_plugin_path("nvim-lspconfig")
	if lspcfg then
		local success, cfg = pcall(dofile, lspcfg .. "/lsp/" .. name .. ".lua")
		return (success and cfg or {}).filetypes or {}
	else
		return (vim.lsp.config[name] or {}).filetypes or {}
	end
end)

return {
	nixInfo = nixInfo,
	lze = lze,
	get_nix_plugin_path = get_nix_plugin_path,
}
