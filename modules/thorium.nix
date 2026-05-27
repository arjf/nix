{ pkgs ? import <nixpkgs> { } }:

let
  mkThorium = { pname, version, url, variant, hash }:
    let
      src = pkgs.fetchurl { inherit url hash; };
      appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };
    in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;

      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/thorium-browser.desktop $out/share/applications/thorium-browser.desktop
        install -m 444 -D ${appimageContents}/thorium.png $out/share/icons/hicolor/512x512/apps/thorium.png

        substituteInPlace $out/share/applications/thorium-browser.desktop \
          --replace-warn 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U' \
          --replace-warn 'Icon=thorium-browser' 'Icon=thorium'
      '';

      meta = with pkgs.lib; {
        description = "Thorium Browser (${variant}) - A fast and secure web browser";
        homepage = "https://thorium.rocks";
        license = licenses.bsd3;
        platforms = [ "x86_64-linux" ];
        mainProgram = pname;
      };
    };
in
{
  thorium-avx2 = mkThorium {
    pname = "thorium";
    version = "138.0.7204.303";
    variant = "AVX2";
    url = "https://github.com/Alex313031/thorium/releases/download/M138.0.7204.303/Thorium_Browser_138.0.7204.303_AVX2.AppImage";
    hash = "sha256-sXzUgqZ9loprBCObHXLRjkW15EzFFMBbqqqxuQ+ZIjA=";
  };

  thorium-sse4 = mkThorium {
    pname = "thorium";
    version = "138.0.7204.303";
    variant = "SSE4";
    url = "https://github.com/Alex313031/thorium/releases/download/M138.0.7204.303/Thorium_Browser_138.0.7204.303_SSE4.AppImage";
    hash = "sha256-g8C/RT3O++4GLb09RahLCB+3RuSE/EfICf9iIAkRccA=";
  };
}
