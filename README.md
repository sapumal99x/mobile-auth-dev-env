# Mobile Auth Developer Environment

Full local setup for a React Native mobile app with two authentication paths:

- Existing mock auth flow (kept intact)
- FusionAuth OAuth2 + PKCE flow
- Runtime toggle between modes from Settings

## Structure

```
apps/
  mobile-app/
infra/
  docker-compose.yml
  kickstart/
    kickstart.json
scripts/
  start.sh
  update.sh
.env
package.json
```

## One-command start

```bash
npm run start
```

This will:

1. Run `scripts/update.sh`
2. Start FusionAuth + Postgres via Docker
3. Wait for startup
4. Launch the mobile app

## Environment Setup

Do not commit real credentials or secrets.

- Copy root environment template:
  - `cp .env.example .env`
- Copy mobile environment template:
  - `cp apps/mobile-app/.env.example apps/mobile-app/.env`

## Auth mode toggle

In the mobile app Settings screen, use **Enable FusionAuth Login**.

- OFF: uses existing mock auth and demo data
- ON: uses FusionAuth OAuth + PKCE

Both flows return a consistent payload shape:

```json
{
  "user": { "id": "string", "email": "string" },
  "access_token": "string",
  "refresh_token": "string"
}
```

## Mobile App Architecture (Current)

The mobile app is intentionally reduced to a minimal baseline:

- `Login`
- `Home` (Dashboard-style screen)
- `Settings`

Bottom tabs include only:

- `Home`
- `Settings`

Removed mobile features:

- Payments
- Scan
- History
- Invoice

State management is React state plus focused Context providers.  
Future direction is adopting TanStack Query for server state when web/mobile monorepo integration begins.

## Optional demo repo

`oauth2-pkce-mobile-demo` is optional and not required for startup.

## Seeded Credentials

Credentials are environment-specific and must not be hardcoded in source control.

- FusionAuth admin UI:
  - email: `__SET_ADMIN_EMAIL__`
  - password: `__SET_ADMIN_PASSWORD__`
- Mobile app test user:
  - email: `__SET_TEST_EMAIL__`
  - password: `__SET_TEST_PASSWORD__`

## Documentation

See `/docs` for onboarding and deep technical references:

- `docs/setup-guide.md`
- `docs/auth-modes.md`
- `docs/code-walkthrough.md`
- `docs/auth-flow-deep-dive.md`
- `docs/pkce-deep-dive.md`
- `docs/endpoints-reference.md`
- `docs/token-lifecycle.md`
- `docs/mobile-integration.md`
- `docs/architecture-diagram.md`
- `docs/debugging-auth.md`
- `docs/glossary.md`

Legacy docs (kept for continuity):

- `docs/auth-flow.md`
- `docs/api-reference.md`
- `docs/architecture.md`
- `docs/debugging-guide.md`
