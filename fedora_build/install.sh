#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${EUID}" -eq 0 ]]; then
    printf 'Run this installer as your regular user, not as root.\n' >&2
    exit 1
fi

if [[ ! -r /etc/fedora-release ]] || ! command -v dnf >/dev/null 2>&1; then
    printf 'This installer requires Fedora Linux with DNF.\n' >&2
    exit 1
fi

usage() {
    printf 'Usage: %s [--without component[,component...]]\n' "$0"
    printf 'Optional components: bluetooth dev media virtualization web\n'
}

declare -A skipped=()
while (($#)); do
    case "$1" in
        --without)
            (($# >= 2)) || { usage >&2; exit 2; }
            IFS=',' read -r -a components <<< "$2"
            shift 2
            for component in "${components[@]}"; do
                case "$component" in
                    bluetooth|dev|media|virtualization|web)
                        skipped["$component"]=1
                        ;;
                    *) printf 'Unknown component: %s\n' "$component" >&2; usage >&2; exit 2 ;;
                esac
            done
            ;;
        -h|--help) usage; exit 0 ;;
        *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
    esac
done

mkdir -p "$HOME/.src" "$HOME/.bin" "$HOME/.config" "$HOME/screenshots"

# Install tools needed by the bootstrap and Stow steps before using them.
sudo dnf install -y dnf5-plugins git stow

failed_scripts=()
repositories_script="$script_dir/repositories.sh"
repo_args=()
[[ -n "${skipped[web]:-}" ]] && repo_args+=(--no-brave)
[[ -n "${skipped[dev]:-}" ]] && repo_args+=(--no-sublime)
if ! bash "$repositories_script" "${repo_args[@]}"; then
    printf 'Repository setup failed; stopping before package installation.\n' >&2
    exit 1
fi

components=(audio bluetooth dev fonts media network terminal virtualization web window_manager)
for component in "${components[@]}"; do
    [[ -n "${skipped[$component]:-}" ]] && continue
    script_name="$component"
    [[ "$component" == virtualization ]] && script_name=virtual
    script="$script_dir/$script_name.sh"
    if [[ ! -f "$script" ]]; then
        printf 'Required install script is missing: %s\n' "$script" >&2
        failed_scripts+=("$script_name.sh (missing)")
        continue
    fi
    if ! bash "$script"; then
        failed_scripts+=("$script_name.sh")
    fi
done

service_args=()
[[ -n "${skipped[bluetooth]:-}" ]] && service_args+=(--no-bluetooth)
if ! bash "$script_dir/systemctl.sh" "${service_args[@]}"; then
    failed_scripts+=("systemctl.sh")
fi

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
