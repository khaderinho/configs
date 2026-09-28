#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Directories
mkdir -p "$HOME/.src" "$HOME/.bin" "$HOME/.config" 

failed_scripts=()
repositories_script="$script_dir/repositories.sh"
if [[ -f "$repositories_script" ]]; then
    if ! bash "$repositories_script"; then
        failed_scripts+=("repositories.sh")
    fi
fi

while IFS= read -r -d '' script; do
    [[ "$script" == "$script_dir/install.sh" ]] && continue
    [[ "$script" == "$repositories_script" ]] && continue
    [[ "$script" == "$script_dir/stow.sh" ]] && continue
    if ! bash "$script"; then
        failed_scripts+=("$(basename -- "$script")")
    fi
done < <(find "$script_dir" -maxdepth 1 -type f -name '*.sh' -print0 | sort -z)

if ((${#failed_scripts[@]})); then
    printf '\nInstallation completed with failures:\n' >&2
    printf '  - %s\n' "${failed_scripts[@]}" >&2
    exit 1
fi

stow_script="$script_dir/stow.sh"
if [[ -f "$stow_script" ]]; then
    bash "$stow_script"
fi

printf '\nInstallation completed successfully.\n'
