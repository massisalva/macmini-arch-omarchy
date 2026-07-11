# Perfiles de paquetes

Las listas separan requisitos del escritorio de aplicaciones y herramientas
opcionales. Las líneas vacías y los comentarios no representan paquetes.

| Archivo | Alcance |
| --- | --- |
| `desktop.txt` | Sesión Hyprland portable y dependencias de sus helpers |
| `hardware-macmini.txt` | Kernel/DKMS y diagnóstico específicos del Mac mini |
| `applications.txt` | Aplicaciones gráficas, archivos y multimedia usadas en esta máquina |
| `development.txt` | Git, revisión, JavaScript y Python |
| `administration.txt` | SSH, firewall, mantenimiento y diagnóstico |
| `rollback.txt` | Backend de red anterior conservado para recuperación |
| `optional-aur.txt` | Aplicaciones personales AUR, fuera del perfil base |

`official.txt` es un índice compatible compuesto por `desktop.txt`,
`hardware-macmini.txt` y `rollback.txt`. `aur.txt` refleja
`optional-aur.txt`. `scripts/check.sh` comprueba que ambos índices permanezcan
sincronizados.

Para instalar perfiles oficiales, por ejemplo escritorio y hardware:

```bash
mapfile -t packages < <(
  sed -E '/^[[:space:]]*(#|$)/d' \
    packages/desktop.txt packages/hardware-macmini.txt
)
sudo pacman -S --needed "${packages[@]}"
```

Los paquetes AUR se revisan e instalan por separado; nunca se incorporan a un
comando automático con privilegios.
