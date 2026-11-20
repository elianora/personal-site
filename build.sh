#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bundler bundix jekyll ruby.devEnv

bundle config set path vendor
bundle config set --local force_ruby_platform true
bundle cache
bundix
export JEKYLL_ENV=production
bundler exec jekyll build
rm -rf vendor
rm -rf ~/.cache/bundix
