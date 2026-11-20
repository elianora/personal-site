{
  description = "Elianora Rose's Personal Site Flake";
  inputs = {
    # nixpkgs (https://github.com/NixOS/nixpkgs)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Updated ruby versions (https://github.com/bobvanderlinden/nixpkgs-ruby)
    bob-ruby = {
      url = "github:bobvanderlinden/nixpkgs-ruby";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fork of bundix (https://github.com/inscapist/bundix)
    bundix = {
      url = "github:inscapist/bundix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake utilities (https://github.com/numtide/flake-utils)
    flake-utils.url = "github:numtide/flake-utils";

    # Ruby declarative builds (https://github.com/inscapist/ruby-nix)
    ruby-nix = {
      url = "github:inscapist/ruby-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      bob-ruby,
      bundix,
      flake-utils,
      nixpkgs,
      ruby-nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            bob-ruby.overlays.default
          ];
        };

        bundix-cli = bundix.packages.${system}.default;
        ruby = pkgs.ruby;
        deps = [
          env
          ruby
          bundix-cli
        ];

        inherit
          ((ruby-nix.lib pkgs) {
            name = "personal-site";
            inherit ruby;
            gemset = ./gemset.nix;
          }) env;
      in
      {
        packages =
          let
            bundle-cli = pkgs.writeShellApplication {
              name = "bundle";
              runtimeInputs = deps;
              text = ''
                bundle config set path vendor
                bundle config set --local force_ruby_platform true
                bundle "$@"
              '';
            };

            jekyll = pkgs.writeShellApplication {
              name = "jekyll";
              runtimeInputs = deps;
              text = ''
                bundle config set path vendor
                bundle config set --local force_ruby_platform true
                bundle cache
                if [ $# -eq 0 ]; then
                  export JEKYLL_ENV=production
                  bundler exec jekyll build
                else
                  bundler exec jekyll "$@"
                fi
              '';
            };

            personal-site = pkgs.stdenv.mkDerivation {
              pname = "personal-site";
              version = "1.0.0";
              src = ./.;
              nativeBuildInputs = [
                jekyll
              ];

              installPhase = ''
                export JEKYLL_ENV=production
                ${jekyll}/bin/jekyll build -d $out
                rm -rf vendor
              '';
            };
          in
          {
            bundix = bundix-cli;
            bundle = bundle-cli;
            jekyll = jekyll;
            personal-site = personal-site;
            default = jekyll;
          };

        devShells.default = pkgs.mkShell {
          buildInputs = deps;
          shellHook = ''
            bundle config set path vendor
            bundle config set --local force_ruby_platform true
          '';
        };
      }
    );
}
