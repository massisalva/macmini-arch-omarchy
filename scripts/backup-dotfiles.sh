#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="${1:-$project_dir/backups/$stamp}"

files=(
  .config/hypr
  .config/waybar
  .config/fuzzel
  .config/foot
  .config/mako
  .config/gtk-3.0/settings.ini
  .local/bin/hypr-autostart
  .local/bin/lock-screen
)

mkdir -p "$backup_dir"
for relative in "${files[@]}"; do
  source_path="$HOME/$relative"
  [[ -e "$source_path" ]] || continue
  mkdir -p "$backup_dir/$(dirname -- "$relative")"
  cp -a -- "$source_path" "$backup_dir/$relative"
done

printf 'Backup creado en: %s\n' "$backup_dir"
