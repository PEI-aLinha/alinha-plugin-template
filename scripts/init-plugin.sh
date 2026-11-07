#!/usr/bin/env bash
# Transforma este template num plugin concreto. Corre UMA vez, logo depois de
# criar o repo a partir do template (o scripts/new-plugin.sh do repo principal
# já o chama). Apaga-se a si próprio no fim.
#
#   ./scripts/init-plugin.sh feature risk-assets "Risk & Assets"
#   ./scripts/init-plugin.sh provider code-repository "Code Repository"
set -euo pipefail

kind="${1:?tipo: feature | provider}"
id="${2:?id em kebab-case, ex.: risk-assets}"
name="${3:?nome legível, ex.: \"Risk & Assets\"}"

[[ "$kind" == feature || "$kind" == provider ]] || { echo "tipo inválido: $kind"; exit 1; }
[[ "$id" =~ ^[a-z][a-z0-9-]*$ ]] || { echo "id inválido: $id (kebab-case)"; exit 1; }

cd "$(dirname "$0")/.."

pkg="${id//-/}"                                                    # risk-assets → riskassets
class="$(echo "$id" | perl -pe 's/(^|-)([a-z])/\U$2/g')"           # risk-assets → RiskAssets
kindup="$(echo "$kind" | tr '[:lower:]' '[:upper:]')"              # FEATURE | PROVIDER
ts="$(date +%Y%m%d%H%M%S)"                                         # versão da 1.ª migração

export A_ID="$id" A_NAME="$name" A_KIND="$kind" A_KINDUP="$kindup" A_PKG="$pkg" A_CLASS="$class" A_TS="$ts"

# 1) conteúdo dos ficheiros
grep -rlI --exclude-dir=.git -e '__ID__' -e '__NAME__' -e '__KIND' -e '__PKG__' -e '__CLASS__' -e '__TS__' . \
  | grep -v 'scripts/init-plugin.sh' \
  | while read -r f; do
      perl -pi -e 's/__TS__/$ENV{A_TS}/g; s/__KINDUP__/$ENV{A_KINDUP}/g; s/__KIND__/$ENV{A_KIND}/g;
                   s/__CLASS__/$ENV{A_CLASS}/g; s/__PKG__/$ENV{A_PKG}/g; s/__NAME__/$ENV{A_NAME}/g;
                   s/__ID__/$ENV{A_ID}/g' "$f"
    done

# 2) nomes de pastas e ficheiros (mais fundo primeiro)
find . -depth -not -path './.git/*' \( -name '*__PKG__*' -o -name '*__CLASS__*' -o -name '*__TS__*' \) \
  | while read -r p; do
      base="$(basename "$p")"
      new="$(echo "$base" | perl -pe 's/__TS__/$ENV{A_TS}/g; s/__CLASS__/$ENV{A_CLASS}/g; s/__PKG__/$ENV{A_PKG}/g')"
      mv "$p" "$(dirname "$p")/$new"
    done

# 3) 1.ª migração com versão timestamp (evita colisões entre plugins no Flyway)
mig="backend/src/main/resources/db/migration/$pkg"
mv "$mig/V0__init.sql" "$mig/V${ts}__${pkg}_init.sql"

# 4) só providers têm worker Python
[[ "$kind" == provider ]] || rm -rf worker

# 5) README do template → README do plugin
perl -0pi -e 's/<!-- TEMPLATE:START -->.*?<!-- TEMPLATE:END -->\n*//s' README.md

rm -f scripts/init-plugin.sh
rmdir scripts 2>/dev/null || true

echo "Plugin '$name' ($kind/$id) inicializado: package pt.alinha.$pkg, classe ${class}Plugin."
