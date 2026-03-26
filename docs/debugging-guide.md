# Debugging Guide

## Fast Triage Checklist

1. Confirm Docker containers are up.
2. Confirm FusionAuth responds on `http://localhost:9011`.
3. Confirm mobile config client ID and redirect URI match FusionAuth application.
4. Confirm auth mode toggle is set as expected in Settings.

## Common Issues

### 1) `invalid_client`

Symptoms:

- browser error page says `client_id ... is not valid`

Causes:

- app `FUSIONAUTH_CLIENT_ID` does not match FusionAuth application OAuth client ID

Fix:

- verify client ID in FusionAuth app config and mobile config files

### 2) Redirect/callback not triggered

Symptoms:

- login page appears, but app never receives callback

Causes:

- app scheme missing
- redirect URI mismatch (`myapp://callback`)

Fix:

- ensure app scheme includes `myapp`
- ensure FusionAuth authorized redirect URLs include `myapp://callback`

### 3) PKCE mismatch

Symptoms:

- `invalid_pkce_code_challenge`

Causes:

- malformed challenge
- verifier/challenge pair mismatch

Fix:

- verify `createPkcePair()` output and token request payload

### 4) Token exchange fails

Symptoms:

- `Token exchange failed: ...` message in app

Causes:

- bad code/verifier/redirect/client combination
- auth code reused/expired

Fix:

- retry fresh login
- check `/oauth2/token` request payload and HTTP status

### 5) `client_authentication_missing`

Symptoms:

- token exchange error indicates missing Basic Authorization or client credentials

Cause:

- FusionAuth application is configured as confidential client

Fix:

- ensure OAuth config uses:
  - `clientAuthenticationPolicy: NotRequired`
  - `requireClientAuthentication: false`
  - `proofKeyForCodeExchangePolicy: Required`

## Useful Logs

- App logs:
  - `Using mock auth`
  - `Using FusionAuth`
  - `Authorization code received`
  - `Token exchange success`
- Container logs:
  - `docker logs fusionauth`
  - `docker logs fusionauth-db`

## Debug Commands

```bash
docker ps
docker logs fusionauth --tail 200
docker logs fusionauth-db --tail 120
curl -i http://localhost:9011
```
