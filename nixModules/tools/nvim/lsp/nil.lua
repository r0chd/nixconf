local nvim_lsp = require 'lspconfig'

nvim_lsp.rnix.setup {
  cmd = { 'nil' },
  filetypes = { 'nix' },
}
