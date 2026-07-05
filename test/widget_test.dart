import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jungle/main.dart';

void main() {
  testWidgets('jUNGLE shows catalog shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: JungleApp()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('jUNGLE / 2038'), findsOneWidget);
    expect(find.text('The Canopy'), findsOneWidget);
    expect(find.text('FLEET'), findsWidgets);
    expect(find.byIcon(Icons.search), findsWidgets);
  });

  testWidgets('downloads tab starts empty', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: JungleApp()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.text('Drops'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('NO ACTIVE DOWNLOADS YET.'), findsOneWidget);
  });
}
