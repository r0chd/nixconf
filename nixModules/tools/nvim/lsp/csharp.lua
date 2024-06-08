local nvim_lsp = require 'lspconfig'

local on_attach = function(client, buffer) end

nvim_lsp.omnisharp.setup {
  on_attach = on_attach,
  cmd = { 'OmniSharp' },
}
