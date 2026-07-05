import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jungle/main.dart';

void main() {
  testWidgets('jUNGLE shows catalog shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: JungleApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('jUNGLE'), findsOneWidget);
    expect(find.text('The Canopy'), findsOneWidget);
    expect(find.text('FLEET'), findsWidgets);
    expect(find.byIcon(Icons.search), findsWidgets);
  });

  testWidgets('downloads tab starts empty', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: JungleApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Downloads'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('No active downloads yet.'), findsOneWidget);
  });
}
