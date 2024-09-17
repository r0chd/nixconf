{
  pkgs,
  username,
  colorscheme,
  inputs,
}: {
  environment.systemPackages = with pkgs; [
    ripgrep
    tree-sitter
    fd
    adwaita-icon-theme
    lua-language-server
    alejandra
    nil
    gcc
    stylua
  ];

  home-manager.users."${username}".programs.neovim = let
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      {
        plugin = telescope-nvim;
        config = toLuaFile ./plugins/telescope.lua;
      }
      {
        plugin = oil-nvim;
        config = toLuaFile ./plugins/oil.lua;
      }
      {
        plugin = nvim-cmp;
        config = toLuaFile ./plugins/cmp.lua;
      }
      {
        plugin = dashboard-nvim;
        config = toLuaFile ./plugins/dashboard.lua;
      }
      {
        plugin = nvim-notify;
        config = toLuaFile ./plugins/notify.lua;
      }
      {
        plugin = bufferline-nvim;
        config = toLuaFile ./plugins/bufferline.lua;
      }
      {
        plugin = noice-nvim;
        config = toLuaFile ./plugins/noice.lua;
      }
      (
        if colorscheme.name == "catppuccin"
        then {
          plugin = catppuccin-nvim;
          config = toLuaFile ./themes/catppuccin.lua;
        }
        else []
      )
      {
        plugin = which-key-nvim;
        config = toLuaFile ./plugins/which-key.lua;
      }
      {
        plugin = indent-blankline-nvim;
        config = toLuaFile ./plugins/ibl.lua;
      }
      {
        plugin = gitsigns-nvim;
        config = toLuaFile ./plugins/gitsigns.lua;
      }
      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./plugins/lsp.lua;
      }
      {
        plugin = conform-nvim;
        config = toLuaFile ./plugins/conform.lua;
      }
      {
        plugin = vim-highlightedyank;
        config = toLuaFile ./plugins/highlighted-yank.lua;
      }
      {
        plugin = nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-c
          p.tree-sitter-cpp
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-json
          p.tree-sitter-rust
          p.tree-sitter-zig
          p.tree-sitter-glsl
        ]);
        config = toLuaFile ./plugins/tree-sitter.lua;
      }
      cmp-nvim-lsp
      rustaceanvim
      zig-vim
      cmp-path
      cmp-buffer
      nui-nvim
      nvim-web-devicons
      plenary-nvim
      nvim-treesitter-textobjects
      auto-pairs
      fidget-nvim
      vim-tmux-navigator
      cmp-vsnip
      vim-vsnip
      presence-nvim
      vim-wakatime
    ];
    extraLuaConfig = ''
      vim.g.mapleader = ' '

      vim.api.nvim_set_keymap('n', 'j', 'v:count ? "j" : "gj"', { noremap = true, expr = true, silent = true })
      vim.api.nvim_set_keymap('n', 'k', 'v:count ? "k" : "gk"', { noremap = true, expr = true, silent = true })

      vim.wo.relativenumber = true
      vim.wo.number = true

      vim.opt.expandtab = true
      vim.opt.shiftwidth = 4
      vim.opt.tabstop = 4

      vim.cmd 'autocmd BufEnter * set formatoptions-=cro'
      vim.cmd 'autocmd BufEnter * setlocal formatoptions-=cro'

      vim.o.clipboard = 'unnamedplus'
      vim.o.hlsearch = false
      vim.o.breakindent = true
      vim.o.undofile = true
      vim.o.ignorecase = true
      vim.o.smartcase = true
      vim.wo.signcolumn = 'yes'
      vim.o.updatetime = 250
      vim.o.timeoutlen = 300
      vim.o.completeopt = 'menuone,noselect'
      vim.o.scrolloff = 3
      vim.o.completeopt = 'menuone,noinsert'
      vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        pattern = { '*' },
        command = [[%s/\s\+$//e]],
      })
    '';
  };
}
