#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"
out_dir="$project_dir/reports/local/$stamp"
out_file="$out_dir/smart-full.txt"

command -v smartctl >/dev/null 2>&1 || {
  echo "Falta smartmontools: sudo pacman -S smartmontools" >&2
  exit 1
}

mkdir -p "$out_dir"
echo "Se solicitará la contraseña administrativa para leer SMART de /dev/sda."
sudo smartctl -x /dev/sda >"$out_file"
echo "Informe SMART creado en: $out_file"
