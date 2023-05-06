#!/usr/bin/env bash

ROOT="$HOME/.config/nvim/lua/custom"

mkdir -p "$ROOT/profiles"

rm -rf "$ROOT/../../plugin" "$HOME/.local/share/nvim"
env features=minimal nvim
mv "$ROOT/../../plugin/packer_compiled.lua" "$ROOT/profiles/packer_compiled_minimal.lua"

rm -rf "$ROOT/../../plugin" "$HOME/.local/share/nvim"
env features=default nvim
mv "$ROOT/../../plugin/packer_compiled.lua" "$ROOT/profiles/packer_compiled_default.lua"

rm -rf "$ROOT/../../plugin" "$HOME/.local/share/nvim"
env env features=ide,extconfig nvim
mv "$ROOT/../../plugin/packer_compiled.lua" "$ROOT/profiles/packer_compiled_ide.lua"

rm -rf "$ROOT/../../plugin" "$HOME/.local/share/nvim"
env features=all nvim
mv "$ROOT/../../plugin/packer_compiled.lua" "$ROOT/profiles/packer_compiled_all.lua"
