local vim = _G['vim'] -- useless line to remove unnecessary warnings

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
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

require("lazy").setup({
  -- Tabs and spaces
  {
    "tpope/vim-sleuth",
    event = { "BufReadPre", "BufNewFile" },
  },

  {
    "github/copilot.vim"
  },

  -- theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme tokyonight')
      vim.cmd(':hi statusline guibg=NONE')
    end,
  },

  -- File explorer
  {
    "stevearc/oil.nvim",
    lazy = false,
    config = function()
      require('oil').setup()
      vim.keymap.set('n', '-', ':Oil<CR>')
    end,
  },

  -- LSP installer
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require('mason').setup()
    end,
  },

  -- Mason LSP config bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        automatic_installation = true,
      })
    end,
  },

  -- Snippet collection
  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },

  -- Modern completion engine
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" }
  },

  -- LSP configurations
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      -- LSP completion setup
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          -- LSP keymaps
          vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { buffer = ev.buf })
        end,
      })
    end,
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

  -- Plenary (dependency for elescope)
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
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
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
  }
})
