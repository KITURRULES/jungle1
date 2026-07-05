import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/jungle_theme.dart';
import '../../../features/downloads/domain/download_task.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/jungle_background.dart';
import '../data/app_repository.dart';
import '../domain/app_model.dart';

class AppDetailScreen extends ConsumerWidget {
  const AppDetailScreen({super.key, required this.appId});

  static const routeName = 'app-detail';

  final String appId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appValue = ref.watch(appByIdProvider(appId));

    return JungleBackground(
      child: appValue.when(
        data: (app) {
          if (app == null) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(title: const Text('Missing app')),
              body: const Center(child: Text('This trail does not exist.')),
            );
          }
          return _DetailBody(app: app);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.app});

  final JungleAppModel app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloads = ref.watch(downloadControllerProvider);
    final task = downloads[app.id];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(app.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppIcon(app: app, size: 82),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.name,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            app.tagline,
                            style: TextStyle(
                              color: JungleColors.mist.withValues(alpha: 0.76),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetaChip(icon: Icons.category, label: app.category),
                    _MetaChip(
                      icon: Icons.system_update_alt,
                      label: app.version,
                    ),
                    _MetaChip(
                      icon: Icons.storage,
                      label: '${app.sizeMb.toStringAsFixed(1)} MB',
                    ),
                    _MetaChip(
                      icon: Icons.star,
                      label: app.rating.toStringAsFixed(1),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _DownloadButton(app: app, task: task),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The Clearing',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Text(
                  app.description,
                  style: TextStyle(
                    height: 1.4,
                    color: JungleColors.mist.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Screenshots',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: app.screenshots.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) => SizedBox(
                width: 230,
                child: GlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.screenshot_monitor,
                        color: JungleColors.moss,
                      ),
                      const Spacer(),
                      Text(
                        app.screenshots[index],
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distribution',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Text(
                  'APK URL: ${app.downloadUrl}',
                  style: TextStyle(
                    color: JungleColors.mist.withValues(alpha: 0.68),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadButton extends ConsumerWidget {
  const _DownloadButton({required this.app, required this.task});

  final JungleAppModel app;
  final DownloadTask? task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(downloadControllerProvider.notifier);
    final stage = task?.stage;

    if (stage == DownloadStage.installed) {
      return FilledButton.icon(
        onPressed: null,
        icon: const Icon(Icons.verified),
        label: const Text('Installed'),
      );
    }

    if (stage == DownloadStage.downloading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(value: task!.progress),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => controller.advance(app.id),
                  icon: const Icon(Icons.download),
                  label: const Text('Continue'),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                tooltip: 'Cancel',
                onPressed: () => controller.cancel(app.id),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ],
      );
    }

    return FilledButton.icon(
      onPressed: () => controller.queue(app.id, app.name),
      icon: const Icon(Icons.download),
      label: const Text('Download APK'),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: JungleColors.night),
      label: Text(label),
    );
  }
}
