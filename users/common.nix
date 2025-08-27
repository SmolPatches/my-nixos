{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    neofetch
    rnix-lsp
    pavucontrol
    yaml-language-server
    zls
    tree
    glxinfo
    eza
    ripgrep
    wofi
    nixpkgs-fmt
    moar
    yacreader
    htop
    thunderbird
    pcmanfm
    qbittorrent
    keepassxc
    rpcs3
    spotify-tui
  ];
  programs = {
    home-manager.enable = true;
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
    kitty = {
      enable = true;
    };
    tmux = {
      enable = true;
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "vicmd";
      shellAliases = {
        ll = "eza -Fxl --icons";
        ls = "eza --icons";
      };
    };
    nushell = {
      enable = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
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
      package = pkgs.emacs30-pgtk;
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
    waybar = {
      enable = true;
    };
  };
  home.sessionVariables = {
    EDITOR = "neovim";
    # wayland session variables are all set in my hyprland config
    #GDK_BACKEND = "wayland";
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
}
