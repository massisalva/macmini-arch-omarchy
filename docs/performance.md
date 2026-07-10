# Medición de rendimiento — 2026-07-10

Medición tomada con Hyprland, Waybar, PipeWire e iwd activos:

- RAM total utilizable: 7,6 GiB;
- RAM usada: 2,3 GiB;
- RAM disponible: 5,3 GiB;
- zram swap: 3,8 GiB;
- swap usada: 24 KiB.

El resultado deja margen suficiente para el perfil de 8 GiB. El entorno de
auditoría aislado no permite atribuir RSS a los procesos de la sesión real;
esa medición debe repetirse desde una terminal normal si se necesita el
desglose por componente.

El perfil conserva una sola barra, fondo estático, blur de una pasada,
animaciones breves y herramientas TUI. Walker, Elephant y Swaylock fueron
retirados. La red usa iwd e Impala, sin NetworkManager activo.
