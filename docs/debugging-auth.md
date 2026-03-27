# Authentication Debugging Guide

Focused troubleshooting for the OAuth + PKCE path implemented in this project.

## First Checks (Always)

1. Confirm auth mode in app settings (`Demo`, `FusionAuth`, `Mock`).
2. Confirm FusionAuth and Postgres containers are healthy.
3. Confirm mobile env values:
   - `EXPO_PUBLIC_FUSIONAUTH_BASE_URL`
   - `EXPO_PUBLIC_FUSIONAUTH_CLIENT_ID`
   - `EXPO_PUBLIC_FUSIONAUTH_REDIRECT_URI`
4. Confirm redirect URI in FusionAuth app config exactly matches app value.

## Common Issues

### Redirect not working

Symptoms:

- Browser login completes but app never resumes.

Checks:

- `app.json` contains `myapp` scheme.
- redirect URI equals `myapp://callback` in both app and FusionAuth.
- no typo/trailing slash mismatch.

### PKCE mismatch

Symptoms:

- token request fails after successful authorize/login.

Checks:

- `code_challenge_method=S256` on authorize request.
- same `code_verifier` generated pre-authorize is used in token request.
- verifier/challenge encoding not mutated.

### `invalid_client`

Symptoms:

- authorize or token request rejected immediately.

Checks:

- `client_id` equals FusionAuth application UUID.
- app configured as public client for PKCE (no required client secret).

### `invalid_grant`

Symptoms:

- token exchange fails with a seemingly valid code.

Checks:

- code not expired or already used.
- `redirect_uri` on token request exactly matches authorize request.
- PKCE verifier is correct.
- clock skew/system time issues are not extreme.

## Request Inspection Checklist

- Authorize URL contains all required params.
- Callback includes `code` and expected `state`.
- Token body includes `grant_type`, `client_id`, `code`, `redirect_uri`, `code_verifier`.
- FusionAuth logs show successful code issue before token exchange.

## Useful Project Log Points

- `authService.ts`: selected auth mode logs.
- `fusionauth.ts`: authorize start, callback handling, token exchange step logs.
- `SettingsScreen.tsx` (dev only): token visibility panel for quick verification.

## Quick Recovery Actions

- Restart Metro and simulator app.
- Recreate infra state if kickstart/config changed.
- Clear app storage and retry from fresh login.
