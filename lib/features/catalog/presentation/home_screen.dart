import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/jungle_theme.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/jungle_background.dart';
import '../data/app_repository.dart';
import '../domain/app_model.dart';
import '../domain/manifest_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(appCatalogProvider);
    final featured = ref.watch(featuredAppsProvider);
    final manifest = ref.watch(manifestProvider);

    return JungleBackground(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 176,
            title: const Text('jUNGLE / 2038'),
            actions: [
              IconButton(
                tooltip: 'Search',
                onPressed: () => context.go('/search'),
                icon: const Icon(Icons.search),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(20, 78, 20, 12),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'The Canopy',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 44,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
              child: GlassPanel(
                accentColor: JungleColors.acid,
                child: Row(
                  children: [
                    const Icon(Icons.security, color: JungleColors.ink),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        manifest.maybeWhen(
                          data: (snapshot) =>
                              '${_sourceLabel(snapshot.source)} manifest ${snapshot.manifest.version}. ${snapshot.isSignatureVerified ? 'Signature verified.' : 'Bundled fallback trusted by app package.'}',
                          orElse: () =>
                              'Loading offline-first app catalog manifest.',
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: JungleColors.ink,
                          height: 1.35,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 680;
                  final tiles = [
                    const _ControlTile(
                      icon: Icons.verified_user,
                      label: 'SIGNED',
                      value: 'Ed25519 manifest',
                      color: JungleColors.acid,
                    ),
                    const _ControlTile(
                      icon: Icons.offline_bolt,
                      label: 'OFFLINE',
                      value: 'Bundled fallback',
                      color: JungleColors.volt,
                    ),
                    const _ControlTile(
                      icon: Icons.install_mobile,
                      label: 'APK DROPS',
                      value: 'Worker downloads',
                      color: JungleColors.amber,
                    ),
                  ];
                  if (compact) {
                    return Column(
                      children: [
                        for (final tile in tiles) ...[
                          tile,
                          if (tile != tiles.last) const SizedBox(height: 12),
                        ],
                      ],
                    );
                  }
                  return Row(
                    children: [
                      for (final tile in tiles) ...[
                        Expanded(child: tile),
                        if (tile != tiles.last) const SizedBox(width: 12),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: featured.when(
              data: (apps) => SizedBox(
                height: 266,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: apps.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) => SizedBox(
                    width: 292,
                    child: _FeaturedCard(app: apps[index]),
                  ),
                ),
              ),
              loading: () => const _LoadingPanel(label: 'Growing canopy'),
              error: (error, stack) => _ErrorPanel(message: error.toString()),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(
                    'NEW GROWTH',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Divider(color: JungleColors.ink, thickness: 4),
                  ),
                ],
              ),
            ),
          ),
          catalog.when(
            data: (apps) => SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 360,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.96,
                ),
                itemCount: apps.length,
                itemBuilder: (context, index) => AppCard(app: apps[index]),
              ),
            ),
            loading: () => const SliverToBoxAdapter(
              child: _LoadingPanel(label: 'Loading apps'),
            ),
            error: (error, stack) => SliverToBoxAdapter(
              child: _ErrorPanel(message: error.toString()),
            ),
          ),
        ],
      ),
    );
  }
}

String _sourceLabel(ManifestSource source) {
  return switch (source) {
    ManifestSource.bundled => 'Bundled',
    ManifestSource.cached => 'Cached',
    ManifestSource.remote => 'Remote',
  };
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.app});

  final JungleAppModel app;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      onTap: () => context.go('/apps/${app.id}'),
      accentColor: JungleColors.volt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon(app: app, size: 64, heroEnabled: false),
              const Spacer(),
              const Icon(Icons.auto_awesome, color: JungleColors.ink),
            ],
          ),
          const Spacer(),
          Text(
            app.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            app.tagline,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: JungleColors.ink,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => context.go('/apps/${app.id}'),
            icon: const Icon(Icons.park),
            label: const Text('Enter clearing'),
          ),
        ],
      ),
    );
  }
}

class _ControlTile extends StatelessWidget {
  const _ControlTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      accentColor: color,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: JungleColors.ink),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassPanel(
        accentColor: JungleColors.concrete,
        child: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 14),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassPanel(
        accentColor: JungleColors.warning,
        child: Text(
          message,
          style: const TextStyle(
            color: JungleColors.ink,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
