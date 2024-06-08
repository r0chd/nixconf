require('conform').setup {
  formatters_by_ft = {
    rust = { 'rustfmt' },
    lua = { 'stylua' },
    nix = { 'alejandra' },
    c = { 'clang_format' },
    csharp = { 'dotnet-csharpier' },
    javascript = { 'prettierd', 'prettier' },
    javascriptreact = { 'prettierd', 'prettier' },
    typescript = { 'prettierd', 'prettier' },
    typescriptreact = { 'prettierd', 'prettier' },
    asm = { 'asmfmt' },
    zig = { 'zig fmt' },
  },
}

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf }
  end,
})
