import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/jungle_distribution.dart';
import '../domain/app_model.dart';
import '../domain/manifest_model.dart';
import 'manifest_security.dart';

abstract class AppRepository {
  Future<ManifestSnapshot> fetchManifest();

  Future<ManifestSnapshot> refreshManifest() => fetchManifest();

  Future<List<JungleAppModel>> fetchApps() async =>
      fetchManifest().then((snapshot) => snapshot.apps);
}

class OfflineFirstAppRepository implements AppRepository {
  const OfflineFirstAppRepository({
    this.assetPath = 'assets/catalog/apps.json',
    this.remoteManifestUrl = JungleDistribution.remoteManifestUrl,
    this.security = const ManifestSecurity(),
    http.Client? client,
    Connectivity? connectivity,
  }) : _client = client,
       _connectivity = connectivity;

  static const _cachedManifestKey = 'jungle.cachedManifest';
  static const _cachedEtagKey = 'jungle.cachedManifest.etag';

  final String assetPath;
  final String remoteManifestUrl;
  final ManifestSecurity security;
  final http.Client? _client;
  final Connectivity? _connectivity;

  @override
  Future<ManifestSnapshot> fetchManifest() async {
    final SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance().timeout(
        const Duration(milliseconds: 800),
      );
    } catch (_) {
      return _loadBundled();
    }
    final fallback = await _loadCachedOrBundled(prefs);

    if (remoteManifestUrl.trim().isEmpty) {
      return fallback;
    }

    final connectivity = _connectivity ?? Connectivity();
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return fallback;
    }

    try {
      return await _fetchRemote(prefs, fallback);
    } catch (_) {
      return fallback;
    }
  }

  @override
  Future<List<JungleAppModel>> fetchApps() async {
    final snapshot = await fetchManifest();
    return snapshot.apps;
  }

  @override
  Future<ManifestSnapshot> refreshManifest() async {
    final prefs = await SharedPreferences.getInstance();
    final fallback = await _loadBundled();

    if (remoteManifestUrl.trim().isEmpty) {
      return fallback;
    }

    return _fetchRemote(prefs, fallback, force: true);
  }

  Future<ManifestSnapshot> _loadCachedOrBundled(SharedPreferences prefs) async {
    final cached = prefs.getString(_cachedManifestKey);
    if (cached != null) {
      return _decodeManifest(
        cached,
        source: ManifestSource.cached,
        isSignatureVerified: true,
        etag: prefs.getString(_cachedEtagKey),
      );
    }

    return _loadBundled();
  }

  Future<ManifestSnapshot> _loadBundled() async {
    final raw = await rootBundle.loadString(assetPath);
    return _decodeManifest(
      raw,
      source: ManifestSource.bundled,
      isSignatureVerified: false,
    );
  }

  Future<ManifestSnapshot> _fetchRemote(
    SharedPreferences prefs,
    ManifestSnapshot fallback, {
    bool force = false,
  }) async {
    final client = _client ?? http.Client();
    final cachedEtag = prefs.getString(_cachedEtagKey);
    final response = await client.get(
      Uri.parse(remoteManifestUrl),
      headers: {if (!force && cachedEtag != null) 'If-None-Match': cachedEtag},
    );

    if (response.statusCode == 304) {
      return fallback;
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'Manifest request failed with HTTP ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final verified = await security.verifyRemoteManifest(decoded);
    if (!verified) {
      throw StateError('Remote manifest signature could not be verified.');
    }

    final snapshot = _decodeManifest(
      response.body,
      source: ManifestSource.remote,
      isSignatureVerified: true,
      etag: response.headers['etag'],
    );
    _validateDownloadHosts(snapshot);

    await prefs.setString(_cachedManifestKey, response.body);
    final etag = response.headers['etag'];
    if (etag != null) {
      await prefs.setString(_cachedEtagKey, etag);
    }
    return snapshot;
  }

  ManifestSnapshot _decodeManifest(
    String rawJson, {
    required ManifestSource source,
    required bool isSignatureVerified,
    String? etag,
  }) {
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    final manifest = ManifestModel.fromJson(decoded);
    return ManifestSnapshot(
      manifest: manifest,
      source: source,
      isSignatureVerified: isSignatureVerified,
      etag: etag,
    );
  }

  void _validateDownloadHosts(ManifestSnapshot snapshot) {
    for (final app in snapshot.apps) {
      final trusted = security.downloadUrlIsTrusted(
        app.downloadUrl,
        manifestHosts: snapshot.manifest.trustedDownloadHosts,
      );
      if (!trusted) {
        throw StateError('Untrusted download host for ${app.id}.');
      }
    }
  }
}

final appRepositoryProvider = Provider<AppRepository>((ref) {
  return const OfflineFirstAppRepository();
});

final manifestProvider = FutureProvider<ManifestSnapshot>((ref) async {
  return ref.watch(appRepositoryProvider).fetchManifest();
});

final appCatalogProvider = FutureProvider<List<JungleAppModel>>((ref) async {
  return ref.watch(manifestProvider.future).then((snapshot) => snapshot.apps);
});

final featuredAppsProvider = Provider<AsyncValue<List<JungleAppModel>>>((ref) {
  return ref
      .watch(appCatalogProvider)
      .whenData((apps) => apps.where((app) => app.isFeatured).toList());
});

final appByIdProvider = Provider.family<AsyncValue<JungleAppModel?>, String>((
  ref,
  id,
) {
  return ref.watch(appCatalogProvider).whenData((apps) {
    for (final app in apps) {
      if (app.id == id) {
        return app;
      }
    }
    return null;
  });
});
