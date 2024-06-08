local function on_attach(client, buffer) end

local opts = {
  tools = {
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = true,
      parameter_hints_prefix = '',
      other_hints_prefix = '',
    },
  },

  server = {
    on_attach = on_attach,
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          features = { 'all' },
        },
        checkOnSave = {
          command = 'clippy',
        },
      },
    },
  },
}
