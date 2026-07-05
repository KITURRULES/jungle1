import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/jungle_theme.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/jungle_background.dart';
import '../domain/download_task.dart';

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  static const routeName = 'downloads';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(downloadControllerProvider).values.toList();

    return JungleBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Downloads')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            GlassPanel(
              accentColor: JungleColors.volt,
              child: Row(
                children: [
                  const Icon(Icons.offline_bolt, color: JungleColors.ink),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Background downloads use the device download worker. APK delivery comes from signed manifest URLs, so no paid database is required.',
                      style: TextStyle(
                        color: JungleColors.ink,
                        height: 1.35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (tasks.isEmpty)
              const GlassPanel(
                accentColor: JungleColors.concrete,
                child: Column(
                  children: [
                    Icon(
                      Icons.download_for_offline_outlined,
                      color: JungleColors.ink,
                      size: 44,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'NO ACTIVE DOWNLOADS YET.',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              )
            else
              for (final task in tasks)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TaskTile(task: task),
                ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task});

  final JungleDownloadTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(downloadControllerProvider.notifier);
    return GlassPanel(
      accentColor: task.stage == DownloadStage.failed
          ? JungleColors.warning
          : JungleColors.paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.appName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: JungleColors.acid,
                  border: Border.fromBorderSide(
                    BorderSide(color: JungleColors.ink, width: 2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    task.stage.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: task.progress),
          const SizedBox(height: 12),
          Row(
            children: [
              if (task.stage == DownloadStage.completed)
                FilledButton.icon(
                  onPressed: () => controller.install(task.appId),
                  icon: const Icon(Icons.install_mobile),
                  label: const Text('Install'),
                )
              else if (task.stage == DownloadStage.paused)
                FilledButton.icon(
                  onPressed: () => controller.resume(task.appId),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Resume'),
                )
              else if (task.stage == DownloadStage.downloading ||
                  task.stage == DownloadStage.queued)
                FilledButton.icon(
                  onPressed: () => controller.pause(task.appId),
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                )
              else
                FilledButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.verified),
                  label: Text(task.stage.name),
                ),
              const SizedBox(width: 10),
              TextButton.icon(
                onPressed:
                    task.stage == DownloadStage.completed ||
                        task.stage == DownloadStage.installed ||
                        task.stage == DownloadStage.failed
                    ? () => controller.dismiss(task.appId)
                    : () => controller.cancel(task.appId),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove'),
              ),
            ],
          ),
          if (task.message != null) ...[
            const SizedBox(height: 8),
            Text(
              task.message!,
              style: const TextStyle(
                color: JungleColors.ink,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
