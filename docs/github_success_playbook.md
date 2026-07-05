# GitHub Success Playbook for jUNGLE

This is the operational path for publishing apps through jUNGLE without paid
backend services and without avoidable Android trust problems.

## 1. Repository Layout

Use these GitHub repositories:

- `KITURRULES/jungle1`: jUNGLE app source and signed catalog manifest.
- `KITURRULES/jungle-assets`: icons, screenshots, banners, and 3D files.
- GitHub Releases under each app repo or under `KITURRULES/jungle1`: APK assets.

## 2. Never Publish These

- `app-debug.apk`
- APKs signed by `CN=Android Debug`
- APKs with placeholder package names like `com.example.*`
- APKs with unnecessary sensitive permissions
- APKs whose SHA-256 is not recorded in the manifest

## 3. Build A Safe APK

For each Flutter app:

```bash
/home/kingcode/development/flutter/bin/flutter clean
/home/kingcode/development/flutter/bin/flutter pub get
/home/kingcode/development/flutter/bin/flutter build apk --release
```

Then verify:

```bash
/home/kingcode/Android/Sdk/build-tools/36.1.0/apksigner verify \
  --verbose \
  --print-certs \
  build/app/outputs/flutter-apk/app-release.apk
```

The signer must not be `CN=Android Debug`.

## 4. Create A GitHub Release

If GitHub CLI is installed and authenticated:

```bash
gh release create fleet-1.0.0 \
  /path/to/fleet-1.0.0.apk \
  --repo KITURRULES/jungle1 \
  --title "FLEET 1.0.0" \
  --notes "Signed release APK for jUNGLE distribution."
```

Without GitHub CLI:

1. Open `https://github.com/KITURRULES/jungle1/releases`.
2. Click **Draft a new release**.
3. Tag: `fleet-1.0.0`.
4. Title: `FLEET 1.0.0`.
5. Upload the APK.
6. Publish the release.

## 5. Update Manifest

For each approved APK:

```json
{
  "downloadUrl": "https://github.com/KITURRULES/jungle1/releases/download/fleet-1.0.0/fleet-1.0.0.apk",
  "downloadSha256": "<64-character-sha256>",
  "distributionReady": true,
  "distributionNote": "Release-signed APK verified with apksigner."
}
```

## 6. Sign Manifest

Generate keys once:

```bash
/home/kingcode/development/flutter/bin/dart run tool/jungle_manifest.dart keygen
```

Sign the manifest:

```bash
/home/kingcode/development/flutter/bin/dart run tool/jungle_manifest.dart sign \
  assets/catalog/apps.json \
  <private-seed-base64> \
  public/apps.json
```

Keep the private seed secret. Put only the public key in jUNGLE builds.

## 7. Security Alert Reduction Checklist

- Release-sign every APK.
- Keep one stable signing key per app.
- Use HTTPS URLs only.
- Keep `distributionReady` false until verification passes.
- Keep permissions minimal.
- Avoid sideloading through random file hosts.
- Prefer verified Android App Links if you later use a custom domain.
- Expect Android/Play Protect to show some sideload prompts; that is normal.

The goal is not to bypass Android safety prompts. The goal is to make every
prompt defensible: signed APK, known developer, trusted URL, recorded hash,
minimal permissions.
