# Firefox en Intel Haswell

La comprobación con `vainfo` del 2026-07-12 confirmó el controlador Intel
`i965` y decodificación VA-API para H.264, MPEG-2, VC-1 y JPEG. La Intel HD
5100 no ofrece decodificación por hardware para VP9 ni AV1.

El perfil activo recibe tres preferencias conservadoras desde
`dotfiles/.config/firefox-performance/user.js`: habilitar VA-API y la
decodificación de video por hardware, y deshabilitar AV1 para evitar su costo
de CPU. No se fuerzan WebRender, número de procesos, caché ni preferencias de
aislamiento.

El archivo no se despliega automáticamente porque el nombre aleatorio del
perfil de Firefox varía entre instalaciones. Para revertir, cerrar Firefox,
retirar `user.js` del perfil y volver a abrirlo.
