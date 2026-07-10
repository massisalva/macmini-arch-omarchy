# Mac mini Arch + Hyprland

Configuración reproducible y documentada de Arch Linux con Hyprland para un
Apple Mac mini 2014 (`Macmini7,1`), inspirada visualmente en
[Omarchy](https://github.com/basecamp/omarchy) y ajustada a un Intel Core
i5-4278U, Intel HD Graphics 5100 y 8 GiB de RAM.

> Para continuar después de un reinicio o una sesión nueva, abrir primero
> [`docs/CONTINUAR.md`](docs/CONTINUAR.md).

## Objetivos

1. Auditar la instalación y separar errores reales de advertencias inocuas.
2. Mantener una experiencia cercana a Omarchy sin sacrificar fluidez.
3. Versionar configuraciones, decisiones y procedimientos de recuperación.

## Estado

- Auditoría inicial: completada el 10 de julio de 2026; sistema apto.
- Ajustes de salud instalados: `smartmontools`, `rtkit` y `wireless-regdb`.
- Configuración visual existente: detectada y preservada.
- Cambios del sistema: tres paquetes correctivos instalados; sin cambios de
  arranque, controladores ni configuración visual.
- Fase estética y empaquetado de dotfiles: siguiente etapa.
- Publicación en GitHub: pendiente, una vez revisado que no haya secretos.

## Uso

Ejecutar la auditoría desde una terminal abierta dentro de la sesión real de
Hyprland (no desde un contenedor):

```bash
./scripts/audit.sh
```

El informe queda en `reports/local/`, una ruta ignorada por Git porque puede
contener hostname, dispositivos, redes y otros datos particulares. Los
resultados revisados y anonimizados se resumen manualmente en `docs/`.

Para inspeccionar el despliegue de dotfiles sin modificar la sesión:

```bash
./scripts/install-dotfiles.sh --dry-run
```

La instalación real crea primero un backup ignorado por Git:

```bash
./scripts/install-dotfiles.sh
```

SMART necesita privilegios y se obtiene por separado:

```bash
./scripts/audit-smart.sh
```

## Estructura

- `docs/audit-initial.md`: diagnóstico inicial y verificaciones pendientes.
- `docs/CONTINUAR.md`: estado exacto y siguiente acción tras un reinicio.
- `docs/roadmap.md`: etapas y criterios de aceptación.
- `scripts/audit.sh`: recolección de evidencia, sin modificar el sistema.
- `dotfiles/`: configuraciones revisadas y desplegables.
- `packages/`: listas declarativas de paquetes oficiales y AUR.

## Principios de seguridad

- No versionar claves SSH, cookies, tokens, historial, perfiles Wi-Fi ni
  archivos de autenticación.
- Hacer copia fechada antes de desplegar cualquier configuración.
- Mantener `personal.conf` para particularidades locales no portables.
- Probar los cambios visuales con `hyprctl reload` antes de reiniciar.
