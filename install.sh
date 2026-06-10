#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)"

ensure_dir() {
  mkdir -p "$1"
}

confirm_overwrite() {
  local target="$1"
  local answer

  printf 'WARN: %s already exists and is not the expected symlink. Overwrite? [y/N] ' "$target"
  if ! read -r answer; then
    answer=
  fi

  case "$answer" in
    y | Y | yes | YES) return 0 ;;
    *) return 1 ;;
  esac
}

link_item() {
  local source="$1"
  local target="$2"

  if [[ ! -e "$source" ]]; then
    printf 'WARN: source missing, skipping: %s\n' "$source"
    return
  fi

  if [[ -L "$target" && "$(/usr/bin/readlink "$target")" == "$source" ]]; then
    printf 'OK: %s -> %s\n' "$target" "$source"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    if confirm_overwrite "$target"; then
      rm -rf "$target"
    else
      printf 'SKIP: %s\n' "$target"
      return
    fi
  fi

  ln -s "$source" "$target"
  printf 'LINK: %s -> %s\n' "$target" "$source"
}

ensure_dir "$HOME/.config"
ensure_dir "$HOME/.config/opencode"
ensure_dir "$HOME/.agents"

link_item "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
link_item "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
link_item "$DOTFILES_DIR/config/tmuxinator" "$HOME/.config/tmuxinator"
link_item "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
link_item "$DOTFILES_DIR/config/alacritty" "$HOME/.config/alacritty"
link_item "$DOTFILES_DIR/config/aerospace" "$HOME/.config/aerospace"
link_item "$DOTFILES_DIR/config/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
link_item "$DOTFILES_DIR/config/opencode/skills" "$HOME/.config/opencode/skills"
link_item "$HOME/.config/opencode/skills" "$HOME/.agents/skills"

printf 'Done.\n'
