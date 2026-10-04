#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "$script_dir/.." && pwd)"

mkdir -p "$HOME/.src" "$HOME/.bin" "$HOME/.config" "$HOME/screenshots"

if [[ -e "$HOME/.bashrc" || -L "$HOME/.bashrc" ]]; then
    expected_bashrc="$repo_dir/bash/.bashrc"
    current_bashrc="$(readlink -f "$HOME/.bashrc" 2>/dev/null || true)"
    if [[ "$current_bashrc" != "$expected_bashrc" ]]; then
        mv -- "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%Y%m%d%H%M%S%N)"
    fi
fi

stow --dir="$repo_dir" --target="$HOME" bash vim xorg

for package in alacritty fontconfig i3 i3status rofi tmux; do
    mkdir -p "$HOME/.config/$package"
    stow --dir="$repo_dir" --target="$HOME/.config/$package" "$package"
done
