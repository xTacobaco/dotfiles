local vim = _G['vim'] -- useless line to remove unnecessary warnings

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.g.mapleader = ' '
vim.o.winborder = 'rounded'
vim.o.clipboard = 'unnamedplus'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitright = true

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>t', ':e /tmp/todo.md<CR>')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.pack.add({
	{ src = 'https://github.com/tpope/vim-sleuth' },				-- tabs and spaces idk

	{ src = 'https://github.com/Mofiqul/vscode.nvim' },				-- theme

	{ src = 'https://github.com/stevearc/oil.nvim' },				-- best file explorer

	{ src = 'https://github.com/mason-org/mason.nvim' },			-- lsp installer
	{ src = 'https://github.com/mason-org/mason-lspconfig.nvim' },  -- easier installation of lsp servers
	{ src = 'https://github.com/neovim/nvim-lspconfig' },			-- lsp configs

	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' }, -- treesitter good

	{ src = 'https://github.com/echasnovski/mini.ai' },				-- good text-objects
	{ src = 'https://github.com/echasnovski/mini.surround' },		-- good surround 

	{ src = 'https://github.com/nvim-lua/plenary.nvim' },			-- needed for telescope 
	{ src = 'https://github.com/nvim-telescope/telescope.nvim' }	-- best file picker
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd('set completeopt+=noselect')

require('nvim-treesitter.configs').setup({
	ensure_installed = { 'typescript', 'javascript' },
	highlight = { enable = true }
})
require('oil').setup()
require('mason').setup()
require("mason-lspconfig").setup({ automatic_enable = false })

require('mini.ai').setup()
require('mini.surround').setup()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Telescope buffers' })

vim.keymap.set('n', '-', ':Oil<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

require('vscode').setup({
	transparent = true,
	italic_comments = true,
	underline_links = true,
})
vim.cmd('colorscheme vscode')
vim.cmd(':hi statusline guibg=NONE')
