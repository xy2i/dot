--t st Leader key, before plugin manager so that plugins use the right leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Plugin manager setup
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
-------------------------------------------------------------------------------
require'lazy'.setup{
  'neovim/nvim-lspconfig', -- LSP
  {
    'navarasu/onedark.nvim', -- Theme
    priority = 1000,
    opts = {
      style = 'dark',
      toggle_style_key = '<leader>ts',
      toggle_style_list = { 'light', 'dark' },
    },
    config = function(plug, opts)
      require'onedark'.setup(opts)
      vim.cmd.colorscheme 'onedark'
    end,
  },
  {
    'lvimuser/lsp-inlayhints.nvim', -- LSP inlay hints
    branch = 'anticonceal',
  },
  {
    'hrsh7th/nvim-cmp', -- Autocomplete
    dependencies = {
      -- Snippet engine and cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      -- LSP cmp
      'hrsh7th/cmp-nvim-lsp',
      -- Basic snippets
      'rafamadriz/friendly-snippets',
    },
  },
  {
    'folke/which-key.nvim', -- Useful for learning keybinds
    opts = {}
  },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },
}

-- General vim options
-------------------------------------------------------------------------------
vim.o.colorcolumn = '80'

-- System clipboard
vim.o.clipboard = 'unnamedplus'

-- Enable line numbers
vim.wo.number = true
-- Sign column takes up numbers
vim.wo.signcolumn = 'number'

-- Wrapped lines continue visually indented
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Highlight on search
vim.o.hlsearch = false
-- Case insensitive search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Truecolor
vim.o.termguicolors = true

-- Completion behavior
vim.o.completeopt = 'menuone,noselect'

-- Lsp config
-------------------------------------------------------------------------------
local lspconfig = require'lspconfig'
lspconfig.rust_analyzer.setup {
  on_attach = function(client, bufnr) 
    require'lsp-inlayhints'.on_attach(client, bufnr)
  end,
}

require'lsp-inlayhints'.setup {} -- Lsp inlayhints setup

-- Lsp format on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]] 

-- Lsp mappings
-------------------------------------------------------------------------------
local nmap = function(keys, func, desc)
  if desc then
    desc = 'LSP: ' .. desc
  end

  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end

nmap('<leader>e', vim.diagnostic.open_float, "Open diagnostic message")
nmap('<leader>n', vim.diagnostic.goto_next, "[N]ext diagnostic message")
nmap('<leader>p', vim.diagnostic.goto_prev, "[P]rev diagnostic message")
nmap('<leader>q', vim.diagnostic.setloclist, "Diagnostic list")
nmap('<leader>r', vim.lsp.buf.rename, "[R]ename")
nmap('<leader>c', vim.lsp.buf.code_action, "[C]ode action")
nmap('<leader>d', vim.lsp.buf.definition, "Jump to [d]efinition")
nmap('<leader>i', vim.lsp.buf.implementation, "Jump to [i]mplementation")
nmap('<leader>f', vim.lsp.buf.references, "Find re[f]erences")
nmap('K', vim.lsp.buf.hover, "Hover documentation")
nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature documentation')

-- nvim-cmp configuration
-------------------------------------------------------------------------------

local cmp = require 'cmp'
local luasnip = require 'luasnip'
require'luasnip.loaders.from_vscode'.lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  mapping = {
    ["<cr>"] = cmp.mapping.confirm{ select = true };
    ["<s-tab>"] = cmp.mapping.select_prev_item();
    ["<tab>"] = cmp.mapping.select_next_item();
  }
}

-- vim: ts=2 sts=2 sw=2 et
