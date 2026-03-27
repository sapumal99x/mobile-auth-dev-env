# Token Lifecycle

This document explains how tokens are issued, stored, and consumed in the app.

## Issuance

Tokens are minted only in FusionAuth mode after successful `POST /oauth2/token`.

Expected fields:

- `access_token`
- `refresh_token` (when `offline_access` scope is granted)
- `id_token` (OpenID Connect)
- `expires_in`

Code path: `apps/mobile-app/app/services/auth/fusionauth.ts`.

## Runtime Usage

- `access_token`: primary API bearer token for authenticated requests.
- `id_token`: identity claims token (not an API bearer replacement).
- `refresh_token`: used to obtain new access tokens when current one expires (refresh flow support depends on app implementation stage).

## Storage in This App

Primary session state is held by `AuthContext` in:

- `apps/mobile-app/app/context/AuthContext.tsx`

The project currently uses MMKV-backed helpers for session persistence.  
The settings debug section reads `authToken`, `authRefreshToken`, and `authIdToken` from `useAuth()`.

Auth mode flags are separate and stored in AsyncStorage:

- `auth.mode`
- `DemoApp.demoModeEnabled`

Code path: `apps/mobile-app/app/services/auth/authMode.ts`.

## Lifetime and Expiry

- Access token expiry is determined by FusionAuth tenant/application configuration (`expires_in` in response).
- Refresh token lifetime/revocation is governed server-side by FusionAuth settings.
- Authorization codes are one-time and short-lived.

## Security Notes

- Do not log raw tokens in production builds.
- Dev-only token inspection is gated behind `__DEV__` in `SettingsScreen`.
- Treat refresh tokens as high-sensitivity credentials.

## Typical Event Timeline

1. User logs in, tokens issued.
2. App stores session and transitions to authenticated UI.
3. API calls include `Authorization: Bearer <access_token>`.
4. On expiry, app should refresh using `refresh_token` (if implemented) or force re-auth.
5. On logout, clear stored session tokens.
