import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import '../../../core/config/jungle_distribution.dart';

class ManifestSecurity {
  const ManifestSecurity({
    this.publicKeyBase64 = JungleDistribution.manifestPublicKey,
    this.trustedHosts = JungleDistribution.trustedDownloadHosts,
  });

  final String publicKeyBase64;
  final List<String> trustedHosts;

  bool get hasPublicKey => publicKeyBase64.trim().isNotEmpty;

  Future<bool> verifyRemoteManifest(Map<String, dynamic> manifestJson) async {
    if (!hasPublicKey) {
      return false;
    }
    final signatureBase64 = manifestJson['signature'] as String? ?? '';
    if (signatureBase64.isEmpty) {
      return false;
    }

    final signedPayload = Map<String, dynamic>.from(manifestJson)
      ..remove('signature');
    final message = utf8.encode(jsonEncode(signedPayload));
    final signatureBytes = base64Decode(signatureBase64);
    final publicKeyBytes = base64Decode(publicKeyBase64);
    final algorithm = Ed25519();

    return algorithm.verify(
      message,
      signature: Signature(
        signatureBytes,
        publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519),
      ),
    );
  }

  bool downloadUrlIsTrusted(
    String url, {
    List<String> manifestHosts = const [],
  }) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || uri.scheme != 'https') {
      return false;
    }
    final allowedHosts = {...trustedHosts, ...manifestHosts};
    return allowedHosts.any(
      (host) => uri.host == host || uri.host.endsWith('.$host'),
    );
  }
}
