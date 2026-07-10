#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || ! -d "$1" ]]; then
  echo "Uso: $0 RUTA_DEL_BACKUP" >&2
  exit 2
fi

backup_dir="$(cd -- "$1" && pwd)"

while IFS= read -r -d '' source_path; do
  relative="${source_path#"$backup_dir/"}"
  target="$HOME/$relative"
  mkdir -p "$(dirname -- "$target")"
  rm -rf -- "$target"
  cp -a -- "$source_path" "$target"
done < <(find "$backup_dir" -mindepth 1 \( -type f -o -type l \) -print0)

if command -v hyprctl >/dev/null 2>&1; then
  hyprctl reload >/dev/null || true
fi
if command -v systemctl >/dev/null 2>&1; then
  systemctl --user restart waybar.service mako.service || true
fi
printf 'Backup restaurado desde: %s\n' "$backup_dir"
