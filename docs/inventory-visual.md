# Inventario visual — 2026-07-11

## Resumen

La sesión actual ya tiene una base modular inspirada en Omarchy y preparada
para el Mac mini. No conviene reemplazarla en bloque: la fase visual debe
consolidar lo existente, unificar la paleta y hacerlo reproducible.

El barrido de privacidad no encontró tokens, contraseñas, SSID fijos, rutas
absolutas del usuario ni otros datos personales en los archivos visuales y
scripts auxiliares revisados. La expresión `{essid}` de Waybar es una variable
dinámica y no contiene el nombre de una red.

La captura pública se renovó el 2026-07-12 con una composición representativa:
Fastfetch, ncmpcpp, Cava, el cajón Fuzzel por categorías y Waybar con metadata
musical. Para la foto, Waybar reemplazó temporalmente el SSID por `Wi-Fi` y
Fuzzel se abrió en capa `top` para conservar visible el escritorio. La imagen
no contiene SSID, IP, rutas, tokens, notificaciones ni cuentas privadas; el
usuario público del repositorio y el hostname genérico `macmini` se mantienen
como parte de la identidad visual del proyecto.

## Componentes activos

| Componente | Ruta local | Estado |
| --- | --- | --- |
| Hyprland | `~/.config/hypr/` | Modular, activo y recargable |
| Waybar | `~/.config/waybar/` | Activa como servicio de usuario |
| Fuzzel | `~/.config/fuzzel/` | Launcher configurado en Hyprland |
| Foot | `~/.config/foot/` | Terminal activa |
| Mako | `~/.config/mako/` | Notificaciones activas como servicio |
| Hyprlock | `~/.config/hypr/hyprlock.conf` | Bloqueador activo mediante `lock-screen` |
| GTK 3/4 | `~/.config/gtk-{3,4}.0/settings.ini` | Adwaita oscuro, iconos Tela y cursor Capitaine |
| Fondo | `~/.config/hypr/wallpaper.png` | Activo mediante Swaybg |

## Arquitectura de Hyprland

`hyprland.conf` carga, en orden:

1. entorno y aplicaciones predeterminadas;
2. monitor;
3. entrada;
4. apariencia;
5. autostart;
6. atajos;
7. reglas de ventanas;
8. `personal.conf` para cambios locales no portables.

Esta separación debe conservarse en la versión publicable.

## Paleta predominante

La mayor parte del escritorio usa Tokyo Night:

- fondo: `#1a1b26`;
- primer plano: `#a9b1d6`;
- superficie: `#32344a`;
- acento: `#7aa2f7`;
- advertencia: `#e0af68`;
- error: `#f7768e`.

Hyprland, Waybar, Foot, Mako e Hyprlock ya comparten esta familia.

## Inconsistencias resueltas

1. Fuzzel fue unificado con la paleta Tokyo Night.
2. GTK conserva deliberadamente Adwaita oscuro, con iconos Tela Circle Blue
   Dark y cursor Capitaine declarados en los perfiles reproducibles.
3. La referencia ZIP del proyecto previo `conectar-igualdad-sway` se usó sólo
   para scripts y comportamiento, no como fuente visual de Hyprland.

## Dependencias confirmadas

Están instalados Hyprland, Waybar, Fuzzel, Foot, Mako, Hypridle, Hyprlock,
Swaybg, UWSM, los portales de Hyprland/GTK y JetBrains Mono Nerd Font.

## Perfil recomendado para Intel HD 5100

- conservar una sola Waybar de 26 px;
- blur de una pasada y tamaño pequeño, con opción sencilla de desactivarlo;
- animaciones breves y sin efectos complejos;
- fondo estático mediante Swaybg;
- opacidad moderada solo donde aporte legibilidad;
- evitar procesos duplicados para launcher y lockscreen;
- mantener `personal.conf` fuera del perfil portable.

## Decisiones aplicadas

1. Mantener Fuzzel como único launcher por ligereza.
2. Unificar Fuzzel con la paleta Tokyo Night.
3. Usar Hyprlock como único bloqueador.
4. Mantener Adwaita oscuro inicialmente, pero unificar iconos y cursor sin
   incorporar temas externos no instalados.
5. Versionar configuraciones y scripts propios en `dotfiles/`, excluyendo
   `personal.conf` y fondos previos.

La configuración portable se desplegó nuevamente el 2026-07-10 y se comprobó
que Hyprland recarga sin errores, Waybar y Mako permanecen activos y los
archivos de la sesión coinciden con los versionados.
