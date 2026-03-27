# Endpoints Reference

This file documents the exact FusionAuth endpoints used by the mobile app in real auth mode.

## Base URL

Configured from mobile env:

- `EXPO_PUBLIC_FUSIONAUTH_BASE_URL`
- local dev default commonly `http://localhost:9011`

Code path: `apps/mobile-app/app/services/auth/fusionauth.ts`.

## `GET /oauth2/authorize`

Purpose: start Authorization Code + PKCE login.

### Required Query Parameters

- `client_id`: FusionAuth application UUID
- `redirect_uri`: app deep link (`myapp://callback`)
- `response_type=code`
- `code_challenge`: derived from verifier
- `code_challenge_method=S256`

### Common Additional Parameters

- `scope=openid offline_access profile email`
- `state=<csrf nonce>`
- `login_hint=<user email>` (optional UX helper)

### Example

`http://localhost:9011/oauth2/authorize?client_id=11111111-1111-1111-1111-111111111111&redirect_uri=myapp%3A%2F%2Fcallback&response_type=code&scope=openid%20offline_access%20profile%20email&state=8d4...&code_challenge=Q9...&code_challenge_method=S256`

## `POST /oauth2/token`

Purpose: exchange authorization code for tokens.

Content type: `application/x-www-form-urlencoded`.

### Request Body

- `grant_type=authorization_code`
- `client_id=<same app id>`
- `code=<authorization code>`
- `redirect_uri=myapp://callback`
- `code_verifier=<original verifier>`

### Example Body

`grant_type=authorization_code&client_id=11111111-1111-1111-1111-111111111111&code=Fe26...&redirect_uri=myapp%3A%2F%2Fcallback&code_verifier=nJx...`

### Example Response

```json
{
  "access_token": "eyJraWQiOiJ...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "v1.eyJraWQiOiJ...",
  "id_token": "eyJhbGciOiJSUzI1NiIs..."
}
```

## `GET /oauth2/userinfo` (used after token exchange)

Purpose: retrieve normalized user claims from token context.

Headers:

- `Authorization: Bearer <access_token>`

Typical claims used by app mapping:

- `sub` (stable user id)
- `email`
- optional profile claims (`name`, etc.)

## Error Mapping

- `invalid_client`: client ID/config mismatch
- `invalid_grant`: expired/reused code, redirect mismatch, verifier mismatch
- `client_authentication_missing`: app configured as confidential instead of PKCE public client
