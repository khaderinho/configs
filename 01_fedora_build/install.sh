#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${EUID}" -eq 0 ]] || [[ ! -r /etc/fedora-release ]] || ! command -v dnf >/dev/null 2>&1; then
    printf 'Run this installer as a regular user on Fedora Linux.\n' >&2
    exit 1
fi

sudo dnf install -y dnf5-plugins git stow

for component in audio bluetooth dev fonts media network terminal web window_manager; do
    bash "$script_dir/$component.sh"
done

bash "$script_dir/systemctl.sh"
bash "$script_dir/stow.sh"

printf '\nInstallation completed successfully.\n'
