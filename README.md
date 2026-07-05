# jUNGLE

jUNGLE is a Flutter personal app store for showcasing and distributing your own Android builds. This starter uses a no-Firestore distribution model: the app boots from a bundled JSON catalog and can later read the same manifest from a free static host.

## Current Stack

- Flutter with feature-first folders and Riverpod providers
- `go_router` bottom-shell navigation and app detail routes
- Bundled offline catalog at `assets/catalog/apps.json`
- Optional remote manifest repository for GitHub Pages, Cloudflare Pages, Netlify, or any HTTPS static host
- Local download queue state for the prototype

## No-Firestore Alternative

Use static distribution:

1. Build APKs in each app repo.
2. Upload APKs to GitHub Releases.
3. Update `apps.json` with the release download URLs.
4. Host `apps.json` on GitHub Pages or another free static host.
5. Swap `AssetAppRepository` for `RemoteManifestAppRepository` in `lib/features/catalog/data/app_repository.dart`.

This avoids Firestore billing, Firebase project setup, and database security rules. The tradeoff is that ratings, reviews, accounts, and per-user sync should stay local or be added later through a free-tier backend only when you actually need them.

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
