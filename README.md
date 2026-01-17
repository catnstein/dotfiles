# Dotfiles

Personal dotfiles for macOS.

## Installation

```bash
git clone git@github.com:catnstein/dotfiles.git ~/.dotfiles
```

## Setup

### Prerequisites

```bash
mkdir -p ~/.config
```

### Symlinks

**zsh**
```bash
ln -s ~/.dotfiles/zshrc ~/.zshrc
```

**tmux**
```bash
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
```

**tmuxinator**
```bash
ln -sf ~/.dotfiles/config/tmuxinator ~/.config/tmuxinator
```

**nvim**
```bash
ln -s ~/.dotfiles/config/nvim ~/.config
```

**alacritty**
```bash
ln -s ~/.dotfiles/config/alacritty ~/.config
```

**aerospace**
```bash
ln -s ~/.dotfiles/config/aerospace ~/.config
```

**opencode**
```bash
ln ~/.dotfiles/config/opencode/opencode.json ~/.config/opencode/opencode.json
```

### Alacritty GPU Mode

To force Alacritty to use the dedicated GPU, edit `Alacritty.app/Contents/Info.plist`:

```xml
<key>NSSupportsAutomaticGraphicsSwitching</key>
<false/>
```
