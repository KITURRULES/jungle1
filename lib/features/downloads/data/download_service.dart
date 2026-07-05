import 'package:background_downloader/background_downloader.dart' as bg;
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../catalog/domain/app_model.dart';

class JungleDownloadService {
  JungleDownloadService({bg.FileDownloader? downloader})
    : _downloader = downloader ?? bg.FileDownloader();

  final bg.FileDownloader _downloader;

  Stream<bg.TaskUpdate> get updates => _downloader.updates;

  bg.DownloadTask taskFor(JungleAppModel app) {
    return bg.DownloadTask(
      taskId: taskIdFor(app.id, app.version),
      url: app.downloadUrl,
      filename: '${app.id}-${app.version}.apk',
      directory: 'jungle_downloads',
      baseDirectory: bg.BaseDirectory.applicationDocuments,
      group: 'jungle-apks',
      updates: bg.Updates.statusAndProgress,
      retries: 3,
      allowPause: true,
      displayName: app.name,
      metaData: app.id,
    );
  }

  Future<bool> enqueue(JungleAppModel app) async {
    if (kIsWeb) {
      return false;
    }
    await _downloader.ready;
    return _downloader.enqueue(taskFor(app));
  }

  Future<bool> pause(bg.DownloadTask task) {
    return _downloader.pause(task);
  }

  Future<bool> resume(bg.DownloadTask task) {
    return _downloader.resume(task);
  }

  Future<bool> cancel(bg.DownloadTask task) {
    return _downloader.cancel(task);
  }

  Future<String> filePathFor(bg.DownloadTask task) {
    return task.filePath();
  }

  Future<void> install(bg.DownloadTask task) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError('APK install is only supported on Android.');
    }

    final permission = await Permission.requestInstallPackages.request();
    if (!permission.isGranted) {
      throw StateError('Install unknown apps permission was not granted.');
    }

    final path = await filePathFor(task);
    await OpenFilex.open(path, type: 'application/vnd.android.package-archive');
  }
}

String taskIdFor(String appId, String version) => 'jungle-$appId-$version';
