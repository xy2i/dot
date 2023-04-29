-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Disable built-in lsp for Rust, because rust-tools sets it up
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {}
      }
    },
  },

  --  Rust lsp
  {
    "simrat39/rust-tools.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
  },
}
-- vim: ts=2 sts=2 sw=2 et
