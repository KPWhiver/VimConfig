{
  outputs = {self, nixpkgs}: {
    nixosModules.vim = { pkgs, ... }: let
      vim-karel = pkgs.vimUtils.buildVimPlugin {
        name = "vim-karel";
        src = pkgs.fetchFromGitHub {
          owner = "onerobotics";
          repo = "vim-karel";
          rev = "master";
          sha256 = "Dw+/LRUlOhX7Bl4FFAFRVExp1O7hTliUXS1cBPXg5BE=";
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
              nerdtree nerdtree-git-plugin    # File browser
              molokai                         # Theme
              vim-auto-save                   # Auto save
              fzfWrapper fzf-vim              # File/text searching
              vim-polyglot                    # Syntax highlighting
              vim-sleuth                      # Auto tab size
              camelcasemotion                 # Subname motions
              vim-gitgutter                   # Git info line numbers
              vim-fugitive                    # Git commands
              vim-karel                       # Karel syntax highlighting
              nvim-lspconfig cmp-nvim-lsp     # Easy LSP setup
              nvim-cmp                        # Autocompletion
              cmp-treesitter
              (nvim-treesitter.withPlugins (  # Syntax highlighting
                plugins: with plugins; [
                  tree-sitter-nix
                  tree-sitter-python
                  tree-sitter-c
                  tree-sitter-cpp
                  tree-sitter-cpp
                  tree-sitter-json
                  tree-sitter-bash
                  tree-sitter-toml
                  tree-sitter-make
                  tree-sitter-yaml
                  tree-sitter-vim
                  tree-sitter-cmake
                ]
              ))
            ];
          };
        };
      };

      environment.systemPackages = with pkgs; [
        silver-searcher
        fzf
        wl-clipboard
        nil
      ];
    };
    nixosModule = self.nixosModules.vim;
  };
}
