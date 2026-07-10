#!/usr/bin/env bash
set -euo pipefail

if (( EUID != 0 )); then
  echo "Ejecutar con sudo: sudo $0" >&2
  exit 2
fi

for command in ip sshd systemctl ufw; do
  command -v "$command" >/dev/null 2>&1 || {
    echo "Falta el comando requerido: $command" >&2
    exit 1
  }
done

interface="${1:-}"
if [[ -z "$interface" ]]; then
  interface="$(ip -4 route show default | awk 'NR == 1 {print $5}')"
fi

[[ -n "$interface" ]] || {
  echo "No se pudo detectar la interfaz de la ruta predeterminada." >&2
  exit 1
}

subnet="$(ip -4 route show dev "$interface" scope link | awk '$1 ~ /^[0-9]+\./ && $1 ~ /\// {print $1; exit}')"
[[ -n "$subnet" ]] || {
  echo "No se pudo detectar la subred IPv4 conectada a $interface." >&2
  exit 1
}

drop_in="/etc/ssh/sshd_config.d/20-local-security.conf"
if [[ -e "$drop_in" ]]; then
  cp -a "$drop_in" "${drop_in}.bak"
fi

cat >"$drop_in" <<'EOF'
# La contraseña se mantiene hasta instalar y probar una clave autorizada.
PermitRootLogin no
MaxAuthTries 3
EOF

sshd -t
systemctl restart sshd.service

ufw default deny incoming
ufw default allow outgoing
# Retirar la regla genérica que crea `ufw allow ssh` o `ufw allow 22/tcp`.
# UFW elimina en la misma operación sus variantes IPv4 e IPv6.
ufw --force delete allow 22/tcp >/dev/null 2>&1 || true
ufw allow from "$subnet" to any port 22 proto tcp comment 'SSH from local LAN'
ufw --force enable
systemctl enable --now ufw.service

systemctl is-active --quiet sshd.service
systemctl is-enabled --quiet ufw.service
systemctl is-active --quiet ufw.service
firewall_status="$(ufw status verbose)"
printf '%s\n' "$firewall_status"

if grep -Eq '^22/tcp([[:space:]]| \(v6\)).*ALLOW IN.*Anywhere' <<<"$firewall_status"; then
  echo "Quedó una regla SSH abierta a cualquier origen; revisar UFW." >&2
  exit 1
fi

echo "SSH limitado a $subnet por $interface; root deshabilitado."
