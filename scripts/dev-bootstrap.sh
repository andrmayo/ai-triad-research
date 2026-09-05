#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

if [ ! -d "../ai-triad-data/taxonomy" ]; then
  echo "==> Sibling data repo (../ai-triad-data) is missing"
  exit 1
fi

echo "==> pnpm install (offline, from warm store)"
pnpm install --frozen-lockfile --offline --store-dir /pnpm/store

echo "==> Bootstrap complete."
