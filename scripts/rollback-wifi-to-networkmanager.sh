#!/usr/bin/env bash
set -euo pipefail

if (( EUID != 0 )); then
  echo "Ejecutar con sudo: sudo $0 RUTA_DEL_BACKUP" >&2
  exit 2
fi

if [[ $# -ne 1 || ! -d "$1" ]]; then
  echo "Uso: sudo $0 RUTA_DEL_BACKUP" >&2
  exit 2
fi

backup_dir="$(cd -- "$1" && pwd)"

systemctl disable --now iwd.service 2>/dev/null || true

rm -rf /etc/iwd
if [[ -d "$backup_dir/etc/iwd" ]]; then
  mkdir -p /etc
  cp -a "$backup_dir/etc/iwd" /etc/iwd
fi

rm -rf /var/lib/iwd
if [[ -d "$backup_dir/var/lib/iwd" ]]; then
  mkdir -p /var/lib
  cp -a "$backup_dir/var/lib/iwd" /var/lib/iwd
fi

rm -rf /etc/NetworkManager
if [[ -d "$backup_dir/etc/NetworkManager" ]]; then
  mkdir -p /etc
  cp -a "$backup_dir/etc/NetworkManager" /etc/NetworkManager
fi

if [[ -e "$backup_dir/resolv.conf" || -L "$backup_dir/resolv.conf" ]]; then
  rm -f /etc/resolv.conf
  cp -a "$backup_dir/resolv.conf" /etc/resolv.conf
fi

if [[ "$(cat "$backup_dir/resolved-enabled" 2>/dev/null || true)" != "enabled" ]]; then
  systemctl disable systemd-resolved.service 2>/dev/null || true
fi
if [[ "$(cat "$backup_dir/resolved-active" 2>/dev/null || true)" != "active" ]]; then
  systemctl stop systemd-resolved.service 2>/dev/null || true
fi

systemctl enable --now NetworkManager.service
sleep 3

echo "NetworkManager restaurado desde: $backup_dir"
nmcli general status || true
