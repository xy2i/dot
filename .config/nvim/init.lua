-- Set Leader key, before plugin manager so that plugins use the right leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enable lua cache for faster load times
vim.loader.enable()

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
require 'lazy'.setup {
  {
    'neovim/nvim-lspconfig', -- LSP
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
    },
    priority = 1000,
    config = function()
      -- Rust-analyzer
      local capabilities = require 'cmp_nvim_lsp'.default_capabilities()
      local lspconfig = require 'lspconfig'
      lspconfig.rust_analyzer.setup {
        on_attach = function(_client, bufnr)
          vim.lsp.inlay_hint(bufnr, true)
        end,
        capabilities = capabilities,
      }
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        }
      }
      lspconfig.typst_lsp.setup {}
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = { 'nvim-lua/plenary.nvim' }
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
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      -- luasnip
      require 'luasnip.loaders.from_vscode'.lazy_load()
      luasnip.config.setup {}

      -- cmp
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
          ["<cr>"] = cmp.mapping.confirm { select = true },
          ["<s-tab>"] = cmp.mapping.select_prev_item(),
          ["<tab>"] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
        }
      }
    end
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
    }
  },                        -- Color
  {
    'folke/which-key.nvim', -- Useful for learning keybinds
    opts = {}
  },
  { "lukas-reineke/indent-blankline.nvim" }, -- Indent guides
  {
    -- Adds git releated signs to the gutter, as well as utilities
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
        vim.keymap.set('n', '<leader>gp', require 'gitsigns'.prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require 'gitsigns'.next_hunk,
          { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>gr', require 'gitsigns'.preview_hunk,
          { buffer = bufnr, desc = 'P[r]eview [H]unk' })
      end,
    },
  },
  { -- Status line
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
  },
  { -- Pairs
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {},
  },
  { -- adhd
    'j-hui/fidget.nvim',
    tag = 'legacy',
    opts = {},
  },
  {
    'kaarmu/typst.vim',
    ft = 'typst',
    lazy = false,
  },
}

-- General vim options
-------------------------------------------------------------------------------
vim.cmd [[set colorcolumn=80]]
vim.cmd [[highlight ColorColumn ctermbg=1 guibg=Black]]
-- Colorscheme
vim.cmd.colorscheme "catppuccin"

-- Tabs insert spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.bo.softtabstop = 0

-- Trailing whitespace
vim.opt.listchars:append({ trail = '#' })
vim.opt.list = true
vim.cmd [[highlight Whitespace ctermfg=Red guifg=Red]]

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
vim.o.hlsearch = true
vim.o.incsearch = true
-- Case insensitive search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Truecolor
vim.o.termguicolors = true

-- Completion behavior
vim.o.completeopt = 'menuone,noselect'

-- Format on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Lsp mappings
-------------------------------------------------------------------------------
local nmap = function(keys, func, desc)
  if desc then
    desc = 'LSP: ' .. desc
  end

  vim.keymap.set('n', keys, func, { desc = desc })
end

nmap('<leader>e', vim.diagnostic.open_float, "Open diagnostic message")
nmap('<leader>n', vim.diagnostic.goto_next, "[N]ext diagnostic message")
nmap('<leader>p', vim.diagnostic.goto_prev, "[P]rev diagnostic message")
nmap('<leader>q', vim.diagnostic.setloclist, "Diagnostic list")
nmap('<leader>r', vim.lsp.buf.rename, "[R]ename")
nmap('<leader>c', vim.lsp.buf.code_action, "[C]ode action")
nmap('<leader>d', vim.lsp.buf.definition, "Jump to [d]efinition")
nmap('<leader>D', vim.lsp.buf.declaration, "Jump to [D]eclaration")
nmap('<leader>i', vim.lsp.buf.implementation, "Jump to [i]mplementation")
nmap('<leader>f', vim.lsp.buf.references, "Find re[f]erences")
nmap('K', vim.lsp.buf.hover, "Hover documentation")
nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature documentation')

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- vim: ts=2 sts=2 sw=2 et
