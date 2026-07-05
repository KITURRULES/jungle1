import 'dart:async';

import 'package:background_downloader/background_downloader.dart' as bg;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/domain/app_model.dart';
import '../data/download_service.dart';

enum DownloadStage {
  queued,
  downloading,
  paused,
  completed,
  installing,
  installed,
  failed,
}

class JungleDownloadTask {
  const JungleDownloadTask({
    required this.appId,
    required this.appName,
    required this.version,
    required this.nativeTask,
    required this.stage,
    required this.progress,
    this.message,
  });

  final String appId;
  final String appName;
  final String version;
  final bg.DownloadTask nativeTask;
  final DownloadStage stage;
  final double progress;
  final String? message;

  JungleDownloadTask copyWith({
    DownloadStage? stage,
    double? progress,
    String? message,
  }) {
    return JungleDownloadTask(
      appId: appId,
      appName: appName,
      version: version,
      nativeTask: nativeTask,
      stage: stage ?? this.stage,
      progress: progress ?? this.progress,
      message: message ?? this.message,
    );
  }
}

final downloadServiceProvider = Provider<JungleDownloadService>((ref) {
  return JungleDownloadService();
});

class DownloadController extends Notifier<Map<String, JungleDownloadTask>> {
  StreamSubscription<bg.TaskUpdate>? _subscription;

  @override
  Map<String, JungleDownloadTask> build() {
    ref.onDispose(() => _subscription?.cancel());
    return {};
  }

  Future<void> queue(JungleAppModel app) async {
    _startListening();
    final current = state[app.id];
    if (current?.stage == DownloadStage.installed ||
        current?.stage == DownloadStage.downloading ||
        current?.stage == DownloadStage.queued) {
      return;
    }

    final service = ref.read(downloadServiceProvider);
    final nativeTask = service.taskFor(app);
    state = {
      ...state,
      app.id: JungleDownloadTask(
        appId: app.id,
        appName: app.name,
        version: app.version,
        nativeTask: nativeTask,
        stage: DownloadStage.queued,
        progress: 0,
      ),
    };

    final enqueued = await service.enqueue(app);
    if (!enqueued) {
      state = {
        ...state,
        app.id: state[app.id]!.copyWith(
          stage: DownloadStage.failed,
          message: 'Download could not be enqueued on this platform.',
        ),
      };
    }
  }

  void _startListening() {
    _subscription ??= ref
        .read(downloadServiceProvider)
        .updates
        .listen(_onUpdate);
  }

  Future<void> pause(String appId) async {
    final task = state[appId];
    if (task == null) {
      return;
    }
    await ref.read(downloadServiceProvider).pause(task.nativeTask);
    state = {...state, appId: task.copyWith(stage: DownloadStage.paused)};
  }

  Future<void> resume(String appId) async {
    final task = state[appId];
    if (task == null) {
      return;
    }
    await ref.read(downloadServiceProvider).resume(task.nativeTask);
    state = {...state, appId: task.copyWith(stage: DownloadStage.downloading)};
  }

  Future<void> install(String appId) async {
    final task = state[appId];
    if (task == null) {
      return;
    }
    state = {...state, appId: task.copyWith(stage: DownloadStage.installing)};
    try {
      await ref.read(downloadServiceProvider).install(task.nativeTask);
      state = {
        ...state,
        appId: task.copyWith(stage: DownloadStage.installed, progress: 1),
      };
    } catch (error) {
      state = {
        ...state,
        appId: task.copyWith(
          stage: DownloadStage.failed,
          message: error.toString(),
        ),
      };
    }
  }

  Future<void> cancel(String appId) async {
    final task = state[appId];
    if (task != null) {
      await ref.read(downloadServiceProvider).cancel(task.nativeTask);
    }
    final next = Map<String, JungleDownloadTask>.from(state)..remove(appId);
    state = next;
  }

  void dismiss(String appId) {
    final next = Map<String, JungleDownloadTask>.from(state)..remove(appId);
    state = next;
  }

  void _onUpdate(bg.TaskUpdate update) {
    final taskId = update.task.taskId;
    MapEntry<String, JungleDownloadTask>? match;
    for (final entry in state.entries) {
      if (entry.value.nativeTask.taskId == taskId) {
        match = entry;
        break;
      }
    }
    if (match == null) {
      return;
    }

    final current = match.value;
    if (update is bg.TaskProgressUpdate) {
      state = {
        ...state,
        match.key: current.copyWith(
          stage: DownloadStage.downloading,
          progress: update.progress.clamp(0, 1).toDouble(),
        ),
      };
      return;
    }

    if (update is bg.TaskStatusUpdate) {
      state = {
        ...state,
        match.key: current.copyWith(
          stage: _mapStatus(update.status),
          progress: update.status == bg.TaskStatus.complete
              ? 1
              : current.progress,
          message: update.exception?.description,
        ),
      };
    }
  }

  DownloadStage _mapStatus(bg.TaskStatus status) {
    return switch (status) {
      bg.TaskStatus.enqueued => DownloadStage.queued,
      bg.TaskStatus.running => DownloadStage.downloading,
      bg.TaskStatus.complete => DownloadStage.completed,
      bg.TaskStatus.paused => DownloadStage.paused,
      bg.TaskStatus.failed ||
      bg.TaskStatus.notFound ||
      bg.TaskStatus.canceled ||
      bg.TaskStatus.waitingToRetry => DownloadStage.failed,
    };
  }
}

final downloadControllerProvider =
    NotifierProvider<DownloadController, Map<String, JungleDownloadTask>>(
      DownloadController.new,
    );
