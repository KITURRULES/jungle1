import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/catalog/presentation/app_detail_screen.dart';
import '../../features/catalog/presentation/home_screen.dart';
import '../../features/catalog/presentation/search_screen.dart';
import '../../features/downloads/presentation/downloads_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../shared/widgets/jungle_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return JungleShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: HomeScreen.routeName,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'app/:appId',
                    builder: (context, state) =>
                        AppDetailScreen(appId: state.pathParameters['appId']!),
                  ),
                  GoRoute(
                    path: 'apps/:appId',
                    name: AppDetailScreen.routeName,
                    builder: (context, state) =>
                        AppDetailScreen(appId: state.pathParameters['appId']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: SearchScreen.routeName,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/downloads',
                name: DownloadsScreen.routeName,
                builder: (context, state) => const DownloadsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: ProfileScreen.routeName,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('jUNGLE')),
      body: Center(
        child: Text('Trail lost: ${state.error?.message ?? state.uri.path}'),
      ),
    ),
  );
});
