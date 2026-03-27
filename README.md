# Mobile Auth Developer Environment

Full local setup for a React Native mobile app with two authentication paths:

- Existing mock auth flow (kept intact)
- FusionAuth OAuth2 + PKCE flow
- Runtime toggle between modes from Settings

## Structure

```
apps/
  mobile-app/
  bff/
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

## Optional demo repo

`oauth2-pkce-mobile-demo` is optional and not required for startup.

## Seeded Credentials

- FusionAuth admin UI:
  - `admin@99x.io` / `Adm1nIsAwes0m3!`
- Mobile app test user:
  - `user@99x.io` / `ign1teIsAwes0m3`

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
