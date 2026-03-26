#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE_REPO_URL="https://github.com/sapumal99x/rn-mobile-boilerplate.git"
MOBILE_DIR="${ROOT_DIR}/apps/mobile-app"

mkdir -p "${ROOT_DIR}/apps" "${ROOT_DIR}/bff"

if [[ ! -d "${MOBILE_DIR}/.git" ]]; then
  git clone "${MOBILE_REPO_URL}" "${MOBILE_DIR}"
fi

cd "${MOBILE_DIR}"
git fetch origin
git checkout main
git pull origin main

if git show-ref --verify --quiet refs/heads/feature/fusionauth-integration; then
  git checkout feature/fusionauth-integration
else
  git checkout -b feature/fusionauth-integration
fi

npm install
