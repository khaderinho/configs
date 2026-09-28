#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "$script_dir/.." && pwd)"

if ! command -v stow >/dev/null 2>&1; then
    printf 'GNU Stow is required. Install it and run this script again.\n' >&2
    exit 1
fi

mkdir -p "$HOME/.config" "$HOME/screenshots"

if [[ -e "$HOME/.bashrc" || -L "$HOME/.bashrc" ]]; then
    expected_bashrc="$repo_dir/bash/.bashrc"
    current_bashrc="$(readlink -f "$HOME/.bashrc" 2>/dev/null || true)"
    if [[ "$current_bashrc" != "$expected_bashrc" ]]; then
        backup="$HOME/.bashrc.backup.$(date +%Y%m%d%H%M%S%N)"
        mv -- "$HOME/.bashrc" "$backup"
        printf 'Backed up existing .bashrc to %s\n' "$backup"
    fi
fi

stow --dir="$repo_dir" --target="$HOME" --stow bash vim xorg

config_packages=(alacritty fontconfig i3 i3status rofi tmux wallpapers)

if ((${#config_packages[@]})); then
    for package in "${config_packages[@]}"; do
        mkdir -p "$HOME/.config/$package"
        stow --dir="$repo_dir" --target="$HOME/.config/$package" --stow "$package"
    done
fi

printf 'Links created successfully.\n'
