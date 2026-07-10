#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$project_dir/dotfiles"
dry_run=false

if [[ "${1:-}" == "--dry-run" ]]; then
  dry_run=true
elif [[ $# -gt 0 ]]; then
  echo "Uso: $0 [--dry-run]" >&2
  exit 2
fi

[[ -d "$source_dir" ]] || {
  echo "No existe $source_dir" >&2
  exit 1
}

if [[ "$dry_run" == true ]]; then
  echo "Archivos que se desplegarían:"
  find "$source_dir" -type f -printf '%P\n' | sort
  exit 0
fi

backup="$("$project_dir/scripts/backup-dotfiles.sh" | sed -n 's/^Backup creado en: //p')"
[[ -n "$backup" && -d "$backup" ]] || {
  echo "No pude verificar el backup; despliegue cancelado." >&2
  exit 1
}

cp -a "$source_dir/." "$HOME/"

if [[ ! -e "$HOME/.config/hypr/personal.conf" ]]; then
  cp "$HOME/.config/hypr/personal.conf.example" "$HOME/.config/hypr/personal.conf"
fi

if [[ -d "$source_dir/.local/bin" ]]; then
  while IFS= read -r -d '' source_script; do
    chmod u+x "$HOME/.local/bin/${source_script##*/}"
  done < <(find "$source_dir/.local/bin" -maxdepth 1 -type f -print0)
fi

if command -v hyprctl >/dev/null 2>&1; then
  hyprctl reload >/dev/null || true
fi
if command -v systemctl >/dev/null 2>&1; then
  systemctl --user restart waybar.service mako.service || true
fi

echo "Dotfiles desplegados. Backup: $backup"
