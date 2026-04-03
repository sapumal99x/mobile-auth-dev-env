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
 - mobile env:
   - `apps/mobile-app/.env`

## Mobile Environment Variables

`apps/mobile-app/.env`:

```env
EXPO_PUBLIC_FUSIONAUTH_URL=http://localhost:9011
EXPO_PUBLIC_CLIENT_ID=__SET_FUSIONAUTH_CLIENT_ID__
EXPO_PUBLIC_REDIRECT_URI=myapp://callback
EXPO_PUBLIC_GOOGLE_IDP_ID=__SET_GOOGLE_IDP_ID__
EXPO_PUBLIC_AUTH_MODE=mock
```

These values drive OAuth endpoint selection and default auth mode fallback.

## Expected Seeded Values

- redirect URI: `myapp://callback`
- OAuth client/application ID: `__SET_FUSIONAUTH_CLIENT_ID__`
- FusionAuth admin UI user:
  - email: `__SET_ADMIN_EMAIL__`
  - password: `__SET_ADMIN_PASSWORD__`
- test user:
  - email: `__SET_TEST_EMAIL__`
  - password: `__SET_TEST_PASSWORD__`
  - scope: app login testing only (not admin UI)

## Verification

- FusionAuth web: [http://localhost:9011](http://localhost:9011)
- Metro: [http://localhost:8081](http://localhost:8081)
- In app Settings, toggle `Enable FusionAuth Login` and test both login modes.
