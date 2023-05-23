#! /bin/bash
set -o errexit -o pipefail -o nounset

# Patch makepkg
build-pacman-repo patch-makepkg --replace

eval "$INPUT_COMMAND"