import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/router/app_router.dart';
import 'core/theme/jungle_theme.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const ProviderScope(child: JungleApp()));
}

class JungleApp extends ConsumerWidget {
  const JungleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'jUNGLE',
      debugShowCheckedModeBanner: false,
      theme: JungleTheme.dark(),
      routerConfig: router,
    );
  }
}
