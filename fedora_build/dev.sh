#!/usr/bin/env bash
set -euo pipefail

sudo dnf install -y @development-tools
sudo dnf install -y wget curl openssh stow
