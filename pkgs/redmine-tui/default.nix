{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  stdenv,
  xclip,
  xdg-utils,
}:

buildGoModule rec {
  pname = "redmine-tui";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "omertahaoztop";
    repo = "redmine-tui";
    tag = "v${version}";
    hash = "sha256-Tr7P4KTtkGJEAOqij6haHRrYcIBjJPT6kJUXwB4QN3I=";
  };

  vendorHash = "sha256-VDu/hgC7pfgCnqtcjuMtJIzQPJfC8hoMSPGoD5r6tJ0=";

  # Upstream's export tests only stub xdg-open, even on Darwin.
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ makeWrapper ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/redmine-tui \
      --prefix PATH : ${lib.makeBinPath [ xclip xdg-utils ]}
  '';

  meta = {
    description = "Terminal user interface for Redmine";
    homepage = "https://github.com/omertahaoztop/redmine-tui";
    changelog = "https://github.com/omertahaoztop/redmine-tui/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "redmine-tui";
  };
}
