#!/usr/bin/env bash
set -euo pipefail

sudo dnf install -y @development-tools
sudo dnf install -y wget curl openssh

if [[ "$(uname -m)" == x86_64 ]]; then
    if ! grep -Rqs '^\[sublime-text\]$' /etc/yum.repos.d; then
        sudo rpm --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
        sudo dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
    fi
    sudo dnf install -y sublime-text
fi

if ! command -v codex >/dev/null 2>&1; then
    curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi
