#!/usr/bin/env bash
# install.sh - installs all programs and places all dotfiles
# Run from a fresh Arch (Omarchy) system, e.g.:
#   chmod +x install.sh
#   ./install.sh
set -euo pipefail

DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.Config.backup.$(date +%Y%m%d-%H%M%S)"

info() { printf '\033[1;34m::\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m!!\033[0m %s\n' "$*" >&2; exit 1; }

install_official() {
  info "Installing official packages (full system upgrade first)"
  mapfile -t official < "$DOTDIR/packages-official.txt"
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm "${official[@]}"
}

install_aur() {
  if ! command -v yay >/dev/null 2>&1; then
    # yay is in the official package list; give it a moment or bail out clearly.
    die "yay not found. Install it first:  sudo pacman -S --needed yay"
  fi
  info "Installing AUR packages"
  mapfile -t aur < "$DOTDIR/packages-aur.txt"
  yay -S --needed --noconfirm "${aur[@]}"
}

deploy() {
  local src="$1" dest="$2" base
  base="$(basename "$src")"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    local stamp
    stamp="$(date +%Y%m%d-%H%M%S)-$$"
    warn "Moving existing '$dest' aside to $BACKUP_DIR/$base.$stamp"
    mv "$dest" "$BACKUP_DIR/$base.$stamp"
  fi
  cp -a "$src" "$dest"
}

place_top_level_dotfiles() {
  info "Placing top-level dotfiles"
  local f base
  for f in "$DOTDIR"/.[!.]*; do
    [ -e "$f" ] || continue
    base="$(basename "$f")"
    case "$base" in
      .git|.gitattributes|.github|.config) continue ;; # .config is handled in place_config
    esac
    deploy "$f" "$HOME/$base"
  done
}

place_config() {
  info "Placing ~/.config entries"
  mkdir -p "$HOME/.config"
  local f base
  for f in "$DOTDIR"/.config/*; do
    base="$(basename "$f")"
    deploy "$f" "$HOME/.config/$base"
  done
  # The omarchy icon font lives in .config on the user's setup; refresh font caches.
  if [ -f "$HOME/.config/omarchy.ttf" ]; then
    info "Refreshing font cache"
    fc-cache -f >/dev/null 2>&1 || true
  fi
}

place_system_config() {
  info "Placing Pacman mirrorlist (Omarchy-only)"
  if [ -f "$DOTDIR/etc/pacman.d/mirrorlist" ]; then
    sudo install -Dm 644 "$DOTDIR/etc/pacman.d/mirrorlist" /etc/pacman.d/mirrorlist
  fi
}

main() {
  place_system_config
  install_official
  install_aur
  place_top_level_dotfiles
  place_config
  # Reload user services in case systemd-unit symlinks were placed.
  systemctl --user daemon-reload >/dev/null 2>&1 || true

  ok "Done. All programs installed and dotfiles placed."
  if [ -d "$BACKUP_DIR" ]; then
    printf '\033[1;33m  Backups of replaced files were kept in: %s\033[0m\n' "$BACKUP_DIR"
  fi
  printf '\033[1;32m  Log out and back in for the new shell/session config to take effect.\033[0m\n'
}

main "$@"