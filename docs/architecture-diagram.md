# Authentication Architecture Diagram

This architecture focuses on the current implementation where the mobile app talks directly to FusionAuth, with an optional BFF path for future expansion.

## Components

- Mobile App (Expo/React Native)
- System Browser (hosted login experience)
- FusionAuth (authorization server + identity provider)
- Optional BFF (`apps/bff`) for future token mediation/API aggregation

## Diagram

```mermaid
graph TD
    MobileApp[Mobile App] --> Browser[System Browser]
    Browser --> FusionAuth[FusionAuth]
    FusionAuth --> Browser
    Browser --> MobileApp
    MobileApp -. Optional future .-> BFF[Optional BFF]
    BFF -. OAuth/API mediation .-> FusionAuth
```

## Current Request Boundaries

- Browser is used only for user authentication UI and redirect handoff.
- Token exchange is executed by mobile app code (public client + PKCE).
- Session state is persisted client-side in app storage via auth context helpers.

## Why No Mandatory BFF Today

The project intentionally demonstrates native OAuth + PKCE end-to-end.  
A BFF is optional if you later need stricter token isolation, centralized policy enforcement, or downstream API orchestration.
