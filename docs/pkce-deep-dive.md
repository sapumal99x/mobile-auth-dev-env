# PKCE Deep Dive

## What PKCE Is

PKCE (Proof Key for Code Exchange) extends OAuth 2.0 Authorization Code flow for public clients (mobile apps, SPAs) that cannot safely store a client secret.

Instead of trusting only the authorization code, the token endpoint also verifies proof that the same client initiated the flow.

## Why It Exists

Without PKCE, an intercepted authorization code could be exchanged by an attacker.

With PKCE:

- app creates a random `code_verifier`
- app sends hashed `code_challenge` in authorize request
- token exchange succeeds only when original `code_verifier` is presented

## Security Benefits

- Mitigates code interception replay
- Reduces risk in custom/deep-link redirect handlers
- Safe for public/native clients without embedded secret

## Verifier vs Challenge

- `code_verifier`:
  - high-entropy random string
  - kept only on client until token exchange
- `code_challenge`:
  - `BASE64URL(SHA256(code_verifier))`
  - sent to authorization endpoint

## PKCE Diagram

```mermaid
flowchart TD
  A[Generate code_verifier] --> B[SHA-256 hash]
  B --> C[Base64URL encode]
  C --> D[code_challenge]
  D --> E[/oauth2/authorize]
  A --> F[/oauth2/token as code_verifier]
  E --> G[FusionAuth compares verifier->challenge]
  F --> G
  G --> H[Issue tokens if match]
```

## Project Implementation

In `pkce.ts`:

- `createPkcePair()` returns `{ verifier, challenge }`
- `createOAuthState()` creates CSRF state nonce

In `fusionauth.ts`:

- challenge is sent in authorize URL
- verifier is sent during token exchange

If these do not match, FusionAuth returns `invalid_pkce_code_challenge`.
