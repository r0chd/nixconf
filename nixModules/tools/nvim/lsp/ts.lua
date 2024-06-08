require('lspconfig').tsserver.setup{
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_dir = function(fname)
    return require'lspconfig'.util.root_pattern('tsconfig.json')(fname) or
           require'lspconfig'.util.root_pattern('package.json', 'jsconfig.json', '.git')(fname)
  end
}
