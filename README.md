# dotfiles
my personal dotfiles

## Clone

```bash
git clone git@github.com:catnstein/dotfiles.git ~/.dotfiles
```

## Symlinks

- zsh
```bash
ln -s ~/.dotfiles/zshrc ~/.zshrc
```

### .config

```bash
mkdir ~/.config
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
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
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

