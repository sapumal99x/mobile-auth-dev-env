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

## Documentation

See `/docs` for onboarding and deep technical references:

- `docs/architecture.md`
- `docs/setup-guide.md`
- `docs/auth-flow.md`
- `docs/pkce-deep-dive.md`
- `docs/code-walkthrough.md`
- `docs/api-reference.md`
- `docs/debugging-guide.md`
- `docs/glossary.md`
