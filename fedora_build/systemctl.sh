#!/usr/bin/env bash
set -euo pipefail

enable_bluetooth=1
while (($#)); do
    case "$1" in
        --no-bluetooth) enable_bluetooth=0 ;;
        *) printf 'Unknown service option: %s\n' "$1" >&2; exit 2 ;;
    esac
    shift
done

if ((enable_bluetooth)) && systemctl list-unit-files --type=service --no-legend bluetooth.service | grep -q bluetooth.service; then
    sudo systemctl enable --now bluetooth.service
fi

if systemctl list-unit-files --type=service --no-legend NetworkManager.service | grep -q NetworkManager.service; then
    sudo systemctl enable --now NetworkManager.service
fi

if systemctl --user list-unit-files --no-legend pipewire.socket pipewire-pulse.socket wireplumber.service 2>/dev/null | grep -q pipewire.socket; then
    if ! systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service; then
        printf 'Could not start the PipeWire user services in this session; they can start after logging into the desktop.\n' >&2
    fi
fi
