# Dotfiles

Personal dotfiles for macOS.

## Installation

```bash
git clone git@github.com:catnstein/dotfiles.git ~/.dotfiles
```

## Setup

Run the installer:

```bash
~/.dotfiles/install.sh
```

The installer creates the needed `~/.config` directories, links the dotfiles, skips
links that already point to the right place, and prompts before overwriting any
existing target.
