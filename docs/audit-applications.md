# Auditoría de aplicaciones — 2026-07-10

## Alcance

Revisión de paquetes explícitos, paquetes AUR, huérfanos, servicios, puertos,
procesos de la sesión, consumo de disco y correspondencia con las listas
reproducibles. No se desinstaló ni deshabilitó nada durante la auditoría.

## Estado general

- La raíz usa 40 GiB de 439 GiB (10 %); no hay presión de almacenamiento.
- La caché de pacman ocupa 1,7 GiB y no requiere limpieza urgente.
- No hay servicios fallidos confirmados en la sesión real.
- Hyprland usa Hypridle; Niri y Swayidle están instalados pero inactivos.
- iwd gestiona la red. NetworkManager y wpa_supplicant permanecen instalados
  como ruta de rollback, no como servicios activos.
- Waybar, Mako, PipeWire, WirePlumber, MPD y OneDrive funcionan como servicios
  de usuario esperados.

## Hallazgos prioritarios

### 1. SSH expuesto en la red local

`sshd.service` está habilitado y escucha en IPv4 e IPv6 por el puerto 22. UFW
está instalado pero deshabilitado e inactivo. Antes de modificarlo hay que
confirmar si el acceso remoto se utiliza:

- si no se usa, deshabilitar SSH;
- si se usa, comprobar autenticación por clave, desactivar contraseña y root,
  y habilitar una política de firewall limitada a la red local.

Se confirmó que SSH se usa ocasionalmente y sólo desde la LAN
`192.168.1.0/24`. `scripts/harden-ssh-lan.sh` configura UFW con entrada
predeterminada denegada, permite TCP/22 únicamente desde la subred conectada,
deshabilita acceso de root y valida la configuración antes de reiniciar SSH.
La contraseña se conserva hasta instalar y probar una clave desde el cliente.
En Arch también habilita explícitamente `ufw.service`; `ufw enable` actualiza
la configuración pero por sí solo no garantiza que la unidad systemd quede
habilitada para restaurar las reglas después de reiniciar.

**Aplicado el 2026-07-10:** UFW y SSH quedaron habilitados y activos, con cero
unidades fallidas. La única regla de entrada para TCP/22 acepta
`192.168.1.0/24`; se eliminaron permisos anteriores para cualquier origen.
La clave Ed25519 del cliente macOS fue instalada y probada correctamente. El
helper detecta `authorized_keys` antes de desactivar contraseñas y exigir clave
pública, evitando bloquear una instalación que todavía no tenga claves.
La política final quedó aplicada el 2026-07-11 y una prueba deliberada sin
clave fue rechazada con `Permission denied (publickey)`.

### 2. Paquetes de depuración residuales

`onedrive-abraunegg-debug` es el único huérfano confirmado. También está
instalado `yay-bin-debug`. Son artefactos habituales de compilación AUR y no
son necesarios para el uso normal; pueden retirarse después de una última
comprobación de dependencias.

**Resuelto el 2026-07-10:** se retiraron ambos paquetes de depuración junto con
Niri, Xwayland Satellite y Swayidle. Pacman eliminó 37,65 MiB sin arrastrar
otras dependencias. La comprobación posterior mostró cero huérfanos, cero
unidades fallidas y únicamente las sesiones normales de Hyprland.

### 3. Listas reproducibles con alcance ambiguo

`packages/official.txt` describe el perfil de escritorio, pero la máquina
tiene además aplicaciones explícitas como LibreOffice, herramientas de
desarrollo y utilidades administrativas. `packages/aur.txt` afirma que el
perfil no requiere AUR, mientras la sesión real usa 1Password, OneDrive y
Pyradio, y mantiene Yay.

Conviene separar claramente:

- paquetes mínimos del escritorio;
- aplicaciones personales opcionales;
- herramientas de desarrollo y administración;
- paquetes de rollback o compatibilidad.

**Resuelto el 2026-07-11:** `packages/` quedó separado en escritorio,
hardware del Mac mini, aplicaciones, desarrollo, administración, rollback y
AUR opcional. Los índices compatibles `official.txt` y `aur.txt` se validan
automáticamente en CI para evitar divergencias.

Durante la limpieza se retiró `xdg-desktop-portal-gnome` y su árbol GNOME. Los
portales Hyprland y GTK permanecieron activos, pero pacman también retiró GVfs
y XDG User Dirs como dependencias no requeridas. Ambos se incorporaron al
perfil base para conservar papelera/montaje de Thunar y la inicialización de
directorios estándar sin reinstalar Nautilus ni el portal GNOME.

**Validado el 2026-07-11:** `gvfs` y `xdg-user-dirs` quedaron instalados
explícitamente. GVfs detecta el SSD mediante UDisks2, `trash:///` responde como
Papelera y `xdg-user-dir DESKTOP` resuelve el directorio esperado. Los portales
principal, Hyprland y GTK permanecen activos, sin advertencias en el arranque;
systemd y el gestor de usuario muestran cero unidades fallidas y pacman no
informa paquetes huérfanos.

## Candidatos que requieren decisión

| Paquete o servicio | Evidencia | Recomendación |
| --- | --- | --- |
| `niri` | Instalado explícitamente, inactivo | Retirado; Hyprland queda como única sesión |
| `xwayland-satellite` | Inactivo; opcional para Niri | Retirado junto con Niri |
| `swayidle` | Sin dependientes y reemplazado por Hypridle | Retirado |
| NetworkManager + wpa_supplicant | Inactivos; conservados para rollback | Mantener mientras el rollback Wi-Fi siga siendo requisito |
| `1password` | Aplicación activa; paquete grande | Mantener si se usa; desactivar autostart sólo si se prefiere ahorrar RAM |
| MPD + ncmpcpp | Servicio y cliente activos | Mantener: forman parte del flujo musical actual |
| OneDrive | Servicio activo | Mantener si la sincronización sigue siendo necesaria |

## Rendimiento observado

Durante la auditoría, Headroom fue el mayor consumidor de memoria
(aproximadamente 1,3 GiB RSS), seguido por el conjunto de procesos de
1Password. Headroom y Codex son herramientas de la sesión de trabajo actual,
por lo que esta medición no representa el escritorio en reposo. La línea base
sin herramientas de desarrollo continúa siendo la registrada en
`docs/performance.md`.

## Falsos positivos descartados

La auditoría aislada informó propietarios `nobody:nobody` para archivos de
1Password. La comprobación desde el host confirmó `root:root` y permisos
esperados, incluido `4755` para `chrome-sandbox`. No hay evidencia de una
instalación dañada; el cambio de UID es una consecuencia del sandbox.

## Orden recomendado

1. Mantener SSH para uso esporádico. Actualmente no hay claves autorizadas, por
   lo que se debe configurar una antes de desactivar autenticación por
   contraseña.
2. Definir si el acceso SSH será sólo desde la red local antes de habilitar una
   regla restrictiva de firewall.
3. Mantener los perfiles de paquetes sincronizados mediante CI cuando cambien
   las aplicaciones de la máquina.

## Revisión orientada a trabajo documental — 2026-07-12

La revisión posterior confirmó cero paquetes huérfanos y sólo cinco paquetes
externos conocidos (`1password`, `localsend-bin`, `onedrive-abraunegg`,
`pyradio` y `yay-bin`).
No se encontraron aplicaciones explícitas que sea seguro retirar sin eliminar
una función elegida por el usuario. NetworkManager y wpa_supplicant continúan
como rollback de red documentado.

Las entradas técnicas de Avahi, GPS, Video4Linux y XFCE que aparecen en el
lanzador pertenecen a dependencias de LibreOffice, Waybar, MPV y Thunar. En
lugar de desinstalarlas, se añadieron anulaciones locales `Hidden=true` para
limpiar Fuzzel sin afectar esas dependencias.

El perfil de documentos incorpora Zathura con soporte MuPDF, QPDF, silabeo y
sinónimos en español, y tipografías métricamente compatibles con Arial, Times
New Roman, Calibri y Cambria. Se mantienen LibreOffice Still, su traducción al
español y Hunspell de Argentina. LanguageTool y Pandoc se posponen: el primero
añade Java y unos 386 MiB, y el segundo un árbol Haskell considerable, sin que
exista todavía un flujo concreto que justifique ese costo.
