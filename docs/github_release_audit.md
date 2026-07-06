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
| FLEET | `/home/kingcode/Desktop/jungle/release_artifacts/fleet-1.0.0.apk` | Ready to upload | Existing release build was re-signed with the FLEET release keystore and verifies with non-debug certificate `CN=FLEET Release, OU=jUNGLE, O=KITURRULES, L=Nairobi, ST=Nairobi, C=KE`. |
| KOMpRESS | `/home/kingcode/Desktop/KOMpRESS/build/app/outputs/flutter-apk/app-debug.apk` | Blocked | Debug APK only. Release signing config exists, but release build attempts failed due Gradle daemon disappearance. |
| THE BID | `/home/kingcode/Desktop/THE BID/build/app/outputs/flutter-apk/app-debug.apk` | Blocked | Debug APK only. |
| Shuffle | none in scanned build outputs | Blocked | No APK artifact found. |
| jUNGLE | `/home/kingcode/Desktop/jungle/build/app/outputs/flutter-apk/app-debug.apk` | Blocked | Debug APK only. |

## Fleet APK Details

- Path: `/home/kingcode/Desktop/jungle/release_artifacts/fleet-1.0.0.apk`
- Size: `57,945,064` bytes
- SHA-256: `82aeb92713c22825ae7f0ebf549bb0e1eddbee512cb1955df992aab6d04996f1`
- Package: `com.kingcode.fleet`
- Version: `1.0.0` / versionCode `1`
- Signature verification: APK Signature Scheme v2 and v3 verify
- Signer certificate DN: `CN=FLEET Release, OU=jUNGLE, O=KITURRULES, L=Nairobi, ST=Nairobi, C=KE`

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

The current manifest marks FLEET as `distributionReady: true` and keeps all
other apps as `distributionReady: false` to avoid sending users to unsafe or
nonexistent APKs.

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

## Pending GitHub CLI Commands

GitHub CLI has been downloaded locally to:

```text
/tmp/gh-cli/bin/gh
```

It is not authenticated yet. After authenticating:

```bash
/tmp/gh-cli/bin/gh auth login --hostname github.com --git-protocol https --web
```

Create the FLEET release:

```bash
/tmp/gh-cli/bin/gh release create fleet-1.0.0 \
  release_artifacts/fleet-1.0.0.apk \
  --repo KITURRULES/jungle1 \
  --title "FLEET 1.0.0" \
  --notes "Release-signed FLEET APK for jUNGLE distribution. SHA-256: 82aeb92713c22825ae7f0ebf549bb0e1eddbee512cb1955df992aab6d04996f1"
```

Then push the manifest/source updates:

```bash
git push origin master
```
