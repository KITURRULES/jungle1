import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/jungle_theme.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/jungle_background.dart';
import '../data/app_repository.dart';

class SearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

class SelectedCategory extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? category) {
    state = category;
  }
}

final searchQueryProvider = NotifierProvider<SearchQuery, String>(
  SearchQuery.new,
);
final selectedCategoryProvider = NotifierProvider<SelectedCategory, String?>(
  SelectedCategory.new,
);

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  static const routeName = 'search';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(appCatalogProvider);
    final query = ref.watch(searchQueryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return JungleBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Search')),
        body: catalog.when(
          data: (apps) {
            final categories = apps.map((app) => app.category).toSet().toList()
              ..sort();
            final results = apps.where((app) {
              final categoryMatches =
                  selectedCategory == null || app.category == selectedCategory;
              return categoryMatches && app.matches(query);
            }).toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                TextField(
                  onChanged: (value) =>
                      ref.read(searchQueryProvider.notifier).setQuery(value),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search apps, categories, or tags',
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: selectedCategory == null,
                      onSelected: (_) {
                        ref
                            .read(selectedCategoryProvider.notifier)
                            .select(null);
                      },
                    ),
                    for (final category in categories)
                      ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (_) {
                          ref
                              .read(selectedCategoryProvider.notifier)
                              .select(category);
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                if (results.isEmpty)
                  const GlassPanel(
                    child: Column(
                      children: [
                        Icon(Icons.eco, size: 42, color: JungleColors.moss),
                        SizedBox(height: 10),
                        Text('No matching apps in this clearing.'),
                      ],
                    ),
                  )
                else
                  ...results.map(
                    (app) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(app: app, compact: true),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}
