import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../domain/app_model.dart';

abstract class AppRepository {
  Future<List<JungleAppModel>> fetchApps();
}

class AssetAppRepository implements AppRepository {
  const AssetAppRepository({this.assetPath = 'assets/catalog/apps.json'});

  final String assetPath;

  @override
  Future<List<JungleAppModel>> fetchApps() async {
    final raw = await rootBundle.loadString(assetPath);
    return _decodeApps(raw);
  }
}

class RemoteManifestAppRepository implements AppRepository {
  const RemoteManifestAppRepository(this.manifestUri, {http.Client? client})
    : _client = client;

  final Uri manifestUri;
  final http.Client? _client;

  @override
  Future<List<JungleAppModel>> fetchApps() async {
    final client = _client ?? http.Client();
    final response = await client.get(manifestUri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'Manifest request failed with HTTP ${response.statusCode}',
      );
    }
    return _decodeApps(response.body);
  }
}

List<JungleAppModel> _decodeApps(String rawJson) {
  final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
  final apps = decoded['apps'] as List<dynamic>;
  return apps
      .map((app) => JungleAppModel.fromJson(app as Map<String, dynamic>))
      .toList()
    ..sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
}

final appRepositoryProvider = Provider<AppRepository>((ref) {
  return const AssetAppRepository();
});

final appCatalogProvider = FutureProvider<List<JungleAppModel>>((ref) async {
  return ref.watch(appRepositoryProvider).fetchApps();
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
