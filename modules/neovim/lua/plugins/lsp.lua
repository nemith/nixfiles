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
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
					end

					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					local has_telescope, builtin = pcall(require, "telescope.builtin")
					if has_telescope then
						map("grr", builtin.lsp_references, "[G]oto [R]eferences")
						map("gri", builtin.lsp_implementations, "[G]oto [I]mplementation")
						map("grd", builtin.lsp_definitions, "[G]oto [D]efinition")
						map("gO", builtin.lsp_document_symbols, "Open Document Symbols")
						map("gW", builtin.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
						map("grt", builtin.lsp_type_definitions, "[G]oto [T]ype Definition")
					end

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

					if client and client:supports_method("textDocument/inlayHint", bufnr) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
						end, "[T]oggle Inlay [H]ints")
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
