#!/usr/bin/env bash
set -u

failures=0
warnings=0

pass() {
  printf '[OK]    %s\n' "$1"
}

warn() {
  printf '[AVISO] %s\n' "$1"
  ((warnings += 1))
}

fail() {
  printf '[FALLO] %s\n' "$1"
  ((failures += 1))
}

check_active() {
  local scope="$1"
  local unit="$2"
  local label="$3"
  local -a command=(systemctl is-active --quiet "$unit")

  if [[ "$scope" == user ]]; then
    command=(systemctl --user is-active --quiet "$unit")
  fi

  if "${command[@]}"; then
    pass "$label activo"
  else
    fail "$label no está activo"
  fi
}

check_failed_units() {
  local scope="$1"
  local label="$2"
  local -a command=(systemctl --failed --no-legend --plain)
  local output

  if [[ "$scope" == user ]]; then
    command=(systemctl --user --failed --no-legend --plain)
  fi

  if ! output="$("${command[@]}" 2>&1)"; then
    fail "No se pudo consultar systemd ($label): $output"
  elif [[ -n "$output" ]]; then
    fail "Hay unidades fallidas ($label): ${output//$'\n'/; }"
  else
    pass "Cero unidades fallidas ($label)"
  fi
}

printf 'Salud rápida del Mac mini — %s\n\n' "$(date '+%F %T %Z')"

check_failed_units system sistema
check_failed_units user usuario

check_active system iwd.service iwd
check_active system systemd-resolved.service systemd-resolved
check_active system ufw.service UFW
check_active system sshd.service SSH

check_active user xdg-desktop-portal.service 'Portal principal'
check_active user xdg-desktop-portal-hyprland.service 'Portal Hyprland'
check_active user xdg-desktop-portal-gtk.service 'Portal GTK'

if ip route show default | grep -q '^default '; then
  pass 'Ruta de red predeterminada disponible'
else
  fail 'No hay ruta de red predeterminada'
fi

if resolvectl query archlinux.org >/dev/null 2>&1; then
  pass 'Resolución DNS operativa'
else
  fail 'La resolución DNS no responde'
fi

missing_packages=()
for package in \
  broadcom-wl-dkms gvfs linux-lts thunar wireless-regdb xdg-user-dirs; do
  if ! pacman -Q "$package" >/dev/null 2>&1; then
    missing_packages+=("$package")
  fi
done

if ((${#missing_packages[@]} == 0)); then
  pass 'Paquetes esenciales instalados'
else
  fail "Faltan paquetes esenciales: ${missing_packages[*]}"
fi

orphans="$(pacman -Qdtq 2>/dev/null || true)"
if [[ -z "$orphans" ]]; then
  pass 'Cero paquetes huérfanos'
else
  warn "Paquetes huérfanos: ${orphans//$'\n'/ }"
fi

if dkms status | grep -Fq 'broadcom-wl/'; then
  pass 'Broadcom WL aparece en DKMS'
else
  fail 'Broadcom WL no aparece en DKMS'
fi

root_usage="$(df --output=pcent / | tail -n 1 | tr -dc '0-9')"
if [[ -z "$root_usage" ]]; then
  warn 'No se pudo calcular el uso de la raíz'
elif ((root_usage >= 90)); then
  fail "La raíz está al ${root_usage}%"
elif ((root_usage >= 80)); then
  warn "La raíz está al ${root_usage}%"
else
  pass "Espacio de la raíz saludable (${root_usage}% usado)"
fi

if gio info trash:/// >/dev/null 2>&1; then
  pass 'Papelera GVfs accesible'
else
  fail 'No se pudo acceder a la papelera GVfs'
fi

smart_output=''
if smart_output="$(smartctl -H /dev/sda 2>&1)"; then
  if grep -q 'PASSED' <<<"$smart_output"; then
    pass 'SMART del SSD: PASSED'
  else
    fail 'SMART respondió sin confirmar PASSED'
  fi
elif smart_output="$(sudo -n smartctl -H /dev/sda 2>&1)"; then
  if grep -q 'PASSED' <<<"$smart_output"; then
    pass 'SMART del SSD: PASSED'
  else
    fail 'SMART respondió sin confirmar PASSED'
  fi
else
  warn 'SMART omitido; ejecutar scripts/audit-smart.sh para comprobarlo'
fi

printf '\nResultado: %d fallo(s), %d aviso(s).\n' "$failures" "$warnings"
if ((failures > 0)); then
  exit 1
fi
