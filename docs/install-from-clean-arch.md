# Instalación desde Arch Linux limpio

Esta guía instala el perfil portable del proyecto sobre una instalación de
Arch funcional. No reemplaza la guía oficial de instalación de Arch, no
particiona discos y no modifica el cargador de arranque ni el kernel.

## Alcance y supuestos

- El sistema inicia y tiene red operativa.
- Existe un usuario normal con acceso a `sudo`.
- La GPU y el monitor ya funcionan en el sistema base.
- Los comandos se ejecutan desde una TTY o un escritorio existente.
- La migración a iwd es opcional y se realiza al final.

En un Mac mini 2014 con Broadcom BCM4360 se utiliza `broadcom-wl-dkms` y la
lista incluye `linux-lts-headers`. Si el sistema usa otro kernel, hay que
instalar sus headers correspondientes y elegir el controlador apropiado antes
de iniciar Hyprland.

## 1. Actualizar y obtener el proyecto

```bash
sudo pacman -Syu --needed git
git clone https://github.com/massisalva/macmini-arch-omarchy.git
cd macmini-arch-omarchy
```

## 2. Revisar e instalar paquetes

`packages/official.txt` es la lista declarativa. Incluye los dos backends de
red porque la migración segura parte de una conexión activa administrada por
NetworkManager; no deben quedar ambos servicios habilitados al terminar.

```bash
mapfile -t packages < <(sed -E '/^[[:space:]]*(#|$)/d' packages/official.txt)
sudo pacman -S --needed "${packages[@]}"
```

No se requieren paquetes AUR para el perfil actual. Antes de continuar:

```bash
./scripts/check.sh
./scripts/install-dotfiles.sh --dry-run
```

## 3. Desplegar los dotfiles

La instalación real crea primero un backup dentro de `backups/`, ruta ignorada
por Git. Revisar el listado del dry-run antes de aceptar el despliegue.

```bash
./scripts/install-dotfiles.sh
```

El instalador crea `~/.config/hypr/personal.conf` desde el ejemplo sólo cuando
no existe. Ese archivo permite ajustes del equipo que no deben publicarse.

El fondo usa el color Tokyo Night `#1a1b26` por defecto. Para usar una imagen
personal, copiarla sin versionarla:

```bash
cp /ruta/a/fondo.png ~/.config/hypr/wallpaper.png
```

También se puede definir otra ruta mediante la variable de entorno
`HYPR_WALLPAPER` antes de iniciar la sesión.

## 4. Habilitar servicios base

PipeWire y los portales se inician como servicios de usuario. Bluetooth sólo
debe habilitarse si se va a utilizar:

```bash
systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service
sudo systemctl enable --now bluetooth.service
```

Para una primera sesión puede iniciarse Hyprland desde una TTY con UWSM:

```bash
uwsm start hyprland.desktop
```

La configuración inicia Waybar, Mako, Cliphist, Hypridle, SwayOSD y el fondo
cuando sus binarios o unidades están disponibles.

## 5. Red: conservar NetworkManager o migrar a iwd

La sesión visual puede probarse inicialmente con NetworkManager. Impala requiere
iwd directo; no debe utilizarse mientras NetworkManager gestione la interfaz.

Para migrar, mantener primero una conexión Wi-Fi activa y ejecutar desde una
terminal local, no por SSH:

```bash
sudo ./scripts/migrate-wifi-to-iwd.sh
```

El script instala iwd e Impala antes de cortar la red, crea un backup privado,
fija `Country=AR` en `iwd`, valida ruta y DNS y revierte automáticamente si
falla. Conservar la ruta que imprime. El rollback manual es:

```bash
sudo ./scripts/rollback-wifi-to-networkmanager.sh backups/system-wifi/FECHA-HORA
```

Si el regulador queda en `US` después de asociarse, comprobar el país anunciado
por el punto de acceso:

```bash
sudo iw dev wlan0 scan | grep -A2 'Country:'
```

El cliente debe respetar el dominio anunciado por el punto de acceso. Si el
router permite configurar Argentina, hacerlo desde su panel. Algunas variantes
regionales, como Deco M4R UC 2.0, quedan fijadas en `US`: no instalar una unidad
que lo fuerce periódicamente ni mezclar firmware destinado a otros mercados.

## 6. Verificación

Reiniciar y comprobar desde una terminal dentro de Hyprland:

```bash
systemctl --failed --no-pager
systemctl --user --failed --no-pager
hyprctl monitors
wpctl status
./scripts/audit.sh
```

Si se migró la red:

```bash
systemctl is-active iwd systemd-resolved
iw dev
ip route
resolvectl status
iw reg get
```

El criterio de aceptación es cero unidades fallidas relevantes, audio y
portales activos, Waybar y Mako visibles, atajos funcionales, ruta y DNS
operativos y ausencia de errores nuevos repetitivos en el journal.

## Restauración de dotfiles

Para recuperar una copia creada antes del despliegue:

```bash
./scripts/restore-dotfiles.sh backups/FECHA-HORA
```

La restauración reemplaza únicamente las rutas presentes en ese backup. La red
tiene su propio procedimiento de rollback y no se restaura con este comando.

## Diagnóstico rápido

- Pantalla negra: cambiar a una TTY, revisar `journalctl --user -b` y quitar
  temporalmente personalizaciones de `personal.conf`.
- Sin barra o notificaciones: ejecutar `~/.local/bin/hypr-autostart` y revisar
  `systemctl --user status waybar.service mako.service`.
- Sin fondo: comprobar `swaybg`; si la imagen personal no existe se usa el
  color de fallback automáticamente.
- Sin audio: revisar `wpctl status` y los servicios PipeWire/WirePlumber.
- Sin red después de migrar: usar el rollback local documentado arriba.
