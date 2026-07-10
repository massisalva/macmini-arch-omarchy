#!/usr/bin/env bash
set -u

project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"
out_dir="$project_dir/reports/local/$stamp"
mkdir -p "$out_dir"

run() {
  local name="$1"
  shift
  printf 'Auditando %-24s\n' "$name"
  { printf '$'; printf ' %q' "$@"; printf '\n\n'; "$@"; } \
    >"$out_dir/$name.txt" 2>&1 || true
}

run system uname -a
run os-release cat /etc/os-release
run cpu lscpu
run memory free -h
run pci lspci -nnk
run usb lsusb
run disks lsblk -o NAME,SIZE,FSTYPE,FSVER,MOUNTPOINTS,MODEL,SERIAL
run mounts findmnt
run filesystems df -hT
run kernel-cmdline cat /proc/cmdline
run kernel-modules lsmod
run failed-system systemctl --failed --no-pager
run failed-user systemctl --user --failed --no-pager
run journal-errors journalctl -b -p err --no-pager
run journal-warnings journalctl -b -p warning --no-pager
run boot bootctl status
run hypr-version hyprctl version
run hypr-system hyprctl systeminfo
run hypr-monitors hyprctl monitors all
run network nmcli general status
run network-devices nmcli device status
run audio wpctl status
run bluetooth bluetoothctl show
run sensors sensors
run dkms dkms status
run cpu-vulnerabilities bash -c 'for f in /sys/devices/system/cpu/vulnerabilities/*; do printf "%s: " "${f##*/}"; cat "$f"; done'
run recommended-packages bash -c 'for p in smartmontools rtkit wireless-regdb; do pacman -Q "$p" 2>&1 || true; done'
run firewall-unprivileged ufw status
run package-list pacman -Q
run explicit-packages pacman -Qqe
run foreign-packages pacman -Qqm
run orphan-packages pacman -Qdt
run package-integrity pacman -Qkk
run usr-ownership stat -c '%U:%G %u:%g %a %n' /usr /usr/bin /usr/lib
run efi-presence bash -c 'if [[ -d /sys/firmware/efi ]]; then echo UEFI; else echo "No EFI visible"; fi'

if command -v smartctl >/dev/null 2>&1; then
  run smart-basic smartctl -H -A /dev/sda
else
  printf 'smartctl no está instalado; instalar smartmontools para SMART.\n' \
    >"$out_dir/smart-basic.txt"
fi

printf '\nInforme local creado en: %s\n' "$out_dir"
printf 'Revísalo antes de compartirlo: puede contener datos del equipo.\n'
