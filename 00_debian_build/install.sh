#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
components=(audio bluetooth dev fonts media network terminal web window_manager)
final_steps=(systemctl stow)
all_scripts=("${components[@]}" "${final_steps[@]}")

validate_scripts() {
    local component script
    for component in "${all_scripts[@]}"; do
        script="$script_dir/$component.sh"
        if [[ ! -f "$script" || ! -r "$script" || ! -s "$script" ]]; then
            printf 'Installer script is missing, unreadable, or empty: %s\n' "$script" >&2
            return 1
        fi
        if ! bash -n "$script"; then
            printf 'Installer script has a syntax error: %s\n' "$script" >&2
            return 1
        fi
    done
}

run_script() {
    local component="$1" script="$script_dir/$1.sh" status
    printf '\n==> Running %s\n' "$script"
    if bash "$script"; then
        printf '<== Finished %s\n' "$script"
    else
        status=$?
        printf 'Installation stopped: %s failed with exit status %d.\n' "$script" "$status" >&2
        exit "$status"
    fi
}

if [[ "${EUID}" -eq 0 ]] || [[ ! -r /etc/debian_version ]] || ! command -v apt-get >/dev/null 2>&1; then
    printf 'Run this installer as a regular user on Debian Linux.\n' >&2
    exit 1
fi

if ! validate_scripts; then
    exit 1
fi

sudo apt-get update
sudo apt-get install -y git stow ca-certificates

for component in "${components[@]}"; do
    run_script "$component"
done

for component in "${final_steps[@]}"; do
    run_script "$component"
done

printf '\nInstallation completed successfully.\n'
