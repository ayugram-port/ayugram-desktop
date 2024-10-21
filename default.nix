{ lib
, stdenv
, fetchFromGitHub
, fetchgit
, fetchpatch
, telegram-desktop
, nix-update-script
}: 

let
  tg_owt = fetchgit {
    url = "https://github.com/kaeeraa/tg_owt";
    hash = lib.fakeHash;
  };
in

telegram-desktop.overrideAttrs rec {
  pname = "AyuGramDesktop";
  version = "5.4.1";
  src = fetchFromGitHub {
    owner = "AyuGram";
    repo = "${pname}";
    rev = "v${version}";

    fetchSubmodules = true;
    hash = "sha256-7KmXA3EDlCszoUfQZg3UsKvfRCENy/KLxiE08J9COJ8=";
  };

  patches = [
    ./patch/desktop.patch
    ./patch/macos.patch
    ./patch/scheme.patch
    ./patch/macos-opengl.patch
    ./patch/color_space.patch
    ./patch/native_event.patch
  ];

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "Desktop Telegram client with good customization and Ghost mode.";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    homepage = "https://https://github.com/AyuGram/AyuGramDesktop";
    changelog = "https://https://github.com/AyuGram/AyuGramDesktop/releases/tag/v${version}";
    maintainers = with maintainers; [ 
      s0me1newithhand7s
      kaeeraa
    ];
    mainProgram = "ayugram-desktop";
    broken = stdenv.isDarwin;
  };
}
