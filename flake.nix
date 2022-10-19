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
          customRC = builtins.replaceStrings ["source ~/.config/nvim/vimrc_plugins"] [""] (builtins.readFile ./vimrc);
          packages.myVimPackage = with pkgs.vimPlugins; {
            start = [
              nerdtree
              nerdtree-git-plugin
              molokai
              vim-auto-save
              LanguageClient-neovim
              deoplete-nvim
              fzfWrapper
              fzf-vim
              vim-orgmode
              vim-speeddating
              vim-polyglot
              vim-sleuth
              camelcasemotion
              vimagit
              vim-gitgutter
              vim-fugitive
              vim-sneak
              vim-karel
            ];
          };
        };
      };

      environment.systemPackages = with pkgs; [
        silver-searcher
        fzf
        wl-clipboard
      ];
    };
    nixosModule = self.nixosModules.vim;
  };
}
