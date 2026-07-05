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
              child: Row(
                children: [
                  const Icon(Icons.offline_bolt, color: JungleColors.amber),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Queue state is stored in-app for now. APK delivery comes from manifest URLs, so no database is required.',
                      style: TextStyle(
                        color: JungleColors.mist.withValues(alpha: 0.76),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (tasks.isEmpty)
              const GlassPanel(
                child: Column(
                  children: [
                    Icon(
                      Icons.download_done,
                      color: JungleColors.moss,
                      size: 44,
                    ),
                    SizedBox(height: 10),
                    Text('No active downloads yet.'),
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

  final DownloadTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(downloadControllerProvider.notifier);
    return GlassPanel(
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
              Text(task.stage.name.toUpperCase()),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: task.progress),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton.icon(
                onPressed: task.stage == DownloadStage.installed
                    ? null
                    : () => controller.advance(task.appId),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Advance'),
              ),
              const SizedBox(width: 10),
              TextButton.icon(
                onPressed: () => controller.cancel(task.appId),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
