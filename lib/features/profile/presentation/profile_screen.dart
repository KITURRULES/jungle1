import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/jungle_theme.dart';
import '../../../features/catalog/data/app_repository.dart';
import '../../../features/downloads/domain/download_task.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/jungle_background.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const routeName = 'profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(appCatalogProvider).asData?.value ?? const [];
    final downloads = ref.watch(downloadControllerProvider).values;
    final installed = downloads
        .where((task) => task.stage == DownloadStage.installed)
        .length;

    return JungleBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Profile')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            GlassPanel(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 31,
                    backgroundColor: JungleColors.amber,
                    child: Text(
                      'J',
                      style: TextStyle(
                        color: JungleColors.night,
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guest Explorer',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'No account or paid database required.',
                          style: TextStyle(
                            color: JungleColors.mist.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Catalog apps',
                    value: apps.length.toString(),
                    icon: Icons.apps,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Installed',
                    value: installed.toString(),
                    icon: Icons.verified,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GlassPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No-pay distribution stack',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _StackRow(
                    icon: Icons.data_object,
                    title: 'Manifest',
                    body: 'Bundled JSON now, GitHub Pages JSON later.',
                  ),
                  const _StackRow(
                    icon: Icons.inventory_2_outlined,
                    title: 'APK files',
                    body:
                        'Host binaries on GitHub Releases or another static file host.',
                  ),
                  const _StackRow(
                    icon: Icons.lock_open,
                    title: 'Auth',
                    body:
                        'Guest browsing by default. Add login only when needed.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: JungleColors.moss),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          Text(
            label,
            style: TextStyle(color: JungleColors.mist.withValues(alpha: 0.68)),
          ),
        ],
      ),
    );
  }
}

class _StackRow extends StatelessWidget {
  const _StackRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: JungleColors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: TextStyle(
                    color: JungleColors.mist.withValues(alpha: 0.68),
                    height: 1.3,
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
