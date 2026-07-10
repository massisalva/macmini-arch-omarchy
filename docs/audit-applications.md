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

### 2. Paquetes de depuración residuales

`onedrive-abraunegg-debug` es el único huérfano confirmado. También está
instalado `yay-bin-debug`. Son artefactos habituales de compilación AUR y no
son necesarios para el uso normal; pueden retirarse después de una última
comprobación de dependencias.

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

## Candidatos que requieren decisión

| Paquete o servicio | Evidencia | Recomendación |
| --- | --- | --- |
| `niri` | Instalado explícitamente, inactivo | Retirar sólo si ya no se desea una sesión alternativa |
| `xwayland-satellite` | Inactivo; opcional para Niri | Retirar junto con Niri, no por separado a ciegas |
| `swayidle` | Sin dependientes y reemplazado por Hypridle | Buen candidato de limpieza |
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

1. Decidir si SSH debe permanecer habilitado.
2. Retirar únicamente los paquetes `-debug` huérfanos.
3. Confirmar si Niri sigue siendo una sesión alternativa deseada.
4. Retirar Swayidle si Hypridle seguirá siendo el único gestor de inactividad.
5. Reorganizar las listas de paquetes por perfil y repetir las validaciones.
