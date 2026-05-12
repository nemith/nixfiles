vim.bo.expandtab = false
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

local function go_organize_and_format(async)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { "source.organizeImports" } }
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
	for cid, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
				vim.lsp.util.apply_workspace_edit(r.edit, enc)
			end
		end
	end
	vim.lsp.buf.format({ async = async })
end

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	buffer = 0,
	callback = function()
		go_organize_and_format(false)
	end,
})

-- override <leader>f for Go buffers
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	go_organize_and_format(true)
end, { buffer = 0, desc = "[F]ormat buffer (Go: organize imports + format)" })
