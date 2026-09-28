#!/usr/bin/env bash
set -euo pipefail

sudo dnf install -y @virtualization qemu-kvm virt-manager
sudo env -u XDG_RUNTIME_DIR -u DBUS_SESSION_BUS_ADDRESS systemctl --system --no-ask-password enable --now virtqemud.socket virtnetworkd.socket
