#!/usr/bin/env bash
set -euo pipefail

sudo dnf install -y @development-tools
sudo dnf install -y wget curl openssh
if [[ "$(uname -m)" == x86_64 ]]; then
    sudo dnf install -y sublime-text
fi

if ! command -v codex >/dev/null 2>&1; then
    curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi
