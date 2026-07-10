# Punto de reanudación

Última actualización: 10 de julio de 2026, después de validar la migración
Wi-Fi tras un reinicio.

## Dónde estamos

La fase 1, auditoría de salud y línea base, está terminada. El arranque
posterior confirmó systemd limpio y red, audio, Bluetooth y Hyprland
operativos. La fase 2 de adaptación visual está en curso y su inventario se
encuentra en `docs/inventory-visual.md`.

La gestión Wi-Fi fue migrada de NetworkManager/wpa_supplicant a iwd para usar
Impala, siguiendo el mismo enfoque de Omarchy. El rollback está documentado en
`docs/wifi-impala.md`.

No hay que repetir la instalación ni aplicar reparaciones generales.

## Trabajo realizado

1. Se creó el proyecto en:
   `~/Proyectos/macmini-arch-omarchy`.
2. Se inicializó un repositorio Git local en la rama `main`.
3. Se creó `scripts/audit.sh`, que recolecta información sin modificar el
   sistema y guarda resultados privados en `reports/local/`.
4. Se realizaron dos auditorías desde la sesión real de Hyprland.
5. Se creó `scripts/audit-smart.sh` para leer SMART con privilegios.
6. Se instalaron estos paquetes:
   - `smartmontools 7.5-1`
   - `rtkit 0.14-1`
   - `wireless-regdb 2026.05.30-1`
7. Se documentaron resultados, riesgos y decisiones en
   `docs/audit-initial.md`.

## Estado confirmado

- Arch Linux con `linux-lts 6.18.38-1`.
- Mac mini 2014 (`Macmini7,1`).
- Intel Core i5-4278U, 2 núcleos/4 hilos, 8 GiB de RAM.
- Intel HD Graphics 5100 operativa mediante `i915`.
- Monitor Samsung 1920×1080 a 60 Hz.
- UEFI y Limine funcionando; entrada activa `Arch Linux LTS`.
- Cero unidades fallidas de systemd, de sistema y de usuario.
- `/usr`, `/usr/bin` y `/usr/lib` pertenecen correctamente a `root:root`.
- PipeWire, WirePlumber, Bluetooth, Wi-Fi y audio operativos.
- DKMS de `broadcom-wl` compilado para el kernel LTS.
- Temperaturas normales: CPU aproximadamente 37–46 °C en las mediciones.
- Sin paquetes huérfanos ni paquetes extranjeros/AUR detectados.
- Sin evidencia de corrupción en los componentes principales.

## SSD confirmado

Kingston A400 de 480 GB:

- SMART general: `PASSED`.
- Vida útil restante: 99 %.
- Errores no corregibles: 0.
- Eventos reasignados: 0.
- Errores SATA CRC: 0.
- Temperatura: 22 °C; máximo histórico 45 °C.
- Escrituras acumuladas: aproximadamente 2 TB.
- Dos autotests cortos completados sin errores.
- 72 apagados inseguros registrados: evitar cortar la alimentación.

Informe SMART original, excluido de Git por privacidad:
`reports/local/20260710-083625/smart-full.txt`.

## Riesgo aceptado por ahora

La tarjeta Broadcom BCM4360 utiliza `broadcom-wl`, un controlador propietario
sin mantenimiento upstream que genera advertencias con kernels modernos. La
red funciona y no se cambiará el controlador a ciegas. Si aparecen cortes, se
evaluará Ethernet o un adaptador Wi-Fi con soporte upstream.

## Validación posterior al reinicio

Completada el 2026-07-10 con el informe local
`reports/local/20260710-092626`:

1. iwd reconectó automáticamente mediante la interfaz `wlan0`.
2. iwd y systemd-resolved quedaron activos y habilitados.
3. NetworkManager permaneció deshabilitado.
4. La ruta predeterminada y la resolución DNS quedaron operativas.
5. Systemd mostró cero unidades fallidas de sistema y de usuario.
6. Impala continuó instalado y disponible.
7. No aparecieron errores nuevos en el journal.

Los mensajes antiguos ya documentados sobre Logitech HID++, DMI de Apple,
Broadcom `wl`, nombres D-Bus duplicados y mitigaciones SMT no deben tratarse
como descubrimientos nuevos.

## Trabajo visual completado

1. Dotfiles visuales revisados e incorporados al repositorio.
2. Fuzzel, Waybar, Foot, Mako, GTK, Hyprlock y Hyprland unificados.
3. Walker, Elephant y Swaylock retirados.
4. Tooltips de Waybar corregidos.
5. Backup, instalación y restauración reproducibles creados.
6. Instalador probado en un HOME temporal.
7. Consumo medido: 2,3 GiB usados y 5,3 GiB disponibles.

## Siguiente fase

1. Revisar secretos nuevamente antes de crear un remoto.
2. Añadir licencia, capturas y changelog.
3. Crear el remoto y publicar el repositorio cuando esté listo.

## Estado de Git

El repositorio tiene historial local en la rama `main`, pero todavía no tiene
remoto de GitHub. `reports/local/` y `backups/` están ignorados porque pueden
contener hostname, seriales, redes, credenciales y otros datos privados.
