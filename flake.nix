{
  description = "Elianora Rose's Personal Site Flake";
  inputs = {
    # nixpkgs (https://github.com/NixOS/nixpkgs)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Fork of bundix (https://github.com/inscapist/bundix)
    bundix = {
      url = "github:inscapist/bundix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Ruby declarative builds (https://github.com/inscapist/ruby-nix)
    ruby-nix = {
      url = "github:inscapist/ruby-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      bundix,
      nixpkgs,
      ruby-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ ruby-nix.overlays.ruby ];
      };

      bundix-cli = bundix.packages.${system}.default;
      deps = [
        env
        ruby
        bundix-cli
      ];

      inherit
        ((ruby-nix.lib pkgs) {
          name = "elianorarose.com";
          gemset = ./gemset.nix;
          gemConfig = pkgs.defaultGemConfig;
        })
        env
        ruby;
    in
    {
      packages.${system} =
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

          # personal-site = pkgs.stdenv.mkDerivation {};
        in
        {
          jekyll = jekyll;
          bundle = bundle-cli;
          bundix = bundix-cli;
          # personal-site = personal-site;
          default = jekyll;
        };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = deps;
        shellHook = ''
          bundle config set path vendor
          bundle config set --local force_ruby_platform true
        '';
      };
    };
}
