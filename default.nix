{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation {
  pname = "nes-pong";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = with pkgs; [gnumake cc65];

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/share/nes-pong/
    cp build/pong.nes $out/share/nes-pong/
  '';

  meta = with pkgs.lib; {
    description = "Pong game for the NES";
    homepage = "https://github.com/Grazen0/nes-pong";
    license = licenses.gpl3;
  };
}
