# Rushy’s dotfiles

## Installation

You can clone the repository wherever you want. (I like to keep it in `~/Projects/config/dotfiles`). Then run `bootstrap/init.sh`, which sets up configuration and Doom.

```bash
git clone https://github.com/panchr/dotfiles.git && cd dotfiles && bootstrap/init.sh
```

### macOS preferences

To configure macOS system preferences (keyboard mappings, Finder, Dock, menu bar, power management, etc.), run:

```bash
sudo bootstrap/macos.sh
```

This should be run after `init.sh`. A logout/reboot is required for keyboard modifier changes to take effect.

### Install Homebrew formula

When setting up a new Mac, you may want to install some common [Homebrew](https://brew.sh/) formulae. This will install Homebrew and some standard packages:

```bash
./bootstrap/install-packages.sh
```

## Original

This is forked from the original https://github.com/mathiasbynens/dotfiles.

