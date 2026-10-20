# Configs

Personal configuration files and installation scripts for a Debian setup with an bspwm based X11 desktop.

## Fedora installation

Start with a Fedora installation and a user account that can run commands with `sudo`. Clone this repository, enter it, and run:

```console
git clone https://github.com/khedrinho/configs.git
cd configs
bash fedora_build/install.sh
```

Run the installer as your regular user, not as root. It requires an internet connection and a sudo-enabled account. `sudo` is used for system package and service operations. Existing `.bashrc` files are backed up before the repository version is linked.

## Configuration links

`fedora_build/stow.sh` links `bash`, `vim`, and `xorg` files directly into `$HOME`. The remaining configuration directories are linked into their matching subdirectories under `$HOME/.config`, such as `i3/config` to `$HOME/.config/i3/config`.

To create or refresh the links separately, run:

```console
bash fedora_build/stow.sh
```

GNU Stow reports other conflicting files and leaves them in place. Move or back them up, then run the command again.
