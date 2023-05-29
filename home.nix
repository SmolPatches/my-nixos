{ config, pkgs, ... }: {


  # home-manager.users.rob = {
  /* The home.stateVersion option does not have a default and must be set */
  home.stateVersion = "23.05";
  #home.stateVersion = "18.09";
  home.packages = with pkgs; [
    neofetch
    rnix-lsp
    yaml-language-server
    zls
    nixpkgs-fmt
    moar
    yacreader
    htop
    wofi
    thunderbird
    pcmanfm
    keepassxc
    spotify-tui
  ];
  programs = {
    git = {
      enable = true;
      ignores = [ "*.*~" "#*#" ];
      userEmail = "rob73hall@gmail.com";
      userName = "mdnlss";
      extraConfig = {
        core = { defaultBranch = "trunk"; };
      };
      difftastic = {
        enable = true;
        background = "dark";
      };
    };
    neovim = {
      enable = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;
      defaultEditor = true;
      extraLuaConfig = builtins.readFile ./neovim/init.lua;
      plugins = with pkgs.vimPlugins; [
        zig-vim
        trouble-nvim
        telescope-nvim
        coc-clangd
        coc-rust-analyzer
        coc-python
        coc-docker
        gitsigns-nvim
        gruvbox-nvim
      	nvim-treesitter
      ];
    };
    kitty = {
      enable = true;
    };
    vscode = {
      package = pkgs.vscodium;
      enable = true;
      userSettings = {
        "editor.fontFamily" = "'Caskaydia Nerd Font Mono'";
        "editor.fontSize" = 14;
      };
      extensions = with pkgs.vscode-extensions;[
        vscodevim.vim
        matklad.rust-analyzer
        tiehuis.zig
      ];
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      defaultKeymap = "vicmd";
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [ "--exact" ];
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    alacritty = {
      enable = true;
    };
    emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
      #package = pkgs.emacs-nox;
      extraPackages = epkgs: (with epkgs; [ evil nix-mode nixos-options editorconfig tao-theme yaml-mode flycheck rustic treemacs-evil lsp-ui company ]);
    };
    zathura = {
      enable = true;
    };
    lf = {
      enable = true;
    };
    librewolf = {
      enable = true;
    };
    rofi = {
      enable = true;
    };
    helix = {
      enable = true;
      settings = {
        editor = {
          mouse = false;
          auto-format = true;
          line-number = "relative";
          lsp.display-messages = true;
        };
      };
      themes = { };
    };
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  gtk = {
    enable = true;
    font = {
      package = (pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; });
      name = " CaskaydiaCove Nerd Font Mono";
      size = 14;
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  services = {
    spotifyd = {
      enable = true;

    };
  };
  # xdg entries for home manager
  xdg.desktopEntries = {
    steam = {
      name = "Steam";
      exec = "steam -w 2160 -h 1440 %U";
      type = "Application";
      categories = [ "Game" ];
      terminal = false;
      mimeType = [ "x-scheme-handler/steam" "x-scheme-handler/steamlink" ];
      prefersNonDefaultGPU = true;
    };
  };
}
