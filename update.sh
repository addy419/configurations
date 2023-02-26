#!/usr/bin/env bash

mozilla-addons-to-nix ./modules/desktop/firefox/firefox.json ./modules/desktop/firefox/addons.nix
nix flake update
