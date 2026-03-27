# Authentication Modes

## Modes

The mobile app supports three effective auth modes at runtime:

- `demo` - hard override to local mock behavior (no browser, no OAuth calls)
- `fusionauth` - real OAuth Authorization Code + PKCE flow
- `mock` - default local mock login path

## Priority Rules

Mode resolution is centralized in `app/services/auth/authMode.ts`:

1. If Demo Mode is enabled, return `demo`
2. Else if FusionAuth login toggle is enabled, return `fusionauth`
3. Else fallback to `EXPO_PUBLIC_AUTH_MODE` (`mock` if not set)

This guarantees that Demo Mode always wins, regardless of FusionAuth toggle state.

## Settings Behavior

In Settings:

- Toggle 1: **Enable FusionAuth Login**
- Toggle 2: **Demo Mode**

Both are persisted so behavior is stable across app restarts.

## Runtime Effects

- `demo`:
  - logs `Demo Mode Active`
  - logs `Using Mock Data`
  - uses mock login only
- `fusionauth`:
  - logs `FusionAuth Mode Active`
  - logs `Using Real OAuth Flow`
  - opens browser and runs OAuth + PKCE
- `mock`:
  - logs `Using Mock Data`
  - uses mock login only
