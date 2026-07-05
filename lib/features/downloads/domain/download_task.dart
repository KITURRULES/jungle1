import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DownloadStage { queued, downloading, installed, failed }

class DownloadTask {
  const DownloadTask({
    required this.appId,
    required this.appName,
    required this.stage,
    required this.progress,
  });

  final String appId;
  final String appName;
  final DownloadStage stage;
  final double progress;

  DownloadTask copyWith({DownloadStage? stage, double? progress}) {
    return DownloadTask(
      appId: appId,
      appName: appName,
      stage: stage ?? this.stage,
      progress: progress ?? this.progress,
    );
  }
}

class DownloadController extends Notifier<Map<String, DownloadTask>> {
  @override
  Map<String, DownloadTask> build() => {};

  void queue(String appId, String appName) {
    final current = state[appId];
    if (current?.stage == DownloadStage.installed) {
      return;
    }
    state = {
      ...state,
      appId: DownloadTask(
        appId: appId,
        appName: appName,
        stage: DownloadStage.downloading,
        progress: 0.38,
      ),
    };
  }

  void advance(String appId) {
    final current = state[appId];
    if (current == null || current.stage == DownloadStage.installed) {
      return;
    }
    final nextProgress = (current.progress + 0.31).clamp(0, 1).toDouble();
    state = {
      ...state,
      appId: current.copyWith(
        progress: nextProgress,
        stage: nextProgress >= 1
            ? DownloadStage.installed
            : DownloadStage.downloading,
      ),
    };
  }

  void cancel(String appId) {
    final next = Map<String, DownloadTask>.from(state)..remove(appId);
    state = next;
  }
}

final downloadControllerProvider =
    NotifierProvider<DownloadController, Map<String, DownloadTask>>(
      DownloadController.new,
    );
