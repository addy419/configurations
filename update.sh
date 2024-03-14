#!/usr/bin/env bash

mozilla-addons-to-nix ./modules/home/desktop/firefox/firefox.json ./modules/home/desktop/firefox/addons.nix
nix flake update
