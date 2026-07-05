import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/jungle_theme.dart';

class JungleShell extends StatelessWidget {
  const JungleShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: JungleColors.ink,
          border: Border(top: BorderSide(color: JungleColors.ink, width: 4)),
        ),
        child: NavigationBar(
          height: 68,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Canopy',
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              selectedIcon: Icon(Icons.manage_search),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.download_outlined),
              selectedIcon: Icon(Icons.downloading),
              label: 'Drops',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.badge),
              label: 'Camp',
            ),
          ],
        ),
      ),
    );
  }
}
