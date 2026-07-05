# GitHub Release Audit

Audit date: 2026-07-05

## GitHub State

- Repository remote: `https://github.com/KITURRULES/jungle1.git`
- Current branch: `master`
- Existing GitHub releases on `KITURRULES/jungle1`: none found
- GitHub CLI: not installed on this machine
- `GITHUB_TOKEN` / `GH_TOKEN`: not present in this shell
- Push attempt: failed because HTTPS GitHub credentials are not available in this environment

Because no authenticated GitHub API token or GitHub CLI is available, release
assets could not be created from this environment.

## APK Scan Results

| App | Located APK | Status | Reason |
| --- | --- | --- | --- |
| FLEET | `/home/kingcode/Desktop/fleet/build/app/outputs/flutter-apk/app-release.apk` | Blocked | APK verifies, but certificate DN is `C=US, O=Android, CN=Android Debug`; do not publish debug-signed APKs. |
| KOMpRESS | `/home/kingcode/Desktop/KOMpRESS/build/app/outputs/flutter-apk/app-debug.apk` | Blocked | Debug APK only. Release signing config exists, but release build attempts failed due Gradle daemon disappearance. |
| THE BID | `/home/kingcode/Desktop/THE BID/build/app/outputs/flutter-apk/app-debug.apk` | Blocked | Debug APK only. |
| Shuffle | none in scanned build outputs | Blocked | No APK artifact found. |
| jUNGLE | `/home/kingcode/Desktop/jungle/build/app/outputs/flutter-apk/app-debug.apk` | Blocked | Debug APK only. |

## Fleet APK Details

- Path: `/home/kingcode/Desktop/fleet/build/app/outputs/flutter-apk/app-release.apk`
- Size: `57,910,029` bytes
- SHA-256: `e6cf65ad5268e6868d14697ba1c26d403b659cb92b2e215004ae66b375f78042`
- Package: `com.kingcode.fleet`
- Version: `1.0.0` / versionCode `1`
- Signature verification: APK Signature Scheme v2 verifies
- Blocker: signer certificate is Android Debug

## Required Before Uploading Any APK

1. Create or locate a private release keystore for each app family.
2. Configure release signing in each app.
3. Build `flutter build apk --release`.
4. Verify with `apksigner verify --verbose --print-certs`.
5. Confirm signer is not `CN=Android Debug`.
6. Record SHA-256.
7. Create a GitHub Release.
8. Upload the APK as a release asset.
9. Update `assets/catalog/apps.json`:
   - `downloadUrl`
   - `downloadSha256`
   - `distributionReady: true`
   - `distributionNote`
10. Sign the manifest with `tool/jungle_manifest.dart`.

The current manifest intentionally marks all apps as `distributionReady: false`
to avoid sending users to unsafe or nonexistent APKs.

## KOMpRESS Signing / Build Notes

- Release keystore found: `/home/kingcode/Desktop/KOMpRESS/android/upload-keystore.jks`
- Signing properties found: `/home/kingcode/Desktop/KOMpRESS/android/key.properties`
- Gradle release signing block is wired to `key.properties`.
- Temporary copy build attempts:
  - Java 17 forced with reduced Gradle memory
  - `flutter build apk --release`
  - `flutter build apk --release --no-shrink`
- Result: both attempts lost the Gradle daemon before producing an APK.

Do not publish the existing KOMpRESS debug APK. The signing setup appears ready,
but this machine could not complete the release build.

## GitHub Push Status

Local commit created:

```text
b23a5aa Gate unsafe APK distribution
```

Push command attempted:

```bash
git push origin master
```

Result:

```text
fatal: could not read Username for 'https://github.com': No such device or address
```

To push from this machine, configure GitHub HTTPS credentials, use SSH remotes,
or install/authenticate GitHub CLI.
