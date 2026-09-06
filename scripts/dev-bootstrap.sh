#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

if [ ! -d "../ai-triad-data/taxonomy" ]; then
  echo "==> Sibling data repo (../ai-triad-data) is missing"
  exit 1
fi

# Load powershell module (and make cmdlets available), then use cmdlets
# `Get-Tax | Measure-Object` should show several hundred nodes (785 POV nodes as of 2026-07)
pwsh -c 'Import-Module ./scripts/AITriad/AITriad.psm1; Install-AIDependencies -Fix; Get-Tax | Measure-Object'

echo "==> pnpm install (offline, from warm store)"
pnpm install --frozen-lockfile --offline --store-dir /pnpm/store

if [ -z "${GEMINI_API_KEY:-}${ANTHROPIC_API_KEY:-}${GROQ_API_KEY:-}${AI_API_KEY:-}" ]; then
  echo "==> No AI API key set. Set GEMINI_API_KEY (or ANTHROPIC_API_KEY/GROQ_API_KEY/AI_API_KEY)"
  echo "    in a .env file next to compose.yaml, then restart the container."
fi

echo "==> Bootstrap complete."
