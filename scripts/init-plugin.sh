#!/usr/bin/env bash
# Turns this template into a concrete plugin. Runs ONCE, right after the repo is
# created from the template (the main repo's scripts/new-plugin.sh already calls
# it). Deletes itself at the end.
#
#   ./scripts/init-plugin.sh feature risk-assets "Risk & Assets"
#   ./scripts/init-plugin.sh provider code-repository "Code Repository"
set -euo pipefail

kind="${1:?kind: feature | provider}"
id="${2:?kebab-case id, e.g. risk-assets}"
name="${3:?display name, e.g. \"Risk & Assets\"}"

[[ "$kind" == feature || "$kind" == provider ]] || { echo "invalid kind: $kind"; exit 1; }
[[ "$id" =~ ^[a-z][a-z0-9-]*$ ]] || { echo "invalid id: $id (kebab-case)"; exit 1; }

cd "$(dirname "$0")/.."

pkg="${id//-/}"                                                    # risk-assets → riskassets
class="$(echo "$id" | perl -pe 's/(^|-)([a-z])/\U$2/g')"           # risk-assets → RiskAssets
kindup="$(echo "$kind" | tr '[:lower:]' '[:upper:]')"              # FEATURE | PROVIDER
ts="$(date +%Y%m%d%H%M%S)"                                         # version of the first migration

export A_ID="$id" A_NAME="$name" A_KIND="$kind" A_KINDUP="$kindup" A_PKG="$pkg" A_CLASS="$class" A_TS="$ts"

# 1) file contents
grep -rlI --exclude-dir=.git -e '__ID__' -e '__NAME__' -e '__KIND' -e '__PKG__' -e '__CLASS__' -e '__TS__' . \
  | grep -v 'scripts/init-plugin.sh' \
  | while read -r f; do
      perl -pi -e 's/__TS__/$ENV{A_TS}/g; s/__KINDUP__/$ENV{A_KINDUP}/g; s/__KIND__/$ENV{A_KIND}/g;
                   s/__CLASS__/$ENV{A_CLASS}/g; s/__PKG__/$ENV{A_PKG}/g; s/__NAME__/$ENV{A_NAME}/g;
                   s/__ID__/$ENV{A_ID}/g' "$f"
    done

# 2) folder and file names (deepest first)
find . -depth -not -path './.git/*' \( -name '*__PKG__*' -o -name '*__CLASS__*' -o -name '*__TS__*' \) \
  | while read -r p; do
      base="$(basename "$p")"
      new="$(echo "$base" | perl -pe 's/__TS__/$ENV{A_TS}/g; s/__CLASS__/$ENV{A_CLASS}/g; s/__PKG__/$ENV{A_PKG}/g')"
      mv "$p" "$(dirname "$p")/$new"
    done

# 3) first migration gets a timestamp version (avoids Flyway collisions between plugins)
mig="backend/src/main/resources/db/migration/$pkg"
mv "$mig/V0__init.sql" "$mig/V${ts}__${pkg}_init.sql"

# 4) only providers have a Python worker
[[ "$kind" == provider ]] || rm -rf worker

# 5) template README → plugin README
perl -0pi -e 's/<!-- TEMPLATE:START -->.*?<!-- TEMPLATE:END -->\n*//s' README.md

rm -f scripts/init-plugin.sh
rmdir scripts 2>/dev/null || true

echo "Plugin '$name' ($kind/$id) initialised: package pt.alinha.$pkg, class ${class}Plugin."
echo "Remember: user-visible labels/paths in frontend/src/index.ts must be in Portuguese."
