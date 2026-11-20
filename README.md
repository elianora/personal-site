# Elianora Rose's Personal Site

The source code, markup, markdown, and assets of my personal site.

## Before You Get Started

Before getting started, be sure to read [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) and [CONTRIBUTING.md](./CONTRIBUTING.md), each of which contains guidelines that must be understood before working on this project. Note that these guidelines are merely for consistency with my other repositories.

## Running the Website

For local development, the following commands are possible:

- For `jekyll build` use `nix run .`
- For `jekyll serve --watch --drafts` use `nix run . serve -- --watch --drafts`
- For `bundle lock` use `nix run .#bundle lock`
- For `bundix -m` use `nix run .#bundix -- -m`

## Licenses

Note that [LICENSE](./LICENSE) is a combination of licenses (MIT AND OFL-1.1) that must both be adhered to. The relevant licenses for each are contained within [LICENSE.MIT](./LICENSE.MIT), [LICENSE.Atkinson.OFL-1.1](./LICENSE.Atkinson.OFL-1.1), [LICENSE.FiraCode.OFL-1.1](./LICENSE.FiraCode.OFL-1.1), the latter two of which are to comply with the following font licenses:

- Braille Institute of America, Inc. for the "Atkinson" and "Hyperlegible" fonts
- The Fira Code Project Authors for the "Fira Code" fonts
