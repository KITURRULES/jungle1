# jUNGLE

jUNGLE is a Flutter personal app store for showcasing and distributing your own Android builds. This starter uses a no-Firestore distribution model: the app boots from a bundled JSON catalog and can later read the same manifest from a free static host.

## Current Stack

- Flutter with feature-first folders and Riverpod providers
- `go_router` bottom-shell navigation and app detail routes
- Bundled offline catalog at `assets/catalog/apps.json`
- Optional signed remote manifest for GitHub Pages, Cloudflare Pages, Netlify, or any HTTPS static host
- ETag-aware manifest cache with bundled fallback
- Background APK download queue and Android install handoff

## No-Firestore Alternative

Use static distribution:

1. Build APKs in each app repo.
2. Upload APKs to GitHub Releases.
3. Update `apps.json` with the release download URLs.
4. Sign `apps.json` with `tool/jungle_manifest.dart`.
5. Host `apps.json` on GitHub Pages or another free static host.
6. Build jUNGLE with `JUNGLE_MANIFEST_URL` and `JUNGLE_MANIFEST_PUBLIC_KEY`.

This avoids Firestore billing, Firebase project setup, and database security rules. The tradeoff is that ratings, reviews, accounts, and per-user sync should stay local unless you later choose to add a backend.

## Manifest Signing

```bash
/home/kingcode/development/flutter/bin/dart run tool/jungle_manifest.dart keygen
/home/kingcode/development/flutter/bin/dart run tool/jungle_manifest.dart sign assets/catalog/apps.json <private-seed-base64> public/apps.json
```

Build with:

```bash
/home/kingcode/development/flutter/bin/flutter build apk --release \
  --dart-define=JUNGLE_MANIFEST_URL=https://your-name.github.io/jungle/apps.json \
  --dart-define=JUNGLE_MANIFEST_PUBLIC_KEY=<public-key-base64>
```

## Project Structure

```text
lib/
  core/
    router/
    theme/
  features/
    catalog/
      data/
      domain/
      presentation/
    downloads/
      domain/
      presentation/
    profile/
      presentation/
  shared/
    widgets/
assets/
  catalog/apps.json
docs/
  manifest.schema.json
  no_firestore_distribution.md
```

## Run

```bash
/home/kingcode/development/flutter/bin/flutter pub get
/home/kingcode/development/flutter/bin/flutter run
```

## Verify

```bash
/home/kingcode/development/flutter/bin/flutter analyze
/home/kingcode/development/flutter/bin/flutter test
```
