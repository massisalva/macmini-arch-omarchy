# Migración Wi-Fi a Impala/iwd

Impala controla `iwd` directamente. Su documentación indica que
NetworkManager y `wpa_supplicant` no deben administrar simultáneamente la
interfaz. La migración incluida en este proyecto:

1. detecta la conexión Wi-Fi activa;
2. instala `impala` e `iwd` antes de cortar la red;
3. respalda NetworkManager, iwd y `resolv.conf`;
4. crea el perfil de red en `/var/lib/iwd` con permisos `600`;
5. activa la configuración de red integrada de iwd y systemd-resolved;
6. valida ruta predeterminada y resolución DNS;
7. restaura NetworkManager automáticamente si falla.

Ejecutar desde una terminal local:

```bash
sudo ./scripts/migrate-wifi-to-iwd.sh
```

El script imprime la ruta exacta del backup. Para volver manualmente:

```bash
sudo ./scripts/rollback-wifi-to-networkmanager.sh backups/system-wifi/FECHA-HORA
```

No borrar el backup hasta comprobar conexión, reconexión y un reinicio.

## Resultado local

Migración completada el 2026-07-10:

- interfaz Wi-Fi conectada mediante iwd (detectada como `wlan0` después del
  reinicio; el nombre puede variar entre arranques);
- dirección IPv4 y DNS operativos;
- Impala integrado con el módulo de red de Waybar;
- NetworkManager deshabilitado;
- backup verificado en backups/system-wifi/20260710-091212.

## Validación después del reinicio

Completada el 2026-07-10:

- iwd reconectó automáticamente la interfaz `wlan0`;
- ruta predeterminada, dirección DHCP y resolución DNS operativas;
- `iwd` y `systemd-resolved` activos y habilitados;
- NetworkManager deshabilitado;
- cero unidades fallidas de systemd, tanto de sistema como de usuario;
- Impala disponible en `/usr/bin/impala`.

Los scripts de uso diario no fijan el nombre de la interfaz. La auditoría usa
`ip`, `iw` y `resolvectl` para reflejar el backend iwd actual.
