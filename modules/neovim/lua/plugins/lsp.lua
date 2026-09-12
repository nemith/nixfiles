local hl_group = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
local detach_group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true })

vim.api.nvim_create_autocmd("LspDetach", {
	group = detach_group,
	callback = function(ev)
		vim.lsp.buf.clear_references()
		vim.api.nvim_clear_autocmds({ group = hl_group, buffer = ev.buf })
	end,
})

return {
	{
		"nvim-lspconfig",
		lsp = function(plugin)
			vim.lsp.config(plugin.name, plugin.lsp or {})
			vim.lsp.enable(plugin.name)
		end,
		before = function(_)
			vim.lsp.config("*", {
				on_attach = function(client, bufnr)
					if client and client:supports_method("textDocument/documentHighlight", bufnr) then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = bufnr,
							group = hl_group,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = bufnr,
							group = hl_group,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})
		end,
	},
	{
		"lua_ls",
		lsp = {
			filetypes = { "lua" },
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = false

				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
						path ~= vim.fn.stdpath("config")
						and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
					then
						return
					end
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
					runtime = {
						version = "LuaJIT",
					},
					workspace = {
						checkThirdParty = false,
						library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
							"${3rd}/luv/library",
							"${3rd}/busted/library",
						}),
					},
				})
			end,
			settings = {
				Lua = {
					format = { enable = false },
					diagnostics = {
						globals = { "vim" },
						disable = { "missing-fields" },
					},
				},
			},
		},
	},
	{ "nixd", lsp = { filetypes = { "nix" } } },
	{
		"gopls",
		lsp = {
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			settings = {
				gopls = {
					gofumpt = true,
				},
			},
		},
	},
	{ "rust_analyzer", lsp = { filetypes = { "rust" } } },
}
