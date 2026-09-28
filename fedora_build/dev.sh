#!/usr/bin/env bash
set -euo pipefail

sudo dnf install -y @development-tools
sudo dnf install -y git wget curl openssh stow sublime-text

if ! command -v codex >/dev/null 2>&1; then
    curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi
