vim.loader.enable()

local lze = require("nix").lze

-- leader set to <sp>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.fillchars:append({ diff = " " })

vim.o.tabstop = 4

vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

vim.opt.diffopt:append({ "algorithm:histogram", "linematch:60", "indent-heuristic" })

-- [[ Basic Keymaps ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.opt.linebreak = true
vim.keymap.set({ "n", "x" }, "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, desc = "Down (visual line when no count)" })
vim.keymap.set({ "n", "x" }, "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, desc = "Up (visual line when no count)" })
vim.keymap.set({ "n", "x" }, "<Down>", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true })
vim.keymap.set({ "n", "x" }, "<Up>", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true })

vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },
	virtual_text = true,
	virtual_lines = false,
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = "cursor",
				focus = false,
			})
		end,
	},
})

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("t", "<C-w>h", [[<C-\><C-n><C-w>h]], { desc = "Window left from terminal" })
vim.keymap.set("t", "<C-w>j", [[<C-\><C-n><C-w>j]], { desc = "Window down from terminal" })
vim.keymap.set("t", "<C-w>k", [[<C-\><C-n><C-w>k]], { desc = "Window up from terminal" })
vim.keymap.set("t", "<C-w>l", [[<C-\><C-n><C-w>l]], { desc = "Window right from terminal" })

vim.keymap.set("n", "<leader>-", "<cmd>split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>x", "<cmd>close<CR>", { desc = "Close split" })

-- [[ Autocommands ]]
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_user_command("Q", function(opts)
	if opts.bang then
		vim.cmd("q!")
		return
	end

	local bufs = vim.tbl_filter(function(b)
		if not vim.api.nvim_buf_is_valid(b) or not vim.bo[b].buflisted then
			return false
		end
		local ft = vim.bo[b].filetype
		if ft == "neo-tree" or ft == "snacks_terminal" or ft == "ClaudeCode" then
			return false
		end
		return vim.api.nvim_buf_get_name(b) ~= ""
	end, vim.api.nvim_list_bufs())

	if #bufs <= 1 then
		vim.cmd("qa!")
	else
		local cur = vim.api.nvim_get_current_buf()
		vim.cmd("BufferLineCyclePrev")
		vim.cmd("bdelete " .. cur)
	end
end, { bang = true })

vim.cmd("cabbrev q Q")

-- [[ Plugins ]]
-- Auto-discover specs from lua/plugins/*.lua. Each file returns either a
-- single lze spec or a list of specs.
local specs = {}
local files = vim.api.nvim_get_runtime_file("lua/plugins/*.lua", true)
table.sort(files)
for _, file in ipairs(files) do
	local name = vim.fn.fnamemodify(file, ":t:r")
	local mod = require("plugins." .. name)
	if type(mod[1]) == "table" then
		for _, spec in ipairs(mod) do
			table.insert(specs, spec)
		end
	else
		table.insert(specs, mod)
	end
end
lze.load(specs)
