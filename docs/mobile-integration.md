# Mobile Integration

This document covers how the Expo app integrates with FusionAuth OAuth + PKCE.

## Key Integration Files

- `apps/mobile-app/app/services/auth/authService.ts`  
  Entry point and mode dispatcher (`demo` > `fusionauth` > `mock`)
- `apps/mobile-app/app/services/auth/fusionauth.ts`  
  OAuth authorize URL, browser flow, callback parsing, token exchange
- `apps/mobile-app/app/services/auth/pkce.ts`  
  PKCE verifier/challenge and OAuth state generation
- `apps/mobile-app/app/context/AuthContext.tsx`  
  Session persistence and authenticated state
- `apps/mobile-app/app/screens/LoginScreen.tsx`  
  UI trigger for login and session setup
- `apps/mobile-app/app/screens/SettingsScreen.tsx`  
  Mode toggles and dev token visibility panel

## Expo/Auth Session Behavior

The app uses Expo browser/auth-session tooling to:

1. Open hosted login in system browser context.
2. Wait for redirect back to app deep link.
3. Parse query params (`code`, `state`, or `error`).

`expo-web-browser` is explicitly imported to complete browser auth session handling on mobile.

## Deep Linking

Configured callback:

- `myapp://callback`

Flow:

1. `fusionauth.ts` includes `redirect_uri=myapp://callback` in authorize request.
2. FusionAuth validates URI against app config and redirects to this URI with code.
3. App receives callback and extracts authorization code.

If callback does not return to app, verify:

- `app.json` includes `myapp` in `scheme`
- FusionAuth app redirect URI exactly matches `myapp://callback`

## Session and Navigation

After successful token exchange, login code returns a unified auth payload.  
`LoginScreen` calls `setAuthSession(...)` in `AuthContext`, which flips authentication state and transitions navigation away from login stack.

## Mode-Aware Behavior

- Demo mode: never opens browser, returns local mock auth payload.
- FusionAuth mode: full OAuth + PKCE.
- Mock mode: local auth fallback.

This allows UI to stay mode-agnostic while auth backend behavior changes via settings/env.
