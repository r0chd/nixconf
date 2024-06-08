local nvim_lsp = require 'lspconfig'
local on_attach = function(client, bufnr) end

-- define capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.zls.setup {
  on_attach = on_attach,
  cmd = { 'zls' },
  filetypes = { 'zig' },
  single_file_support = true,
  capabilities = capabilities,
}
