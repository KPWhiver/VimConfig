{
  outputs = {self, nixpkgs}: {
    nixosModules.vim = { pkgs, ... }: {
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
