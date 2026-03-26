#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"${ROOT_DIR}/scripts/update.sh"

cd "${ROOT_DIR}/infra"
docker compose --env-file "${ROOT_DIR}/.env" up -d

echo "Waiting for FusionAuth to boot..."
sleep 20

cd "${ROOT_DIR}/apps/mobile-app"
npm run start
