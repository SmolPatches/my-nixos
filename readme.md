# How to Use
- Install on NixOS
  > ```sudo nixos-rebuild switch - -flake flake.nix```

- Install on Non-NixOS with Home-Manaager
> ```home-manager switch --flake flake.nix```

- Test
> ```nix flake check```

# Agenix Branch
This branch uses agenix to store a file in nix(secrets/secret1.age)
which when decrypted ends up in /home/watashi/test.txt as clear text (note that the file is owned by root)
Effectively hidding the test.txt file within nix store but only visible on a system with the proper keys
Note that my nixos system still builds if the key cannot be decrypted because the key is not necessary to nixos/home-manager setup

