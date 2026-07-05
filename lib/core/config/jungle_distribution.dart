class JungleDistribution {
  const JungleDistribution._();

  // Leave empty until you publish apps.json to GitHub Pages or another static
  // host. The bundled manifest remains the source of truth while this is empty.
  static const remoteManifestUrl = String.fromEnvironment(
    'JUNGLE_MANIFEST_URL',
    defaultValue: '',
  );

  // Base64 Ed25519 public key. Remote manifests are only trusted when this is
  // configured and their signature verifies.
  static const manifestPublicKey = String.fromEnvironment(
    'JUNGLE_MANIFEST_PUBLIC_KEY',
    defaultValue: '',
  );

  static const trustedDownloadHosts = [
    'github.com',
    'objects.githubusercontent.com',
    'raw.githubusercontent.com',
  ];
}
