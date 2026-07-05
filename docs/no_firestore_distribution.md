# No-Firestore Distribution Plan

Firestore is not required for the first useful version of jUNGLE.

## Recommended Free Architecture

| Need | Free alternative | Notes |
| --- | --- | --- |
| App catalog | Signed `apps.json` on GitHub Pages | Same schema as bundled asset |
| APK files | GitHub Releases | Direct release asset URLs work well for personal distribution |
| Screenshots | Repo assets or static host URLs | Add image URLs to the manifest when ready |
| Reviews | Local-only or disabled | Avoid fake community data |
| Auth | None | Guest browsing is enough for a personal catalog |
| Updates | ETag + manifest version comparison | The app sends `If-None-Match` and falls back to cache |
| Integrity | Ed25519 signature | Remote manifests are rejected unless the signature verifies |

## Remote Manifest Switch

Build with the remote manifest URL and public key:

```bash
/home/kingcode/development/flutter/bin/flutter build apk --release \
  --dart-define=JUNGLE_MANIFEST_URL=https://your-name.github.io/jungle/apps.json \
  --dart-define=JUNGLE_MANIFEST_PUBLIC_KEY=<public-key-base64>
```

Generate keys and sign manifests:

```bash
/home/kingcode/development/flutter/bin/dart run tool/jungle_manifest.dart keygen
/home/kingcode/development/flutter/bin/dart run tool/jungle_manifest.dart sign \
  assets/catalog/apps.json <private-seed-base64> public/apps.json
```

Keep the bundled asset as an offline fallback. Remote manifests are cached with
their ETag after verification.

## What Requires A Backend Later

- User accounts
- Server-trusted ratings and reviews
- Private apps with access control
- Download analytics
- Payment-gated access

Until one of those becomes necessary, static hosting is the lower-risk path.
