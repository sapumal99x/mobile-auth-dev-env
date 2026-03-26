# OAuth API Reference

This project primarily uses FusionAuth OAuth endpoints.

## `GET /oauth2/authorize`

Starts login and returns an authorization code through redirect URI.

Required query params:

- `client_id`
- `redirect_uri`
- `response_type=code`
- `code_challenge`
- `code_challenge_method=S256`
- `state`

Common optional params:

- `scope` (used: `openid offline_access profile email`)
- `login_hint`

Example:

```http
GET /oauth2/authorize?client_id=11111111-1111-1111-1111-111111111111&redirect_uri=myapp%3A%2F%2Fcallback&response_type=code&code_challenge=...&code_challenge_method=S256&scope=openid%20offline_access%20profile%20email&state=...
```

Success behavior:

- Redirects to `myapp://callback?code=...&state=...`

Typical errors:

- `invalid_client` (unknown client ID)
- `invalid_pkce_code_challenge` (challenge malformed)
- `invalid_redirect_uri` (redirect mismatch)

## `POST /oauth2/token`

Exchanges authorization code for tokens.

Headers:

- `Content-Type: application/x-www-form-urlencoded`

For this mobile public-client setup, no client secret or Basic auth header is sent.
FusionAuth is configured for PKCE + `clientAuthenticationPolicy=NotRequired`.

Body params:

- `grant_type=authorization_code`
- `client_id`
- `code`
- `redirect_uri`
- `code_verifier`

Example body:

```txt
grant_type=authorization_code&client_id=11111111-1111-1111-1111-111111111111&code=...&redirect_uri=myapp%3A%2F%2Fcallback&code_verifier=...
```

Success response (example):

```json
{
  "access_token": "...",
  "refresh_token": "...",
  "id_token": "...",
  "expires_in": 3600,
  "token_type": "Bearer"
}
```
