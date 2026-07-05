import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/jungle_theme.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/jungle_background.dart';
import '../data/app_repository.dart';
import '../domain/app_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(appCatalogProvider);
    final featured = ref.watch(featuredAppsProvider);

    return JungleBackground(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            title: const Text('jUNGLE'),
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
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
              child: Text(
                'A private app store for your Android builds, served from a no-pay manifest.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: JungleColors.mist.withValues(alpha: 0.74),
                ),
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
              child: Text(
                'New Growth',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
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

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.app});

  final JungleAppModel app;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      onTap: () => context.go('/apps/${app.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon(app: app, size: 64, heroEnabled: false),
              const Spacer(),
              const Icon(Icons.auto_awesome, color: JungleColors.amber),
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
            style: TextStyle(color: JungleColors.mist.withValues(alpha: 0.72)),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => context.go('/apps/${app.id}'),
            icon: const Icon(Icons.park),
            label: const Text('Enter clearing'),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 360.ms).scale(begin: const Offset(0.98, 0.98));
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
        child: Text(message, style: const TextStyle(color: JungleColors.amber)),
      ),
    );
  }
}
