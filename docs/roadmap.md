# Hoja de ruta

## Fase 1 — Salud y línea base

**Estado: completada el 2026-07-10.** El reinicio confirmó cero unidades
fallidas, PipeWire con RTKit operativo, red activa y sesión Hyprland estable.
`wireless-regdb` está instalado y la migración a iwd fija la preferencia local
`Country=AR`. El TP-Link Deco M4R UC 2.0 anuncia legítimamente `Country: US` y
el cliente adopta ese dominio al asociarse. Se acepta como limitación del punto
de acceso; no se fuerza otro dominio ni se mezcla firmware entre regiones.

- Ejecutar `scripts/audit.sh` desde Hyprland.
- Revisar SMART, temperaturas, systemd, DKMS, journal y paquetes alterados.
- Corregir únicamente fallos confirmados y documentar cada cambio.
- Guardar listas de paquetes explícitos oficiales y AUR.

Criterio de aceptación: cero unidades fallidas relevantes, SSD saludable,
propietarios del sistema correctos y sesión gráfica sin errores repetitivos.

## Fase 2 — Paridad visual con Omarchy

**Estado: en curso desde el 2026-07-10.** Inventario inicial documentado en
`docs/inventory-visual.md`.

- Inventariar la configuración actual y compararla con Omarchy upstream.
- Unificar paleta, tipografía, espaciado, bordes, barra, launcher, lockscreen,
  notificaciones, terminal, GTK, iconos, cursor y wallpapers.
- Adaptar animaciones y blur al Intel HD 5100.
- Medir RAM en reposo, fluidez y errores de render antes/después.

Criterio de aceptación: apariencia coherente y cercana a Omarchy, recarga de
Hyprland limpia y uso en reposo acorde con un equipo de 8 GiB.

## Fase 3 — Reproducibilidad

**Estado: completada localmente el 2026-07-10.** Los dotfiles, listas de
paquetes y scripts portables de backup, instalación y restauración están
versionados; el instalador fue validado en un HOME temporal.

- Incorporar dotfiles revisados y libres de datos privados.
- Crear scripts idempotentes de backup, instalación y restauración.
- Declarar paquetes oficiales/AUR y servicios habilitados.
- Documentar instalación desde Arch limpio y procedimiento de rollback.

Criterio de aceptación: poder reconstruir la experiencia desde un usuario
nuevo siguiendo solo el README.

## Fase 4 — GitHub

**Estado: completada el 2026-07-10.** El repositorio público, la revisión de
secretos, la licencia MIT, el changelog y la captura pública están disponibles
en GitHub.

- Revisar secretos e información personal en todo el historial.
- Crear el remoto después de la revisión final y publicar la rama `main`.
- Añadir licencia, capturas, changelog y política de actualización.

Criterio de aceptación: clonación y prueba de instalación en seco exitosas.
