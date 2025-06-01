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
              nerdtree                        # File browser
              nerdtree-git-plugin

              molokai                         # Theme

              auto-save-nvim                  # Auto save

              fzfWrapper fzf-vim              # File/text searching

              vim-sleuth                      # Auto tab size

              camelcasemotion                 # Subname motions

              vim-gitgutter                   # Git info line numbers
              vim-fugitive                    # Git commands

              nvim-lspconfig                  # Easy LSP setup
              clangd_extensions-nvim

              luasnip                         # Snippets
              friendly-snippets

              nvim-cmp                        # Autocompletion
              cmp-treesitter
              cmp-nvim-lsp
              cmp-path
              cmp-buffer
              cmp_luasnip

              nvim-treesitter.withAllGrammars  # Syntax highlighting
              nvim-treesitter-context          # Context viewing
              vim-monkey-c                     # monkey C syntax highlighting
            ];
          };
        };
      };

      environment.systemPackages = with pkgs; [
        # Utilities
        silver-searcher
        fzf
        wl-clipboard

        # LSPs
        nil
        rust-analyzer
        rustfmt
        rustc
        cargo
        clang-tools_16
        marksman
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
