#!/usr/bin/env bash
set -euo pipefail

install_brave=1
install_sublime=1
while (($#)); do
    case "$1" in
        --no-brave) install_brave=0 ;;
        --no-sublime) install_sublime=0 ;;
        *) printf 'Unknown repository option: %s\n' "$1" >&2; exit 2 ;;
    esac
    shift
done

repo_exists() {
    local repo_id="$1"
    grep -Rqs "^\\[$repo_id\\]$" /etc/yum.repos.d
}

# Brave Browser repository
if ((install_brave)) && ! repo_exists brave-browser; then
    sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
fi

# Sublime's RPM repository currently documents x86_64.
if ((install_sublime)) && [[ "$(uname -m)" == x86_64 ]] && ! repo_exists sublime-text; then
    sudo rpm --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    sudo dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
fi
