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
    'folke/which-key.nvim', -- Useful for learning keybinds
    opts = {}
  }
}

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

-- vim: ts=2 sts=2 sw=2 et
