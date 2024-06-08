local nvim_lsp = require 'lspconfig'

local on_attach = function(client, bufnr) end

nvim_lsp.html.setup {
  cmd = { 'html-languageserver', '--stdio' },
  on_attach = on_attach,
}
