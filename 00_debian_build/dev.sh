#!/usr/bin/env bash
set -euo pipefail

sudo apt-get install -y build-essential wget curl openssh-client

if [[ "$(uname -m)" == x86_64 ]]; then
    keyring=/etc/apt/keyrings/sublimehq-pub.asc
    source_file=/etc/apt/sources.list.d/sublime-text.sources

    if [[ ! -f "$keyring" ]]; then
        sudo install -d -m 0755 /etc/apt/keyrings
        wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee "$keyring" >/dev/null
    fi

    if [[ ! -f "$source_file" ]]; then
        printf '%s\n' \
            'Types: deb' \
            'URIs: https://download.sublimetext.com/' \
            'Suites: apt/stable/' \
            "Signed-By: $keyring" | sudo tee "$source_file" >/dev/null
        sudo apt-get update
    fi

    sudo apt-get install -y sublime-text
fi

if ! command -v codex >/dev/null 2>&1; then
    curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi
