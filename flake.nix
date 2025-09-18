{
  outputs = {self}: {
    nixosModules.vim = { pkgs, ... }: let
      vim-monkey-c = pkgs.vimUtils.buildVimPlugin {
        name = "vim-monkey-c";
        src = pkgs.fetchFromGitHub {
          owner = "klimeryk";
          repo = "vim-monkey-c";
          rev = "master";
          sha256 = "DVSxJHNrNCxQJNRJqwo6hxLjx22Qe2mWHcmfhFmPTOg=";
        };
      };
    in {
      programs.neovim = {
        enable = true;
        vimAlias = true;
        viAlias = true;
        defaultEditor = true;
        configure = {
          customRC = ''
            luafile ${./nvim.lua}
          '';
          packages.myVimPackage = with pkgs.vimPlugins; {
            start = [
              # File browser
              nvim-tree-lua
              nvim-web-devicons

              # Status line
              lualine-nvim

              # Themes
              monokai-pro-nvim

              # Indentation
              indent-blankline-nvim
              guess-indent-nvim

              # Auto save
              auto-save-nvim

              # File/search
              telescope-nvim
              telescope-fzf-native-nvim
              remote-sshfs-nvim
              toggleterm-nvim
              trouble-nvim

              # Motion
              camelcasemotion
              nvim-treesitter-textobjects

              # Git
              gitsigns-nvim

              # LSP
              nvim-lspconfig
              clangd_extensions-nvim
              overseer-nvim

              # Autopairs
              nvim-autopairs

              # Snippets
              luasnip
              friendly-snippets

              # Autocompletion
              nvim-cmp
              cmp-treesitter
              cmp-nvim-lsp
              cmp-path
              cmp-buffer
              cmp_luasnip

              # Syntax highlighting
              nvim-treesitter.withAllGrammars  # Syntax highlighting
              nvim-treesitter-context          # Context viewing
              vim-monkey-c                     # monkey C syntax highlighting
            ];
          };
        };
      };

      environment.systemPackages = with pkgs; [
        # Utilities
        ripgrep
        wl-clipboard
        just

        # LSPs
        nil
        rust-analyzer
        rustfmt
        rustc
        cargo
        clang-tools_16
        marksman
        mesonlsp
        cmake-language-server
        lua-language-server
        nodePackages.dockerfile-language-server-nodejs
        nodePackages.yaml-language-server
        nodePackages.vscode-json-languageserver
        nodePackages.bash-language-server
        python3Packages.python-lsp-server
      ];
    };
    nixosModule = self.nixosModules.vim;
  };
}
