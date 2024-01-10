{ lib
, stdenvNoCC
, fetchFromGitHub
, gnome-themes-extra
, gtk-engine-murrine
, fetchzip
}:
stdenvNoCC.mkDerivation {
  pname = "dark-abyss";
  version = "2.3.0";

  src = fetchzip {
    url = "./Abyss-BLOOD-2.3.0.tar";
    hash = "";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  buildInputs = [
    gnome-themes-extra
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    mkdir -p $out/share/icons
    cp -a themes/* $out/share/themes
    cp -a icons/* $out/share/icons
    runHook postInstall
  '';

  # meta = with lib; {
  #   description = "A Gtk theme based on the Gruvbox colour pallete";
  #   homepage = "https://www.pling.com/p/1681313/";
  #   license = licenses.gpl3Only;
  #   platforms = platforms.unix;
  #   maintainers = [ maintainers.math-42 ];
  # };
}
