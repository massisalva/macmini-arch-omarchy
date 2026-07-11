#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"

mapfile -t shell_files < <(
  git ls-files 'scripts/*.sh' 'dotfiles/.local/bin/*'
)

if ((${#shell_files[@]} == 0)); then
  echo "No se encontraron scripts para validar." >&2
  exit 1
fi

printf 'Validando sintaxis de %d scripts...\n' "${#shell_files[@]}"
bash -n "${shell_files[@]}"

if ! command -v shellcheck >/dev/null 2>&1; then
  echo "Falta shellcheck." >&2
  exit 1
fi
shellcheck "${shell_files[@]}"

printf 'Validando permisos ejecutables...\n'
for file in "${shell_files[@]}"; do
  if [[ ! -x "$file" ]]; then
    printf 'No es ejecutable: %s\n' "$file" >&2
    exit 1
  fi
done

printf 'Probando instalación en seco...\n'
HOME="$(mktemp -d)" ./scripts/install-dotfiles.sh --dry-run >/dev/null

printf 'Validando índices de paquetes...\n'
package_lines() {
  sed -E '/^[[:space:]]*(#|$)/d' "$@" | sort -u
}

if ! diff -u \
  <(package_lines packages/desktop.txt packages/hardware-macmini.txt packages/rollback.txt) \
  <(package_lines packages/official.txt); then
  echo "packages/official.txt no coincide con los perfiles base." >&2
  exit 1
fi

if ! diff -u \
  <(package_lines packages/optional-aur.txt) \
  <(package_lines packages/aur.txt); then
  echo "packages/aur.txt no coincide con el perfil AUR opcional." >&2
  exit 1
fi

printf 'Buscando credenciales de alto riesgo en el historial...\n'
secret_pattern='BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY|AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9_]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{20,}|xox[baprs]-[A-Za-z0-9-]+'
if git grep --untracked -nIE "$secret_pattern" -- . ':!reports/local' ':!backups'; then
  echo "Se encontraron posibles credenciales en el árbol de trabajo." >&2
  exit 1
fi

mapfile -t revisions < <(git rev-list --all)
if git grep -nIE "$secret_pattern" "${revisions[@]}" -- .; then
  echo "Se encontraron posibles credenciales en el historial." >&2
  exit 1
fi

echo "Todas las comprobaciones pasaron."
