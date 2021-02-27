{ stdenv, lib, fetchurl, fetchzip, makeWrapper, jre, undmg }:

let
  pname = "freeplane";
  version = "1.8.11";
in stdenv.mkDerivation ({
  inherit pname;
  inherit version;

  meta = with lib; {
    description = "Mind-mapping software";
    homepage = "https://www.freeplane.org/wiki/index.php/Home";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ maxhbr aaschmid ];
    platforms = platforms.linux ++ platforms.darwin;
  };

} // lib.optionalAttrs stdenv.isLinux {
  src = fetchzip {
    url = "https://sourceforge.net/projects/freeplane/files/freeplane%20stable/freeplane_bin-${version}.zip/download#freeplane_bin-${version}.zip";
    sha256 = "tJyJ7LQoeEFakjOgOU6yUA8dlCuXSCvbUB+gRq4ElMw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r * $out/share
    makeWrapper $out/share/freeplane.sh $out/bin/freeplane \
      --set JAVA_HOME "${jre}/lib/openjdk"

    runHook postInstall
  '';

} // lib.optionalAttrs stdenv.isDarwin {
  src = fetchurl {
    url = "https://altushost-swe.dl.sourceforge.net/project/freeplane/freeplane%20stable/Freeplane-${version}.dmg";
    name = "${pname}-${version}.dmg";
    sha256 = "0yikdcgh15wdayiqhz1vzdyqfpggv726gz2xa55hs741x108cmaz";
  };

  depsBuildBuild = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/${pname}.app"
    cp -a . "$out/Applications/${pname}.app"
    chmod a+x "$out/Applications/${pname}.app/Contents/MacOs/Freeplane";

    runHook postInstall
  '';
})
