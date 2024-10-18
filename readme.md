# feat/secret-packages
use agenix to install packages without people knowing what (or other nixos setups)
# How to Use
- Install on NixOS
  > ```nixos-rebuild switch --flake . --impure --use-remote-sudo```
  Impure
  Because
  Agenix
  uses
  files
  outside in /run/agenix which is outside the scope of the nix-store
- Install on Non-NixOS with Home-Manaager
> ```home-manager switch --flake flake.nix```

- Test
> ```nix flake check```

# What it does
Use agenix to include a secret nix file to run a(hidden from the view of others)
Use overlay for ungoogled chromium to allow web players
