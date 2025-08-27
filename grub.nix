# grub that overides secure boot
# i hope
{ pkgs }:

pkgs.grub2.overrideAttrs (old: {
  version = "head";
  patches = [
    ./insecureboot.patch
  ];
  configureFlags = old.configureFlags or [ ] ++ [
    "--with-platform=efi"
    "--enable-efivars"
  ];
  src = pkgs.fetchFromSavannah {
    repo = "grub";
    rev = "19c698d123ae46d7a8fbf425067aff2d10dac8ca";
    hash = "sha256-I1XKt9W93mcdbv42CCb06wHVie63ITY5AmK4vYW53kw=";
  };
})
