#!/usr/bin/env bash
set -euo pipefail

if systemctl list-unit-files --type=service --no-legend bluetooth.service | grep -q bluetooth.service; then
    sudo env -u XDG_RUNTIME_DIR -u DBUS_SESSION_BUS_ADDRESS systemctl --system --no-ask-password enable --now bluetooth.service
fi

if systemctl list-unit-files --type=service --no-legend NetworkManager.service | grep -q NetworkManager.service; then
    sudo env -u XDG_RUNTIME_DIR -u DBUS_SESSION_BUS_ADDRESS systemctl --system --no-ask-password enable --now NetworkManager.service
fi

if systemctl --user list-unit-files --no-legend pipewire.socket pipewire-pulse.socket wireplumber.service 2>/dev/null | grep -q pipewire.socket; then
    if ! systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service; then
        printf 'Could not start the PipeWire user services in this session; they can start after logging into the desktop.\n' >&2
    fi
fi
