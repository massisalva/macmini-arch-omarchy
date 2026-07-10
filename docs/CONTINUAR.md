# Punto de reanudación

Última actualización: 10 de julio de 2026, después de completar la adaptación
visual y la migración Wi-Fi.

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

## Acción exacta después del próximo reinicio

Abrir una terminal dentro de Hyprland y ejecutar:

```bash
cd ~/Proyectos/macmini-arch-omarchy
./scripts/audit.sh
```

Enviar al asistente la nueva ruta `reports/local/<fecha-hora>`.

En esa captura hay que comprobar:

1. Que no aparezcan errores nuevos de RTKit/PipeWire.
2. Que iwd reconecte automáticamente y que Impala abra desde Waybar.
3. Que systemd siga mostrando cero unidades fallidas.
4. Que red, audio y Hyprland sigan operativos.

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

1. Configurar la identidad Git local y crear el primer commit.
2. Reiniciar para validar reconexión automática de iwd.
3. Revisar secretos nuevamente antes de crear un remoto.
4. Añadir licencia, capturas y changelog.

## Estado de Git

El repositorio está listo para el primer commit, pero no tiene identidad Git
local ni remoto de GitHub. `reports/local/` y `backups/` están ignorados porque
pueden contener hostname, seriales, redes, credenciales y otros datos privados.
