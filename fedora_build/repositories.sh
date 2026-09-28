#!/usr/bin/env bash
set -euo pipefail

sudo dnf install -y dnf5-plugins

# Brave Browser repository
if [[ ! -f /etc/yum.repos.d/brave-browser.repo ]]; then
    sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
fi

## Sublime text
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

sudo dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
