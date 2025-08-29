local vim = _G['vim'] -- useless line to remove unnecessary warnings

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.wrap = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.swapfile = false
vim.g.mapleader = ' '
vim.o.winborder = 'rounded'
vim.o.clipboard = 'unnamedplus'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitright = true

vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>t', ':e /tmp/todo.md<CR>')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

require("lazy").setup({
  {
    "tpope/vim-sleuth",
    event = { "BufReadPre", "BufNewFile" },
  },

  {
    "github/copilot.vim"
  },

  {
    "lewis6991/gitsigns.nvim"
  },

  -- theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme tokyonight')
      vim.cmd(':hi statusline guibg=NONE')
      vim.cmd [[
	  hi Normal guibg=NONE ctermbg=NONE
	  hi NormalNC guibg=NONE ctermbg=NONE
	  hi SignColumn guibg=NONE ctermbg=NONE
	  hi VertSplit guibg=NONE ctermbg=NONE
	  hi StatusLine guibg=NONE ctermbg=NONE
	  hi TabLineFill guibg=NONE ctermbg=NONE
      ]]
    end,
  },

  -- File explorer
  {
    "stevearc/oil.nvim",
    lazy = false,
    config = function()
      require("oil").setup({
        win_options = {
          signcolumn = "yes:2",
        },
      })
      vim.keymap.set('n', '-', ':Oil<CR>')
    end,
  },

  {
    "benomahony/oil-git.nvim",
    dependencies = { "stevearc/oil.nvim" },
  },

  -- Coc.nvim
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      -- Example keymaps (can be extended)
      vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { silent = true })
      vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
      vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
      vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { silent = true })
      vim.keymap.set('n', '<leader>rn', '<Plug>(coc-rename)', { silent = true })
      vim.keymap.set('n', '<leader>lf', '<Plug>(coc-format)', { silent = true })
    end
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'typescript', 'javascript' },
        highlight = { enable = true },
        auto_install = true,
      })
    end,
  },

  -- Text objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    config = function()
      require('mini.ai').setup()
    end,
  },

  -- Surround
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    config = function()
      require('mini.surround').setup()
    end,
  },

  -- Plenary (dependency for telescope)
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- Telescope file picker
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
      { "<leader>sb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
    },
  },

  -- Best plugin
  {
    "xTacobaco/cursor-agent.nvim",
    config = function()
      vim.keymap.set("n", "<leader>ca", ":CursorAgent<CR>", { desc = "Cursor Agent: Toggle terminal" })
      vim.keymap.set("v", "<leader>ca", ":CursorAgentSelection<CR>", { desc = "Cursor Agent: Send selection" })
      vim.keymap.set("n", "<leader>cA", ":CursorAgentBuffer<CR>", { desc = "Cursor Agent: Send buffer" })
    end,
  },
})

