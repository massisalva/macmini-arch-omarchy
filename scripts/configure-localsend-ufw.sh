#!/usr/bin/env bash
set -euo pipefail

if ((EUID != 0)); then
  echo "Ejecutar con sudo: sudo $0 [SUBRED/CIDR]" >&2
  exit 1
fi

subnet="${1:-}"
if [[ -z "$subnet" ]]; then
  subnet="$(ip -4 route show scope link | awk '$1 ~ /^[0-9.]+\/[0-9]+$/ && / src / {print $1; exit}')"
fi

if [[ ! "$subnet" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/([0-9]|[12][0-9]|3[0-2])$ ]]; then
  echo "No se pudo detectar una subred IPv4 válida; indicar SUBRED/CIDR." >&2
  exit 1
fi

add_rule() {
  local protocol=$1
  if ufw status | grep -E "53317/${protocol}.*ALLOW IN.*${subnet//./\\.}" >/dev/null; then
    printf 'Regla existente: %s/53317 desde %s\n' "$protocol" "$subnet"
  else
    ufw allow from "$subnet" to any port 53317 proto "$protocol" comment 'LocalSend LAN'
  fi
}

add_rule tcp
add_rule udp
ufw reload
ufw status numbered
