local nvim_lsp = require 'lspconfig'

nvim_lsp.asm_lsp.setup {
  cmd = { 'asm-lsp' },
  filetypes = { 'asm' },
}
