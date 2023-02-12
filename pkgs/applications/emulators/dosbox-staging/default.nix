{ lib
, stdenv
, fetchFromGitHub
, SDL2
, SDL2_image
, SDL2_net
, alsa-lib
, copyDesktopItems
, fluidsynth
, glib
, gtest
, irr1
, libGL
, libGLU
, libjack2
, libmt32emu
, libogg
, libpng
, libpulseaudio
, libslirp
, libsndfile
, makeDesktopItem
, makeWrapper
, meson
, ninja
, opusfile
, pkg-config
, speexdsp
}:

stdenv.mkDerivation (self: {
  pname = "dosbox-staging";
  version = "0.80.1";

  src = fetchFromGitHub {
    owner = "dosbox-staging";
    repo = "dosbox-staging";
    rev = "v${self.version}";
    hash = "sha256-I90poBeLSq1c8PXyjrx7/UcbfqFNnnNiXfJdWhLPGMc=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    gtest
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_net
    alsa-lib
    fluidsynth
    glib
    irr1
    libGL
    libGLU
    libjack2
    libmt32emu
    libogg
    libpng
    libpulseaudio
    libslirp
    libsndfile
    opusfile
    speexdsp
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${SDL2_image}/include/SDL2"
    "-I${SDL2_net}/include/SDL2"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "dosbox-staging";
      exec = "dosbox-staging";
      icon = "dosbox-staging";
      comment = "x86 dos emulator enhanced";
      desktopName = "DosBox-Staging";
      genericName = "DOS emulator";
      categories = [ "Emulator" "Game" ];
    })
  ];

  postFixup = ''
    # Rename binary, add a wrapper, and copy manual to avoid conflict with
    # original dosbox. Doing it this way allows us to work with frontends and
    # launchers that expect the binary to be named dosbox, but get out of the
    # way of vanilla dosbox if the user desires to install that as well.
    mv $out/bin/dosbox $out/bin/${self.pname}
    makeWrapper $out/bin/dosbox-staging $out/bin/dosbox

    # Create a symlink to dosbox manual instead of merely copying it
    pushd $out/share/man/man1/
    mv dosbox.1.gz ${self.pname}.1.gz
    ln -s ${self.pname}.1.gz dosbox.1.gz
    popd
  '';

  meta = {
    homepage = "https://dosbox-staging.github.io/";
    description = "A modernized DOS emulator";
    longDescription = ''
      DOSBox Staging is an attempt to revitalize DOSBox's development
      process. It's not a rewrite, but a continuation and improvement on the
      existing DOSBox codebase while leveraging modern development tools and
      practices.
    '';
    changelog = "https://github.com/dosbox-staging/dosbox-staging/releases/tag/v${self.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = [
      lib.maintainers.joshuafern
      lib.maintainers.AndersonTorres
    ];
    platforms = lib.platforms.unix;
    priority = 101;
  };
})
# TODO: report upstream about not finding extra SDL2 libraries
