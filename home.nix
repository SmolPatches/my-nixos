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
    xfce.thunar
    pcmanfm
    qbittorrent
    keepassxc
    rpcs3
    pcsx2
    duckstation
    retroarchFull
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
      extraPackages = with pkgs; [
        zls
        rnix-lsp
        zig
        rust-analyzer
        rustc
        cargo
      ];
      plugins = with pkgs.vimPlugins; [
        zig-vim
        trouble-nvim
        telescope-nvim
        nvim-lspconfig
        nvim-cmp
        cmp-buffer
        cmp-path
        cmp-nvim-lsp
        cmp-nvim-lua
        gitsigns-nvim
        gruvbox-nvim
        nvim-treesitter
        nvim-tree-lua
      ];
    };
    kitty = {
      enable = true;
    };
    tmux = {
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
      shellAliases = {
        ll = "exa -Fxl --icons";
        ls = "exa --icons";
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
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
      package = pkgs.emacs29-pgtk;
      #package = pkgs.emacs-nox;
      extraPackages = epkgs: (with epkgs; [ evil nix-mode nixos-options editorconfig rustic treemacs-evil lsp-ui company darkokai-theme adwaita-dark-theme ]);
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
    eww = {
      enable = true;
      configDir = ./eww-bar;
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
    emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
      startWithUserSession = true;
    };
  };
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
