# Setup Guide

## Prerequisites

- Docker Desktop running
- Node.js 20+
- Xcode (for iOS)
- Android Studio (optional for Android)

## First-Time Setup

From repository root:

```bash
npm run start
```

This executes:

1. `scripts/update.sh` (clone/update mobile app branch)
2. `docker compose up -d` (FusionAuth + Postgres)
3. waits for startup
4. starts mobile app Metro

If you changed kickstart/bootstrap settings and want a fresh seed, reset local infra state:

```bash
cd infra
docker compose --env-file ../.env down -v
docker compose --env-file ../.env up -d
```

## iOS Run

In `apps/mobile-app`:

```bash
npm run ios
```

## Configuration Files

- root `.env`: infra settings (DB + FusionAuth bootstrap)
- `infra/kickstart/kickstart.json`: seeded app/user
- mobile config:
  - `app/config/config.dev.ts`
  - `app/config/config.prod.ts`

## Expected Seeded Values

- redirect URI: `myapp://callback`
- OAuth client/application ID: `11111111-1111-1111-1111-111111111111`
- FusionAuth admin UI user:
  - email: `admin@99x.io`
  - password: `Adm1nIsAwes0m3!`
- test user:
  - email: `user@99x.io`
  - password: `ign1teIsAwes0m3`
  - scope: app login testing only (not admin UI)

## Verification

- FusionAuth web: [http://localhost:9011](http://localhost:9011)
- Metro: [http://localhost:8081](http://localhost:8081)
- In app Settings, toggle `Enable FusionAuth Login` and test both login modes.
