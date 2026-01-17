# dotfiles
my personal dotfiles

## Clone

```bash
git clone git@github.com:catnstein/dotfiles.git ~/.dotfiles
```

## Symlinks

- tmuxinator
```bash
ln -sf /Users/mirceabadragan/.dotfiles/config/tmuxinator ~/.config/tmuxinator
```

- zsh
```bash
ln -s ~/.dotfiles/zshrc ~/.zshrc
```

### .config

```bash
mkdir ~/.config
```

- opencode
```bash
ln ~/.dotfiles/config/opencode/opencode.json ~/.config/opencode/opencode.json
```

- alacritty
```bash
ln -s ~/.dotfiles/config/alacritty ~/.config
```

- aerospace
```bash
ln -s ~/.dotfiles/config/aerospace/ ~/.config
```

- tmux
```bash
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
```

Running on GPU

- edit Info.plist

``` bash
# Alacritty.app/Contents/Info.plist
# change automatic graphic switch to false
<key>NSSupportsAutomaticGraphicsSwitching</key>
<false/>
```

- nvim
```bash
ln -s ~/.dotfiles/config/nvim ~/.config
```

## Local LLM

1. install ollama

2. use model

```bash
ollama run deepseek-r1
```

3. TODO: use a rag service

