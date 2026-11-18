#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bundler bundix jekyll ruby.devEnv

bundle config set path vendor
bundle config set --local force_ruby_platform true
bundle cache
bundix
bundler exec jekyll serve --watch
rm -rf vendor
rm -rf ~/.cache/bundix
