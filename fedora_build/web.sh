#!/usr/bin/env bash
set -euo pipefail

sudo dnf install -y firefox chromium

curl -fsS https://dl.brave.com/install.sh | FLAVOR=origin sh
