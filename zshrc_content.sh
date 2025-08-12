fv() {
  local file
  file=$(fd --type f --hidden --exclude .git |
    fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' \
      --preview-window=right:60% \
      --bind 'ctrl-/:toggle-preview') &&
    [[ -n "$file" ]] && {
    if tmux list-sessions &>/dev/null; then
      tmux new-window "nvim \"$file\""
    else
      nvim "$file"
    fi
  }
}
