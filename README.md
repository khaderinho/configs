# Configs

Personal configuration files and installation scripts for a Fedora Server setup with an i3 based X11 desktop.

## Fedora Server installation

Start with a fresh Fedora Server installation and a user account that can run commands with `sudo`. Clone this repository, enter it, and run:

```console
git clone https://github.com/khedrinhoo/configs.git
cd configs
bash fedora_build/install.sh
```

Run the installer as your regular user, not as root. It requires an internet connection and a sudo-enabled account, and installs the setup tools through DNF. `sudo` is used for system package and service operations. The default install includes all components; optional groups can be omitted, for example:

```console
bash fedora_build/install.sh --without virtualization,bluetooth,web
```

Supported optional components are `bluetooth`, `dev`, `media`, `virtualization`, and `web`. Audio, fonts, networking, terminal tools, and the i3 desktop are part of the core setup. Repository setup is skipped when its corresponding optional component is omitted. Install scripts run in a fixed order; package failures are reported, and configuration linking runs only if package setup succeeds.

On the text-only Fedora Server install, log in on a local TTY and run `startx` to start i3. The configuration starts a PolicyKit authentication agent for GUI tools such as virt-manager.

If an installation script fails, the installer reports the failed script names and exits without linking the configurations. Resolve the reported issue and run the installer again; package operations are repeatable. Existing `.bashrc` files are backed up before the repository version is linked.

## Configuration links

`fedora_build/stow.sh` links `bash`, `vim`, and `xorg` files directly into `$HOME`. The remaining configuration directories are linked into their matching subdirectories under `$HOME/.config`, such as `i3/config` to `$HOME/.config/i3/config`.

To create or refresh the links separately, run:

```console
bash fedora_build/stow.sh
```

GNU Stow reports other conflicting files and leaves them in place. Move or back them up, then run the command again.
