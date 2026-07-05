# No-Firestore Distribution Plan

Firestore is not required for the first useful version of jUNGLE.

## Recommended Free Architecture

| Need | Free alternative | Notes |
| --- | --- | --- |
| App catalog | `apps.json` on GitHub Pages | Same schema as bundled asset |
| APK files | GitHub Releases | Direct release asset URLs work well for personal distribution |
| Screenshots | Repo assets or static host URLs | Add image URLs to the manifest when ready |
| Reviews | Local-only or disabled | Avoid fake community data |
| Auth | None | Guest browsing is enough for a personal catalog |
| Updates | Manifest version comparison | Compare installed version against manifest version |

## Remote Manifest Switch

In `lib/features/catalog/data/app_repository.dart`, change:

```dart
return const AssetAppRepository();
```

to:

```dart
return RemoteManifestAppRepository(
  Uri.parse('https://your-name.github.io/jungle/apps.json'),
);
```

Keep the bundled asset as an offline fallback if you want better resilience.

## What Requires A Backend Later

- User accounts
- Server-trusted ratings and reviews
- Private apps with access control
- Download analytics
- Payment-gated access

Until one of those becomes necessary, static hosting is the lower-risk path.
