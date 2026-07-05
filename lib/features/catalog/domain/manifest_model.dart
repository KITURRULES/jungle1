import 'app_model.dart';

class ManifestModel {
  const ManifestModel({
    required this.version,
    required this.signature,
    required this.generatedAt,
    required this.trustedDownloadHosts,
    required this.apps,
  });

  final String version;
  final String signature;
  final DateTime generatedAt;
  final List<String> trustedDownloadHosts;
  final List<JungleAppModel> apps;

  factory ManifestModel.fromJson(Map<String, dynamic> json) {
    final apps = json['apps'] as List<dynamic>;
    return ManifestModel(
      version: (json['version'] ?? json['schemaVersion']).toString(),
      signature: (json['signature'] ?? '') as String,
      generatedAt: DateTime.parse(
        (json['generatedAt'] ?? '1970-01-01T00:00:00Z') as String,
      ),
      trustedDownloadHosts: List<String>.from(
        (json['trustedDownloadHosts'] ?? const <String>[]) as List,
      ),
      apps:
          apps
              .map(
                (app) => JungleAppModel.fromJson(app as Map<String, dynamic>),
              )
              .toList()
            ..sort((a, b) => b.releaseDate.compareTo(a.releaseDate)),
    );
  }
}

class ManifestSnapshot {
  const ManifestSnapshot({
    required this.manifest,
    required this.source,
    required this.isSignatureVerified,
    this.etag,
  });

  final ManifestModel manifest;
  final ManifestSource source;
  final bool isSignatureVerified;
  final String? etag;

  List<JungleAppModel> get apps => manifest.apps;
}

enum ManifestSource { bundled, cached, remote }
