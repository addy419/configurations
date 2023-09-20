#!/usr/bin/env bash

nix develop --impure .#mozilla-addons-to-nix --command bash -c "mozilla-addons-to-nix ./modules/desktop/firefox/firefox.json ./modules/desktop/firefox/addons.nix"
nix flake update
