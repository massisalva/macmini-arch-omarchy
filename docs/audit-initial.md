# Auditoría inicial — 2026-07-10

## Resumen

La instalación tiene una base coherente y moderna: kernel LTS, microcódigo
Intel, pila gráfica Intel correcta, PipeWire y zram. La segunda captura se
ejecutó desde la sesión real de Hyprland y confirmó que no hay unidades de
systemd fallidas, `/usr` pertenece a `root:root`, el arranque es UEFI con
Limine y la sesión gráfica funciona correctamente.

**Conclusión:** sistema apto para continuar con la personalización. No hay
evidencia de corrupción ni de una instalación defectuosa.

## Hardware detectado

- CPU: Intel Core i5-4278U, 2 núcleos/4 hilos, 800–3100 MHz.
- GPU: Intel Haswell integrada (`8086:0a2e`), controlador `i915`.
- RAM: 7.6 GiB utilizables; 3.8 GiB de zram swap.
- Disco: SSD Kingston A400 de 480 GB; raíz ext4 y ESP FAT32.
- Wi-Fi: Broadcom BCM4360 con `wl` (`broadcom-wl-dkms`).
- Ethernet: Broadcom BCM57766 con `tg3`.
- Thunderbolt 2: controlador Falcon Ridge reconocido.
- Kernel: `linux-lts 6.18.38-1`.

## Aspectos correctos

- `intel-ucode` está instalado.
- `mesa`, `vulkan-intel` e `i915` forman una pila gráfica adecuada.
- PipeWire, WirePlumber y compatibilidad PulseAudio están instalados.
- El SSD usa solo alrededor del 3 % y no muestra presión de espacio.
- zram equivale aproximadamente al 50 % de la RAM, razonable para 8 GiB.
- Hyprland 0.55.4 y componentes principales están actualizados entre sí.
- La configuración visual ya es modular y reserva `personal.conf`.
- Systemd reporta cero unidades fallidas, tanto de sistema como de usuario.
- Limine inicia `Arch Linux LTS` mediante UEFI.
- DKMS compiló correctamente `broadcom-wl` para el kernel LTS actual.
- CPU a 37–40 °C y ventilador a unas 1800 RPM en reposo.
- PipeWire reconoce audio analógico y HDMI.
- Bluetooth, Wi-Fi y el monitor Samsung 1080p/60 Hz están operativos.
- No hay paquetes huérfanos ni paquetes ajenos a los repositorios oficiales.

## Hallazgos a revisar

### Prioridad alta

1. **Broadcom BCM4360.** `broadcom-wl` produjo advertencias internas del kernel
   y el propio kernel indica que el módulo propietario no está mantenido. DKMS
   está correcto y la red funciona. Mantenerlo mientras sea estable; ante
   cortes, preferir Ethernet o un adaptador USB con buen soporte upstream antes
   que cambiar a ciegas a un controlador incompatible.

### Prioridad media

1. ~~Falta `rtkit`.~~ Instalado (`0.14-1`). Su activación debe comprobarse en
   una sesión nueva porque el journal revisado pertenece al arranque anterior.
2. ~~Falta `wireless-regdb`.~~ Instalado (`2026.05.30-1`). El firmware se
   cargará en el siguiente arranque.
3. `wpa_supplicant` no pudo activar monitorización de señal (`bgscan`) con el
   driver propietario `wl`. Es común con BCM4360; importa solo si hay cortes o
   roaming deficiente.
4. Dos receptores Logitech emitieron errores de negociación HID++ `0x08`.
   Si mouse/teclado funcionan bien, suele ser inocuo; si no, revisar firmware,
   receptor y `solaar`.
5. D-Bus detectó dos proveedores de `org.freedesktop.FileManager1`, incluido
   Thunar. Es una advertencia de nombres duplicados, no un fallo del disco.

## Integridad de paquetes

La verificación no encontró alteraciones en binarios de Hyprland, kernel,
gráficos, audio ni herramientas principales. Las diferencias corresponden
principalmente a configuraciones esperables (`fstab`, usuarios, locales,
sudoers, UFW y mirrors) o a archivos que un usuario sin privilegios no puede
leer. Debe repetirse `sudo pacman -Qkk` solo si se necesita una comprobación
forense; los resultados actuales no sugieren corrupción.

## Estado del SSD

SMART del Kingston A400 de 480 GB: **PASSED**.

- Vida útil informada: 99 % restante.
- Horas encendido: 1066.
- Escrituras acumuladas: aproximadamente 2 TB.
- Sectores/eventos reasignados: 0.
- Errores no corregibles: 0.
- Errores SATA CRC: 0.
- Errores registrados: 0.
- Temperatura: 22 °C; máximo histórico 45 °C.
- Dos autotests cortos completados sin errores.
- Apagados inseguros: 72. Evitar desconectar alimentación sin apagar Arch.

El número de ciclos de alimentación es alto (13.196), pero no está acompañado
por desgaste, errores de interfaz ni fallos de NAND.

## Seguridad de CPU

El microcódigo está actualizado y el kernel aplica mitigaciones para Meltdown,
Spectre, MDS, L1TF y vulnerabilidades relacionadas. Haswell conserva riesgo
residual de MDS/L1TF con SMT habilitado. Para un escritorio doméstico se
mantiene SMT por rendimiento; puede reevaluarse si cambia el modelo de amenaza.

## Perfil de rendimiento recomendado

Para Haswell y 8 GiB conviene conservar animaciones cortas, blur moderado o
desactivable, sombras discretas y una sola barra. Evitar fondos animados,
widgets Electron permanentes y efectos de blur por múltiples pasadas. Foot,
Fuzzel, Mako y Waybar son elecciones apropiadas.

## Limitaciones de esta captura

El estado de UFW todavía requiere privilegios administrativos. `bootctl`
identificó correctamente Limine y UEFI, aunque el usuario
normal no puede leer algunos contenidos de `/boot`, como corresponde a los
permisos restrictivos configurados en `fstab`.

## Registro de ajustes

### 2026-07-10

- Instalado `smartmontools 7.5-1` para diagnóstico SMART del SSD.
- Instalado `rtkit 0.14-1` para prioridad de tiempo real de PipeWire.
- Instalado `wireless-regdb 2026.05.30-1` para regulación inalámbrica.
- No se modificó el controlador Broadcom, Limine ni la configuración gráfica.
- SMART completo: estado correcto, 99 % de vida y cero errores registrados.
