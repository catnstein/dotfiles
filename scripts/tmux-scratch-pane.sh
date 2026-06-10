#!/usr/bin/env bash
set -euo pipefail

session="${TMUX_SCRATCH_SESSION:-scratch}"
scratch_window="${TMUX_SCRATCH_WINDOW:-scratch}"
parking_window="${TMUX_SCRATCH_PARKING_WINDOW:-__scratch_parking}"
scratch_option="@scratch_pane_id"

current_pane="$(tmux display-message -p '#{pane_id}')"
current_window="$(tmux display-message -p '#{window_id}')"
current_path="$(tmux display-message -p '#{pane_current_path}')"
scratch_pane="$(tmux show-option -gqv "$scratch_option")"

pane_exists() {
  [[ -n "$1" ]] && tmux display-message -p -t "$1" '#{pane_id}' >/dev/null 2>&1
}

pane_window() {
  tmux display-message -p -t "$1" '#{window_id}' 2>/dev/null || true
}

pane_session() {
  tmux display-message -p -t "$1" '#{session_name}' 2>/dev/null || true
}

window_exists() {
  local window_name

  while IFS= read -r window_name; do
    [[ "$window_name" == "$1" ]] && return 0
  done < <(tmux list-windows -t "$session" -F '#{window_name}' 2>/dev/null)

  return 1
}

ensure_session() {
  if tmux has-session -t "$session" 2>/dev/null; then
    return
  fi

  tmux new-session -d -s "$session" -n "$scratch_window" -c "$current_path"
  tmux set-option -t "$session" status off
  scratch_pane="$(tmux display-message -p -t "$session:$scratch_window.1" '#{pane_id}')"
  tmux set-option -gq "$scratch_option" "$scratch_pane"
}

ensure_parking_window() {
  ensure_session

  if ! window_exists "$parking_window"; then
    tmux new-window -d -t "$session:" -n "$parking_window" -c "$current_path"
  fi
}

find_existing_scratch_pane() {
  local window_name pane_id

  while IFS=$'\t' read -r window_name pane_id; do
    if [[ "$window_name" != "$parking_window" ]]; then
      printf '%s\n' "$pane_id"
      return 0
    fi
  done < <(tmux list-panes -a -t "$session" -F '#{window_name}	#{pane_id}' 2>/dev/null)

  return 1
}

ensure_scratch_pane() {
  ensure_session

  if pane_exists "$scratch_pane"; then
    return
  fi

  scratch_pane="$(find_existing_scratch_pane || true)"
  if pane_exists "$scratch_pane"; then
    tmux set-option -gq "$scratch_option" "$scratch_pane"
    return
  fi

  tmux new-window -d -t "$session:" -n "$scratch_window" -c "$current_path"
  scratch_pane="$(tmux display-message -p -t "$session:$scratch_window.1" '#{pane_id}')"
  tmux set-option -gq "$scratch_option" "$scratch_pane"
}

hide_scratch_pane() {
  if [[ "$(pane_session "$scratch_pane")" == "$session" ]]; then
    return
  fi

  ensure_parking_window
  tmux break-pane -d -n "$scratch_window" -s "$scratch_pane" -t "$session:"
}

ensure_scratch_pane

if [[ "$current_pane" == "$scratch_pane" ]]; then
  hide_scratch_pane
  exit 0
fi

if [[ "$(pane_window "$scratch_pane")" == "$current_window" ]]; then
  tmux select-pane -t "$scratch_pane"
  exit 0
fi

ensure_parking_window
tmux move-pane -f -h -l 50% -s "$scratch_pane" -t "$current_pane"
tmux select-pane -t "$scratch_pane"
