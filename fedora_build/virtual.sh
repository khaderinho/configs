#!/usr/bin/env bash
set -euo pipefail

sudo dnf install -y @virtualization qemu-kvm virt-manager
sudo systemctl --system enable --now libvirtd
