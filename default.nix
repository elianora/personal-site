with (import <nixpkgs> {});

let
  env = bundlerEnv {
    name = "personal-site";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
stdenv.mkDerivation {
  name = "personal-site";
  buildInputs = [
    env
    ruby
  ];

  shellHook = ''
    exec ${env}/bin/jekyll serve --watch
  '';
}
