# Rushy’s dotfiles

## Installation

You can clone the repository wherever you want. (I like to keep it in `~/Projects/config/dotfiles`). Then run `bootstrap/init.sh`, which sets up configuration and Doom.

```bash
git clone https://github.com/panchr/dotfiles.git && cd dotfiles && bootstrap/init.sh
```

### Install Homebrew formula

When setting up a new Mac, you may want to install some common [Homebrew](https://brew.sh/) formulae. This will install Homebrew and some standard packages:

```bash
./bootstrap/install-packages.sh
```

## Original

This is forked from the original https://github.com/mathiasbynens/dotfiles.

## Todos
- [x] Switch prompt with [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [x] Automatically install the iTerm2 profile and [manage all other settings] (https://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/)
- [x] Use a Brewfile for managing MacOS packages
- [x] Install iTerm2 shell integration automatically
- [ ] Install MacOS settings in init.sh
- [ ] Install emacs server daemon as a systemd service
- [x] Fix emacs word wrapping
- [ ] Fix emacs inserting random characters into the buffer before it is ready
- [ ] Fix [powerlevel10k resizing issue](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#mitigation)
- [x] Use fzf for shell history
- [x] Use fzf for cmd completions
