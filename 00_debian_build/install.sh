#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${EUID}" -eq 0 ]] || [[ ! -r /etc/debian_version ]] || ! command -v apt-get >/dev/null 2>&1; then
    printf 'Run this installer as a regular user on Debian Linux.\n' >&2
    exit 1
fi

sudo apt-get update
sudo apt-get install -y git stow ca-certificates

for component in audio bluetooth dev fonts media network terminal web window_manager; do
    bash "$script_dir/$component.sh"
done

bash "$script_dir/systemctl.sh"
bash "$script_dir/stow.sh"

printf '\nInstallation completed successfully.\n'
