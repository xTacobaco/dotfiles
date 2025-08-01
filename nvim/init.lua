vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.smartcase = true

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>t', ':e /tmp/todo.md<CR>')

vim.pack.add({
	{ src = "https://github.com/tpope/vim-sleuth" },         -- tabs and spaces idk

	{ src = "https://github.com/Mofiqul/vscode.nvim" },      -- theme

	{ src = "https://github.com/stevearc/oil.nvim" },        -- best file explorer

	{ src = "https://github.com/mason-org/mason.nvim" },     -- easier installation of lsp servers
	{ src = "https://github.com/neovim/nvim-lspconfig" },    -- lsp
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- treesitter good

	{ src = "https://github.com/echasnovski/mini.ai" },      -- better around and inner
	{ src = "https://github.com/echasnovski/mini.pick" },    -- simple search files

	-- { src = "https://github.com/echasnovski/mini.completion" }, -- completion
	-- { src = "https://github.com/echasnovski/mini.snippets" }, -- snippets
	-- { src = "https://github.com/rafamadriz/friendly-snippets" }, -- cool snippets database
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

require "nvim-treesitter.configs".setup({
	ensure_installed = { "typescript", "javascript" },
	highlight = { enable = true }
})
require "oil".setup()
require "mason".setup()

require 'mini.ai'.setup()
require "mini.pick".setup()
-- require "mini.completion".setup()
-- require "mini.snippets".setup()

vim.keymap.set('n', '<leader>sf', ":Pick files<CR>")
vim.keymap.set('n', '<leader>sb', ":Pick buffers<CR>")
vim.keymap.set('n', '<leader>sg', ":Pick grep_live<CR>")

vim.keymap.set('n', '-', ":Oil<CR>")
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.lsp.enable({ "lua_ls", "ts_ls" })

vim.o.background = 'dark'
local c = require('vscode.colors').get_colors()
require('vscode').setup({
	transparent = true,
	italic_comments = true,
	underline_links = true,
	disable_nvimtree_bg = true,
	terminal_colors = true,
})

vim.cmd.colorscheme "vscode"
vim.cmd(":hi statusline guibg=NONE")
