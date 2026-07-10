#!/usr/bin/env bash
set -euo pipefail

if (( EUID != 0 )); then
  echo "Ejecutar con sudo: sudo $0" >&2
  exit 2
fi

project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="$project_dir/backups/system-wifi/$stamp"
rollback="$project_dir/scripts/rollback-wifi-to-networkmanager.sh"

command -v nmcli >/dev/null 2>&1 || {
  echo "NetworkManager no está disponible; no se modificó nada." >&2
  exit 1
}

interface="$(nmcli -t -f DEVICE,TYPE,STATE device | awk -F: '$2 == "wifi" && $3 ~ /connected|conectado/ {print $1; exit}')"
[[ -n "$interface" ]] || {
  echo "No hay una interfaz Wi-Fi conectada; no se modificó nada." >&2
  exit 1
}

connection="$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: -v dev="$interface" '$2 == dev {print $1; exit}')"
[[ -n "$connection" ]] || {
  echo "No pude identificar la conexión activa; no se modificó nada." >&2
  exit 1
}

ssid="$(nmcli -g 802-11-wireless.ssid connection show "$connection")"
psk="$(nmcli --show-secrets -g 802-11-wireless-security.psk connection show "$connection")"

[[ -n "$ssid" && -n "$psk" ]] || {
  echo "No pude leer SSID o contraseña de la conexión activa; no se modificó nada." >&2
  exit 1
}

[[ "$ssid" != */* ]] || {
  echo "El SSID contiene '/', caso no automatizable de forma segura." >&2
  exit 1
}

echo "Instalando Impala e iwd antes de modificar el backend..."
pacman -S --needed --noconfirm impala iwd

mkdir -p "$backup_dir/etc"
chmod 700 "$backup_dir" "$backup_dir/etc"
systemctl is-enabled systemd-resolved.service >"$backup_dir/resolved-enabled" 2>&1 || true
systemctl is-active systemd-resolved.service >"$backup_dir/resolved-active" 2>&1 || true
[[ -d /etc/NetworkManager ]] && cp -a /etc/NetworkManager "$backup_dir/etc/NetworkManager"
[[ -d /etc/iwd ]] && cp -a /etc/iwd "$backup_dir/etc/iwd"
[[ -d /var/lib/iwd ]] && {
  mkdir -p "$backup_dir/var/lib"
  cp -a /var/lib/iwd "$backup_dir/var/lib/iwd"
}
cp -a /etc/resolv.conf "$backup_dir/resolv.conf"
printf '%s\n' "$interface" >"$backup_dir/interface"
printf '%s\n' "$connection" >"$backup_dir/connection"

install -d -m 755 /etc/iwd
cat >/etc/iwd/main.conf <<'EOF'
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd
EOF

install -d -m 700 /var/lib/iwd
profile="/var/lib/iwd/$ssid.psk"
umask 077
{
  printf '[Security]\nPassphrase=%s\n\n' "$psk"
  printf '[Settings]\nAutoConnect=true\n'
} >"$profile"
chmod 600 "$profile"
unset psk

echo "Cambiando de NetworkManager a iwd..."
systemctl disable --now NetworkManager.service
systemctl enable --now systemd-resolved.service
ln -sfn /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
systemctl enable --now iwd.service

success=false
for _ in {1..20}; do
  if ip -4 route show default dev "$interface" | grep -q '^default' &&
     getent ahostsv4 archlinux.org >/dev/null 2>&1; then
    success=true
    break
  fi
  sleep 1
done

if [[ "$success" != true ]]; then
  echo "La validación de ruta/DNS falló; restaurando NetworkManager..." >&2
  "$rollback" "$backup_dir"
  exit 1
fi

echo "Migración completada correctamente."
echo "Backup y rollback: $backup_dir"
echo "Interfaz: $interface"
iwctl station "$interface" show || true
